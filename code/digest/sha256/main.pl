#!/usr/bin/env perl
# coding: utf-8
#
# Digest
#

use Digest::SHA;

sub _main {

	my $s = Digest::SHA::sha256_hex('abc');
	print('[', $s, ']', "\n");
}

_main(@ARGV);

