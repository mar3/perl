#!/usr/bin/env perl
# coding: utf-8
#
use strict;

sub _println {

	print(@_, "\n");
}

sub _execute {

	my ($x, $y, $z) = @_;



	# doesn't modify original variables.
	$x = 'a';
	$y = 'b';
	$z = 'c';
}

sub _main {

	my $a = 0;
	my $b = 0;
	my $c = 0;

	_execute($a, $b, $c);

	_println('a=[', $a, '], b=[', $b, '], c=[', $c, ']');
}

_main(@ARGV);

