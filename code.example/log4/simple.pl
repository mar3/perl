#!/usr/bin/env perl
# coding: utf-8
# log4perl の例

use strict;
use Log::Log4perl;

sub _main {

	Log::Log4perl::init('conf/log4perl.conf');
	my $logger = Log::Log4perl->get_logger('myapp1');
	$logger->info('情報');
	$logger->debug('デバッグ');
	$logger->warn('警告');
	$logger->trace('トレース');
	$logger->fatal('致命的エラー');
}

_main();

