#!/usr/bin/env perl
# coding: utf-8
#
# 一時ディレクトリのテスト
#
#


use strict;
use File::Temp;


sub _test_tmpfile {

	# 一時ファイル
	my $tmp = File::Temp->new(UNLINK => 1, SUFFIX => '.dat');

	print($tmp "Hello\n");
	print($tmp "Hello\n");
	print($tmp "Hello\n");
}

sub _main {

	# 一時ディレクトリ
	my $unknown = File::Temp::tempdir();

	print('[', $unknown, ']', "\n");

	if(-d $unknown) {
		rmdir($unknown);
	}
}

_main();

