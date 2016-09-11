#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;

sub _get_filetime {

	my ($path) = @_;
	my @timestruct = stat($path);
	my $filetime = @timestruct[9];
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime($filetime);
	my $timestamp = sprintf('%04d-%02d-%02d %02d:%02d:%02d', 1900 + $year, 1 + $mon, $mday, $hour, $min, $sec);
	return $timestamp;
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $path = shift;
	my $filetime = _get_filetime($path);
	print("[", $filetime, "]\n");
}

_main(@ARGV);
