#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use YAML;
use DBI;
use Data::UUID;

package out;

# sub new

sub println {

	print(@_, "\n");
}

package configuration_manager;

sub configure {

	my $conf = YAML::LoadFile('settings.yml');
	return $conf;
}

package database;

sub new {

	my ($package_name) = @_;
	my $this = {};
	$this->{'dbh'} = undef;
	$this = bless($this, $package_name);
	return $this;
}

sub _create_new_connection{

	my $conf = configuration_manager::configure();
	my $dbfile = $conf->{dbfile};
	my $options = {
		AutoCommit => 1,
		RaiseError => 0
	};
	my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile", undef, undef, $options);
	return $dbh;
}

sub open {

	my ($this) = @_;
	my $dbh = $this->{'dbh'};
	if (!defined($dbh)) {
		$dbh = _create_new_connection();
		$this->{'dbh'} = $dbh;
	}
	return $dbh;
}

sub execute {

	my ($this, $sql, @parameters) = @_;
	my $dbh = $this->open();
	my $sth = $dbh->prepare($sql);
	if (!defined($sth)) {
		return undef;
	}
	$sth->execute(@parameters);
	$sth->finish();
	# $dbh->commit();
}

sub query {

	my ($this, $sql, @parameters) = @_;
	my $dbh = $this->open();
	my $sth = $dbh->prepare($sql);
	$sth->execute(@parameters);
	return $sth;
}

sub DESTROY {

	my ($this) = @_;
	my $dbh = $this->{'dbh'};
	$this->{'dbh'} = undef;
	if (defined($dbh)) {
		$dbh->finish();
	}
	out::println('[TRACE] <database::DESTROY()> connection closed.');
	out::println('[TRACE] <database::DESTROY()> closed database instance.');
}

package application;

sub new {

	my ($package_name) = @_;
	my $this = {};
	$this->{'dbh'} = undef;
	$this = bless($this, $package_name);
	return $this;
}

sub generate_id {

	my $generator = Data::UUID->new;
	$generator->create_str();
}

sub run {

	my ($this) = @_;

	out::println('[TRACE] ### BEGIN ###');

	{
		my $db = new database();
		$db->execute('CREATE TABLE OSHIRO_T(ID NVARCHAR2(1000), NAME NVARCHAR2(1000), PRIMARY KEY(ID))');
		return;
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '犬山城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '姫路城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '松本城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '熊本城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '二条城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '松山城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '備中松山城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '松江城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '彦根城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '中城城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '勝連城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '竹田城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '首里城');
		$db->execute('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '高知城');
		my $statement = $db->query('SELECT * FROM OSHIRO_T');
		while (my $row = $statement->fetch()) {
			out::println('[TRACE] ', $row->[0], ':', $row->[1]);
		}
		$statement->finish();
		$db->execute('DROP TABLE OSHIRO_T');
	}
	out::println('[TRACE] Ok.');
	out::println('[TRACE] --- END ---');
}

sub DESTROY {

	my ($this) = @_;
	out::println('[TRACE] <application::DESTROY()> closed application instance.');
}

package main;

sub _main {

	my $app = new application();
	$app->run();
}

_main();
