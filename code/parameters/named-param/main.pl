#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;

sub _println {

	print(@_, "\n");
}

sub _test {

	my $parameters = {@_};
	_println('LPARAM: [', $parameters->{LPARAM}, ']');
	_println('RPARAM: [', $parameters->{RPARAM}, ']');
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_test(
		'LPARAM' => 'lparam の値～',
		'RPARAM' => 'rparam の値－',
	);
}

_main();
