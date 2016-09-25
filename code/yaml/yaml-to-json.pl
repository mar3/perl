#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use YAML;
use JSON;
use Data::Dumper;

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my @lines = <STDIN>;
	my $content = join('', @lines);
	$content = YAML::Load($content);
	# print(YAML::Dump($content), "\n");

	if(1) {
		local $Data::Dumper::Indent = 1;
		local $Data::Dumper::Sortkeys = 1;
		local $Data::Dumper::Terse = 1;
		print(Data::Dumper::Dumper($content), "\n");
		return;
	}

	if(1) {
		$content = JSON::to_json($content, {pretty => 1});
		print($content);
		print("\n");
		return;
	}
}

_main();
