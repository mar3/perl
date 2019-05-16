#!/usr/bin/perl
# coding: utf-8

use strict;
use File::Spec::Functions;

sub _test {
	my $path = shift;
	my ($drive, $parent, $name) = File::Spec::Functions::splitpath($path);
	printf('path=[%s] >>> drive=[%s], parent=[%s], name=[%s]', $path, $drive, $parent, $name);
	print("\n");
}

sub _exec_by_arguments {
	my $count = 0;
	foreach my $e (@_) {
		_test($e);
		$count++;
	}
	return $count;
}

sub _main {
	if (_exec_by_arguments(@_)) {
		return;
	}
	_test(undef);
	_test('');
	_test('.');
	_test('..');
	_test('...');
	_test('....');
	_test('simple name');
	_test('normal.suffix');
	_test('normal.txt.suffix');
	_test('a.b.c.d');
	_test('a....b.....c.....d');
	_test('x.');
	_test('x..');
	_test('x...');
	_test('xx.');
	_test('xx..');
	_test('xx...');
	_test('.hidden file');
	_test('.hidden file.suffix');
	_test('..abnormal suffix');
	_test('..abnormal name and.suffix');
	_test('...abnormal name and.suffix');
	_test('/root file');
	_test('/root file.suffix');
	_test('/.root hidden file');
	_test('/.root hidden file.suffix');
	_test('/.root hidden file.middle name.suffix');
}

_main(@ARGV);
