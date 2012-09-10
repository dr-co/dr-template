/* vim: set ft=ragel: */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <stdio.h>


static void
_cb_call(const char *key, const char *data, STRLEN len, SV *cbl, unsigned *cnt)
{
    

    if (!len)
        return;
    

    if (!*cnt) {
        data++;
        len--;
    }

    *cnt = *cnt + 1;

    if (!len)
        return;

    size_t keylen = strlen(key);
    HV * hcbl = (HV *)SvRV(cbl);

    SV *cb = NULL;
    if (hv_exists(hcbl, key, keylen))
        cb = *hv_fetch(hcbl, key, keylen, 0);

    if (!cb || !SvROK(cb) || SVt_PVCV != SvTYPE(SvRV(cb)) )
        croak("Callback '%s' was not defined", key );

    
    dSP;
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    XPUSHs(sv_2mortal(newSVpv(data, len)));
    PUTBACK;
    call_sv(cb, G_DISCARD);
    FREETMPS;
    LEAVE;
}


static unsigned _transform(SV *tpl, SV *cbl) {
    
    const char *p;
    const char *pe;
    int cs;

    const char *tstart = p;
    const char *eof = pe;
    const char *ts, *te;
    int act;

    STRLEN len;
    p = SvPV(tpl, len);
    pe = p + len;
    unsigned tokens = 0;
    int top = 0;
    int stack[5];

    %%{
        machine template;

        action mline_code {
            _cb_call("code_cb", ts + 2, te - ts - 4, cbl, &tokens);
        }
        
        action line_code {
            const char *bc;
            for (bc = ts; bc < te; bc++) {
                if (*bc != '%')
                    continue;
                if (bc > ts) {
                    _cb_call("text_cb", ts, bc - ts, cbl, &tokens);
                }
                _cb_call("code_cb", bc + 1, te - bc - 1, cbl, &tokens);
                break;
            }
        }

        action text {
            if (!tokens) {
                const char *bc;
                for (bc = ts; bc < te; bc++) {
                    if (*bc == ' ')
                        continue;
                    if (*bc == '\t')
                        continue;
                    if (*bc != '%')
                        break;
                    
                    if (bc > ts) {
                        _cb_call("text_cb", ts, bc - ts, cbl, &tokens);
                    }
                    _cb_call("code_cb", bc + 1, te - bc - 1, cbl, &tokens);
                    break;
                }
                if (!tokens)
                    _cb_call("text_cb", ts, te - ts, cbl, &tokens);

            } else {
                _cb_call("text_cb", ts, te - ts, cbl, &tokens);
            }
        }

        text_old = (
            (
                (
                    ([^<%\n])*
                    (
                        ("<"  [^%]) | ("\n"  space* [^%<])
                    )*
                )
                |
                (
                    ([^<%\n])+
                    (
                            ("<"  [^%])
                        |   ("\n"  space* [^<%])
                        |   "%"
                        |   ("<%%")
                    )*
                )
            )
        );

        text1       =  ([^<%\n]+);
        text2       =  ("\n" space* [^<%]);
        text3       =  ("<" [^%\n]);
        text4       =  ([^\n<] "%");
        text5       =  ("%");



        
        mline_code  =  ("<%" ([^%]+ ("%" [^>]  [^%]*)?)+ "%>");
        line_code   =  ("\n" space* "%" [^\n]*);



        #line_code   =  ("\n" space* "%" [^\n]*);
        #fline_code  =  ([ \t]* "%" [^\n]*);
        #amline_code =  ("<%" ([^%]* ("%" [^>])?)* "%>");
        #mline_code  =  ("<%" ([^%]+ ("%" [^>]  [^%]*)?)+ "%>");
        

        main := |*
#            fline_code  => first_line_code;
            text1       => text;
            text2       => text;
            text3       => text;
            text4       => text;
            text5       => text;
            mline_code  => mline_code;
            line_code   => line_code;

        *|;
        write data;
        write init;
        write exec;

    }%%

    /* unparsed tail: may be text/may be codeline */
    if (ts && ts < pe) {
        printf("tail: '%.*s'\n", pe - ts, ts);
        const char *bc;
        if (!tokens) {
            for (bc = ts; bc < pe; bc++) {
                if (*bc == ' ')
                    continue;
                if (*bc == '\t')
                    continue;
                if (*bc == '%') {
                    _cb_call("text_cb", ts, bc - ts, cbl, &tokens);
                    _cb_call("code_cb", bc + 1, pe - bc - 1, cbl, &tokens);
                    return tokens;
                }
            }
        }
        for (bc = ts; bc < pe; bc++) {
            if (*bc != '\n')
                continue;
            bc++;
            _cb_call("text_cb", ts, bc - ts, cbl, &tokens);

            for (ts = bc; bc < pe; bc++) {
                if (*bc == ' ')
                    continue;
                if (*bc == '\t')
                    continue;
                if (*bc == '%') {
                    _cb_call("text_cb", ts, bc - ts, cbl, &tokens);
                    _cb_call("code_cb", bc + 1, pe - bc - 1, cbl, &tokens);
                    return tokens;
                }
            }
            break;
        }

        _cb_call("text_cb", ts, pe - ts, cbl, &tokens);
    }

    return tokens;
}


MODULE = DR::Template PACKAGE = DR::Template
PROTOTYPES: ENABLE

void _tpl_transform(tpl, cbl)
    SV *tpl
    SV *cbl

    CODE:

        _transform(tpl, cbl);

