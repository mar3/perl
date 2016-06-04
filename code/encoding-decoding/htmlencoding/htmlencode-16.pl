#!/usr/bin/env perl
# coding: utf-8

use strict;

sub _main {

	my ($s) = @_;
	my $length = length($s);
	my $buffer = '';
	for(my $i = 0; $i < $length; $i++) {
		my $ch = substr($s, $i, 1);
		$buffer = $buffer . '&#' . ord($ch) . ';';
	}
	print($buffer, "\n");
}

_main(@ARGV);
