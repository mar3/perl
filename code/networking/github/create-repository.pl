#!/usr/bin/env perl
# coding: utf-8
#


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
	my $github = Net::GitHub->new(  # Net::GitHub::V3
		access_token => $access_token
	);

	$github->repos->create({
		name => 'test-test-test',
		description => 'This is test...' });

	_println('repository created.');
}

_main();





