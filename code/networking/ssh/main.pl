#!/usr/bin/env perl
# coding: utf-8

use strict;
use POSIX;
use Net::SSH::Perl;
use Data::Dumper;









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
package paths;

our $_instance = undef;

# sub new {

sub get_instance {

	if(!defined($_instance)) {
		$_instance = {};
		$_instance->{'paths'} = {};
		$_instance = bless($_instance, __PACKAGE__);
	}
	return $_instance;
}

sub keys {

	my ($this) = @_;
	return $this->{'paths'};
}

sub push {

	my ($this, $path, $length) = @_;
	$this->{'paths'}->{$path} = {
		'length' => $length
	};
}



















###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package main;

sub _is_pathname {

	my $s = shift;
	if($s =~ m/\A\//ms) {
		return 1;
	}
	return 0;
}

sub _is_num {

	my $s = shift;
	if($s =~ m/\A[0-9]+\z/ms) {
		return 1;
	}
	return 0;
}

sub _validate_fields {

	my ($perm, $num, $owner, $group, $length, $date, $time, $timezone, $path) = @_;



	if(!_is_num($num)) {
		warn('format invalid. [field:num] "', $num, '"');
	}

	if(!_is_pathname($path)) {
		warn('format invalid. [field:path]');
	}
}

sub _read_line {

	my ($line, $handler) = @_;
	my @fields = split(' ', $line, 9);
	my ($perm, $num, $owner, $group, $length, $date, $time, $timezone, $path) = @fields;
	_validate_fields(@fields);
	print(Data::Dumper::Dumper($path));
}

sub _read_stream {

	my ($stream) = @_;
	while(my $line = <$stream>) {
		chomp($line);
		_read_line($line);
	}
}

sub _main {

	local $Data::Dumper::Indent = 1;
	local $Data::Dumper::Sortkeys = 1;
	local $Data::Dumper::Terse = 1;

	my $manager = paths::get_instance();




	#
	# Net::SSH を利用したケース
	#
	if(0) {

		# 重要(1023 アドレスが既に使用されています、という無意味なエラーを回避する)
		POSIX::setlocale(POSIX::LC_ALL, 'C');

		my $ssh = Net::SSH::Perl->new('127.0.0.1', protocol => '2,1');
		$ssh->login('root','root');
		my ($stdout, $stderr, $exit) = $ssh->cmd('find ~/ -type f | xargs /bin/ls -lF --full-time --color=auto');
		chomp($stdout);
		out::println('[', $stdout, ']');
	}

	#
	# Net::SSH が使えないケース
	#
	if(0) {
		my $stream = undef;
		my $command_text = 'find /etc -type f | xargs /bin/ls -lF --full-time |';
		if(!open($stream, $command_text)) {
			out::println('[ERROR] ', $!);
			return;
		}
		_read_stream($stream);
		close($stream);
	}

	if(1) {
		my $stream = undef;
		my $command_text = '/usr/bin/ssh root@127.0.0.1 \'/bin/find ~/documents -type f | /usr/bin/xargs /bin/ls -lF --full-time\' |';
		if(!open($stream, $command_text)) {
			out::println('[ERROR] ', $!);
			return;
		}
		_read_stream($stream);
		close($stream);
	}
}

main::_main();
