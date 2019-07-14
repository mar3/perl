#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use YAML;
use Net::Amazon::S3;
use Data::Dumper;

sub _println {

	print(@_, "\n");
}

sub _configure {

	my $conf = YAML::LoadFile('.env');
	return $conf;
}

sub _get_timestamp {

	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime();
	return sprintf('%04d-%02d-%02d %02d:%02d:%02d',
		1900 + $year, 1 + $mon, $mday, $hour, $min, $sec);
}

sub _refresh_temp_file {

	my $stream = undef;
	if (!open($stream, '>ファイル.txt')) {
		die($!);
	}
	binmode($stream, ':utf8');
	my $timestamp = _get_timestamp();
	print($stream $timestamp);
	close($stream);
}

sub _open_s3 {

	# 設定ファイルを読みこみます。
	my $conf = _configure();
	_println("[TRACE] セッションを開いています...");
	my $s3 = Net::Amazon::S3->new(
		aws_access_key_id => $conf->{'aws_access_key_id'},
		aws_secret_access_key => $conf->{'aws_secret_access_key'});
	my $client = Net::Amazon::S3::Client->new(s3 => $s3);
	_println("[TRACE] ok.");
	return $client;
}

sub _open_bucket {

	my ($name) = @_;
	# セッションを開始
	my $client = _open_s3();
	# バケットを作成します。存在している場合は参照になります。
	_println("[TRACE] 新しいバケットを作成しています...");
	my $new_bucket = $client->create_bucket(name => $name, acl_short => 'private');
	_println("[TRACE] ok.");
	return $new_bucket;
}

sub _send {

	my ($bucket_name, $left, $right) = @_;
	# バケットを作成します。存在している場合は参照になります。
	my $bucket = _open_bucket($bucket_name);
	# オブジェクトを作成します。
	_println("[TRACE] ファイルを作成しています...");
	my $object = $bucket->object(key => $right);
	# アップロード
	$object->put_filename($left);
	_println("[TRACE] ok.");
}

sub _test1 {

	# テストファイルをリフレッシュ
	_refresh_temp_file();
	# ファイルをバケットに送信します。
	_send('xxxx-xxxxxxxx-xxxxxxx-xxxxxx-xxxxxx-xxxxxxxxx', 'ファイル.txt', 'ファイル.txt');
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_println("[TRACE] ### START ###");
	_test1();
	_println("[TRACE] --- END ---");
}

_main();
