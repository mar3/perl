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
		AutoCommit => 0,
		RaiseError => 1
	};
	my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile", undef, undef, $options);
	return $dbh;
}

sub open {

	my ($this) = @_;
	my $dbh = $this->{'dbh'};
	if (defined($dbh)) {
		return $dbh;
	}
	$dbh = _create_new_connection();
	$this->{'dbh'} = $dbh;
	return $dbh;
}

sub execute_update {

	my ($this, $sql, @parameters) = @_;
	my $dbh = $this->open();
	my $sth = $dbh->prepare($sql);
	$sth->execute(@parameters);
	$sth->finish();
	if (!$dbh->{'AutoCommit'}) {
	}
	else {
		out::println('[TRACE] (COMMIT)');
	}
}

sub query {

	my ($this, $sql, @parameters) = @_;
	my $dbh = $this->open();
	my $sth = $dbh->prepare($sql);
	$sth->execute(@parameters);
	return $sth;
}

sub commit {

	my ($this) = @_;
	my $dbh = $this->{'dbh'};
	if (!defined($dbh)) {
		return;
	}
	if ($dbh->{'AutoCommit'}) {
		return;
	}
	out::println('[TRACE] (COMMIT)');
	$dbh->commit();
}

sub rollback {

	my ($this) = @_;
	my $dbh = $this->{'dbh'};
	if (!defined($dbh)) {
		return;
	}
	if ($dbh->{'AutoCommit'}) {
		return;
	}
	out::println('[TRACE] (ROLLBACK)');
	$dbh->rollback();
}

sub close {

	my ($this) = @_;
	my $dbh = $this->{'dbh'};
	if (!defined($dbh)) {
		return;
	}
	$this->rollback();
	out::println('[TRACE] <database::close()> closing connection.');
	$this->{'dbh'} = undef;
	$dbh->disconnect();
}

sub DESTROY {

	my ($this) = @_;
	out::println('[TRACE] <database::DESTROY()> closing database instance.');
	$this->close();
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

	# ========== 開始 ==========
	{
		out::println('[TRACE] ### BEGIN ###');
	}

	# ========== お城の登録と確認 ==========
	{
		my $db = new database();
		$db->execute_update('CREATE TABLE OSHIRO_T(ID NVARCHAR2(1000), NAME NVARCHAR2(1000), PRIMARY KEY(ID))');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '犬山城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '姫路城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '松本城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '熊本城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '二条城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '松山城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '備中松山城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '松江城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '彦根城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '中城城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '勝連城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '竹田城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '首里城');
		$db->execute_update('INSERT INTO OSHIRO_T VALUES(?, ?)', generate_id(), '高知城');
		my $statement = $db->query('SELECT * FROM OSHIRO_T');
		while (my $row = $statement->fetch()) {
			out::println('[TRACE] ', $row->[0], ':', $row->[1]);
		}
		$statement->finish();
		$db->execute_update('DROP TABLE OSHIRO_T');
		$db->commit();
	}

	# ========== 終了 ==========
	{
		out::println('[TRACE] Ok.');
		out::println('[TRACE] --- END ---');
	}
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
