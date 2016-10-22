#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;

sub _main {

	my @result = sort { $a <=> $b } @_;
	foreach my $e (@result) {
		print($e, "\n");
	}
}

_main(@ARGV);
