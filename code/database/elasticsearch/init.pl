#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use YAML;
use Time::HiRes;
use Data::UUID;
use Search::Elasticsearch;

sub _println {

	print(@_, "\n");
}

sub _get_date {

	my (undef, undef, undef, $mday, $mon, $year, undef, undef, undef) = localtime();
	return sprintf('%04d-%02d-%02d', 1900 + $year, 1 + $mon, $mday);
}

sub _get_timestamp {

	my ($sec1, $usec) = Time::HiRes::gettimeofday();
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime($sec1);
	my $msec = int($usec / 1000);
	return sprintf('%04d-%02d-%02d %02d:%02d:%02d.%03d', 1900 + $year, 1 + $mon, $mday, $hour, $min, $sec, $msec);
}

sub _create_uuid {

	my $generator = Data::UUID->new;
	return $generator->create_str();
}

sub _open_connection {

	my $connection = Search::Elasticsearch->new(nodes => ['127.0.0.1:9200']);
	return $connection;
}

sub _erase_all {

	my $connection = _open_connection();
	if(!$connection->indices->exists(index => 'sake_database')) {
		_println('[INFO] "sake_databse" not found.');
		return;
	}
	_println('[INFO] removing "sake_databse".');
	$connection->indices->delete(index => 'sake_database');
	_println('[INFO] "sake_databse" removed.');
}

sub _regist_new_sake {

	my ($name, @description) = @_;
	my $connection = _open_connection();
	my $id = _create_uuid();
	$connection->index(
		index => 'sake_database',
		type => '日本酒',
		id => $id,
		body => {
			product_name => $name,
			attributes => @description,
			date => _get_date(),
			datetime => _get_timestamp(),
			生産者 => 'Unknown'
		}
	);
	_println('[INFO] created a new node "', $name, '" in "sake_database".');
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_erase_all();

	_regist_new_sake('旭若松', ['純米生', 'しっかりめ', 'どっしり', '甘口']);
	_regist_new_sake('仙禽', ['純米生', 'しっかりめ', 'どっしり', '甘口', '酸味']);
	_regist_new_sake('悦凱陣', ['純米生', 'しっかりめ', 'どっしり', '甘口']);
	_regist_new_sake('十旭', ['純米', 'しっかりめ', 'どっしり', '甘口']);
	_regist_new_sake('陸奥八仙', ['純米', '華やか', '香り', '甘口']);
	_regist_new_sake('隆', ['純米', 'どっしり', '旨口']);
	_regist_new_sake('秋鹿', ['純米', 'どっしり', '旨口']);
	_regist_new_sake('神渡', ['純米生', 'どっしり', '甘口', 'ややべたつき感']);

	_println('[INFO] ok.');
}

_main();
