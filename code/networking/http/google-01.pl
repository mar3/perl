#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use LWP::UserAgent;
# use IO::Socket::SSL;

sub _main {

	binmode(STDIN,  ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	# my $ua = LWP::UserAgent->new(
	#	env_proxy => 1,
	#	ssl_opts => { 
	#		verify_hostname => 0, 
	#		SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE 
	#	},
	#	requests_redirectable => ['GET']
	# );

	my $ua = LWP::UserAgent->new();
	$ua->default_header('Accept-Language' => 'ja');
	$ua->agent('Mozilla/5.0');

	my $url = 'https://www.google.co.jp/search?q=jenkins%20ci';
	my $response = $ua->get($url);
	if(!$response->is_success) {
		# print('code=[', $response->code, '], message=[', $response->message, ']', "\n");
		print($response->status_line, "\n");
		return;
	}
	print($response->decoded_content, "\n");
}

_main(@ARGV);
