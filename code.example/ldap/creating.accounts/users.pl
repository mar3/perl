#!/usr/bin/env perl
# coding: utf-8
#
# 簡単な初期化処理
#

use strict;
use Net::LDAP;
use Net::LDAP::Util;
use Net::LDAP::LDIF;






##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
package constants;

# sub new {
#
# }

use constant HOST => '192.168.141.129';
use constant PORT => 389;
use constant USER => 'cn=Manager,dc=example,dc=jp';
use constant PASSWORD => 'root';









##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
package out;

sub println {

	print(@_, "\n");
}









##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
package ldap_model;

sub new {
	
	my ($package) = @_;
	my $this = bless({}, $package);
	if(!defined($this->_get_connection())) {
		die;
	}
	return $this;
}

sub create_root {
	
	my ($this) = @_;
	my $connection = $this->_get_connection();
	my $new_entry = new Net::LDAP::Entry();
	$new_entry->dn('dc=example,dc=jp');
	$new_entry->add('dc', 'example');
	$new_entry->add('o', 'myorganization');
	$new_entry->add('objectClass', 'dcObject');
	$new_entry->add('objectClass', 'organization');
	my $status = $connection->add($new_entry);
	if($status->code) {
		out::println('[WARN] ', $status->error);
		return 0;
	}
	return 1;
}

sub create_branch {
	
	my ($this) = @_;
	my $connection = $this->_get_connection();
	my $new_entry = new Net::LDAP::Entry();
	$new_entry->dn('ou=People,dc=example,dc=jp');
	$new_entry->add('ou', 'People');
	$new_entry->add('objectClass', 'organizationalUnit');
	my $status = $connection->add($new_entry);
	if($status->code) {
		out::println('[WARN] ', $status->error);
		return 0;
	}
	return 1;
}

sub create_account {
	
	my ($this, $uid, $mail_address) = @_;
	my $connection = $this->_get_connection();
	my $dn = sprintf('uid=%s,ou=People,dc=example,dc=jp', $uid);
	my $new_entry = new Net::LDAP::Entry();
	$new_entry->dn($dn);
	$new_entry->add('uid', $uid);
	$new_entry->add('sn', $uid);
	$new_entry->add('cn', $uid);
	$new_entry->add('mail', $mail_address);
	$new_entry->add('objectClass', 'top');
	$new_entry->add('objectClass', 'inetOrgPerson');
	my $status = $connection->add($new_entry);
	if($status->code) {
		out::println('[WARN] ', $status->error);
		return 0;
	}
	return 1;
}

# アクティブなセッションを返します。
sub _get_connection {
	
	my ($this) = @_;

	my $session = $this->{'session'};
	if(defined($session)) {
		return $session;
	}
	
	# LDAPセッションを開始します。
	my $host = constants::HOST;
	my $port = constants::PORT;
	$session = Net::LDAP->new($host, 'port' => $port);
	if(!defined($session)) {
		out::println('[error] 接続できません。ホスト=[', $host, '] ポート=[', $port, '] 情報=[', $!, ']');
		return undef;
	}

	# ログイン
	my $principal = constants::USER;
	my $password = constants::PASSWORD;
	my $status = $session->bind('dn' => $principal, 'password' => $password);
	if($status->code) {
		out::println('[error] 接続できません。ホスト=[', $host, '] ポート=[', $port, '] 情報=[', $status->error, ']');
		$session->disconnect();
		return undef;
	}
	$this->{'session'} = $session;
	return $session;
}

# セッションを解放します。
sub _close {
	
	my ($this) = @_;
	my $session = $this->{'session'};
	if(!defined($session)) {
		return;
	}
	delete($this->{'session'});
	$session->unbind();
	$session->disconnect();
}

sub DESTROY {

	my ($this) = @_;
	$this->_close();
}











##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
##############################################################################
package main;

sub _main {

	my $model = new ldap_model;
	$model->create_root();
	$model->create_branch();
	$model->create_account('user.000', 'user.000@example.jp');
	$model->create_account('user.001', 'user.001@example.jp');
	$model->create_account('user.002', 'user.002@example.jp');
}

main::_main(@ARGV);
