#!/usr/bin/perl

open(LOG, "/etc/passwd");

$count = 0;

while (<LOG>) {
chomp($_);
($name,$password,$uid,$gid,$dir,$shell) = split(/:/, $_);
if ($count == 0) {
print "<accounts>\n";
}
print << "XML";
    <user name="$name">
        <username>$name</username>
        <password>$password</password>
        <uid>$uid</uid>
        <gid>$gid</gid>
        <dir>$dir</dir>
        <shell>$shell</shell>
     </user>
XML

$count++;
}

print << "XML";
    <TotalAccounts total="$count">
</accounts>
XML

close(LOG);
