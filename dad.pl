#!/usr/bin/perl

require "cgi-lib.pl";
require "bear-lib.pl";
&GetTimes;
&ReadParse;

$date_string = join("", $TYEAR, $TMONTH, $TDAY);

$view = $in{view};
$search = $in{search};

if ($view eq "") {
$view = "batch";
}

chomp($host=`hostname`);

$host=uc($host);


print <<"END_OF_HTML";
Content-type: text/html

 

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">

<HTML>

<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache" NAME="Page"> 

<TITLE>dad</TITLE>

<BODY BGCOLOR=white>

<p align=center>
<IMG BORDER=0 SRC="/images/th.jpg">
</p>

<p align=center>
<br>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold>&nbsp; &nbsp;</bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold><a href="dad.pl?view=batch">batch</a></bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold>&nbsp; | &nbsp;</bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold><a href="dad.pl?view=table">table</a></bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold>&nbsp; | &nbsp;</bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold><a href="dad.pl?view=report">report</a></bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold>&nbsp; | &nbsp;</bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold><a href="dad.pl?view=cache">cache</a></bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold>&nbsp; | &nbsp;</bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold><a href="dad.pl?view=uc4">uc4</a></bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold>&nbsp; | &nbsp;</bold>
<FONT size="1" face="geneva, arial, helvetica, sans-serif" color="#000000"><bold><a href="dad.pl?view=rtp">rtp</a></bold>
</p>

<p align=center>
<FONT SIZE=+3>daily $view status</FONT>
<BR>
</p>

</TABLE>

<HR SIZE=3 ALIGN=LEFT NOSHADE>

<DIV align=left>

<TABLE width=100% cellpadding=5 border=0>

<font size="2" face="Arial, Helvetica, sans-serif">

END_OF_HTML

if ($view =~ /batch/gio) {
print << "END_OF_HTML";

<tr BGCOLOR="#666666">

<td> Batch </td>

<td> Completed </td>

</tr>

END_OF_HTML

} 

if ($view =~ /table/) {
print << "END_OF_HTML";

<tr BGCOLOR="#666666">

<td> Table </td>

<td> Started </td>

<td> Completed </td>

</tr>

END_OF_HTML

}

if ($view =~ /report/) {
print << "END_OF_HTML";

<tr BGCOLOR="#666666">

<td> Report </td>

<td> Status </td>

<td> Started </td>

<td> Completed </td>

</tr>

END_OF_HTML

}

if ($view =~ /cache/) {
print << "END_OF_HTML";

<tr BGCOLOR="#666666">

<td> Chain </td>

<td> Module </td> 

<td> Status </td>

<td> Started </td>

<td> Completed </td>

</tr>

END_OF_HTML

}

if ($view =~ /uc4/) {
print << "END_OF_HTML";

<tr BGCOLOR="#666666">

<td> Chain </td>

<td> Module </td>

<td> Started </td>

<td> Completed </td>

<td> Minutes </td>

<td> Status </td>
</tr>

END_OF_HTML

}

if ($view =~ /rtp/) {
print << "END_OF_HTML";

<tr BGCOLOR="#666666">

<td> File </td>

<td> Size </td>

<td> Lines </td>

<td> To </td>

<td> From </td>

<td> Completed </td>
</tr>

END_OF_HTML

}


$recs=0;

open(LOG, "dad.log");

while (<LOG>) {

$recs++;
$recs%=2;

if ($recs == 0) {
$color="#CCCCCC";
} else {
$color="#888888";
}

#$_ =~ s/\.000000//g;

(@data) = split(/\|/, $_);
#
# Batch
#
if ($view =~ /batch/) {
if ($_ =~ /\|BATCH/gio) {
if ($_ =~ /$date_string/) {
push(@lines, $_);
}
}
}

#
# Table
#
if ($view =~ /table/) {
if ($_ =~ /\|TABLE/gio) {
if ($data[0] =~ /TABLE_NAME/) {
$recs=0;
} else {
print << "END_OF_HTML";
<tr BGCOLOR="$color">
    <td vAlign=baseline noWrap align=left>$data[0]</td>
    <td vAlign=baseline noWrap align=left>$data[4]</td>
    <td vAlign=baseline noWrap align=left>$data[5]</td>
</tr>
END_OF_HTML
}
}
}

if ($view =~ /report/) {
if ($_ =~ /\|REPORT/gio) {
print << "END_OF_HTML";
<tr BGCOLOR="$color">
    <td vAlign=baseline noWrap align=left>$data[1]</td>
    <td vAlign=baseline noWrap align=left>$data[2]</td>
    <td vAlign=baseline noWrap align=left>$data[3]</td>
    <td vAlign=baseline noWrap align=left>$data[4]</td>
</tr>
END_OF_HTML
}
}

if ($view =~ /cache/) {
if ($_ =~ /\|CACHE/gio) {
print << "END_OF_HTML";
<tr BGCOLOR="$color">
    <td vAlign=baseline noWrap align=left>$data[2]</td>
    <td vAlign=baseline noWrap align=left>$data[3]</td>
    <td vAlign=baseline noWrap align=left>$data[5]</td>
    <td vAlign=baseline noWrap align=left>$data[6]</td>
    <td vAlign=baseline noWrap align=left>$data[7]</td>
</tr>
END_OF_HTML
}
}

if ($view =~ /uc4/) {
if ($_ =~ /\|UC4/gio) {
#|C_ADN_OPT_EPN_RULES|EPN_RULES_FILTER_DATA_FOR_BATCH|2465002k\ADNET|27-APR-2012 04:13:00|27-APR-2012 04:13:34|162.95|1.02|Success|

print << "END_OF_HTML";
<tr BGCOLOR="$color">
    <td vAlign=baseline noWrap align=left>$data[1]</td>
    <td vAlign=baseline noWrap align=left>$data[2]</td>
    <td vAlign=baseline noWrap align=left>$data[4]</td>
    <td vAlign=baseline noWrap align=left>$data[5]</td>
    <td vAlign=baseline noWrap align=left>$data[6]</td>
    <td vAlign=baseline noWrap align=left>$data[8]</td>
</tr>
END_OF_HTML
}
}

if ($view =~ /rtp/) {
if ($_ =~ /\|RTP/gio) {
#|C_ADN_OPT_EPN_RULES|EPN_RULES_FILTER_DATA_FOR_BATCH|2465002k\ADNET|27-APR-2012 04:13:00|27-APR-2012 04:13:34|162.95|1.02|Success|

print << "END_OF_HTML";
<tr BGCOLOR="$color">
    <td vAlign=baseline noWrap align=left>$data[0]</td>
    <td vAlign=baseline noWrap align=left>$data[1]</td>
    <td vAlign=baseline noWrap align=left>$data[2]</td>
    <td vAlign=baseline noWrap align=left>$data[3]</td>
    <td vAlign=baseline noWrap align=left>$data[4]</td>
    <td vAlign=baseline noWrap align=left>$data[5]</td>
</tr>
END_OF_HTML
}
}


} #END WHILE

if ($view =~ /batch/) {
#
# 26
#
$recs = 0;
for ($i = 1; $i <= 26; $i++) {

$recs++;
$recs%=2;
if ($recs == 0) {
$color="#CCCCCC";
} else {
#TWO
$color="#888888";
}

@data = ();
$end  = "";
foreach $line (@lines) {
(@data)  = split(/\|/, $line);
$batch   = $data[1];
$data[1] =~ s/\s+//g;
$data[1] =~ s/Core-//g;
$data[1] =~ s/PayPal Batch-//g;
$data[1] =~ s/Batch//g;
$data[1] =~ s/PayPal//g;
$data[1] =~ s/-//g;
if ("$data[1]" eq "$i") {
#ore-3 Batch
#PayPal Batch-7
$end = $data[2];
}

}

if ($end eq "") {
$end = "NA";
}

if ($i < 5) {
print << "END_OF_HTML";
<tr BGCOLOR="$color">
    <td vAlign=baseline noWrap align=left>Core-$i Batch</td>
    <td vAlign=baseline noWrap align=left>$end</td>
</tr>
END_OF_HTML
} else {
print << "END_OF_HTML";
<tr BGCOLOR="$color">
    <td vAlign=baseline noWrap align=left>PayPal Batch-$i</td>
    <td vAlign=baseline noWrap align=left>$end</td>
</tr>
END_OF_HTML
} # IF

} # FOR

} #END IF
 
print << "END_OF_HTML";

</TABLE> </font>

END_OF_HTML

