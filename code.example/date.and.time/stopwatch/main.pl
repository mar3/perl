#!/usr/bin/env perl

use strict;
use stopwatch;
use Time::HiRes;

sub _main {


	my $s = new stopwatch();

	Time::HiRes::sleep(3.123);

	print('[', $s->to_string(), ']', "\n");
}

_main();

