#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use YAML;
use JSON;
use Search::Elasticsearch;

sub _println {

	print(@_, "\n");
}

sub _open_connection {

	my $connection = Search::Elasticsearch->new(nodes => ['127.0.0.1:9200']);
	return $connection;
}

sub _enum_all {

	my $connection = _open_connection();
	if(!$connection->indices->exists(index => 'sake_database')) {
		_println('[WARN] "sake_databse" not found.');
		return;
	}
	my $results = $connection->search(
		index => 'sake_database',
		body => {
			size => 9999,
		}
	);
	my $hits = $results->{hits};
	foreach my $e (@{$hits->{hits}}) {
		_println(JSON::to_json($e, {pretty => 0}));
	}
	_println('total: ', $hits->{total});
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_enum_all();
}

_main();
