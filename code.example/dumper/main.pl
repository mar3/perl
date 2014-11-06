#!/usr/bin/perl
# coding: utf-8

use strict;
use Data::Dumper;

sub _main {

	my $struct = {
		'key1' => 'value 1',
		'key2' => {
			'key2-1' => 'value 2-1',
			'key2-2' => [ 'value 2-2-1', 'value 2-2-2', 'value 2-2-3' ]
		},
		'key3' => 'value 3',
	};

	local $Data::Dumper::Indent = 1;
	local $Data::Dumper::Sortkeys = 1;
	local $Data::Dumper::Terse = 1;

	print(Data::Dumper::Dumper($struct));
}

_main();

