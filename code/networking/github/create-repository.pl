#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Net::GitHub;

sub _println {

	print(@_, "\n");
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $access_token = `cat .access_token`;
	# Net::GitHub::V3
	my $github = Net::GitHub->new(access_token => $access_token);

	$github->repos->create({
		name => 'simple-chat1',
		description => '' });

	_println('repository created.');
}

_main();
