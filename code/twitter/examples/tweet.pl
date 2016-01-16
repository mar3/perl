#!/usr/bin/env perl
# coding: utf-8
#
# Twitter のテスト
#

use strict;
use utf8;
use Encode;
use Net::Twitter;
use Data::Dumper;
use File::Spec::Functions;
use YAML;


local $Data::Dumper::Indent = 1;
local $Data::Dumper::Sortkeys = 1;
local $Data::Dumper::Terse = 1;




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
	# print Dumper($settings);
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

	# 不要
	# utf8::decode($text);

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

