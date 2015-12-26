#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Encode;
use String::Random;

sub _println {

	print(@_, "\n");
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_println('ランダムな3ケタの数字(digit): [', String::Random::random_regex('\d\d\d'), ']');
	_println('ランダムな3ケタの文字(printable-character): [', String::Random::random_string("..."), ']');
	_println('ランダムな3ケタの数字(正規表現による): [', String::Random::random_regex('[0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z][0-9a-zA-Z]'), ']');
	_println('ランダムな3ケタの文字(random-character): [', String::Random::random_string('000', ['0'..'9', 'a'..'z', 'A'..'Z', ' ', '-', '_']), ']');
	_println('ランダムな3ケタの文字(random-character): [', String::Random::random_string('000000000000000000000000000000', ['0'..'9', 'a'..'z', 'A'..'Z']), ']');
}

_main(@ARGV);
