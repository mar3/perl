#!/usr/bin/env perl
# coding: utf-8

use strict;
use YAML;

sub _println {

	print(@_, "\n");
}

sub _main {

	my ($path) = @_;
	my $yaml = YAML::Load($path);
	print $yaml;
}

_main(@ARGV);
