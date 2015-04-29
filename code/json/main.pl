#!/usr/bin/env perl
# coding: utf-8
#
# JSON 変換のサンプル
#
#   ※復元がうまくいかない。
#
#
#
use strict;
use JSON;
use Data::Dumper;
use Encode;

sub _println {

	print(@_, "\n");
}

sub _dump {

	my $x = shift;
	_println(Data::Dumper::Dumper($x));
}

sub _main {

#my $operator = JSON->new->allow_nonref;

	my $set = {
		key1 => 'value 1',
		key2 => 'value 2',
		'キー3' => '日本語ソ表',
		'キー4' => [ '配列要素1', '配列要素2', '配列要素3' ],
	};

	_dump($set);

	# ただしい！
	my $text = JSON::to_json($set);

	# _println($text);

	# if(!Encode::is_utf8($s)) {
	# 	$s = Encode::decode('UTF-8', $s);
	# }

	# _dump(JSON->new->utf8(1)->decode($s));
	# _dump(JSON::decode_json($s));
	# _dump(JSON::from_json($s, { utf8  => 1 }));

	my $json = new JSON;
	$set = $json->decode($text);

	# utf8::encode($text);
	# $set = JSON::from_json($text, { utf8  => 1 });
	# $set = JSON::decode_json($text);
	# $set = $operator->pretty->encode(m_json($text, { utf8  => 1 });

	_dump($set);
}

_main();
