#!/usr/bin/env perl
# coding: utf-8
#
# Digest
#

use Digest::MD5;

sub _main {

	my $s = Digest::MD5::md5_hex(@_);
	print('[', $s, ']', "\n");
}

_main(@ARGV);

