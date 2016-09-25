#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use File::Temp;

sub _main {

	#
	# 一時的なパス名を生成します。
	#
	# ※この名前のファイルはまだ存在しません。
	#

	my $temporary_path_name = File::Temp::tempnam('/tmp', '.application-name-');

	print('[', $temporary_path_name, ']', "\n");
}

_main();

