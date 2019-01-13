#!/usr/bin/perl

use strict;






###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package keys;

#sub new {
#
#}

use constant KEY => 'pass:password';










###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package out;

#sub new {
#
#}

sub println {

	print(@_, "\n");
}









###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package crypt;

#sub new {
#
#}

sub encrypt_with_password {

	my $s = shift;

	#
	#
	#
	my $path = './.x.in';

	{
		unlink($path);
		my $stream = undef;
		if(!open($stream, '>'.$path)) {
			die $!;
		}
		binmode($stream); #必要かどうかの検証していない
		print($stream $s);
		close($stream);
	}

	#
	#
	#
	my $out = './.x.out';

	{
		unlink($out);
		
		my @command_parameters;
		push(@command_parameters, 'openssl');
		push(@command_parameters, 'enc');
		push(@command_parameters, '-des3');
		push(@command_parameters, '-e');
		# push(@command_parameters, '-salt'); # this is default.
		push(@command_parameters, '-in', $path);
		push(@command_parameters, '-out', $out);
		push(@command_parameters, '-pass'); # formally as [-k]
		push(@command_parameters, keys::KEY);
		# push(@command_parameters, '-debug');
		push(@command_parameters, '-a');
		system(@command_parameters);
		
		unlink($path);

		# system('cat', $out);
		# unlink($out);
	}

	return $out;
}

sub decrypt {

	my ($out) = @_;



	my @command_parameters;
	push(@command_parameters, 'openssl');
	push(@command_parameters, 'enc');
	push(@command_parameters, '-des3');
	push(@command_parameters, '-d');
	push(@command_parameters, '-in');
	push(@command_parameters, $out);
	push(@command_parameters, '-out');
	push(@command_parameters, '.plain.txt');
	push(@command_parameters, '-pass'); # formally as [-k]
	push(@command_parameters, keys::KEY);
	push(@command_parameters, '-a');
	# push(@command_parameters, '-debug');

	system(@command_parameters);

	my $source_text = `cat .plain.txt`;

	return $source_text;
}

sub test_method {

	my $response = `openssl no-enc`;
	chomp($response);
	if($response eq 'enc') {
		out::println('[info] "enc" コマンドは実装されています。');
	}
	else {
		out::println('[warn] "enc" コマンドは実装されていません。');
	}
}







###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package main;

#sub new {
#
#}

sub _test {

	my $s = shift;



	out::println('暗号化 >>> [', $s, ']');

	#
	# 暗号化
	#
	my $out = crypt::encrypt_with_password($s);

	#
	# 復号
	#
	my $source = crypt::decrypt($out);

	if($source eq $s) {
		out::println('復元成功 [', $s, ']');
		return;
	}

	die('Failure! [', $source, ']');
}

sub _main {

	crypt::test_method();

	_test('hASh jhasy 2388 hwe 98414 hjasdg');
}

_main(@ARGV);

