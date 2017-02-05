#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use MIME::Base64;
use Data::Dumper;

sub _attach_stdin {

	my $rin = '';
	vec($rin, fileno(STDIN),  1) = 1;
	my $r = select($rin, undef, undef, 0.0);
	return 1 == $r;
}

sub _u {

	my ($s) = @_;
	if (utf8::is_utf8($s)) {
		utf8::encode($s);
		return $s;
	}
	return $s;
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my ($s) = @_;

	if (_attach_stdin()) {
		while (my $line = <STDIN>) {
			my $s = $line;
			$s = _u($s);
			my $s = MIME::Base64::encode_base64($s);
			print($s);
		}
	}
	else {
		print(MIME::Base64::encode_base64($s));
	}
}

_main(@ARGV);
