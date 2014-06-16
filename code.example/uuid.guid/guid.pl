#!/usr/bin/perl
# coding: utf-8
#
# GUID を生成するサンプルです。
#
use strict;
use Data::GUID;

sub _main {

	my $guid = Data::GUID->new;
	print($guid->as_string(), "\n");
}

_main();
