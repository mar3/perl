#!/usr/bin/env perl
# coding: utf-8

use utf8;
use strict;
use Encode;
use Net::Twitter;
use File::Spec::Functions;
use YAML;



sub _println {

	print(@_, "\n");
}

sub _configure {

	my $home = `echo ~/`;
	chomp($home);
	my $path = File::Spec::Functions::catfile($home, '.twitter-settings.yml');
	my $stream = undef;
	if(!open($stream, $path)) {
		_println('[warn] cannot open [', $path, ']');
		return undef;
	}
	my $settings = YAML::LoadFile($path);
	return $settings;
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');



	my $settings = _configure();
	if(!defined($settings)) {
		return;
	}

	print('Tweet or Ctrl+C> ');

	my $text = '';
	while(my $line = <STDIN>) {
		if($line eq ".\n") { last }
		$text .= $line;
	}

	if(!length($text)) {
		_println('[info] キャンセル');
		return;
	}

	if($text =~ m/\A[\r\n\t\ ]*\z/ms) {
		_println('[info] キャンセル');
		return;
	}

	my $t = Net::Twitter->new(
		traits => ['API::RESTv1_1'],
		consumer_key => $settings->{'consumer_key'},
		consumer_secret => $settings->{'consumer_secret'},
		access_token => $settings->{'token'},
		access_token_secret => $settings->{'token_secret'});
	my $result = $t->update($text);
	print(YAML::Dump($result));
}

main::_main(@ARGV);
