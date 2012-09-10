use utf8;
use strict;
use warnings;

package DR::Template::Parser;

require DR::Template;
use Data::Dumper;

local $Data::Dumper::Indent = 1;
local $Data::Dumper::Terse = 1;
local $Data::Dumper::Useqq = 1;
local $Data::Dumper::Deepcopy = 1;
local $Data::Dumper::Maxdepth = 0;


sub _parse {
    my ($tpl, @vars) = @_;


    my $res = '';


    DR::Template::_tpl_transform($tpl, {
        code_cb => sub {
            my ($code) = @_;
#             warn Dumper { code => $code };

            for ($code) {

                if (/^=/) {
                    s/;(\s*)\z/$1/;
                    if (/^==/) {
                        $_ = sprintf '$_TPL->insert_text(%s);', substr $_, 2;
                        last;
                    }
                    $_ = sprintf '$_TPL->insert_qtext(%s);', substr $_, 1;
                    last;
                }
               
                if (/^%/) {
                    $_ = sprintf "<%s%%>", $_;
                    last;
                }
            }

            $res .= $code;
            return;
        },
        text_cb => sub {
            my ($text) = @_;
#             warn Dumper { text => $text };
            for ($text) {
                s/\\/\\\\/g;
                s/"/\\"/g;
            }

            $res .= sprintf '$_TPL->insert_text("%s");', $text;
            return;
        }
    });

    
    return $res;
}

1;
