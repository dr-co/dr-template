
#line 1 "Template.rl"
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

    
#line 72 "Template.xs"
static const char _template_actions[] = {
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 6, 1, 
	7, 1, 8, 1, 9
};

static const char _template_key_offsets[] = {
	0, 0, 5, 7, 8, 9, 10, 11, 
	12, 15, 18, 21, 26, 27
};

static const char _template_trans_keys[] = {
	32, 37, 60, 9, 13, 10, 37, 37, 
	37, 62, 37, 62, 10, 37, 60, 10, 
	37, 60, 10, 37, 60, 32, 37, 60, 
	9, 13, 10, 37, 0
};

static const char _template_single_lengths[] = {
	0, 3, 2, 1, 1, 1, 1, 1, 
	3, 3, 3, 3, 1, 1
};

static const char _template_range_lengths[] = {
	0, 1, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 1, 0, 0
};

static const char _template_index_offsets[] = {
	0, 0, 5, 8, 10, 12, 14, 16, 
	18, 22, 26, 30, 35, 37
};

static const char _template_trans_targs[] = {
	11, 12, 0, 11, 8, 0, 3, 8, 
	0, 4, 5, 4, 8, 6, 7, 4, 
	8, 0, 1, 13, 2, 9, 8, 8, 
	8, 10, 8, 8, 8, 10, 11, 12, 
	8, 11, 8, 8, 12, 8, 8, 8, 
	8, 8, 8, 8, 0
};

static const char _template_trans_actions[] = {
	0, 0, 0, 0, 5, 0, 0, 7, 
	0, 0, 0, 0, 11, 0, 0, 0, 
	11, 0, 0, 0, 0, 0, 13, 9, 
	13, 0, 13, 13, 13, 0, 0, 0, 
	15, 0, 5, 19, 0, 9, 17, 13, 
	13, 15, 19, 17, 0
};

static const char _template_to_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 0, 0, 0, 0, 0
};

static const char _template_from_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	3, 0, 0, 0, 0, 0
};

static const char _template_eof_trans[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 41, 41, 42, 43, 44
};

static const int template_start = 8;
static const int template_first_final = 8;
static const int template_error = 0;

static const int template_en_main = 8;


#line 146 "Template.xs"
	{
	cs = template_start;
	ts = 0;
	te = 0;
	act = 0;
	}

#line 154 "Template.xs"
	{
	int _klen;
	unsigned int _trans;
	const char *_acts;
	unsigned int _nacts;
	const char *_keys;

	if ( p == pe )
		goto _test_eof;
	if ( cs == 0 )
		goto _out;
_resume:
	_acts = _template_actions + _template_from_state_actions[cs];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 ) {
		switch ( *_acts++ ) {
	case 1:
#line 1 "NONE"
	{ts = p;}
	break;
#line 175 "Template.xs"
		}
	}

	_keys = _template_trans_keys + _template_key_offsets[cs];
	_trans = _template_index_offsets[cs];

	_klen = _template_single_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + _klen - 1;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( (*p) < *_mid )
				_upper = _mid - 1;
			else if ( (*p) > *_mid )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				goto _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _template_range_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + (_klen<<1) - 2;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( (*p) < _mid[0] )
				_upper = _mid - 2;
			else if ( (*p) > _mid[1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				goto _match;
			}
		}
		_trans += _klen;
	}

_match:
_eof_trans:
	cs = _template_trans_targs[_trans];

	if ( _template_trans_actions[_trans] == 0 )
		goto _again;

	_acts = _template_actions + _template_trans_actions[_trans];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 )
	{
		switch ( *_acts++ )
		{
	case 2:
#line 88 "Template.rl"
	{te = p+1;{
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
        }}
	break;
	case 3:
#line 88 "Template.rl"
	{te = p+1;{
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
        }}
	break;
	case 4:
#line 88 "Template.rl"
	{te = p+1;{
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
        }}
	break;
	case 5:
#line 71 "Template.rl"
	{te = p+1;{
            _cb_call("code_cb", ts + 2, te - ts - 4, cbl, &tokens);
        }}
	break;
	case 6:
#line 88 "Template.rl"
	{te = p;p--;{
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
        }}
	break;
	case 7:
#line 88 "Template.rl"
	{te = p;p--;{
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
        }}
	break;
	case 8:
#line 88 "Template.rl"
	{te = p;p--;{
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
        }}
	break;
	case 9:
#line 75 "Template.rl"
	{te = p;p--;{
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
        }}
	break;
#line 423 "Template.xs"
		}
	}

_again:
	_acts = _template_actions + _template_to_state_actions[cs];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 ) {
		switch ( *_acts++ ) {
	case 0:
#line 1 "NONE"
	{ts = 0;}
	break;
#line 436 "Template.xs"
		}
	}

	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	if ( p == eof )
	{
	if ( _template_eof_trans[cs] > 0 ) {
		_trans = _template_eof_trans[cs] - 1;
		goto _eof_trans;
	}
	}

	_out: {}
	}

#line 169 "Template.rl"


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

