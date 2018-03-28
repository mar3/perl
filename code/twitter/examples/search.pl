#!/usr/bin/env perl
# coding: utf-8
#
# Twitter のテスト

use strict;
use utf8;
use Encode;
use Getopt::Long;
use Net::Twitter;
use Data::Dumper;
use File::Spec::Functions;
use YAML;
use Cwd;


sub _println {

	print(@_, "\n");
}

sub _configure {

	my $home = `echo ~/`;
	chomp($home);
	my $path = File::Spec::Functions::catfile($home, '.twitter-settings.yml');
	my $stream = undef;
	if(!open($stream, $path)) {
		_println('[ERROR] cannot open [', $path, ']');
		return undef;
	}
	my $settings = YAML::LoadFile($path);

	if (0) {
		local $Data::Dumper::Indent = 1;
		local $Data::Dumper::Sortkeys = 1;
		local $Data::Dumper::Terse = 1;
		# print Dumper($settings);
	}

	return $settings;
}

sub _main {

	my ($s) = @_;

	# my $option_help = 0;
	# Getopt::Long::GetOptions('help!' => \$option_help);

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $settings = _configure();
	if(!defined($settings)) {
		return;
	}

	my $nt = Net::Twitter->new(
		traits => ['API::RESTv1_1'],
		consumer_key => $settings->{'consumer_key'},
		consumer_secret => $settings->{'consumer_secret'},
		access_token => $settings->{'token'},
		access_token_secret => $settings->{'token_secret'});

	if(!length($s)) {
		$s = '友利奈緒';
	}
	utf8::decode($s);
	my $r = $nt->search($s, {
		include_rts => 0,
		exclude_replies => 1,
		count => 100,
	});
	$r = $r->{'statuses'};
	foreach my $e (@$r) {
		if ($e->{'text'} =~ m/\ART\ /ms) {
			next;
		}
		if ($e->{'text'} =~ m/\ART\:/ms) {
			next;
		}
		# print YAML::Dump($e); next;
		my $line = sprintf(
			'%s <%s>: %s',
			$e->{'created_at'},
			$e->{'user'}->{'screen_name'},
			$e->{'text'});
		_println($line);
	}
}

main::_main(@ARGV);

