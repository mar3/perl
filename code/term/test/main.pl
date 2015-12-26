#!/usr/bin/env perl
# coding: utf-8
#
# Perl で top のようなアプリケーションを作成するためのサンプル
#
#

use strict;
use Term::Screen;
use Time::HiRes;


sub _println {

	print(@_, "\n");
}

sub _main {

	my $scr = new Term::Screen;
	my $input = '';

	while(1) {

		if($input eq 'q') {
			$scr->at(2, 0);
			print("\n");
			last;
		}

		$scr->clrscr();

		$scr->at(0, 0);
		print('[', $input, ']');

		$scr->at(1, 0);
		print('--------------------');

		$scr->at(2, 0);
		print('PRESS ANY KEY>');
		# $scr->at(2, 14);

		$input = '';

		my $key = $scr->getch();

		#if($scr->key_pressed()) {
		if(length($key)) {
			$input = $key;
			# sleep(1);
		}

		Time::HiRes::sleep(0.001);
	}
}

_main(@ARGV);
