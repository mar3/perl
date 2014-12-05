#!/usr/bin/env perl
# coding: utf-8
#
# コマンドライン引数の処理
#
#
#

use strict;
use Getopt::Long;

sub _println {

	print(@_, "\n");
}

sub _main {

	my $option_help = undef;
	my $option_protocol = undef;
	my $option_port = undef;



	if(!Getopt::Long::GetOptions(
			'help' => \$option_help,
			'protocol=s' => \$option_protocol,
			'port=i' => \$option_port)) {
		return;
	}

	_println('--help=[', , $option_help, ']');
	_println('--action=[', , $option_protocol, ']');
	_println('--port=[', , $option_port, ']');
}

_main(@ARGV);




