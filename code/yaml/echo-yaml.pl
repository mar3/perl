#!/usr/bin/perl
# coding: utf-8

use strict;
use utf8;
use YAML;


sub _println {

	print(@_, "\n");
}

sub _main {

	my ($path) = @_;

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $dataset = YAML::LoadFile($path);

	_println(YAML::Dump($dataset));
}

_main(@ARGV);
