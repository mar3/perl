#!/usr/bin/env perl
# coding: utf-8
#
# 標準入力を読む
#

use strict;
use utf8;

sub _main {

	my @lines = <STDIN>;
	print('[', @lines, ']');
}

_main(@ARGV);

