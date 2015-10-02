#!/usr/bin/env perl
# coding: utf-8
#
# 一時ディレクトリのテスト
#
#


use strict;
use File::Temp;

sub _main {

	my $unknown = File::Temp::tempdir();

	print('[', $unknown, ']', "\n");

	if(-d $unknown) {
		rmdir($unknown);
	}
}

_main();

