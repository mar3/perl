#!/usr/bin/env perl
# coding: utf-8
# log4perl の例

use strict;
use utf8;
use Log::Log4perl;
use Log::Log4perl::Appender::Screen;

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	Log::Log4perl::init('conf/log4perl.conf');
	my $logger = Log::Log4perl->get_logger('myapp1');
	$logger->info('情報');
	$logger->debug('デバッグ');
	$logger->warn('警告');
	$logger->trace('トレース');
	$logger->fatal('致命的エラー');
}

_main();

