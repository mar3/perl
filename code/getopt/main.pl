#!/usr/bin/env perl
# coding: utf-8
#
# コマンドライン引数の処理
#
#
#

use utf8;
use strict;
use Getopt::Long;

sub _println {

	print(@_, "\n");
}

sub _usage {

	_println('usage:');
	_println('    --help, -h: show this message.');
	_println('    --protocol, -pr: protocol. specify tcp or udp.');
	_println('    --port, -po: port.');
	_println('    --v, -v: verbose. --vv is more, --vvv is more and more.');
	_println('');
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $option_help = undef;
	my $option_protocol = undef;
	my $option_port = undef;
	my $option_v = undef;
	my $option_vv = undef;
	my $option_vvv = undef;







	if(!Getopt::Long::GetOptions(
		'help' => \$option_help,
		'protocol=s' => \$option_protocol,
		'port=i' => \$option_port,
		'v!' => \$option_v,
		'vv!' => \$option_vv,
		'vvv!' => \$option_vvv,
	)) {
		_usage();
		return;
	}




	_println('--help=[', $option_help, ']');
	_println('--action=[', $option_protocol, ']');
	_println('--port=[', $option_port, ']');
	_println('--v=[', $option_v, ']');
	_println('--vv=[', $option_vv, ']');
	_println('--vvv=[', $option_vvv, ']');
}

_main(@ARGV);
