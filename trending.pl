#!/usr/bin/perl

use DBI;

require "/home/happy/www/cgi-bin/bear-lib.pl";
&GetEnviroment;

$sql = "DELETE FROM happy.trends";

&RunSql;

#print "NEWS LIKES...\n";
$sql = "
INSERT INTO happy.trends
SELECT
        '0',
	n.NEWS_ID,
        n.NEWS_SUBJECT,
	count(*),
        'LIKES',
        '1',
	CURRENT_TIMESTAMP,
	'1',
	CURRENT_TIMESTAMP
from happy.news n,
     happy.likes l
where 1 = 1
  and n.NEWS_ID = l.NEWS_ID
GROUP BY n.NEWS_ID,         
	 n.NEWS_SUBJECT
";

&RunSql;

#print "NEWS LOOKS...\n";
$sql = "
INSERT INTO happy.trends
SELECT
        '0',
        n.NEWS_ID,
        n.NEWS_SUBJECT,
        count(*),
        'VIEWS',
        '1',
        CURRENT_TIMESTAMP,
        '1',
        CURRENT_TIMESTAMP
from happy.news n,
     happy.looks k
where 1 = 1
  and n.NEWS_ID = k.NEWS_ID
GROUP BY n.NEWS_ID,
         n.NEWS_SUBJECT
";

&RunSql;

#print "NEWS INTERESTS...\n";
$sql = "
INSERT INTO happy.trends
SELECT
        '0',
        n.NEWS_ID,
        n.NEWS_SUBJECT,
        count(*),
        'INTERESTS',
        '1',
        CURRENT_TIMESTAMP,
        '1',
        CURRENT_TIMESTAMP
from happy.news n,
     happy.interests i
where 1 = 1
  and n.NEWS_SUBJECT = i.INTEREST
GROUP BY n.NEWS_ID,
         n.NEWS_SUBJECT
";

&RunSql;

$sql = "
INSERT INTO happy.trends
SELECT
        '0',
        n.NEWS_ID,
        n.NEWS_SUBJECT,
        count(*),
        'TODAY',
        '1',
        CURRENT_TIMESTAMP,
        '1',
        CURRENT_TIMESTAMP
from happy.news n
where 1 = 1
  and cast(CRE_DATE as date) = CURRENT_DATE
GROUP BY n.NEWS_ID,
         n.NEWS_SUBJECT
";

&RunSql;

$sql = "SELECT * FROM happy.trends";
&LAME;

&SendMail;
exit 1;

sub RunSql {

if (!($dbh = DBI->connect($database, $db_user, $db_pass))) {
  $Err=$DBI::errstr;
  &GeneralError("CDR-100: Database Error: $Err Cannot Connect to $database as $db_user.\n");
}

$sth = $dbh->prepare($sql) ||
       &GeneralError("CDR-113: Database Error: $DBI::errstr: Cannot prepare $database as $db_user.\n");

$rc  = $sth->execute ||
       &GeneralError("CDR-123: Database Error: $DBI::errstr: Cannot execute $sql on $database as $db_user.\n");

$sth->finish;
$dbh->disconnect;

}


sub LAME {

if (!($dbh = DBI->connect($database, $db_user, $db_pass))) {
  $Err=$DBI::errstr;
  &GeneralError("CDR-100: Database Error: $Err Cannot Connect to $database as $db_user.\n");
}

$sth = $dbh->prepare($sql) ||
       &GeneralError("CDR-113: Database Error: $DBI::errstr: Cannot prepare $database as $db_user.\n");

$rc  = $sth->execute ||
       &GeneralError("CDR-123: Database Error: $DBI::errstr: Cannot execute $sql on $database as $db_user.\n");

$html_body = "";

$html_body .= "
        <TR>
          <TD vAlign=baseline noWrap align=left width='15%'><FONT class=Top face='$font' size='$fsize'>TYPE
          </TD>
          <TD colspan=1 align=left vAlign=baseline width='35%'><FONT class=Top face='$font' size='$fsize'>COUNT
          </TD>
          <TD colspan=1 align=left vAlign=baseline width='35%'><FONT class=Top face='$font' size='$fsize'>SUBJECT
          <TD colspan=1 align=left vAlign=baseline width='35%'><FONT class=Top face='$font' size='$fsize'>NEWS ID
          </TD>

          </TD>
        </TR>
";

while ((@Ar) = $sth->fetchrow()) {
print "@Ar\n";
$loccount++;
push(@MyCookieIdTmpLoc, $Ar[0]);
#print "AR: (@Ar) \n";
#print "ID: $Ar[0] and $Ar[1] and $Ar[2] and $Ar[3] and $Ar[4]\n";
#

$html_body .= "
        <TR>
          <TD vAlign=baseline noWrap align=left width='15%'><FONT class=Top face='$font' size='$fsize'>$Ar[4]
          </TD>
          <TD colspan=1 align=left vAlign=baseline width='35%'><FONT class=Top face='$font' size='$fsize'>$Ar[3]
          </TD>
          <TD colspan=1 align=left vAlign=baseline width='35%'><FONT class=Top face='$font' size='$fsize'>$Ar[2]
          <TD colspan=1 align=left vAlign=baseline width='35%'><FONT class=Top face='$font' size='$fsize'>$Ar[1]
          </TD>

          </TD>
        </TR>
";

} #END WHILE

$sth->finish;
$dbh->disconnect;

}

sub GeneralError {
my ($local_error) = @_;

print "$local_error \n";

exit 1;

}


sub SendMail {

$mail_to  = "";
$mess     = "";
$mail_cc  = "";
$mail_bcc = "";

$mail_to    = 'info@thehappydailynews.com'; 
$mail_cc    = 'brian_nunes@hotmail.com';

if ($email_address =~ /\@/) {
if (($email_address =~ /\|/) ||
    ($email_address =~ /\!/) ||
    ($email_address =~ /,/)) {
$mail_from  = 'info@thehappydailynews.com'; 
} else {
$mail_from  = $email_address; 
}
} else {
$mail_from  = 'info@thehappydailynews.com';
}
$subject    = "the happy daily news: trending";
$mailcmd    = "/usr/lib/sendmail -t -f $mail_from";
$mess      .= "Subject: $subject\n";
$mess      .= "To:  $mail_to\n";

if ($mail_cc ne "") {
$mess      .= "Cc:  $mail_cc\n";
}

if ($mail_bcc ne "") {
$mess      .= "Bcc:  $mail_bcc\n";
}

$mess      .= "Content-Type: text/html;\n";

if (($mail_to ne "") || ($mail_to ne /^\@/)) {
open(MAIL,"| $mailcmd") ||
        die "Can't open mail command\n $mailcmd \n";
} else {

}

print "$mailcmd\n";
print "$mess\n";

print MAIL "$mess\n";

print MAIL << "END_OF_HTML";



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<META http-equiv=Content-Type content="text/html; charset=iso-8859-1">


<table class="default">

<TABLE width=100% bgcolor="#222222" cellpadding=5 border=0>

        <TR>
          <TD bgcolor="#222222" vAlign=baseline colspan=1 noWrap align=center width="3%">
            <FONT size="4">
                <br>&nbsp;<br>
            </FONT>
          </TD>

          <TD bgcolor="#222222" vAlign=baseline colspan=1 align=center width="33%">
            <FONT color="#FFFFFF" size="2">
               <br>&nbsp;<br>
            </FONT>
          </TD>

          <TD bgcolor="#222222" vAlign=baseline colspan=1 noWrap align=center width="3%">
            <FONT size="4">
                <br>&nbsp;<br>
            </FONT>
          </TD>
        </TR>

        <TR>
          <TD bgcolor="#222222" vAlign=baseline colspan=1 noWrap align=center width="3%">
            <FONT size="4">
                <br>&nbsp;<br>
            </FONT>
          </TD>

          <TD bgcolor="#222222" vAlign=baseline colspan=1 align=center width="33%">

            <FONT color="#FFFFFF" size="6">
		the happy daily news
            </FONT>

            <FONT color="#FFFFFF" size="3">
		<br>
		our cup is half full<br>
            </FONT>
            <FONT color="#FFFFFF" size="">
            </FONT>

          </TD>

          <TD bgcolor="#222222" vAlign=baseline colspan=1 noWrap align=center width="3%">
            <FONT size="4">
                <br>&nbsp;<br>
            </FONT>
          </TD>
        </TR>

        <TR>
          <TD bgcolor="#222222" vAlign=baseline colspan=1 noWrap align=center width="3%">
            <FONT size="4">
                <br>&nbsp;<br>
            </FONT>
          </TD>

          <TD bgcolor="#222222" vAlign=baseline colspan=1 align=center width="33%">
            <FONT color="#FFFFFF" size="2">
               <br>&nbsp;<br>
            </FONT>
          </TD>

          <TD bgcolor="#222222" vAlign=baseline colspan=1 noWrap align=center width="3%">
            <FONT size="4">
                <br>&nbsp;<br>
            </FONT>
          </TD>
        </TR>


</table>
</table>

<p align="left">
<br>


<table width="100%" class="layout">

<form action="login.pl" method="POST" name="myForm">
<table>

$html_body

<tr>
<td colspan=2 align=center>
</tr>

</table>
</form>
</p>
</html>
END_OF_HTML

close(MAIL);

}

