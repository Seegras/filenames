#!/usr/bin/perl
#
# lowercases file names
# 
# Author:   Peter Keel <seegras@discordia.ch>
# Date:     2013-07-06
# Revision: 
# Version:  1.0
# License:  Public Domain
# URL:      http://seegras.discordia.ch/Programs/
# 

use Getopt::Long;
use Pod::Usage;

&Getopt::Long::Configure( 'pass_through', 'no_autoabbrev');
&Getopt::Long::GetOptions(
		'help|h'		=> \$needshelp,
);

if (!$ARGV[0]) {
    $dname = ".";
} else { 
    $dname=$ARGV[0]; 
}

if ($needshelp) {
pod2usage(1);
}

opendir(IN_DIR, $dname) || die "I am unable to access that directory...Sorry";
@dir_contents = readdir(IN_DIR);
closedir(IN_DIR);

@dir_contents = sort(@dir_contents);
    foreach $filename (@dir_contents) {
	if ($filename ne ".." and $filename ne ".") {
	    $oldname = $filename;
	    $filename = lc($oldname);
	    # fixes
	    $filename =~ s/^ //g; # don't start a filename with a space
	    $filename =~ s/^-//g; # never start a filename with a dash
	    rename ("$dname/$oldname", "$dname/$filename") unless (($filename eq $oldname) || (-e "$dname/$filename")) ;
	}
    }


__END__

=head1 NAME

lowercase - lowercase filenames

=head1 SYNOPSIS

lowercase [options] [directory ...]

 Options:
   -h|--help

=head1 OPTIONS

=over 8

=item B<-h|--help>

Print a brief help message and exit.

=back

=head1 DESCRIPTION

B<This program> will lowercase the filenames of the whole content 
of the directory you're in, unless given another directory. It also
strips leading dashes and spaces. 

=cut
