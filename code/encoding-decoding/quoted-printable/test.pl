#!/usr/bin/env perl
# coding: utf-8


use strict;
use MIME::QuotedPrint;






sub _println {

	print(@_, "\n");
}

sub _test_qp {

	my $source = 'あいうえお 表示 ソ連'."\n".'だーーーーーーーー';
	$source = MIME::QuotedPrint::encode_qp($source);
	_println('Qエンコードされた文字列:[', $source, ']');
	$source = MIME::QuotedPrint::decode_qp($source);
	_println('元の文字列:[', $source, ']');
}

sub _main {

	_test_qp();
}

_main(@ARGV);
