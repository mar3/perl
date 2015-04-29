#!/usr/bin/env perl
# coding: utf-8
use strict;
use Data::Dumper;

sub _execute {

	my (%x) = @_;



	$x{'key1'} = 'Modified?';
	$x{'key3'} = 'Modified?';
}

sub _main {

	local $Data::Dumper::Indent = 1;
	local $Data::Dumper::Sortkeys = 1;
	local $Data::Dumper::Terse = 1;

	my %x = (
		'key1' => 'value of 1',
		'key2' => 'value of 2',
	);

	_execute(%x);

	print(Data::Dumper::Dumper(\%x));
}

_main(@ARGV);

