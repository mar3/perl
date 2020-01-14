#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Time::HiRes;


sub _get_timestamp {

    my ($sec1, $usec) = Time::HiRes::gettimeofday();
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime($sec1);
    my $msec = int($usec / 1000);
    return sprintf('%04d-%02d-%02d %02d:%02d:%02d.%03d',
    	1900 + $year, 1 + $mon, $mday, $hour, $min, $sec, $msec);
}

sub _trace {

	my $timestamp = _get_timestamp();
	print($timestamp, ' [TRACE] ', @_, "\n");
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_trace('### start ###');

	# TEST CASE 1
	{
		_trace('TEST CASE 1: start');
		my $s = 0;
		for (my $i = 0; $i < 10000000; $i++) {
			$s += 1;
		}
		_trace($s);
		_trace('TEST CASE 1: end');
	}

	# TEST CASE 2
	{
		_trace('TEST CASE 2: start');
		my $s = 0;
		for (my $i = 0; $i < 10000000; $i += 10) {
			$s += 1;
			$s += 1;
			$s += 1;
			$s += 1;
			$s += 1;
			$s += 1;
			$s += 1;
			$s += 1;
			$s += 1;
			$s += 1;
		}
		_trace($s);
		_trace('TEST CASE 2: end');
	}

	_trace('Ok.');
}

_main(@ARGV);

