#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use JSON;

sub _test {

	my $parameters = {@_};
	my $text = JSON::to_json($parameters, {pretty => 1});
	print($text, "\n");
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_test(
		'LPARAM' => 'lparam の値～',
		'RPARAM' => 'rparam の値－',
		'その他のキー' => '東京都新宿区新宿1-1'
	);
}

_main();
