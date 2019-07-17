#!/usr/bin/perl
# 
# Re-Spaces BiCapitalized filenames. 
# 
# Author:  Peter Keel <seegras@discordia.ch>
# Date:    ?
# Revised: 06.07.2013
# Version: 0.3
# License: Public Domain
# URL:     http://seegras.discordia.ch/Programs/

# 
# Does not exactly use spaces, but rather underscores.
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
	    $filename =~ s/([A-Z-])/_$1/g;
	    # fixes
	    $filename =~ s/^_//g; # don't start a filename with an underscore
	    $filename =~ s/^-//g; # never start a filename with a dash
	    rename ("$dname/$oldname", "$dname/$filename") unless (($filename eq $oldname) || (-e "$dname/$filename")) ;
	}
    }

__END__

=head1 NAME

respace - re-space BiCapitalized filenames

=head1 SYNOPSIS

B<This program> [options] [directory ...]

 Options:
   -h|--help

=head1 OPTIONS

=over 8

=item B<-h|--help>

Print a brief help message and exit.

=back

=head1 DESCRIPTION

B<This program> will re-space bicapitalized filenames by prefixing 
upper-case letters with underscores. It processes all files of the 
directory you're in, unless given another directory. 

=cut
