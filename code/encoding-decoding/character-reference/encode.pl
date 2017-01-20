#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use HTML::Entities;

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	foreach my $line (<STDIN>) {
		print(HTML::Entities::encode_entities($line));
	}
}

_main(@ARGV);
