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
        text    => '<%= 1 + 1 %>',
        parsed  => '$_TPL->insert_qtext( 1 + 1 );'
    },
    {
        text    => 'a%<%= 1 + 1 %>%',
        parsed  => '$_TPL->insert_text("a%");'
            . '$_TPL->insert_qtext( 1 + 1 );$_TPL->insert_text("%");'
    },
    {
        text    => '<%== 2 + 3 %>',
        parsed  => '$_TPL->insert_text( 2 + 3 );'
    },
    {
        text    => '<% 3 + 4; %>',
        parsed  => ' 3 + 4; '
    },
    {
        text    => "% 3 + 4;",
        parsed  => ' 3 + 4;'
    },
    {
        text    => "%= 3 + 4;",
        parsed  => '$_TPL->insert_qtext( 3 + 4);'
    },
    {
        text    => "%= 3 + 4 ",
        parsed  => '$_TPL->insert_qtext( 3 + 4 );'
    },
    {
        text    => "%= 3 + 4\n%= 1 % 2\naa\n",
        parsed  => "\$_TPL->insert_qtext( 3 + 4\n);"
            . "\$_TPL->insert_qtext( 1 % 2\n);"
            . "\$_TPL->insert_text(\"aa\n\");"
    },
    {
        text    => "<%= 1 + 1 %>% 3 + 4;",
        parsed  =>
            '$_TPL->insert_qtext( 1 + 1 );$_TPL->insert_text("% 3 + 4;");'
    },
);

for (@tests) {
    my $res = eval { DR::Template::Parser::_parse($_->{text}) };
    ok !$@, "There was no errors " . $@ || '';
    cmp_ok $res, 'eq', $_->{parsed}, $_->{name} || 'result is fine';

}
