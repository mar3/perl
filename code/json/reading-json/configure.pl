#!/usr/bin/env perl
# coding: utf-8
use strict;
use utf8;
use JSON;
use Data::Dumper;
use Encode;
use YAML;

sub _println {

	print(@_, "\n");
}

sub _read_text_file {

	my ($path) = @_;
	my $stream;
	if (!open($stream, $path)) {
		die();
	}
	binmode($stream, ':utf8');
	my @lines = <$stream>;
	close($stream);
	my $text = join('', @lines);
	return $text;
}

sub _configure {

	# read json file
	my $text = _read_text_file('settings.json');
	my $tree = JSON::from_json($text);
	return $tree;
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $settings = _configure();
	# _println(YAML::Dump($settings));
	_println('name: ', $settings->{name});
	my @nodes = @{$settings->{nodes}};
	foreach my $node (@nodes) {
		_println('hostname: ', $node->{hostname});
	}
}

_main();
