#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use LWP::UserAgent;
use JSON;

sub main {

	binmode(STDIN,  ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $values = {text => 'てすてす'};
	my $content = JSON::to_json($values, {utf8 => 1});

	my $url = `cat slack.url`;
	chomp($url);

	my $ua = LWP::UserAgent->new();
	my $response = $ua->post(
		$url,
		Content_Type => 'application/json; charset=UTF-8',
		Content => $content);
	if(!$response->is_success) {
		print($response->status_line, "\n");
		return;
	}

	print($response->decoded_content, "\n");
}

main(@ARGV);
