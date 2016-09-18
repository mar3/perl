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

	my $url = 'https://pycon.jp/2016/ja/speaker/list';
	my $response = $ua->get($url);
	if(!$response->is_success) {
		# print('code=[', $response->code, '], message=[', $response->message, ']', "\n");
		_println($response->status_line);
		return;
	}

	for my $line (split("\n", $response->decoded_content)) {
		if($line =~ m/\<a\ href\=\"\/2016\/ja\/speaker\/profile\/([0-9]+)\/\"\>(.+)\<\/a\>/msi) {
			my ($speaker_id, $speaker_name) = ($1, $2);
			_println($speaker_name);
		}		
	}
}

_main();
