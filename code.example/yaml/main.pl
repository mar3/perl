#!/usr/bin/perl
# coding: utf-8
#
# YAML の読み書きサンプル
#
#
#
#

use strict;
use YAML;
use Data::Dumper;


sub _println {

	print(@_, "\n");
}

sub _save {

	my ($path, $dataset) = @_;



	# 一度文字列表現に変換してから UTF-8 フラグを立てる
	if(1) {
		my $source = YAML::Dump($dataset);
		utf8::decode($source);
		$dataset = YAML::Load($source);
	}

	# ファイルに保存
	YAML::DumpFile($path, $dataset);
}

sub _load {

	my ($path) = @_;



	# 読み込み
	my $dataset = YAML::LoadFile($path);

	# 一度文字列表現に変換してから UTF-8 フラグを落とす
	if(1) {
		my $source = YAML::Dump($dataset);
		utf8::encode($source);
		$dataset = YAML::Load($source);
	}

	return $dataset;
}

sub _main {

	my $path = 'sample.yml';

	# =========================================================================
	# データ構造を YAML 形式で保存するテスト
	# =========================================================================
	{
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

		_save($path, $dataset);
	}

	# =========================================================================
	# YAML ファイルから読みこんでダンプするテスト
	# =========================================================================
	{
		my $dataset = _load($path);

		_println(Data::Dumper::Dumper($dataset));
	}
}

_main(@ARGV);

