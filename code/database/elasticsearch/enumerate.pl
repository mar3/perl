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

sub _search_random {

	my $connection = _open_connection();

	if(!$connection->indices->exists(index => 'sake_database')) {
		_println('[WARN] "sake_databse" not found.');
		return;
	}

	my $results = $connection->search(
		index => 'sake_database',
		body => {
			size => 9999,
			query => {
				match => {
					content => '生',
				}
			}
		}
	);
	my $hits = $results->{hits};

	# _println(YAML::Dump($hits));

	_println('max_score=', $hits->{max_score});
	_println('total=', $hits->{total});

	foreach my $e (@{$hits->{hits}}) {
		_println(JSON::to_json($e, {pretty => 1}));
	}
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_search_random();
}

_main();
