#!/usr/bin/perl

(@list) = `ls -1`;

open(NEW, ">MegaUc4.UC4");

print NEW << "END_OF_XML";
<?xml version="1.0" encoding="ISO-8859-15"?>
<uc-export clientvers="11.2.8+hf.2.build.1642">

END_OF_XML

foreach $l (@list) {
chomp($l);
if ($l =~ /.xml/) {
        open(LOG, "$l");
        while (<LOG>) {
                chomp($_);
        if ($_ =~ /^\<\?xml version/gio) {
        } elsif ($_ =~ /^\<uc-export clien/gio) {
        } elsif ($_ =~ /^\<\/uc-export/gio) {
        } else {
        print NEW "$_\n";
        } #END
        } #END WHILE

}
}

print NEW << "END_OF_XML";
</uc-export>
END_OF_XML

