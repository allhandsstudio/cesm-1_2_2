#!/usr/bin/env perl
#-----------------------------------------------------------------------------------------------
#
# get_Icaselist.pl
#
# This utility gets a list of the I cases from the CESM create_newcase script.
#
#-----------------------------------------------------------------------------------------------

use strict;
use Cwd;
use English;
use Getopt::Long;
use IO::File;
use IO::Handle;
#-----------------------------------------------------------------------------------------------

sub usage {
    die <<EOF;
SYNOPSIS
     get_Icaselist.pl  [options]
OPTIONS
EOF
}

#-----------------------------------------------------------------------------------------------
# Setting autoflush (an IO::Handle method) on STDOUT helps in debugging.  It forces the test
# descriptions to be printed to STDOUT before the error messages start.

*STDOUT->autoflush();                  

#-----------------------------------------------------------------------------------------------
my $cwd = getcwd();      # current working directory
my $cfgdir;              # absolute pathname of directory that contains this script
$cfgdir = $cwd;

#-----------------------------------------------------------------------------------------------
# Parse command-line options.
my %opts = (
	    );
GetOptions(
    "h|help"                    => \$opts{'help'},
)  or usage();

# Give usage message.
usage() if $opts{'help'};

# Check for unparsed argumentss
if (@ARGV) {
    print "ERROR: unrecognized arguments: @ARGV\n";
    usage();
}

my $file = "tempfile_compsetlist.txt";
if ( -f $file ) { system( "/bin/rm $file" ); }
system( "../../../../../scripts/create_newcase -list compsets | grep 'alias: I' > $file" );
my $fh = IO::File->new($file, '<') or die "**  can't open input file: $file\n";
print_compsets( $fh );
$fh->close();
#system( "/bin/rm $file" );

#-----------------------------------------------------------------------------------------------
# FINNISHED ####################################################################################
#-----------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------

sub print_compsets
{
    # Print all currently supported valid compsets

    my $fh = shift;

    my %data;
    while ( my $line = <$fh> ) {
        if ( $line =~ /alias: ([^ ]+)[ ]+longname: ([^ ]+)/ ) {
           $data{$1} = $2;
        }
    }
    print "<varname>Alias</varname>\n" .
	  " (Long-name with time-period and each component)\n";
    print "<orderedlist>\n";
    foreach my $alias ( sort(keys(%data)) ) {
        print "<listitem><para><varname>$alias</varname>\n" .
	      " ($data{$alias})</para></listitem>\n";
    }
    print "</orderedlist>\n";
}

