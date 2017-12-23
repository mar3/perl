#!/usr/bin/env perl
# coding: utf-8
#
# Net::Twitter を用いた簡単なサンプル
#

use utf8;
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
	binmode($stream, ':utf8');
	my $settings = YAML::LoadFile($path);
	return $settings;
}

sub _main {

	binmode(STDIN, 'utf8');
	binmode(STDOUT, 'utf8');
	binmode(STDERR, 'utf8');

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

	my $statuses = $t->home_timeline({ count => 1000 });
	for my $status ( @$statuses ) {
		my $line = sprintf(
			'%s <@%s> %s',
			$status->{created_at},
			$status->{user}->{screen_name},
			$status->{text});
		_println($line);
	}
}

main::_main(@ARGV);

