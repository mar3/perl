#!/usr/bin/perl

use strict;
use Net::SNMP;
use Data::Dumper;

sub _println {

	print(@_, "\n");
}

sub _main {

	my ($session, $error) = Net::SNMP->session(
		-hostname => '192.168.141.131',
		-community => 'public',
		-version => '2c',
	);
	if(!defined($session)) {
		_println('[ERROR] error. message=[', $error, '], $!=[', $!, ']');
		return;
	}

	# ホスト名を問い合わせる
	my $response = $session->get_request(-varbindlist => ['.1.3.6.1.2.1.1.5.0']);
	_println(Data::Dumper::Dumper($response));
	$session->close();
	_println('[INFO] Ok.');
}

_main(@ARGV);

