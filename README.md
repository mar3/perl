examples.

# cpan DBD::mysql failed in Ubuntu 18.04 LTS. 

```
Checksum for /root/.cpan/sources/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz ok
'YAML' not installed, will not store persistent state
Configuring C/CA/CAPTTOFU/DBD-mysql-4.046.tar.gz with Makefile.PL
Can't exec "mysql_config": そのようなファイルやディレクトリはありません at Makefile.PL line 88.

Cannot find the file 'mysql_config'! Your execution PATH doesn't seem
not contain the path to mysql_config. Resorting to guessed values!
...
```

do

```
apt install libmysqlclient-dev
```
