#!/Strawberry/perl/bin/perl.exe

use Date::Calc qw(Add_Delta_Days);

#201701	2017-01-28
#201801	2018-01-27
#201901	2019-01-26
#202001	2020-02-01

# 2020-08-08' AND '2020-08-14
$y = 2019;
$m = 1;
$d = 26;
$c = 1;

$y = 2018;
$m = 1;
$d = 27;
$c = 1;

for ($i = 0; $i < 200; $i++) {
if ($dates eq "") {
$dates = &FigureItOut ( $y, $m, $d, $c);
print "$dates\n";
} else {
#print "--brian $dates\n";
$c++;
(@data) = split(/\s+/, $dates);
#print "--brian $data[3]\n";
($y, $m, $d) = split(/-/, $data[3]);
$m =~ s/^0//gio;
$d =~ s/^0//gio;
$c =~ s/^0//gio;
if ($c == 54) {
$c = 1;
}
#print "--brian $y, $m, $d, $c\n";
$dates = &FigureItOut ( $y, $m, $d, $c);
print "$dates\n";
}
}

sub FigureItOut {
if ($m < 10) {
$m = join("", 0, $m);
}
if ($d < 10) {
$d = join("", 0, $d);
}
$sdate = join("-", $y, $m, $d);


($y2, $m2, $d2) = Add_Delta_Days($y, $m, $d, 6);

if ($m2 < 10) {
$m2 = join("", 0, $m2);
}
if ($d2 < 10) {
$d2 = join("", 0, $d2);
}
$edate = join("-", $y2, $m2, $d2);

if ($c < 10) {
$c = join("", 0, $c);
}
$week = join("", $y, $c);

($yn2, $mn2, $dn2) = Add_Delta_Days($y, $m, $d, 7);

if ($mn2 < 10) {
$mn2 = join("", 0, $mn2);
}
if ($dn2 < 10) {
$dn2 = join("", 0, $dn2);
}
$ndate = join("-", $yn2, $mn2, $dn2);

return "$sdate $edate $week $ndate";

}