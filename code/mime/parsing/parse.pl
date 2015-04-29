#!/usr/bin/env perl
# coding: utf-8


use strict;
use MIME::Entity;
use MIME::Parser;
use Data::Dumper;

sub _println {

	print(@_, "\n");
}

sub _split {

	my $entity = shift;




	if(!defined($entity)) {
		return;
	}

	my $header = $entity->head();
	_println('Mime Type: [', $header->mime_type(), ']');
	_println('Subject: [', $header->get('Subject'), ']');
	_println('Sender: [', $header->get('Sender'), ']');
	_println('From: [', $header->get('From'), ']');
	_println('Delived-To: [', $header->get('Delived-To'), ']');
	_println('Return-Path: [', $header->get('Return-Path'), ']');
	_println('Date: [', $header->get('Date'), ']');

	if($entity->is_multipart()) {
		foreach my $p ($entity->parts()) {
			_split($p);
		}
	}
	else {
		my $text = $entity->bodyhandle()->as_string();
		_println('本文: ', $text);
	}
}

sub _parse{

	my $path = shift;





	#
	# 解析
	#

	my $parser = new MIME::Parser;
	$parser->output_to_core(1);
	# $parser->output_under('tmp');
	# $parser->output_dir('tmp');
	# $parser->decode_bodies(0);
	my $entity = $parser->parse_open($path);




	#
	# 単純ダンプ
	#

	{
		local $Data::Dumper::Indent = 1;
		local $Data::Dumper::Sortkeys = 1;
		local $Data::Dumper::Terse = 1;
		_println(Data::Dumper::Dumper($entity));
	}



	#
	# 
	#

	{
		_println('');
		_println('#');
		_println('# MIME をプログラミングで開いていくサンプル');
		_println('#');
		_println('');
		_split($entity);
	}
}

sub _main {

	foreach my $path (@_) {
		_parse($path);
	}
}

_main(@ARGV);

