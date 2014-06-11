sub _split_path_part {

	my ($path) = @_;
	


	my ($drive_letter, $parent, $name) = File::Spec::Functions::splitpath($path);

	my $dotted = rindex($name, '.');
	if($dotted == -1) {
		# 拡張子が無い名前
		return $parent, $name, '';
	}
	elsif($dotted == 0) {
		# .ではじまり、拡張子が無い(=hidden file)
		return $parent, $name, '';
	}
	else {
		return $parent, $name, substr($name, $dotted + 1);
	}
}
