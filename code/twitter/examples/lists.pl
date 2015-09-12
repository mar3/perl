#!/usr/bin/env perl
# coding: utf-8

use strict;
use Encode;
use Net::Twitter;
use Data::Dumper;
use File::Spec::Functions;
use YAML;
use JSON;


local $Data::Dumper::Indent = 1;
local $Data::Dumper::Sortkeys = 1;
local $Data::Dumper::Terse = 1;




sub _println {

	print(@_, "\n");
}

sub _configure {

	my $home = `echo ~/`;
	chomp($home);
	my $path = File::Spec::Functions::catfile($home, '.twitter-settings.yml');
	my $stream = undef;
	if(!open($stream, $path)) {
		_println('[warn] cannot open [', $path, ']');
		return undef;
	}
	my $settings = YAML::LoadFile($path);
	# print Dumper($settings);
	return $settings;
}

# sub _is_hash {

# 	my $unknown = shift;
# 	eval {
# 		keys(%$unknown);
# 	};
# 	if($@) {
# 		return 0;
# 	}
# 	return 1;
# }

sub _normalize {

	my $s = shift;






	if(!length($s)) {
		return '';
	}

	if(utf8::is_utf8($s)) {
		utf8::encode($s);
	}

	return $s;
}

sub _enum_member {

	my ($t, $list_id) = @_;




	my $result = $t->list_members({'list_id' => $list_id});
	if(!defined($result->{'users'})) {
		_println('[warn] member not found.');
		return;
	}
	my @users = @{$result->{'users'}};
	foreach my $user (@users) {
		my $t = {
			id => $user->{'id'},
			name => $user->{'name'},
			screen_name => $user->{'screen_name'},
			profile_image_url_https => $user->{'profile_image_url_https'}
		};
		$t = JSON::to_json($t);
		$t = _normalize($t);
		_println('    ', $t);
		next;
		# https://pbs.twimg.com/profile_images/636164942215774208/CBpbJUxZ_normal.jpg
		$result = YAML::Dump($user);
		utf8::encode($result);
		print($result);
	}
}

sub _main {

	my $settings = _configure();
	if(!defined($settings)) {
		return;
	}

	my $t = Net::Twitter->new(
		traits => ['API::RESTv1_1'],
		consumer_key => $settings->{'consumer_key'},
		consumer_secret => $settings->{'consumer_secret'},
		access_token => $settings->{'token'},
		access_token_secret => $settings->{'token_secret'});

	my $result = $t->get_lists();

	if(0) {
		my $result = YAML::Dump($result);
		utf8::encode($result);
		print($result);
		return;
	}

	my @lists;

	foreach my $e (@$result) {

		_println('---');
		_println('  slug: ', _normalize($e->{'slug'}));
		_println('  name: ', _normalize($e->{'name'}));
		_println('  description: ', _normalize($e->{'description'}));
		_println('  member_count: ', _normalize($e->{'member_count'}));
		_println('  member:');

		_enum_member($t, $e->{'id'});

		next;

		#full_name: Twitter 上で一意な名前？
		#slug: 単純な内部名
	
		delete($e->{'user'}); #リストの所有者の情報(保存しているユーザー情報もあるのかも)

		my $item = YAML::Dump($e);
		utf8::encode($item);
		print($item);

		# print(Dumper($e));

		# my $item = JSON::to_json($e);
		# utf8::decode($item);
		# _println($item);

		_println();
	}
}

main::_main(@ARGV);

