#!/usr/bin/perl
# coding: utf-8

use strict;



# -----------------------------------------------------------------------------
package out;

sub println {
	print(@_, "\n");
}



# -----------------------------------------------------------------------------
package application;

sub new {
	my $name = shift;
	return bless({'.state' => 1}, $name);
}

sub alive {
	my $this = shift;
	return $this->{'.state'};
}

sub quit {
	my $this = shift;
	$this->{'.state'} = 0;
}

sub main {
	my ($this) = @_;
	out::println('<application::main> $$$ begin $$$');
	while($this->alive()) {
		out::println('<application::main> (alive...)');
		sleep(1);
	}
	out::println('<application::main> $$$ exit $$$');
}



# -----------------------------------------------------------------------------
package main;

my $g_app = new application;

sub _on_signal {
	my ($sign) = @_;
	out::println('<_on_signal()> caught signal [', $sign, ']');
	$g_app->quit();
}

sub _main {
	out::println('<_main()> ### start ###');
	foreach my $sign ('INT', 'TERM') {
		$SIG{$sign} = '_on_signal';
	}
	$g_app->main();
	out::println('<_main()> --- exit ---');
}

_main(@ARGV);

