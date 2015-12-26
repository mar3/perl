#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use LWP::UserAgent;
use WWW::Mechanize;

sub _main {

	binmode(STDIN,  ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $me = new WWW::Mechanize(autocheck => 1);
	$me->get('https://www.google.co.jp/search?q=jenkins%20ci');
	print($me->content, "\n");
}

_main(@ARGV);
