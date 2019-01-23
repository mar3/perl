#!/usr/bin/env perl
# coding: uttf-8

use strict;
use utf8;
use Data::Dumper;

package reader;

sub new {

	my ($package_name) = @_;
	my $this = {};
	$this = bless($this, $package_name);
	return $this;
}

sub _read_header_line {

	my ($this, $line) = @_;
	if (-1 == index($line, 'CONTAINER ID')) {
		return 0;
	}
	if(0 <= index($line, 'CONTAINER ID')) {
		$this->{positions}->{'CONTAINER ID'} = index($line, 'CONTAINER ID');
	}
	if(0 <= index($line, 'IMAGE')) {
		$this->{positions}->{'IMAGE'} = index($line, 'IMAGE');
	}
	if(0 <= index($line, 'STATUS')) {
		$this->{positions}->{'STATUS'} = index($line, 'STATUS');
	}
	# print('[TRACE] POSITION: ', Data::Dumper::Dumper($this->{positions}), "\n\n");
	return 1;
}

sub _filter_exited {

	my $container = shift;
	if($container->{'STATUS'} eq 'Exited') {
		return $container;
	}
	return undef;
}

sub _readline {

	my ($this, $line) = @_;

	# print('[TRACE] line: [', $line, ']', "\n");

	# ヘッダー行を無視します。
	if($this->_read_header_line($line)) {
		return undef;
	}

	# コンテナの状況を読み取っています。
	my $container = {};
	if ($line =~ m/\A([a-zA-Z0-9\-\_]+)/ms) {
		$container->{'CONTAINER ID'} = $1;
	}
	if ($line =~ m/Exited\ \([0-9]+\)/ms) {
		$container->{'STATUS'} = 'Exited';
	}
	print('[TRACE] container id: [', $container->{'CONTAINER ID'}, '], status: [', $container->{'STATUS'}, ']', "\n");
	return $container;
}

sub _remove {

	my ($container_id) = @_;
	# print('[TRACE] rm ... [', $container_id, ']', "\n");
	if(!length($container_id)) {
		return;
	}
	system('docker', 'rm', $container_id);
}

sub _erase {

	my ($this) = @_;
	my $stream = undef;
	if(!open($stream, 'docker ps -a |')) {
		print('[ERROR] ', $!, "\n");
		return;
	}
	while(my $line = <$stream>) {
		chomp($line);
		my $container = $this->_readline($line);
		$container = _filter_exited($container);
		_remove($container->{'CONTAINER ID'});
	}
	close($stream)
}

package main;

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	print('### START ###', "\n");

	my $r = new reader();
	$r->_erase();

	print('--- END ---', "\n");
}

_main(@ARGV);

