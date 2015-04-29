#!/usr/bin/env perl
# coding: utf-8
#
#
# Perl でデーモン
#
#
#
#
#
#

use strict;
use Data::Dumper;
use Proc::Daemon;
use File::Spec::Functions;
use Getopt::Long;
use Cwd;
use Time::HiRes;








###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package out;

sub println {

	print(@_, "\n");
}









###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package util;

sub get_timestamp {
	
	my ($sec1, $usec) = Time::HiRes::gettimeofday();
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime($sec1);
	my $msec = int($usec / 1000);
	return sprintf('%04d-%02d-%02d %02d:%02d:%02d.%03d',
		1900 + $year, 1 + $mon, $mday, $hour, $min, $sec, $msec);
}









###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package logger;

sub info {

	my $timestamp = util::get_timestamp();
	my $stream = undef;
	open($stream, '>> daemon.log');
	print($stream $timestamp, ' (', $$, ') [info] ', @_, "\n");
	close($stream);
}





###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package application;

my $_state = 1;

sub quit {

	$_state = 0;
}

sub alive {

	return $_state;
}

sub run {

	logger::info('### start ###');
	while(application::alive()) {
		logger::info('(処理中)');
		sleep(1);
	}
	logger::info('--- end ---');
}













###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package main;

sub _on_signal {

	my ($signal) = @_;
	logger::info('caught signal [', $signal, ']');
	application::quit();
}

sub _start {

	#
	# wip...
	#
	my $pidfile = catfile(getcwd(), 'pidfile.pid');
	my $daemon = Proc::Daemon->new(
		pid_file => $pidfile,
		work_dir => getcwd()
	);
	my $pid = $daemon->Status($pidfile);
	if($pid) {
		out::println('Already running.');
		return;
	}

	#
	# setup
	#
	$pid = $daemon->Init;
	if(!$pid) {
		# メイン処理
		application::run();
	}
	else {
		# シェル側
	}
}

sub _status {

	#
	# wip...
	#
	my $pidfile = catfile(getcwd(), 'pidfile.pid');
	my $daemon = Proc::Daemon->new(
		pid_file => $pidfile,
		work_dir => getcwd()
	);
	my $pid = $daemon->Status($pidfile);
	if(!$pid) {
		out::println("Not running.");
		return;
	}

	#
	# status
	#
	out::println("Running with pid $pid.");
}

sub _stop {

	#
	# wip...
	#
	my $pidfile = catfile(getcwd(), 'pidfile.pid');
	my $daemon = Proc::Daemon->new(
		pid_file => $pidfile,
		work_dir => getcwd()
	);
	my $pid = $daemon->Status($pidfile);
	if(!$pid) {
		out::println("Not running.");
		return;
	}

	#
	# shutting down
	#
	out::println("Stopping pid $pid...");
	if(!$daemon->Kill_Daemon($pidfile, 2)) {
		out::println("Could not find $pid.  Was it running?");
		return;
	}
	out::println("Successfully stopped.");
}

sub _usage {

	out::println('usage:');
	out::println('    --help: show this message.');
	out::println('    --start: start.');
	out::println('    --stop: stop.');
	out::println();
}

sub _main {

	my $action_help = '';
	my $action_start = '';
	my $action_status = '';
	my $action_stop = '';

	if(!Getopt::Long::GetOptions(
		'help!' => \$action_help,
		'start!' => \$action_start,
		'status!' => \$action_status,
		'stop!' => \$action_stop
	)) {
		_usage();
		return;
	}

	#
	# startup
	#

	foreach my $sign ('INT', 'TERM') {
		$SIG{$sign} = \&main::_on_signal;
	}

	if($action_help) {
		_usage();
	}
	elsif($action_stop) {
		_stop();
	}
	elsif($action_status) {
		_status();
	}
	elsif($action_start) {
		_start();
	}
	else {
		_usage();
	}
}

_main(@ARGV);

