#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use YAML;
use JSON;

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my @lines = <STDIN>;
	my $content = join('', @lines);
	$content = YAML::Load($content);
	$content = JSON::to_json($content, {pretty => 1});
	print($content);
	print("\n");
	return;
}

_main();
