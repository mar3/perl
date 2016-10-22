#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use URI::Escape;

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my ($query_string) = @_;
	if(!length($query_string)) {
		$query_string = '東京都新宿区新宿1-1';
	}
	$query_string = URI::Escape::uri_escape_utf8($query_string);
	print('[', $query_string, ']', "\n");
}

_main(@ARGV);
