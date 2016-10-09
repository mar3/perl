#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Data::Dumper;

sub _dump {

	my ($unknown) = @_;

	print('[', $unknown, ']', "\n");
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my @samples = (1, 2, 3, 4);

	map {_dump $_} @samples;
}

_main(@ARGV);
