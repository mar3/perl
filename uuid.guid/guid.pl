#!/usr/bin/perl
use strict;
use Data::GUID;

sub _main {
	my $guid = Data::GUID->new;
	print($guid->as_string(), "\n");
	# 26E28560-F4FA-11E3-85FF-B03299D66150
}

_main();

