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
use MongoDB;
use Data::Dumper;
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

	$e = JSON::to_json($e, { utf8 => 1, convert_blessed => 1 });
	# $e = JSON::to_json($e, { utf8 => 1, pretty => 1, convert_blessed => 1 });

	_println($e);
}
 
#
# 扱いやすい HASH に変換
#
sub _dump2 {
 
	my $e = shift;
 
	$e = JSON::to_json($e, { utf8 => 1, convert_blessed => 1 });
	$e = JSON::from_json($e);
 
	_println('_id: ', $e->{'_id'});
	_println('住所: ', $e->{'住所'});
	_println('会社名: ', $e->{'会社名'});
}
 
sub _main {
 
	local $Data::Dumper::Indent = 1;
	local $Data::Dumper::Sortkeys = 1;
	local $Data::Dumper::Terse = 1;
 
	my $client = MongoDB::MongoClient->new(
			host => '192.168.141.128',
			port => 27017);

	my $database = $client->get_database('test');

	my $collection = $database->get_collection('sakaguradb');

	# my $id = $collection->insert({ some => 'data' });

	my $cursor = $collection->find({});

	while (my $e = $cursor->next()) {

		delete($e->{'_id'});

		_dump1($e);

		# _dump2($e);
	}
}
 
_main(@ARGV);
