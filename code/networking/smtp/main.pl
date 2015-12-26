#!/usr/bin/env perl
# coding: utf-8


use strict;
use Net::SMTP;

sub _main {

	my $s = Net::SMTP->new('127.0.0.1', Timeout => 15);
	$s->mail('root@example.jp');
	$s->to('postmaster@example.jp');
	$s->data();
	$s->datasend('subject: how are you?');
	$s->datasend('body');
	$s->dataend();
	$s->quit();
}

_main();

