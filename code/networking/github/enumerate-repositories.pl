#!/usr/bin/env perl
# coding: utf-8
#
#
# Perl で GitHub を操作するサンプル
#
#
#
#









use strict;
use utf8;
use Net::GitHub;
use JSON;






sub _println {

	print(@_, "\n");
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');




	#
	# token
	#

	my $access_token = `cat .access_token`;

	#
	# starting
	#

	my $github = Net::GitHub->new(  # Net::GitHub::V3
		access_token => $access_token
	);

	#
	# enumerating repositories.
	#

	_println('#');
	_println('# Showing all your repositories.');
	_println('#');

	my $repos = $github->repos->list;

	my $repository_count = 0;

	foreach my $e (@$repos) {

		# fields of entry.
		# [archive_url]
		# [assignees_url]
		# [blobs_url]
		# [branches_url]
		# [clone_url]
		# [collaborators_url]
		# [comments_url]
		# [commits_url]
		# [compare_url]
		# [contents_url]
		# [contributors_url]
		# [created_at]
		# [default_branch]
		# [description]
		# [downloads_url]
		# [events_url]
		# [fork]
		# [forks]
		# [forks_count]
		# [forks_url]
		# [full_name]
		# [git_commits_url]
		# [git_refs_url]
		# [git_tags_url]
		# [git_url]
		# [has_downloads]
		# [has_issues]
		# [has_pages]
		# [has_wiki]
		# [homepage]
		# [hooks_url]
		# [html_url]
		# [id]
		# [issue_comment_url]
		# [issue_events_url]
		# [issues_url]
		# [keys_url]
		# [labels_url]
		# [language]
		# [languages_url]
		# [merges_url]
		# [milestones_url]
		# [mirror_url]
		# [name]
		# [notifications_url]
		# [open_issues]
		# [open_issues_count]
		# [owner]
		# [permissions]
		# [private]
		# [pulls_url]
		# [pushed_at]
		# [releases_url]
		# [size]
		# [ssh_url]
		# [stargazers_count]
		# [stargazers_url]
		# [statuses_url]
		# [subscribers_url]
		# [subscription_url]
		# [svn_url]
		# [tags_url]
		# [teams_url]
		# [trees_url]
		# [updated_at]
		# [url]
		# [watchers]
		# [watchers_count]

		my $data = {
			name => $e->{name},
			clone_url => $e->{clone_url},
			description => $e->{description},
			created_at => $e->{created_at},
			updated_at => $e->{updated_at},
		};

		my $json_text = JSON::to_json($data, {pretty => 0});

		_println($json_text);

		$repository_count++;
	}

	#
	# summary
	#

	_println($repository_count, ' repository detected.');
}

_main();





