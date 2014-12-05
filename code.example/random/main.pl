#!/usr/bin/env perl
# coding: utf-8
#
# 乱数
#

use strict;

sub _println {

	print(@_, "\n");
}

sub _main {

	#
	# 乱数を発生(シード値は自動的に変更されている)
	#
	my $values = {};
	foreach (0..99) {
		my $value = int(rand(20));
		$value = sprintf('%08d', $value);
		$values->{$value}++;
	}

	#
	# サンプルをソートして出力
	#
	foreach my $value (sort(keys(%$values))) {
		_println('value=[', $value, ']');
	}
}

_main(@ARGV);
