#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use open qw(:std :utf8);
use lib qw(lib ../lib);
use lib qw(blib/lib blib/arch ../blib/lib ../blib/arch);



use Test::More tests    => 1;
use Encode qw(decode encode);


BEGIN {
    # Подготовка объекта тестирования для работы с utf8
    my $builder = Test::More->builder;
    binmode $builder->output,         ":utf8";
    binmode $builder->failure_output, ":utf8";
    binmode $builder->todo_output,    ":utf8";

    use_ok 'DR::Template::Parser';
}



my @tests = (
    {
        text    => 'abc',
        parsed  => '$_TPL->insert_text("abc");'
    },
    {
        text    => 'ab"c',
        parsed  => '$_TPL->insert_text("ab\"c");'
    },
    {
        text    => 'a\bc',
        parsed  => '$_TPL->insert_text("a\\\\bc");'
    },
    {
        text    => 'a}bc',
        parsed  => '$_TPL->insert_text("a}bc");'
    },
    {
        text    => '<%= 1 + 2 %>',
        parsed  => '$_TPL->insert_qtext( 1 + 2 );'
    },
    {
        text    => 'a%<%= 3 + 4 %>%',
        parsed  => '$_TPL->insert_text("a%");'
            . '$_TPL->insert_qtext( 3 + 4 );$_TPL->insert_text("%");'
    },
    {
        text    => '<%== 5 + 6 %>',
        parsed  => '$_TPL->insert_text( 5 + 6 );'
    },
    {
        text    => '<% 7 + 8; %>',
        parsed  => ' 7 + 8; '
    },
    {
        text    => "% 9 + 10;",
        parsed  => ' 9 + 10;'
    },
    {
        text    => "%= 11 + 12;",
        parsed  => '$_TPL->insert_qtext( 11 + 12);'
    },
    {
        text    => "%= 13 + 14 ",
        parsed  => '$_TPL->insert_qtext( 13 + 14 );'
    },
    {
        text    => "%= 15 + 16\n%= 17 % 18\naa\n",
        parsed  => "\$_TPL->insert_qtext( 15 + 16);"
            . "\$_TPL->insert_text(\"\n\");"
            . "\$_TPL->insert_qtext( 17 % 18);"
            . "\$_TPL->insert_text(\"\na\");"
            . "\$_TPL->insert_text(\"a\");\$_TPL->insert_text(\"\n\");"
    },
    {
        text    => "<%= 19 + 20 %>% 21 + 22;",
        parsed  =>
            '$_TPL->insert_qtext( 19 + 20 );$_TPL->insert_text("% 21 + 22;");'
    },
);

for (@tests) {
    my $res = eval { DR::Template::Parser::_parse($_->{text}) };
    ok !$@, "There was no errors " . $@ || '';
    diag "=======\n", $_->{text} unless
    cmp_ok $res, 'eq', $_->{parsed}, $_->{name} || 'result is fine';

}
