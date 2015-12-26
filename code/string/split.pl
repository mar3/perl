#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Encode;

sub _println {

	print(@_, "\n");
}

#
# 分割
#
sub _main {

	my $s = "001 002\t003\n004\n,,,,\n005 , 006";
	my @items = split(/[\ \,\t\n]/, $s);
	foreach my $e (@items) {
		_println('[', $e, ']');
	}
}

_main(@ARGV);
