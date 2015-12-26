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
use Getopt::Long;


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

sub _show_node {

	my ($e, $option_type) = @_;



	if($option_type eq '--full') {

		$e = _normalize($e);
		$e = YAML::Dump($e);
		$e = _normalize($e);

		_println($e);
		_println();
	}

	if($option_type eq '--simple') {

		_println(
			'screen_name: ', _normalize($e->{'screen_name'}),
			', name: ', _normalize($e->{'name'}),
			', location: ', _normalize($e->{'location'}),
			', description: ', _normalize($e->{'description'}));
	}

	if($option_type eq '--tiny') {

		_println(
			'', _normalize($e->{'screen_name'}),
			', ', _normalize($e->{'name'}));
	}

	# _println($e);
}

sub _open_twitter {

	my $settings = _configure();
	if(!defined($settings)) {
		die('ERROR: CONFIGURATION FAILURE!');
	}

	return Net::Twitter->new(
		traits => ['API::RESTv1_1'],
		consumer_key => $settings->{'consumer_key'},
		consumer_secret => $settings->{'consumer_secret'},
		access_token => $settings->{'token'},
		access_token_secret => $settings->{'token_secret'});
}

sub _print {

	my ($t, $option_type, $next_cursor) = @_;

	my $params = {};
	if(length($next_cursor)) {
		$params->{cursor} = $next_cursor;
	}
	my $resultset = $t->friends($params);
	if(!defined($resultset)) {
		return 0;
	}
	my $users = $resultset->{'users'};
	my $count = 0;
	for my $e (@$users) {
		_show_node($e, $option_type);
		$count++;
	}

	_println('next_cursor is [', $resultset->{'next_cursor'}, ']');

	if(!length($resultset->{'next_cursor'})) {
		return $count;
	}
	if($resultset->{'next_cursor'} eq '0') {
		return $count;
	}
	$count += _print($t, $option_type, $resultset->{'next_cursor'});
	return $count;
}

sub _show_followings {

	my ($option_type) = @_;
	my $t = _open_twitter();
	my $count = _print($t, $option_type);
	_println($count, '人をフォローしています。');
}

sub _usage {

	_println('USAGE:');
	_println('    --help: Show this.');
	_println('    --full: Verbose.');
	_println('    --simple: Simple.');
	_println('    --tiny: Tiny.');
}

sub _main {

	my $option_help = 0;
	my $option_full = 0;
	my $option_simple = 0;
	my $option_tiny = 0;

	if(!Getopt::Long::GetOptions(
			'help!' => \$option_help,
			'full!' => \$option_full,
			'simple!' => \$option_simple,
			'tiny!' => \$option_tiny
	)) {
		_usage();
		return;
	}

	if($option_help) {
		_usage();
		return;
	}

	if($option_full) {
		_show_followings('--full');
		return;
	}

	if($option_simple) {
		_show_followings('--simple');
		return;
	}

	if($option_tiny) {
		_show_followings('--tiny');
		return;
	}

	_show_followings('--tiny');
	return;

}

_main(@ARGV);
