#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use LWP::UserAgent;
use Data::Dumper;




sub _println {

	print(@_, "\n");
}

sub _read {

	my $line = shift;
	if($line =~ m/\<a\ href\=\"([^\"]+)\"\ class\=\"author\"\>([^\<]+)\<\/a\>/ms) {
		my $link = $1;
		my $user = $2;
		# _println('link=[', $link, '], user=[', $user, ']');
		return $user;
	}
	return '';
}

sub _get_github_issue {

	my $ua = LWP::UserAgent->new();
	$ua->default_header('Accept-Language' => 'ja');
	$ua->agent('Mozilla/5.0');
	my $url = 'https://github.com/hachiojipm/yapcasia-8oji-2016mid/issues/4';
	my $response = $ua->get($url);
	if(!$response->is_success) {
		print('[ERROR] code=[', $response->code, '], message=[', $response->message, ']', "\n");
		print('[ERROR] ', $response->status_line, "\n");
		return '';
	}
	return $response->decoded_content;
}

sub _enum_volunteers {

	# 問題のイシューを読みます
	my $content = _get_github_issue();

	# 行にバラしてユーザーを探します
	my @lines = split("\n", $content);
	my $volunteers = {};
	foreach my $line (@lines) {
		my $user = _read($line);
		if(!length($user)) {
			next;
		}
		$volunteers->{$user}++;
	}
	return keys(%$volunteers);
}

sub _show {

	my @volunteers = @_;

	# ファイルに吐き出して sort！！！
	my $stream;
	open($stream, '>/tmp/.yapc8oji-volunteers.tmp');
	foreach my $user (sort(@volunteers)) {
		print($stream $user, "\n");
	}
	close($stream);
	system('sort', '--ignore-case', '/tmp/.yapc8oji-volunteers.tmp');
	unlink('/tmp/.yapc8oji-volunteers.tmp');
}

sub _main {

	binmode(STDIN,  ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	# ボランティアスタッフの人を収集します
	my @volunteers = _enum_volunteers();

	# 表示します
	_show(@volunteers);
}

_main(@ARGV);
