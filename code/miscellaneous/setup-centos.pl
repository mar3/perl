#!/usr/bin/env perl
# coding: utf-8

use strict;
use Data::Dumper;

sub _println {

	print(@_, "\n");
}

sub _who_is_executing {

	my $id = `id`;
	$id =~ m/\Auid\=([^(]+)\(([^(]+)\)/ms;
	my $uid = $1;
	my $user = $2;
	return $uid, $user;
}

sub _usage {

	_println('USAGE:');
	_println('    must be excuted by \'root\'.');
	_println('');
}

sub _bashrc {

	my $home = `echo ~`;
	chomp($home);
	return $home.'/.bashrc';
}

sub _setup_bashrc {

	my $stream;

	my $bashrc = _bashrc();

	_println('updating ... [', $bashrc, ']');

	if(!open($stream, $bashrc)) {
		_println('[ERROR] ', $!);
		return;
	}

	my $aliases = {
		'alias l=' => 'alias l=/bin/ls\ -lF\ --full-time\ --color',
		'alias n=' => 'alias n=/bin/ls\ -ltrF\ --full-time\ --color',
		'alias u=' => 'alias u=cd\ ..',
	};

	while(my $line = <$stream>) {
		my @keys = keys(%$aliases);
		foreach my $key (@keys) {
			if(0 != index($line, $key)) {
				next;
			}
			delete($aliases->{$key});
			_println('[info] removing alias that starts with "', $key, '"');
		}
		# print($line);
	}

	close($stream);



	my @keys = keys(%$aliases);
	if(scalar(@keys) == 0) {
		_println('[info] nothing todo...');
		return;
	}

	if(!open($stream, '>>'.$bashrc)) {
		_println('[error] ', $!);
		return;
	}

	print($stream "\n");
	print($stream "\n");
	print($stream "\n");
	print($stream '### ', "\n");

	while(my ($key, $value) = (each(%$aliases))) {
		_println('ADDING ... [', $value, ']');
		print($stream $value, "\n");
	}

	close($stream);
}

sub _main {

	my ($uid, $user) = _who_is_executing();

	if($user ne 'root') {
		_usage();
		return;
	}

	_setup_bashrc();

	_println('Ok.');
}

_main();
