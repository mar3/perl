#!/usr/bin/perl
# coding: utf-8
#
# UUID を生成するサンプルです。
#
use strict;
use Data::UUID;

sub _main {

	my $generator = Data::UUID->new;
	print($generator->create_str(), "\n");
}

_main();
