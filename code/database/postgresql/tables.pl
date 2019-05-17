#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use DBI;


sub _println {

	print(@_, "\n");
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

	# データベースに接続します。
	my $dbh = DBI->connect('dbi:Pg:dbname=postgres;host=127.0.0.1', 'postgres', 'postgres');

	# 酒データを出力します。
	{
		my $sql = '
			select table_schema, table_name
			from information_schema.tables
			order by table_schema, table_name';
		my $sth = $dbh->prepare($sql);
		$sth->execute();
		while(my $r = $sth->fetch()) {
			_println('[', $r->[0], '], [', $r->[1], ']');
		}
	}

	# データベースから切断します。
	$dbh->disconnect();
}

_main();
