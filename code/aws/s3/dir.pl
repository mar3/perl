#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use AWS::S3;
use YAML;

sub _println {

	print(@_, "\n");
}

sub _dump {

	my ($file) = @_;
	my $bucket = $file->{bucket};
	my $bucket_name = $bucket->{name};
	_println('[TRACE]');
	_println('    path: [s3://', $bucket_name, '/', $file->{key}, ']');
	_println('    contenttype: [', $file->{contenttype}, ']');
	_println('    etag: [', $file->{etag}, ']');
	_println('    lastmodified: [', $file->{lastmodified}, ']');
	_println('    owner: [', $file->{owner}, ']');
	_println('    size: [', $file->{size}, ']');
	_println('    storage_class: [', $file->{storage_class}, ']');
	# ", Contents: ", ${ $file->contents });
}

sub _configure {

	my $conf = YAML::LoadFile('.env');
	return $conf;
}

sub _enumerate_entries {

	my $conf = _configure();

	my $s3 = new AWS::S3(
		access_key_id => $conf->{aws_access_key_id},
		secret_access_key => $conf->{aws_secret_access_key});

	my $bucket = $s3->bucket($conf->{bucket});

	my $iterator = $bucket->files(
		page_size => 10, page_number => 1);

	while (my @files = $iterator->next_page()) {
		_println('[TRACE]');
		_println('    Page number: ', $iterator->page_number());
		foreach my $file (@files) {
			_dump($file);
		}
	}
}

sub _main {

	_enumerate_entries();
}

_main(@ARGV);
