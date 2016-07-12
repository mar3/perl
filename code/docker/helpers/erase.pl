#!/usr/bin/env perl
# coding: uttf-8

use strict;
use utf8;
use Data::Dumper;

sub _is_header_line {

	my ($line) = @_;
	return 0 <= index($line, 'CONTAINER ID');
}

sub _fill_positions {

	my ($positions, $line) = @_;
	if(0 <= index($line, 'CONTAINER ID')) {
		$positions->{'CONTAINER ID'} = index($line, 'CONTAINER ID');
	}
	if(0 <= index($line, 'IMAGE')) {
		$positions->{'IMAGE'} = index($line, 'IMAGE');
	}
	if(0 <= index($line, 'STATUS')) {
		$positions->{'STATUS'} = index($line, 'STATUS');
	}
}

sub _filter_exited {

	my $container = shift;
	if($container->{'STATUS'} =~ m/Exited/ms) {
		return $container;
	}
	return undef;
}

sub _readline {

	my ($positions, $line) = @_;
	if(_is_header_line($line)) {
		_fill_positions($positions, $line);
		return undef;
	}
	my $container = {};
	if(0 <= $positions->{'CONTAINER ID'}) {
		my $container_id = substr($line, $positions->{'CONTAINER ID'});
		$container_id =~ m/\A([a-zA-Z0-9\-\_]+)/ms;
		$container_id = $1;
		$container->{'CONTAINER ID'} = $container_id;
	}
	if(0 <= $positions->{'STATUS'}) {
		my $status = substr($line, $positions->{'STATUS'});
		$status =~ m/\A([a-zA-Z0-9\-\_]+)/ms;
		$status = $1;
		$container->{'STATUS'} = $status;
	}
	return $container;
}

sub _remove {

	my ($container_id) = @_;
	if(!length($container_id)) {
		return;
	}
	system('docker', 'rm', $container_id);
}

sub _erase {

	my $stream = undef;
	if(!open($stream, 'docker ps -a |')) {
		print('[ERROR] ', $!, "\n");
		return;
	}
	my $positions = {};
	while(my $line = <$stream>) {
		my $container = _readline($positions, $line);
		$container = _filter_exited($container);
		_remove($container->{'CONTAINER ID'});
	}
	close($stream)
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_erase();
}

_main(@ARGV);

