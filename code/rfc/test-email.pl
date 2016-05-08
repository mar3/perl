#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Email::Valid;

sub _main {

	my $email = shift;
	# my $test = Email::Valid->rfc822($email);
	my $test = Email::Valid->address($email);
	print($email, ": [", $test, "]\n");
}

_main(@ARGV);

