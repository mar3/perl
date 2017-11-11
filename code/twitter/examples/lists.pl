#!/usr/bin/env perl
# coding: utf-8

use utf8;
use strict;
use Encode;
use Net::Twitter;
use File::Spec::Functions;
use YAML;
use JSON;





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
	return $settings;
}

sub _enum_member {

	my ($t, $list_name, $list_id, $next_cursor) = @_;



	my $param = {'list_id' => $list_id};
	if (0 < length($next_cursor)) {
		_println('  (fetching next cursor [', $next_cursor, '] in list [', $list_name, '].)');
		$param->{cursor} = $next_cursor;
	}
	my $result = $t->list_members($param);
	if(!defined($result)) {
		_println('[warn] query result was undefined...');
		return;
	}
	if(!defined($result->{'users'})) {
		_println('[warn] member not found.');
		return;
	}
	# _println('###');
	# _println(YAML::Dump($result));
	# _println('###');
	my @users = @{$result->{'users'}};
	foreach my $user (@users) {
		my $t = {
			id => $user->{'id'},
			name => $user->{'name'},
			screen_name => $user->{'screen_name'},
			profile_image_url_https => $user->{'profile_image_url_https'}
		};
		_println('    MEMBER: ', JSON::to_json($t));
	}
	if (!length($result->{'next_cursor'})) {
		return;
	}
	if ('0' eq $result->{'next_cursor'}) {
		return;
	}
	_enum_member($t, $list_name, $list_id, $result->{'next_cursor'});
}

sub _main {

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

	my $result = $t->get_lists();

	foreach my $e (@$result) {

		_println('---');
		# アカウントの詳細
		# print(YAML::Dump($e));
		_println('  slug: ', $e->{'slug'});
		_println('  name: ', $e->{'name'});
		_println('  description: ', $e->{'description'});
		_println('  member_count: ', $e->{'member_count'});
		_println('  member:');

		_enum_member($t, $e->{'name'}, $e->{'id'});
	}
}

main::_main(@ARGV);

