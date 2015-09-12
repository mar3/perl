#!/usr/bin/env perl
# coding: utf-8
#
# Net::Twitter を用いた簡単なサンプル
#

use strict;
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

sub _normalize {

	my $s = shift;
	if(utf8::is_utf8($s)) {
		utf8::encode($s);
	}
	return $s;
}

sub _main {

	my $settings = _configure();
	if(!defined($settings)) {
		return;
	}

	my $t = Net::Twitter->new(
		traits => ['API::RESTv1_1'],
		consumer_key => $settings->{'consumer_key'},
		consumer_secret => $settings->{'consumer_secret'},
		access_token => $settings->{'token'},
		access_token_secret => $settings->{'token_secret'});

	my $resultset = $t->friends();
	my $users = $resultset->{'users'};

	for my $e (@$users) {

		$e = _normalize($e);
		$e = YAML::Dump($e);
		$e = _normalize($e);

		_println($e);
		_println();

		next;

		_println(
			'screen_name: ', _normalize($e->{'screen_name'}),
			', name: ', _normalize($e->{'name'}),
			', location: ', _normalize($e->{'location'}),
			', description: ', _normalize($e->{'description'}));

		# _println($e);
	}
}

main::_main(@ARGV);

