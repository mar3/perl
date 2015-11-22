#!/usr/bin/env perl
# coding: utf-8


use strict;
use Net::SMTP;

sub _main {

	my $s = Net::SMTP->new('157.7.52.249', Timeout => 15);
	# my $s = Net::SMTP->new('127.0.0.1', Timeout => 15);
	$s->mail('root');
	$s->to('postmaster');
	$s->data();
	$s->datasend('bodyyyyyyyyy');
	$s->dataend();
	$s->quit();
}

_main();

