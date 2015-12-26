#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Encode;

sub _main {

	my $s = shift;

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	print(utf8::is_utf8($s), "\n");
	if(!utf8::is_utf8($s)) {
		$s = Encode::decode('UTF-8', $s);
	}
	print(utf8::is_utf8($s), "\n");

	print('[', $s, '] の長さは (', length($s), ') です。');
}

_main(@ARGV);
