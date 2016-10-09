#!/usr/bin/env perl
# coding: utf-8


use strict;
use Net::SMTP;

sub _send {

	my $s = Net::SMTP->new('127.0.0.1', Timeout => 15);
	$s->mail('root@example.jp');
	$s->to('mick.jagger@gmail.com');
	$s->data();
	$s->datasend('Date: 2015-12-24 23:58:58', "\n");
	$s->datasend('Subject: This is test.', "\n");
	$s->datasend('From: You <robert.plant@gmail.com>', "\n");
	$s->datasend('Content-Transfer-Encoding: ISO-2022-JP', "\n");
	$s->datasend('Content-Type: text/plain; charset=ISO-2022-JP', "\n");
	$s->datasend('body');
	$s->dataend();
	$s->quit();
}

sub _main {

	_send();
}

_main();

