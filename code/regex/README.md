####XXX で始まる
```
if($s =~ m/\AXXX/ms) {
}
```

####ZZZ で終わる
```
if($s =~ m/ZZZ\z/ms) {
}
```

####XXX で始まる(case-insensitive)
```
if($s =~ m/\AXXX/msi) {
}
```

####ZZZ で終わる(case-insensitive)
```
if($s =~ m/ZZZ\z/msi) {
}
```
