#!/usr/bin/perl
# coding: utf-8

use strict;
use Time::HiRes;

sub _get_date {

	my (undef, undef, undef, $mday, $mon, $year, undef, undef, undef) = localtime();
	return sprintf('%04d-%02d-%02d',
		1900 + $year, 1 + $mon, $mday);
}

sub _get_timestamp {

	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime();
	return sprintf('%04d-%02d-%02d %02d:%02d:%02d',
		1900 + $year, 1 + $mon, $mday, $hour, $min, $sec);
}

sub _get_timestamp2 {

	my ($sec1, $usec) = Time::HiRes::gettimeofday();
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime($sec1);
	my $msec = int($usec / 1000);
	return sprintf('%04d-%02d-%02d %02d:%02d:%02d.%03d',
		1900 + $year, 1 + $mon, $mday, $hour, $min, $sec, $msec);
}

sub _main {

	printf("- 日付:\n> [%s]\n", _get_date());
	printf("- 普通のタイムスタンプ:\n> [%s]\n", _get_timestamp());
	printf("- 少し高精度なタイムスタンプ:\n> [%s]\n", _get_timestamp2());
}

_main();
