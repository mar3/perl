#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use LWP::UserAgent;
use HTTP::Request::Common;
use Encode;

sub _println {

	print(@_, "\n");
}

# utf8 フラグが立っていれば落とした文字列を返します。
sub _invalidate_utf8_flag {

	my ($text) = @_;
	if (utf8::is_utf8($text)) {
		utf8::encode($text);
	}
	return $text;
}

# Slack チャネルにファイルを投稿します。
sub _upload_file {

	my ($channels, $text, $file) = @_;

	# あらかじめ作成しておいた Slack Application のアクセストークンを使用します。
	my $access_token = `cat .access-token`;

	my $url = 'https://slack.com/api/files.upload';

	my $content = {
		token => $access_token,
		initial_comment => _invalidate_utf8_flag($text),
		channels => $channels,
		file => [ $file ]
	};
	my $ua = LWP::UserAgent->new();
	my $req = $ua->request(POST $url, Content_Type => 'form-data', Content => $content);
	if (!$req->is_success()) {
		_println('[ERROR] 失敗');
		return;
	}

	_println($req->content);
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_upload_file('notifications', 'サズケヨウ', '0.jpg');

	_println('Ok.');
}

_main(@ARGV);
