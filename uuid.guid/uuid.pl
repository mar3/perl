#!/usr/bin/perl
# coding: utf-8
#
# UUID を生成するサンプルです。
#
use strict;
use Data::UUID;

sub _main {
	my $g = Data::UUID->new;
	print($g->create_str(), "\n");
}

_main();

