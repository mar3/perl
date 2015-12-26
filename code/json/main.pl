#!/usr/bin/env perl
# coding: utf-8
#
# JSON 変換のサンプル
#
use strict;
use JSON;
use Data::Dumper;
use Encode;
use utf8;
use YAML;





sub _println {

	print(@_, "\n");
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $tree = {
		key1 => 'value 1',
		key2 => 'value 2',
		'キー3' => '日本語ソ表',
		'キー4' => [ '配列要素1', '配列要素2', '配列要素3' ],
	};

	my $text = JSON::to_json($tree);
	_println('[info] HASH -> JSON: ', $text);

	_println('[info] JSON -> HASH');
	$tree = JSON::from_json($text);
	_println(YAML::Dump($tree));

	$text = JSON::to_json($tree);
	_println('[info] HASH -> JSON: ', $text);
}

_main();
