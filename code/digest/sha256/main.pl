#!/usr/bin/env perl
# coding: utf-8
#
# Digest
#

use Digest::SHA;

sub _main {

	my ($s) = @_;
	$s = Digest::SHA::sha256_hex($s);
	print('[', $s, ']', "\n");
}

_main(@ARGV);

