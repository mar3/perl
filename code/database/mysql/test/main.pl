#!/usr/bin/env perl
# coding: utf-8


use strict;
use utf8;
use DBI;

sub _println {

	print(@_, "\n");
}

sub _open {

	our $db_name = "accounts";
	our $db_user = "sample_application_1";
	our $db_pass = "password";
	our $db_host = "127.0.0.1";
	our $db_port = 3306;

	my $dbh = DBI->connect(
		"dbi:mysql:dbname=$db_name;host=$db_host;port=$db_port", $db_user, $db_pass)
		or die "$!\n Error: failed to connect to DB.\n";
	return $dbh;
}

sub _test {

	# このスコープでは connection_id() は常に同じ値を返す。

	my $dbh = _open();

	{
		my $sth = $dbh->prepare("SELECT connection_id()");
		$sth->execute();
		my $row = $sth->fetch();
		_println($row->[0]);
		$sth->finish;
	}

	{
		my $sth = $dbh->prepare("CREATE TEMPORARY TABLE TEST1(MAIL NVARCHAR(999) NOT NULL, PRIMARY KEY(MAIL))");
		$sth->execute();
		$sth->finish();
	}

	{
		my $sth = $dbh->prepare("INSERT INTO TEST1 VALUES(?)");
		$sth->execute('jimi.hendrix@i.softbank.jp');
		$sth->execute('janis.joplin@docomo.ne.jp');
		$sth->execute('billy.preston@gmail.com');
		$sth->finish();
	}

	{
		my $sth = $dbh->prepare("SELECT * FROM TEST1");
		$sth->execute();
		while (my $row = $sth->fetch()) {
			_println($row->[0]);
		}
		$sth->finish;
	}

	{
		my $sth = $dbh->prepare("SELECT connection_id()");
		$sth->execute();
		my $row = $sth->fetch();
		_println($row->[0]);
		$sth->finish;
	}

	$dbh->disconnect;
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	_test();
}

_main();

