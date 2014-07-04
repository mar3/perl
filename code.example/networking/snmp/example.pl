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

	my $oids = {};

	$oids->{'ssCpuRawUser'} = '.1.3.6.1.4.1.2021.11.50.0';
	$oids->{'ssCpuRawNice'} = '.1.3.6.1.4.1.2021.11.51.0';
	$oids->{'ssCpuRawSystem'} = '.1.3.6.1.4.1.2021.11.52.0';
	$oids->{'ssCpuRawIdle'} = '.1.3.6.1.4.1.2021.11.53.0';
	$oids->{'ssCpuRawWait'} = '.1.3.6.1.4.1.2021.11.54.0';
	$oids->{'ssCpuRawKernel'} = '.1.3.6.1.4.1.2021.11.55.0';
	$oids->{'ssCpuRawInterrupt'} = '.1.3.6.1.4.1.2021.11.56.0';
	$oids->{'sysDescr'} = '.1.3.6.1.2.1.1.1.0';
	$oids->{'sysUpTime'} = '.1.3.6.1.2.1.1.3.0';
	$oids->{'sysContact'} = '.1.3.6.1.2.1.1.4.0';
	$oids->{'sysName'} = '.1.3.6.1.2.1.1.5.0';
	$oids->{'sysLocation'} = '.1.3.6.1.2.1.1.6.0';

	$oids->{'memTotalSwap'} = '.1.3.6.1.4.1.2021.4.3.0';
	$oids->{'memAvailSwap'} = '.1.3.6.1.4.1.2021.4.4.0';
	$oids->{'memTotalReal'} = '.1.3.6.1.4.1.2021.4.5.0';
	$oids->{'memAvailReal'} = '.1.3.6.1.4.1.2021.4.6.0';

	$oids->{'ifIndex'} = '.1.3.6.1.2.1.2.2.1.1';
	$oids->{'ifDescr'} = '.1.3.6.1.2.1.2.2.1.2';
	$oids->{'ifType'} = '.1.3.6.1.2.1.2.2.1.3';
	$oids->{'ifSpeed'} = '.1.3.6.1.2.1.2.2.1.5';
	$oids->{'ifPhysAddress'} = '.1.3.6.1.2.1.2.2.1.6';
	$oids->{'ifInOctets'} = '.1.3.6.1.2.1.2.2.1.10';
	$oids->{'ifOutOctets'} = '.1.3.6.1.2.1.2.2.1.16';
	$oids->{'ifInErrors'} = '.1.3.6.1.2.1.2.2.1.14';
	$oids->{'ifOutErrors'} = '.1.3.6.1.2.1.2.2.1.20';
	
	$oids->{'dskIndex'} = '.1.3.6.1.4.1.2021.9.1.1';
	$oids->{'dskPath'} = '.1.3.6.1.4.1.2021.9.1.2';
	$oids->{'dskDevice'} = '.1.3.6.1.4.1.2021.9.1.3';
	$oids->{'dskTotal'} = '.1.3.6.1.4.1.2021.9.1.6';
	$oids->{'dskAvail'} = '.1.3.6.1.4.1.2021.9.1.7';
	$oids->{'dskUsed'} = '.1.3.6.1.4.1.2021.9.1.8';
	$oids->{'dskPercent'} = '.1.3.6.1.4.1.2021.9.1.9';

	my $response = $session->get_request(
		-varbindlist => [ values(%$oids) ]
	);

	_println(Data::Dumper::Dumper($response));

	$session->close();

	_println('[INFO] Ok.');
}

_main(@ARGV);

