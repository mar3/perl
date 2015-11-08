#!/usr/bin/env perl
# coding: utf-8

use strict;
use File::Spec::Functions;

sub _println {

	print(@_, "\n");
}

sub _get_timestamp {

	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime();
	return sprintf('%04d-%02d-%02d %02d:%02d:%02d',
		1900 + $year, 1 + $mon, $mday, $hour, $min, $sec);
}

sub _append_to_file {

	my ($path, @text) = @_;
	my $stream;
	if(!open($stream, '>>'.$path)) {
		die('[ERROR] ', $!);
	}
	print($stream @text, "\n");
	close($stream);
}

sub _main {

	chdir();




	if(-d '.pyenv') {
		_println('[INFO] $HOME/.pyenv/ already exists.');
		return;
	}



	system('git', 'clone', 'https://github.com/yyuu/pyenv.git', '.pyenv');

	_append_to_file('.bash_profile', '');
	_append_to_file('.bash_profile', '# ', _get_timestamp());
	_append_to_file('.bash_profile', '# for pyenv.');
	_append_to_file('.bash_profile', 'export PYENV_ROOT="$HOME/.pyenv"');
	_append_to_file('.bash_profile', 'export PATH="$PYENV_ROOT/bin:$PATH"');
	_append_to_file('.bash_profile', 'eval "$(pyenv init -)"');
	_append_to_file('.bash_profile', '');
}

_main(@ARGV);
