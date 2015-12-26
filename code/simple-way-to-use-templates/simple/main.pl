#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Template;

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $path = 'sample.tt';
	my $tt = new Template(ENCODING => 'utf-8');
	my $vars = {};
	$vars->{'url'} = 'https://www.example.com/accounts/accept?id=e1bbc262-a457-46be-acd6-6b8d5e12e24a';
	$vars->{'rcpt_to'} = 'somebody.to.love@example.jp';
	$vars->{'mail_from'} = 'the.starman@example.jp';
	$tt->process($path, $vars);
}

_main(@ARGV);
