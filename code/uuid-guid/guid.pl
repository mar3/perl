#!/usr/bin/perl
# coding: utf-8
#
# GUID を生成するサンプルです。
#
use utf8;
use strict;
use Data::GUID;

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $guid = Data::GUID->new;
	print($guid->as_string(), "\n");
}

_main();
