#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Encode;

sub _println {

	print(@_, "\n");
}

sub _right {

	my ($s, $len) = @_;
	$s = substr($s, length($s) - $len);
	return $s;
}

sub _test {

	my $s = shift;
	my $size = rand(length($s));
	$size = int($size);
	_println('[', $s, '] の終端から', $size, '文字を抜き出すと [', _right($s, $size), '] になります。');
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	srand(time());

	_test('abc');
	_test('あいうえお');
	_test('滋賀県');
	_test('職務経歴表');
}

_main(@ARGV);
