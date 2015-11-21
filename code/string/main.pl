#!/usr/bin/env perl
# coding: utf-8

use strict;
use Encode;

sub _println {
	print(@_, "\n");
}

sub _makeutf8 {
	my $s = shift;
	if(!Encode::is_utf8($s)) {
		$s = Encode::decode('utf-8', $s);
	}
	return $s;
}

sub _normalize {
	my $s = shift;
	if(utf8::is_utf8($s)) {
		utf8::encode($s);
	}
	return $s;
}

sub _right {
	my ($s, $len) = @_;
	if(!Encode::is_utf8($s)) {
		$s = Encode::decode('utf-8', $s);
	}
	$s = substr($s, length($s) - $len);
	return _normalize($s);
}

sub _test {
	my $s = shift;
	my $size = rand(length(_makeutf8($s)));
	$size = int($size);
	_println('[', $s, '] の終端から', $size, '文字を抜き出すと [', _right($s, $size), '] になります。');
}

sub _main {
	srand(time());
	_test('abc');
	_test('あいうえお');
	_test('滋賀県');
	_test('職務経歴表');
}

_main(@ARGV);
