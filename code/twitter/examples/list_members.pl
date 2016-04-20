#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
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

sub _enum_member {

	my ($t, $list_id, $current_cursor_id) = @_;




	if(!length($list_id)) {
		_println('[warn] list_id required.');
		return 0;
	}



	my $search_condition = {};
	$search_condition->{'list_id'} = $list_id;
	if(length($current_cursor_id)) {
		$search_condition->{'cursor'} = $current_cursor_id;
	}

	my $result = $t->list_members($search_condition);
	if(!defined($result->{'users'})) {
		_println('[warn] member not found.');
		return 0;
	}

	my $count = 0;
	my $next_cursor = $result->{'next_cursor'};
	my @users = @{$result->{'users'}};
	foreach my $user (@users) {

		my $t = {
			id => $user->{'id'},
			name => $user->{'name'},
			screen_name => $user->{'screen_name'},
			profile_image_url_https => $user->{'profile_image_url_https'}
		};

		$t = JSON::to_json($t);

		_println($t);

		$count++;

		next;

		# $result = YAML::Dump($user);
		# utf8::encode($result);
		# print($result);
	}

	if(!length($next_cursor)) {
		return $count;
	}
	if($next_cursor eq '0') {
		return $count;
	}
	
	return $count + _enum_member($t, $list_id, $next_cursor);
}

sub _main {

	my ($list_id) = @_;



	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');

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

	my $count = _enum_member($t, $list_id);

	_println($count, '件のメンバーがみつかりました。');
}

main::_main(@ARGV);

