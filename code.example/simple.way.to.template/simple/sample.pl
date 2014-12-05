#!/usr/bin/perl

use strict;
use Template;

sub _main {

	my $path = 'sample.tt';
	my $tt = new Template;
	my $vars = {};
	$vars->{'rcpt to'} = 'somebody.to.love@example.jp';
	$vars->{'mail from'} = 'the.starman@example.jp';
	$tt->process($path, $vars);
}

_main(@ARGV);

