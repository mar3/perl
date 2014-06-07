#!/usr/bin/perl
# coding: utf-8

use strict;
use Time::HiRes;

sub _get_timestamp {
	
	my ($sec1, $usec) = Time::HiRes::gettimeofday();
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime($sec1);
	my $msec = int($usec / 1000);
	return sprintf('%04d-%02d-%02d %02d:%02d:%02d.%03d',
		1900 + $year, 1 + $mon, $mday, $hour, $min, $sec, $msec);
}

sub _main {

	print('[', _get_timestamp(), ']', "\n");
}

_main();
