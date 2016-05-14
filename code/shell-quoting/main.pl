#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use String::ShellQuote;

sub _main {

	my $path = shift;

	binmode(STDIN, ':utf8');
	# binmode(STDOUT, ':utf8');
	# binmode(STDERR, ':utf8');

	$path = String::ShellQuote::shell_quote($path);
	my $stream;
	if(!open($stream, $path)) {
		print('[INFO] message="', $!, "\", path=\"", $path, "\"\n");
		return;
	}
	while(my $line = <$stream>) {
		print($line);
	}
	close($stream);
}

_main(@ARGV);

