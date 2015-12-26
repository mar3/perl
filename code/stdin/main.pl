#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;

sub _main {

	my @lines = <STDIN>;
	print('[', @lines, ']');
}

_main(@ARGV);

