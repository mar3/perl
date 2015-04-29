#!/usr/bin/env perl
# coding: utf-8
#
# クロージャの例
#

use strict;

sub _println {

	print(@_, "\n");
}

{
	my $count = 0;
	sub _get_logger {
		return sub {
			$count++;
			_println('COUNT=(', $count, '): ', @_);
		};
	}
}

sub _subsub {

	my $logging = _get_logger();
	$logging->('hello');
}

sub _sub {

	my $logging = _get_logger();
	$logging->('hello');
	_subsub();
}

sub _main {

	my $logging = _get_logger();
	$logging->('hello');
	_sub();
}

_main(@ARGV);

