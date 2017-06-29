#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Data::Dumper;

sub _return_array_ref {

	my @values = ('aaa', 'bbb', 'ccc');
	return \@values;
}

sub _dump {

	local $Data::Dumper::Indent = 1;
	local $Data::Dumper::Sortkeys = 1;
	local $Data::Dumper::Terse = 1;
	print(Data::Dumper::Dumper(@_));
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $ref = _return_array_ref();
	foreach my $e (@$ref) {
		$e = uc($e);
	}

	_dump($ref);
}

_main(@ARGV);

