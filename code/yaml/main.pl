#!/usr/bin/perl
# coding: utf-8

use strict;
use utf8;
use YAML;
use File::Temp;




sub _println {

	print(@_, "\n");
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');







	my $temp_path = File::Temp::tempnam('/tmp', '');


	#
	# store
	#

	my $dataset = {
		'key1' => 'value of 1',
		'key2' => 'キー(2)の値',
		'key3' => [ '配列の要素', '配列の要素', '配列の要素' ],
		'キー4' => {
			'サブキー4-1' => 'C:\\Program Files\\',
			'サブキー4-2' => {
				'key1' => 'bbbbbbbbbbbbbbbbbbbb',
				'key2' => 'cccccccccc\\ccccccccc'
			},
		},
		'表1' => 'ソソソソソソソソソソソソソソソ"ソソソソ',
		'表2' => "\x0a表\x0a",
	};

	YAML::DumpFile($temp_path, $dataset);



	#
	# load
	#

	$dataset = YAML::LoadFile($temp_path);

	_println(YAML::Dump($dataset));



	#
	# erase
	#

	unlink($temp_path);
}

_main(@ARGV);

