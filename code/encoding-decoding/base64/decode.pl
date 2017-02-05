#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use MIME::Base64;

sub _attach_stdin {

	my $rin = '';
	vec($rin, fileno(STDIN),  1) = 1;
	my $r = select($rin, undef, undef, 0.0);
	return 1 == $r;
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my ($s) = @_;

	if (_attach_stdin()) {
		while (my $line = <STDIN>) {
			$s = $line;
			$s = MIME::Base64::decode_base64($s);
			utf8::decode($s);
			print($s);
		}
	}
	else {
		$s = MIME::Base64::decode_base64($s);
		utf8::decode($s);
		print($s);
	}
}

_main(@ARGV);
