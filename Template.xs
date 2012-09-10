
#line 1 "Template.rl"
/* vim: set ft=ragel: */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <stdio.h>


static void _cb_call(const char *key, const char *data, STRLEN len, SV *cbl) {
    

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

    
#line 56 "Template.xs"
static const char _template_actions[] = {
	0, 1, 2, 1, 3, 1, 5, 1, 
	6, 1, 7, 1, 8, 1, 9, 1, 
	10, 2, 0, 1, 2, 3, 4
};

static const char _template_key_offsets[] = {
	0, 0, 4, 5, 6, 7, 9, 11, 
	15, 16, 17, 18, 19, 20, 21, 22, 
	27, 30, 33, 37, 42, 45, 49, 51
};

static const char _template_trans_keys[] = {
	9, 32, 37, 60, 37, 37, 10, 10, 
	37, 10, 37, 9, 32, 37, 60, 37, 
	37, 37, 37, 62, 37, 62, 9, 10, 
	32, 37, 60, 10, 37, 60, 10, 37, 
	60, 32, 60, 9, 10, 9, 10, 32, 
	37, 60, 10, 37, 60, 9, 32, 37, 
	60, 10, 60, 32, 37, 60, 9, 10, 
	0
};

static const char _template_single_lengths[] = {
	0, 4, 1, 1, 1, 2, 2, 4, 
	1, 1, 1, 1, 1, 1, 1, 5, 
	3, 3, 2, 5, 3, 4, 2, 3
};

static const char _template_range_lengths[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 1, 0, 0, 0, 0, 1
};

static const char _template_index_offsets[] = {
	0, 0, 5, 7, 9, 11, 14, 17, 
	22, 24, 26, 28, 30, 32, 34, 36, 
	42, 46, 50, 54, 60, 64, 69, 72
};

static const char _template_indicies[] = {
	2, 2, 0, 0, 1, 3, 1, 1, 
	0, 6, 5, 1, 8, 7, 6, 7, 
	5, 10, 10, 4, 4, 9, 0, 9, 
	11, 9, 13, 12, 14, 12, 16, 15, 
	17, 12, 16, 13, 19, 20, 19, 5, 
	21, 18, 23, 1, 24, 18, 23, 1, 
	24, 22, 2, 24, 2, 1, 19, 23, 
	19, 7, 24, 18, 25, 7, 26, 5, 
	2, 2, 27, 27, 1, 20, 28, 22, 
	10, 22, 28, 10, 9, 0
};

static const char _template_trans_targs[] = {
	15, 17, 18, 3, 15, 4, 15, 20, 
	6, 22, 23, 10, 11, 0, 12, 13, 
	15, 14, 16, 19, 7, 9, 15, 1, 
	2, 21, 5, 15, 8
};

static const char _template_trans_actions[] = {
	13, 3, 3, 0, 15, 0, 7, 20, 
	0, 20, 3, 0, 0, 0, 0, 0, 
	5, 0, 3, 3, 0, 0, 9, 0, 
	0, 0, 0, 11, 0
};

static const char _template_to_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 17, 
	0, 0, 0, 0, 0, 0, 0, 0
};

static const char _template_from_state_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 1, 
	0, 0, 0, 0, 0, 0, 0, 0
};

static const char _template_eof_trans[] = {
	0, 1, 1, 1, 5, 1, 1, 5, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	23, 23, 23, 23, 23, 28, 23, 23
};

static const int template_start = 15;
static const int template_first_final = 15;
static const int template_error = 0;

static const int template_en_main = 15;


#line 150 "Template.xs"
	{
	cs = template_start;
	ts = 0;
	te = 0;
	act = 0;
	}

#line 158 "Template.xs"
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
	case 2:
#line 1 "NONE"
	{ts = p;}
	break;
#line 179 "Template.xs"
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
	_trans = _template_indicies[_trans];
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
	case 3:
#line 1 "NONE"
	{te = p+1;}
	break;
	case 4:
#line 75 "Template.rl"
	{act = 1;}
	break;
	case 5:
#line 55 "Template.rl"
	{te = p+1;{
            _cb_call("code_cb", ts + 2, te - ts - 4, cbl);
            tokens++;
        }}
	break;
	case 6:
#line 60 "Template.rl"
	{te = p+1;{
            const char *bc;
            for (bc = ts; bc < te; bc++) {
                if (*bc != '%')
                    continue;
                if (bc > ts) {
                    _cb_call("text_cb", ts, bc - ts, cbl);
                    tokens++;
                }
                _cb_call("code_cb", bc + 1, te - bc - 1, cbl);
                tokens++;
                break;
            }
        }}
	break;
	case 7:
#line 75 "Template.rl"
	{te = p;p--;{
            _cb_call("text_cb", ts, te - ts, cbl);
            tokens++;
        }}
	break;
	case 8:
#line 60 "Template.rl"
	{te = p;p--;{
            const char *bc;
            for (bc = ts; bc < te; bc++) {
                if (*bc != '%')
                    continue;
                if (bc > ts) {
                    _cb_call("text_cb", ts, bc - ts, cbl);
                    tokens++;
                }
                _cb_call("code_cb", bc + 1, te - bc - 1, cbl);
                tokens++;
                break;
            }
        }}
	break;
	case 9:
#line 75 "Template.rl"
	{{p = ((te))-1;}{
            _cb_call("text_cb", ts, te - ts, cbl);
            tokens++;
        }}
	break;
	case 10:
#line 1 "NONE"
	{	switch( act ) {
	case 0:
	{{cs = 0; goto _again;}}
	break;
	case 1:
	{{p = ((te))-1;}
            _cb_call("text_cb", ts, te - ts, cbl);
            tokens++;
        }
	break;
	}
	}
	break;
#line 323 "Template.xs"
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
	case 1:
#line 1 "NONE"
	{act = 0;}
	break;
#line 340 "Template.xs"
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

#line 115 "Template.rl"


    /* unparsed tail: may be text/may be codeline */
    if (ts && ts < pe) {
        const char *bc;
        if (!tokens) {
            for (bc = ts; bc < pe; bc++) {
                if (*bc == ' ')
                    continue;
                if (*bc == '\t')
                    continue;
                if (*bc == '%') {
                    _cb_call("text_cb", ts, bc - ts, cbl);
                    _cb_call("code_cb", bc + 1, pe - bc - 1, cbl);
                    return 2;
                }
            }
        }
        for (bc = ts; bc < pe; bc++) {
            if (*bc != '\n')
                continue;
            bc++;
            _cb_call("text_cb", ts, bc - ts, cbl);
            tokens++;

            for (ts = bc; bc < pe; bc++) {
                if (*bc == ' ')
                    continue;
                if (*bc == '\t')
                    continue;
                if (*bc == '%') {
                    _cb_call("text_cb", ts, bc - ts, cbl);
                    _cb_call("code_cb", bc + 1, pe - bc - 1, cbl);
                    return 3;
                }
            }
            break;
        }

        _cb_call("text_cb", ts, pe - ts, cbl);
        tokens++;
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

