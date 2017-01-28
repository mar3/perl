#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Cwd;









package out;

sub println {

	print(@_, "\n");
}










package directory;

sub cd_home {

	my $home = $ENV{HOME};
	if (!length($home)) {
		die();
	}
	directory::cd_to($home);
}

sub cd_to {

	my ($path) = @_;
	chdir($path);
	my $current_directory = Cwd::getcwd();
	if ($current_directory eq $path) {
		return;
	}
	die();
}



















package util;

sub rtrim {

	my ($line) = @_;
	while (1) {
		if ($line =~ m/\r\z/ms) {
			chop($line);
		}
		elsif ($line =~ m/\n\z/ms) {
			chop($line);
		}
		elsif ($line =~ m/\ \z/ms) {
			chop($line);
		}
		elsif ($line =~ m/\t\z/ms) {
			chop($line);
		}
		else {
			last;
		}
	}
	return $line;
}

sub ltrim {

	my ($line) = @_;
	while (1) {
		if ($line =~ m/\A[\ \t\r\n]+/ms) {
			$line = substr($line, 1);
			next;
		}
		last;
	}
	return $line;
}

sub trim {

	my ($line) = @_;
	$line = ltrim($line);
	$line = rtrim($line);
	return $line;
}
















package prompt;

sub confirm {

	print(@_, "\n");
	print('(y/N)?> ');
	my $input = readline();
	$input = util::rtrim($input);
	$input = uc($input);
	if ($input eq 'YES') {
		return 1;	
	}
	if ($input eq 'Y') {
		return 1;
	}
	return 0;
}



















package amazon_linux;

sub _setup_bash {

	if (!prompt::confirm('bash_aliases のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}

	directory::cd_home();
	my $stream;
	open($stream, '.bashrc');
	my $read_bash_profile = 0;
	while (my $line = <$stream>) {
		$line = util::trim($line);
		if (0 == index($line, '#')) {
			next;
		}
		if ((0 <= index($line, '-f')) && (0 <= index($line, '.bash_aliases'))) {
			$read_bash_profile = 1;
		}
	}
	if ($read_bash_profile) {
		return;
	}
	close($stream);
	open($stream, '>>.bashrc');
	print($stream "\n");
	print($stream 'if [ -f ~/.bash_aliases ]; then', "\n");
	print($stream '	. ~/.bash_aliases', "\n");
	print($stream 'fi', "\n");
	close($stream);
}

sub _setup_vim {

	if (!prompt::confirm('Vim のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	out::println('[Vim] begin setting.');
	directory::cd_home();
	system(
		'wget',
		'https://raw.githubusercontent.com/mass10/vim.note/master/vimrc/.vimrc',
		'--output-document',
		'.vimrc');
	system(
		'sudo',
		'mkdir',
		'-p',
		'/usr/share/vim/vimfiles/colors');
	system(
		'sudo',
		'wget',
		'https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim',
		'--output-document',
		'/usr/share/vim/vimfiles/colors/zenburn.vim');
	system(
		'sudo',
		'wget',
		'https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim',
		'--output-document',
		'/usr/share/vim/vimfiles/colors/molokai.vim');
	out::println('[Vim] ready.');
}

sub _sudo_test_directory {

	my ($path) = @_;
	my $test = `sudo file /root/bin`;
	if (0 <= index($test, 'directory')) {
		return 1;
	}
	return 0;
}

sub _setup_cpanm {

	if (!prompt::confirm('cpanm のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	out::println('[cpanm] begin setting.');
	system('sudo', 'mkdir', '-p', '/root/bin');
	system('sudo', 'curl', '-L', 'https://cpanmin.us/', '-o', '/root/bin/cpanm');
	system('sudo', 'chmod', 'u+x', '/root/bin/cpanm');
	out::println('[cpanm] ready.');
}

sub setup {

	_setup_bash();
	_setup_vim();
	_setup_cpanm();
}


















package main;

sub _diagnose_os {

	my $stream;
	open($stream, '/etc/os-release');
	my $name = '';
	while (my $line = <$stream>) {
		if (0 <= index($line, 'Amazon Linux')) {
			$name = 'Amazon Linux';
		}
		elsif (0 <= index($line, 'CentOS')) {
			$name = 'Amazon Linux';
		}
		elsif (0 <= index($line, 'RedHat Enterprise Linux')) {
			$name = 'Amazon Linux';
		}
		elsif (0 <= index($line, 'Ubuntu')) {
			$name = 'Amazon Linux';
		}
		elsif (0 <= index($line, 'Debian')) {
			$name = 'Amazon Linux';
		}
	}
	close($stream);
	return $name;
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	if ('Amazon Linux' eq _diagnose_os()) {
		out::println('[info] Great! Amazon Linux found!');
		amazon_linux::setup();
	}
	else {
		out::println('[warn] unknown os. nothing todo...');
	}
}

_main(@ARGV);
