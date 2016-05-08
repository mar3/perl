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

sub _search_attribute {

	my ($keyword) = @_;
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
					attributes => $keyword
				}
			}
		}
	);
	my $hits = $results->{hits};
	my @product_name;
	foreach my $e (@{$hits->{hits}}) {
		_println(JSON::to_json($e, {pretty => 1}));
		push(@product_name, $e->{_source}->{product_name});
	}
	_println('max_score: ', $hits->{max_score});
	_println('total: ', $hits->{total});
	_println('products: ', join(' ', @product_name));
}

sub _search_product_name {

	my ($keyword) = @_;
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
					product_name => $keyword,
				}
			}
		}
	);
	my $hits = $results->{hits};
	my @product_name;
	foreach my $e (@{$hits->{hits}}) {
		_println(JSON::to_json($e, {pretty => 1}));
		push(@product_name, $e->{_source}->{product_name});
	}
	_println('max_score: ', $hits->{max_score});
	_println('total: ', $hits->{total});
	_println('products: ', join(' ', @product_name));
}

sub _search_multi_part {

	my ($keyword) = @_;
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
				multi_match => {
					query => $keyword,
					fields => ['product_name', 'attributes'],
					minimum_should_match => "80%",
				}
			}
		}
	);
	my $hits = $results->{hits};
	my @product_name;
	foreach my $e (@{$hits->{hits}}) {
		_println(JSON::to_json($e, {pretty => 1}));
		push(@product_name, $e->{_source}->{product_name});
	}
	_println('max_score: ', $hits->{max_score});
	_println('total: ', $hits->{total});
	_println('products: ', join(' ', @product_name));
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	# _search_attribute('華やか');
	# _search_product_name('神');
	_search_multi_part('旭')
}

_main();
