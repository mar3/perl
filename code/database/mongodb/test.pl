#!/usr/bin/env perl
# coding: utf-8
#
#
#
# Perl で MongoDB を操作する
#
#
#
#
#


use strict;
use utf8;
use MongoDB;
use JSON;
use Encode;

sub _println {

	print(@_, "\n");
}

sub DateTime::TO_JSON {
	{ "".shift }
}

#
# JSON 形式で文字列化
#
sub _dump1 {
 
	my $e = shift;
	my $json = JSON::to_json($e, { utf8 => 0, pretty => 1, convert_blessed => 1 });
	_println($json);
}
 
#
# 扱いやすい HASH に変換
#
sub _dump2 {
 
	my $e = shift;
 
	$e = JSON::to_json($e, { utf8 => 0, convert_blessed => 1 });
	$e = JSON::from_json($e);
 
	_println('_id: ', $e->{'_id'});
	_println('住所: ', $e->{'住所'});
	_println('会社名: ', $e->{'会社名'});
}
 
sub _main {
 
	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	my $client = MongoDB::MongoClient->new(host => '127.0.0.1', port => 27017);

	my $database = $client->get_database('test');

	my $collection = $database->get_collection('sakaguradb');

	# my $id = $collection->insert({ some => 'data' });

	my $cursor = $collection->find({});

	while (my $e = $cursor->next()) {

		# delete($e->{'_id'});

		_dump1($e);

		# _dump2($e);
	}
}
 
_main(@ARGV);
