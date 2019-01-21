#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;

sub _enum_local_branches {

	my $stream = undef;
	open($stream, 'git branch |');
	my @local_branch_names;
	while (my $line = <$stream>) {
		# print($line);
		chomp($line);
		my $name = '';
		if ($line =~ m/\A  ([0-9a-zA-Z-_]+)\z/ms) {
			$name = $1;
			push(@local_branch_names, $name);
		}
	}
	close($stream);
	return @local_branch_names;
}

sub _prompt {

	my ($question) = @_;
	print($question, "\n");
	print('(y/N)> ');
	my $input = <STDIN>;
	chomp($input);
	$input = uc($input);
	if (uc($input) eq 'Y') { return 1; }
	if (uc($input) eq 'YES') { return 1; }
	return 0;
}

sub _erase_local_branches {

	my @names = _enum_local_branches();
	foreach my $name (@names) {
		my $prompt = sprintf('DELETE LOCAL REPOSITORY [%s] ? ', $name);
		if (!_prompt($prompt)) {
			next;
		}
		system('git', 'branch', '--delete', $name);
	}
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_erase_local_branches();
}

_main();

