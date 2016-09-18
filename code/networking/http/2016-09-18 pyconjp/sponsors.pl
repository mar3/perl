#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use LWP::UserAgent;

sub _println {

	print(@_, "\n");
}

sub _main {

	binmode(STDIN,  ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $ua = LWP::UserAgent->new();
	$ua->default_header('Accept-Language' => 'ja');
	$ua->agent('Mozilla/5.0');

	my $url = 'https://pycon.jp/2016/ja/sponsors/';
	my $response = $ua->get($url);
	if(!$response->is_success) {
		# print('code=[', $response->code, '], message=[', $response->message, ']', "\n");
		_println($response->status_line);
		return;
	}

	my $sponsor = {};
	my $current_category = '';
	for my $line (split("\n", $response->decoded_content)) {
		if($line =~ m/\<H2\>(.+)\<\/H2\>/msi) {
			$current_category = $1;
			# _println('###', $sponsor_category);
		}		
		elsif($line =~ m/\<H4\>(.+)\<\/H4\>/msi) {
			my $sponsor_name = $1;
			_println($current_category, '	', $sponsor_name);
		}		
	}
}

_main();
