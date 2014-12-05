package stopwatch;

use strict;
use Time::HiRes;

sub new {

	my ($name) = shift;



	my $instance = bless({}, $name);
	$instance->{'.time'} = Time::HiRes::time();
	return $instance;
}

sub to_string {

	my ($this) = shift;



	my $now = Time::HiRes::time();
	my $t = $this->{'.time'};
	my $ms = ($now - $t) * 1000;
	my $sec = $ms / 1000;
	$ms = $ms % 1000;
	my $min = $sec / 60;
	$sec = $sec % 60;
	my $hr = $min / 60;
	$min = $min % 60;

	return sprintf('%02d:%02d:%02d.%03d', $hr, $min, $sec, $ms);
}

1;

