#!/usr/bin/env perl
# coding: utf-8

use strict;
use DBI;


sub _println {

	print(@_, "\n");
}

sub _main {

	#
	# データベースに接続します。
	#
	my $dbh = DBI->connect('dbi:Pg:dbname=test0;host=192.168.141.130', 'user0', 'user0');

	#
	# 酒データをセットアップします。
	#
	{
		$dbh->do('create table sake(id integer not null, name varchar(999), timestamp timestamp with time zone, primary key(id))');
		my $sth = $dbh->prepare('insert into sake values(?, ?, current_timestamp)');
		$sth->execute(0, '旭若松');
		$sth->execute(1, '宗玄');
		$sth->execute(2, '秋鹿');
		$sth->execute(3, '十字旭');
		$sth->execute(4, '隆');
		$sth->execute(5, '神渡');
	}

	#
	# 酒データを出力します。
	#
	{
		my $sth = $dbh->prepare('select * from sake');
		$sth->execute();
		while(my $r = $sth->fetch()) {
			_println('[', $r->[0], '], [', $r->[1], '], [', $r->[2], ']');
		}
	}

	#
	# 酒データを破棄します。
	#
	{
		$dbh->do('drop table sake');
	}

	#
	# データベースから切断します。
	#
	$dbh->disconnect();
}

_main();
