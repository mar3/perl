#!/usr/bin/env perl
# coding: utf-8

use utf8;
use strict;

sub _println {

	print(@_, "\n");
}

sub _colored {

	my ($text, $color) = @_;



	return sprintf("\033[%dm%s\033[39m", $color, $text);
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	print("--- ", _colored("テキスト", 33), " ---\n");
	print("--- ", "\033[31m", "テキスト", "\033[39m", " ---\n");
	print("--- ", "\033[32m", "テキスト", "\033[39m", " ---\n");
	print("--- ", "\033[33m", "テキスト", "\033[39m", " ---\n");
	print("--- ", "\033[34m", "テキスト", "\033[39m", " ---\n");
	print("--- ", "\033[35m", "テキスト", "\033[39m", " ---\n");
	print("--- ", "\033[36m", "テキスト", "\033[39m", " ---\n");
	print("--- ", "\033[37m", "テキスト", "\033[39m", " ---\n");
	print("--- ", "\033[7m", "テキスト", "\033[0m", " ---\n");

	print("Ok.\n");
}

_main(@ARGV);
