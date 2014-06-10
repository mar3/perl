sub _find_file {

	my ($path, $handler) = @_;



	if(-f $path) {
		return $handler->($path);
	}
	elsif(-d $path) {
		my $handle;
		if(!opendir($handle $path)) {
			print('[error] cannot open directory. path=[', $path, ']', "\n");
			return 1;
		}
		while(my $name = readdir($handle)) {
			if($name eq '.') {
				next;
			}
			if($name eq '..') {
				next;
			}
			_find_file(File::Spec::Functions::catfile($path, $name), $handler);
		}
		closedir($handle);
	}
	else {
		print('[error] unknown device. path=[', $path, ']', "\n");
	}
}
