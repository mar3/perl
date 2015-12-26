#!/usr/bin/perl
# coding: utf-8

use strict;
use utf8;
use Data::Dumper;
use YAML::XS;

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $struct = {
		'氏名' => {'姓' => '新渡戸', '名' => '稲造'},
		'メールアドレス' => 'inazo-funkadelic@gmail.com',
		'住所' => {'都道府県' => '東京都新宿区新宿1-1',
			'郵便番号' => '897-0019',
			'建物名称' => ''
		},
	};

	local $Data::Dumper::Indent = 1;
	local $Data::Dumper::Sortkeys = 1;
	local $Data::Dumper::Terse = 1;

	print(Data::Dumper::Dumper($struct));
}

_main();
