#!/usr/bin/perl

use DBI;

require "/home/happy/www/cgi-bin/bear-lib.pl";
&GetEnviroment;

$path    = "/home/happy/www";
$site    = "http://thehappydailynews.com";
$htm     = "news.php";

$sql     = "
SELECT

  NEWS_ID,
  NEWS_ID_EXT,
  UPPER(NEWS_TYPE),
  UPPER(NEWS_SOURCE),
  UPPER(NEWS_SUBJECT),
  UPPER(NEWS_AUTHOR),
  DATE_FORMAT(PUBLISHEDAT, '%W, %M %d %Y %r'),
  NEWS_TITLE,
  NEWS_SHORT,
  NEWS,
  NEWS_URL,
  NEWS_ALLOW_MESG,
  NEWS_STATUS,
  DISPLAY_AUTHOR,
  STATUS,
  NEWS_CLASS,

  NEWS_ALLOW_DATE,
  NEWS_ALLOW_USER,

        CRE_USER,
        CRE_DATE,
        UPD_USER,
        cast(UPD_DATE as date)

FROM
        happy.news
WHERE cast(CRE_DATE as date) = CURRENT_DATE

";
open(HTM, ">$path/$htm");

print HTM << "END_OF_HTML";
<html>
<body>

<?php include 'header.php';?>

<TITLE>The Happy Daily News - Today's News</TITLE>

<table class='default'>

<TABLE width=100% bgcolor='#FFFFFF' cellpadding=5 border=0>

        <TR>
          <TD bgcolor='#FFFFFF' vAlign=baseline colspan=1 noWrap align=center width='3%'>
            <FONT size='4'>
                <br>&nbsp;<br>
            </FONT>
          </TD>

        <TR>
          <TD bgcolor='#FFFFFF' vAlign=baseline colspan=1 noWrap align=center width='3%'>
            <FONT size='4'>
                <br>&nbsp;<br>
            </FONT>
          </TD>

          <TD bgcolor='#FFFFFF' vAlign=baseline colspan=1 align=center width='33%'>
            <FONT color='#FFFFFF' size='6'>
                <br>
                <br>
<a href='/index.php'><img src='/images/THDNL.png' alt='today - the happy daily news' border='0' height='333' width='333'></a>
            </FONT>
            <FONT color=#FFFFFF size='4'>
            </FONT>

          </TD>

          <TD bgcolor='#FFFFFF' vAlign=baseline colspan=1 noWrap align=center width='3%'>
            <FONT size='4'>
                <br>&nbsp;<br>
                <br>
            </FONT>
          </TD>
        </TR>

</table>
</table>

<p align='center'>
            <FONT size='6'>
                <br>NEWS: TODAY<br>
            </FONT>
</p>

<p align='center'>

<table class='default'>

<TABLE width=100% cellpadding=5 border=0 BGCOLOR='C0C0C0'>


END_OF_HTML

if (!($dbh = DBI->connect($database, $db_user, $db_pass))) {
  $Err=$DBI::errstr;
  &GeneralError("CDR-100: Database Error: $Err Cannot Connect to $database as $db_user.\n");
}

$sth = $dbh->prepare($sql) ||
       &GeneralError("CDR-113: Database Error: $DBI::errstr: Cannot prepare $database as $db_user.\n");

$rc  = $sth->execute ||
       &GeneralError("CDR-123: Database Error: $DBI::errstr: Cannot execute $sql on $database as $db_user.\n");

while ((@data) = $sth->fetchrow()) {

  $NEWS_ID         = $data[0];
  $NEWS_ID_EXT     = $data[1];
  $NEWS_TYPE       = $data[2];
  $NEWS_SOURCE     = $data[3];
  $NEWS_SUBJECT    = $data[4];
  $NEWS_AUTHOR     = $data[5];
  $PUBLISHEDAT     = $data[6];
  $NEWS_TITLE      = $data[7];
  $NEWS_SHORT      = $data[8];
  $NEWS            = $data[9];
  $NEWS_URL        = $data[10];
  $NEWS_ALLOW_MESG = $data[11];
  $NEWS_STATUS     = $data[12];
  $DISPLAY_AUTHOR  = $data[13];
  $STATUS          = $data[14];
  $NEWS_CLASS      = $data[15];
  $NEWS_ALLOW_DATE = $data[16];
  $NEWS_ALLOW_USER = $data[17];
  $CRE_USER        = $data[18];
  $CRE_DATE        = $data[19];
  $UPD_USER        = $data[20];
  $UPD_DATE        = $data[21];

if ($DISPLAY_AUTHOR =~ /y/gio) {
$AUTHOR = $NEWS_AUTHOR;
} else {
$AUTHOR = "ANONYMOUS";
}

$count++;
$recs++;
$recs%=2;
if ($recs == 0) {
$bgcolor="#DCDCDC";
} else {
$bgcolor="#F5F5F5";
}
$bgcolor="#FFFFFF";

if ($NEWS_TYPE =~ /link/gio) {
$icon = "link.png";
} elsif ($NEWS_TYPE =~ /birth/gio) {
$icon = "birthday.png";
} elsif ($NEWS_TYPE =~ /event/gio) {
$icon = "calendar.jpg";
} elsif ($NEWS_TYPE =~ /wedding/gio) {
$icon = "wedding.png";
} elsif ($NEWS_TYPE =~ /graduation/gio) {
$icon = "graduation.png";
} else {
$icon = "newspaper.png";
}


print HTM << "END_OF_HTML";
<tr>
<td vAlign=center noWrap align=center bgcolor="$bgcolor">
<FONT class=Top face="$font" size="$fsize">
&nbsp;
<a href="/cgi-bin/news.pl?news_id=$data[0]"><img src="/images/$icon" alt="tools" border="0" height="35" width="35"></a>
&nbsp;

</td>
<td vAlign=center align=left bgcolor="$bgcolor">
<FONT class=Top face="$font" size="4">
&nbsp;
<b>$NEWS_TITLE</b>
</FONT>
<FONT class=Top face="$font" size="$fsize">
by
</FONT>
<FONT class=Top face="$font" size="3" color="#777777">
<b>$AUTHOR,</b>
</FONT>
<br>
&nbsp;&nbsp;&nbsp;
<FONT class=Top face="$font" size="2" color="#888888">
$NEWS_SUBJECT $NEWS_TYPE from $NEWS_SOURCE on $UPD_DATE
</font>
<br>

</td>
</tr>
END_OF_HTML

} #END WHILE

print HTM << "END_OF_HTML";

</table>
</table>

<tr>
<td colspan=2 vAlign=center noWrap align=center bgcolor="$bgcolor">
<FONT class=Top face="$font" size="$fsize">
<br>
displaying $count of $count stories
<br>
&nbsp;
</th>
</tr>

</table>
</table>

</p>

<?php include 'footer.php';?>

</body>
</html>


END_OF_HTML

close(HTM);

$sth->finish;
$dbh->disconnect;

sub GeneralError {
my ($local_error) = @_;

print "$local_error \n";

exit 1;

}

