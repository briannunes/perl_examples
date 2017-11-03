#!/usr/bin/perl

open(LOG, "/etc/passwd");

$count = 0;

while (<LOG>) {
chomp($_);
($name,$password,$uid,$gid,$dir,$shell) = split(/:/, $_);
if ($count == 0) {
print "{\"Accounts\": {\n";
}
print << "JSON";
    "User": {
        "username": "$name",
        "password": "$password",
        "uid": $uid,
        "gid": $gid,
        "dir": "$dir",
        "shell": "$shell"
    },
JSON

$count++;
}

print << "JSON";
    "TotalAccounts": $count
}}
JSON

close(LOG);
