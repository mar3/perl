#!/usr/bin/env perl
# coding: utf-8



use strict;
use utf8;
use LWP::UserAgent;
use JSON;

sub _post_login {

	my $content = {"email" => "jimm\@gmail.com", "password" => "p\@ssw0rd", "submit1" => "ログイン"};
	my $ua = LWP::UserAgent->new();
	my $response = $ua->post("http://localhost:6767/login", Content => $content);
	if(!$response->is_success) {
		print($response->status_line, "\n");
		return;
	}
	print($response->decoded_content, "\n");
}

sub _main {

	binmode(STDIN,  ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_post_login();
}

_main();

