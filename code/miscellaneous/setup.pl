#!/usr/bin/env perl
# coding: utf-8

use strict;
use utf8;
use Cwd;













































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package out;

sub println {

	print(@_, "\n");
}





























































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package file_backup;

sub _datetime {

	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdat) = localtime();
	return sprintf('%04d%02d%02d-%02d%02d%02d',
		1900 + $year, 1 + $mon, $mday, $hour, $min, $sec);
}

sub _make_path_name {

	my ($path, $datetime, $i) = @_;
	if ($i == 0) {
		return sprintf('%s.%s', $path, $datetime);
	}
	else {
		return sprintf('%s.%s.%s', $path, $datetime, $i);
	}
}

sub backup {

	my ($path) = @_;



	if(!-f $path) {
		return;
	}

	my $datetime = _datetime();
	for(my $i = 0; $i < 1000; $i++) {
		my $pathname = _make_path_name($path, $datetime, $i);
		if (-f $pathname) {
			next;
		}
		system('/bin/cp', $path, $pathname);
		last;
	}
}






































































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package directory;

sub cd_home {

	my $home = $ENV{HOME};
	if (!length($home)) {
		die();
	}
	directory::cd_to($home);
}

sub cd_to {

	my ($path) = @_;
	chdir($path);
	my $current_directory = Cwd::getcwd();
	if ($current_directory eq $path) {
		return;
	}
	die();
}

































































































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package util;

sub rtrim {

	my ($line) = @_;
	while (1) {
		if ($line =~ m/\r\z/ms) {
			chop($line);
		}
		elsif ($line =~ m/\n\z/ms) {
			chop($line);
		}
		elsif ($line =~ m/\ \z/ms) {
			chop($line);
		}
		elsif ($line =~ m/\t\z/ms) {
			chop($line);
		}
		else {
			last;
		}
	}
	return $line;
}

sub ltrim {

	my ($line) = @_;
	while (1) {
		if ($line =~ m/\A[\ \t\r\n]+/ms) {
			$line = substr($line, 1);
			next;
		}
		last;
	}
	return $line;
}

sub trim {

	my ($line) = @_;
	$line = ltrim($line);
	$line = rtrim($line);
	return $line;
}

sub append_line {

	my ($path, @items) = @_;
	my $stream = undef;
	open($stream, '>>', $path);
	print($stream @items, "\n");
	close($stream);
}

























































































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package prompt;

sub confirm {

	print(@_, "\n");
	print('(y/N)?> ');
	my $input = readline();
	$input = util::rtrim($input);
	$input = uc($input);
	if ($input eq 'YES') {
		return 1;	
	}
	if ($input eq 'Y') {
		return 1;
	}
	return 0;
}


















































































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package amazon_linux;

sub _setup_bash_aliases {

	directory::cd_home();
	out::println('setting up [~/.bash_aliases]');

	file_backup::backup('.bash_aliases');

	if (! -f '.bash_aliases') {
		system('touch', '.bash_aliases');
	}

	my $stream = undef;
	open($stream, '.bash_aliases');
	my $target = {};
	while (my $line = <$stream>) {
		$line = util::trim($line);
		if (0 == index($line, '#')) {
			next;
		}
		if (0 <= index($line, 'alias l=')) {
			$target->{'l'}++;
		}
		elsif (0 <= index($line, 'alias n=')) {
			$target->{'n'}++;
		}
		elsif (0 <= index($line, 'alias u=')) {
			$target->{'u'}++;
		}
		elsif (0 <= index($line, 'alias g=')) {
			$target->{'g'}++;
		}
	}
	close($stream);

	# appending if needed...
	if (!$target->{l}) {
		util::append_line('.bash_aliases', 'alias l=\'/bin/ls -lF --full-time\'');
	}
	if (!$target->{n}) {
		util::append_line('.bash_aliases', 'alias n=\'/bin/ls -ltrF --full-time\'');
	}
	if (!$target->{u}) {
		util::append_line('.bash_aliases', 'alias u=\'cd ..\'');
	}
	if (!$target->{g}) {
		util::append_line('.bash_aliases', 'alias g=\'git\'');
	}

	out::println('setting up [~/.bash_aliases] ok.');
}

sub _setup_bash {

	if (!prompt::confirm('bash_aliases のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}

	directory::cd_home();

	file_backup::backup('.bashrc');

	my $stream = undef;
	open($stream, '.bashrc');
	my $target = {};
	while (my $line = <$stream>) {
		$line = util::trim($line);
		if (0 == index($line, '#')) {
			next;
		}
		if ((0 <= index($line, '-f')) && (0 <= index($line, '.bash_aliases'))) {
			$target->{read_bash_profile}++;
		}
		elsif ((0 <= index($line, 'export')) && (0 <= index($line, 'EDITOR'))) {
			$target->{editor_setting}++;
		}
	}
	close($stream);

	if (!$target->{read_bash_profile}) {
		util::append_line('.bashrc', "\n");
		util::append_line('.bashrc', 'if [ -f ~/.bash_aliases ]; then');
		util::append_line('.bashrc', '	. ~/.bash_aliases');
		util::append_line('.bashrc', 'fi');
		util::append_line('.bashrc', "\n");
	}

	if (!$target->{editor_setting}) {
		util::append_line('.bashrc', "\n");
		util::append_line('.bashrc', 'export EDITOR=vim');
		util::append_line('.bashrc', "\n");
	}
}

sub _setup_vim {

	if (!prompt::confirm('Vim のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	out::println('[Vim] begin setting.');
	directory::cd_home();
	system(
		'wget',
		'https://raw.githubusercontent.com/mass10/vim.note/master/vimrc/.vimrc',
		'--output-document',
		'.vimrc');
	system(
		'sudo',
		'mkdir',
		'-p',
		'/usr/share/vim/vimfiles/colors');
	system(
		'sudo',
		'wget',
		'https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim',
		'--output-document',
		'/usr/share/vim/vimfiles/colors/zenburn.vim');
	system(
		'sudo',
		'wget',
		'https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim',
		'--output-document',
		'/usr/share/vim/vimfiles/colors/molokai.vim');
	out::println('[Vim] ok.');
}

sub _sudo_test_directory {

	my ($path) = @_;
	my $test = `sudo file /root/bin`;
	if (0 <= index($test, 'directory')) {
		return 1;
	}
	return 0;
}

sub _setup_cpanm {

	if (!prompt::confirm('cpanm のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	out::println('[cpanm] begin setting.');
	system('sudo', 'mkdir', '-p', '/root/bin');
	system('sudo', 'curl', '-L', 'https://cpanmin.us/', '-o', '/root/bin/cpanm');
	system('sudo', 'chmod', 'u+x', '/root/bin/cpanm');
	out::println('[cpanm] ok.');
}

sub _has_git_installed {

	return 0;
	my $stream = undef;
	open($stream, 'git --version |');
	my $line = <$stream>;
	close($stream);
	if (-1 == index($line, 'git version')) {
		return 0;
	}
	return 1;
}

sub _setup_git {

	out::println('[git] begin setting.');
	if (!_has_git_installed()) {
		system('sudo', 'yum', 'install', 'git');
	}
	out::println('[git] ok.');
}

sub setup {

	_setup_bash();
	_setup_bash_aliases();
	_setup_git();
	_setup_vim();
	_setup_cpanm();
}










































































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package ubuntu;

sub _setup_bash {

	if (!prompt::confirm('bash_aliases のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	directory::cd_home();
	file_backup::backup('.bashrc');
	file_backup::backup('.bash_aliases');
	if (! -f '.bash_aliases') {
		system('touch', '.bash_aliases');
	}
}

sub _setup_bash_aliases {

	directory::cd_home();
	out::println('setting up [~/.bash_aliases]');
	if (! -f '.bash_aliases') {
		system('touch', '.bash_aliases');
	}
	my $stream = undef;
	open($stream, '.bash_aliases');
	my $target = undef;
	while (my $line = <$stream>) {
		$line = util::trim($line);
		if (0 == index($line, '#')) {
			next;
		}
		if (0 <= index($line, 'alias l=')) {
			$target->{'alias l'}++;
		}
		elsif (0 <= index($line, 'alias n=')) {
			$target->{'alias n'}++;
		}
		elsif (0 <= index($line, 'alias u=')) {
			$target->{'alias u'}++;
		}
		elsif (0 <= index($line, 'alias g=')) {
			$target->{'alias g'}++;
		}
	}
	close($stream);
	if (!defined($target)) {
		# nothing to do
		out::println('[~/.bash_aliases] nothing to do...');
		return;
	}
	# write
	file_backup::backup('.bash_aliases');
	if (!$target->{'alias l'}) {
		util::append_line('.bash_aliases', 'alias l=\'/bin/ls -lF --full-time\'');
	}
	if (!$target->{'alias n'}) {
		util::append_line('.bash_aliases', 'alias n=\'/bin/ls -ltrF --full-time\'');
	}
	if (!$target->{'alias u'}) {
		util::append_line('.bash_aliases', 'alias u=\'cd ..\'');
	}
	if (!$target->{'alias g'}) {
		util::append_line('.bash_aliases', 'alias g=\'git\'');
	}
	# done
	out::println('setting up [~/.bash_aliases] ok.');
}

sub _has_git_installed {

	my $stream = undef;
	if (!open($stream, 'git --version |')) {
		return 0;
	}
	my $line = <$stream>;
	close($stream);
	if (-1 == index($line, 'git version')) {
		return 0;
	}
	return 1;
}

sub _setup_git {

	out::println('[git] begin setting.');
	# if (!_has_git_installed()) {
		system('sudo', 'apt-get', 'install', 'git');
	# }
	if (!_has_git_installed()) {
		out::println('[git] ... [CANCELED]');
	}
	out::println('[git] ... [OK]');
}

sub _setup_vim {

	if (!prompt::confirm('Vim のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	out::println('[Vim] begin setting.');
	directory::cd_home();
	# [.vimrc]
	if (-f '.vimrc') {
		if (prompt::confirm('.vimrc をアップデートしますか？')) {
			system('wget', 'https://raw.githubusercontent.com/mass10/vim.note/master/vimrc/.vimrc', '--output-document', '.vimrc');
		}
	}
	else {
		system('wget', 'https://raw.githubusercontent.com/mass10/vim.note/master/vimrc/.vimrc', '--output-document', '.vimrc');
	}
	system('sudo', 'mkdir', '-p', '/usr/share/vim/vimfiles/colors');
	system('sudo', 'wget', 'https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim', '--output-document', '/usr/share/vim/vimfiles/colors/zenburn.vim');
	system('sudo', 'wget', 'https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim', '--output-document', '/usr/share/vim/vimfiles/colors/molokai.vim');
	out::println('[Vim] ok.');
}

sub ubuntu::_setup_cpanm {

	if (!prompt::confirm('root ユーザーに cpanm のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	out::println('[cpanm] begin setting.');
	system('sudo', 'mkdir', '-p', '/root/bin');
	system('sudo', 'curl', '-L', 'https://cpanmin.us/', '-o', '/root/bin/cpanm');
	system('sudo', 'chmod', 'u+x', '/root/bin/cpanm');
	out::println('[cpanm] ok.');
}

sub setup {
	
	ubuntu::_setup_bash();
	ubuntu::_setup_bash_aliases();
	ubuntu::_setup_git();
	ubuntu::_setup_vim();
	ubuntu::_setup_cpanm();
}




























































































































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package debian;

sub setup {
	
	_setup_bash();
	_setup_bash_aliases();
	_setup_git();
	_setup_vim();
	_setup_cpanm();
}

sub _setup_bash {

	if (!prompt::confirm('bash_aliases のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	directory::cd_home();
	file_backup::backup('.bashrc');
	file_backup::backup('.bash_aliases');
	if (! -f '.bash_aliases') {
		system('touch', '.bash_aliases');
	}
}

sub _has_git_installed {

	my $stream = undef;
	if (!open($stream, 'git --version |')) {
		return 0;
	}
	my $line = <$stream>;
	close($stream);
	if (-1 == index($line, 'git version')) {
		return 0;
	}
	return 1;
}

sub _setup_bash_aliases {

	directory::cd_home();
	out::println('setting up [~/.bash_aliases]');

	file_backup::backup('.bash_aliases');

	if (! -f '.bash_aliases') {
		system('touch', '.bash_aliases');
	}

	my $stream = undef;
	open($stream, '.bash_aliases');
	my $target = {};
	while (my $line = <$stream>) {
		$line = util::trim($line);
		if (0 == index($line, '#')) {
			next;
		}
		if (0 <= index($line, 'alias l=')) {
			$target->{'l'}++;
		}
		elsif (0 <= index($line, 'alias n=')) {
			$target->{'n'}++;
		}
		elsif (0 <= index($line, 'alias u=')) {
			$target->{'u'}++;
		}
		elsif (0 <= index($line, 'alias g=')) {
			$target->{'g'}++;
		}
	}
	close($stream);

	# appending if needed...
	if (!$target->{l}) {
		util::append_line('.bash_aliases', 'alias l=\'/bin/ls -lF --full-time\'');
	}
	if (!$target->{n}) {
		util::append_line('.bash_aliases', 'alias n=\'/bin/ls -ltrF --full-time\'');
	}
	if (!$target->{u}) {
		util::append_line('.bash_aliases', 'alias u=\'cd ..\'');
	}
	if (!$target->{g}) {
		util::append_line('.bash_aliases', 'alias g=\'git\'');
	}

	out::println('setting up [~/.bash_aliases] ok.');
}

sub _setup_git {

	out::println('[git] begin setting.');
	if (!_has_git_installed()) {
		system('sudo', 'apt-get', 'install', 'git');
	}
	if (!_has_git_installed()) {
		out::println('[git] ... [CANCELED]');
	}
	out::println('[git] ... [OK]');
}

sub _setup_vim {

	if (!prompt::confirm('Vim のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	out::println('[Vim] begin setting.');
	directory::cd_home();
	system(
		'wget',
		'https://raw.githubusercontent.com/mass10/vim.note/master/vimrc/.vimrc',
		'--output-document',
		'.vimrc');
	system(
		'sudo',
		'mkdir',
		'-p',
		'/usr/share/vim/vimfiles/colors');
	system(
		'sudo',
		'wget',
		'https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim',
		'--output-document',
		'/usr/share/vim/vimfiles/colors/zenburn.vim');
	system(
		'sudo',
		'wget',
		'https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim',
		'--output-document',
		'/usr/share/vim/vimfiles/colors/molokai.vim');
	out::println('[Vim] ok.');
}

sub _setup_cpanm {

	if (!prompt::confirm('cpanm のセットアップをしますか？')) {
		out::println('canceled.');
		return;
	}
	out::println('[cpanm] begin setting.');
	system('sudo', 'mkdir', '-p', '/root/bin');
	system('sudo', 'curl', '-L', 'https://cpanmin.us/', '-o', '/root/bin/cpanm');
	system('sudo', 'chmod', 'u+x', '/root/bin/cpanm');
	out::println('[cpanm] ok.');
}






























































































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
package main;

sub _diagnose_os {

	my $stream;
	open($stream, '/etc/os-release');
	my $name = '';
	while (my $line = <$stream>) {
		if (0 <= index($line, 'Amazon Linux')) {
			$name = 'Amazon Linux';
		}
		elsif (0 <= index($line, 'CentOS')) {
			$name = 'CentOS';
		}
		elsif (0 <= index($line, 'Red Hat Enterprise Linux')) {
			$name = 'Red Hat Enterprise Linux';
		}
		elsif (0 <= index($line, 'Ubuntu')) {
			$name = 'Ubuntu';
		}
		elsif (0 <= index($line, 'Debian')) {
			$name = 'Debian';
		}
	}
	close($stream);
	return $name;
}

sub _main {

	binmode(STDIN, ':utf8');
	binmode(STDOUT, ':utf8');
	binmode(STDERR, ':utf8');






	my $os_description = _diagnose_os();

	if ('Amazon Linux' eq $os_description) {
		out::println('[info] Great! Amazon Linux found!');
		amazon_linux::setup();
	}
	elsif ('Ubuntu' eq $os_description) {
		out::println('[info] Great! Ubuntu is the smartest way!');
		ubuntu::setup();
	}
	elsif ('Debian' eq $os_description) {
		out::println('[info] Excellent! Debian is elegant operating system!');
		debian::setup();
	}
	else {
		out::println('[warn] unknown os. nothing todo...');
	}
}



















































###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################

main::_main(@ARGV);
