#!/usr/bin/perl
# coding: utf-8
#
#
#
# ESTABLISHED なセッションを表示します。
# netstat の簡易ラッパーです。
#
# 環境:
#    - CentOS 6.5
#    - netstat 1.42 (2001-04-15)
#
#
#

use strict;
use Getopt::Long;
use Time::HiRes;


sub _println {

	print(@_, "\n");
}

sub _get_timestamp {
	
	my ($sec1, $usec) = Time::HiRes::gettimeofday();
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime($sec1);
	my $msec = int($usec / 1000);
	return sprintf('%04d-%02d-%02d %02d:%02d:%02d.%03d',
		1900 + $year, 1 + $mon, $mday, $hour, $min, $sec, $msec);
}

sub _plain_handler {

	return 1;
}

sub _normal_handler {

	my ($line, $requested_port) = @_;



	my ($protocol, undef, undef, $local, undef, undef) = split(' ', $line);
	my ($interface, $port) = split(':', $local);
	if($port eq $requested_port) {
		return 1;
	}
	return 0;
}

sub _create_line_handler {

	my ($port) = @_;



	if(!length($port)) {
		return \&_plain_handler;
	}
	else {
		return \&_normal_handler;
	}
}

sub _print_active_connections {

	my ($port) = @_;



	#
	# 時計
	#
	# system('/bin/date');
	_println('[', _get_timestamp(), ']');
	_println('-------------------------');

	my $sessions = 0;

	#
	# netstat を実行します。
	#
	# 行解析操作を決定します。
	my $line_handler = _create_line_handler($port);

	my $stream = undef;
	my $command_text = '/bin/netstat -nap | /bin/grep ESTABLISHED | /bin/sort |';
	if(!open($stream, $command_text)) {
		_println('[error] ', $!);
		return;
	}
	while(my $line = <$stream>) {
		if(!$line_handler->($line, $port)) {
			next;
		}
		print($line);
		$sessions++;
	}
	close($stream);

	#
	# サマリー出力
	#
	_println('(detected ', $sessions, ' connections)');
}

sub _usage {

	_println('usage:');
	_println('    --help: show this message.');
	_println('    --port: port number to watch. (shows all without this)');
	_println('    --interval: interval. in seconds, floating.');
	_println('    ');
}

sub _main {

	my $action_help = undef;
	my $option_port = undef;
	my $option_interval = 3;



	my $state = Getopt::Long::GetOptions(
			'help!' => \$action_help,
			'port=i' => \$option_port,
			'interval=f' => \$option_interval);
	if(!$state) {
		_usage();
		return;
	}

	if($option_interval <= 0.5) {
		$option_interval = 0.5;
	}

	while(1) {
		_print_active_connections($option_port);
		Time::HiRes::sleep($option_interval);
		_println();
	}
}

_main(@ARGV);
