#!/usr/bin/perl
# 
# Re-Spaces BiCapitalized filenames. 
# 
# Author:   Peter Keel <seegras@discordia.ch>
# Date:     2013-07-06?
# Revision: 2020-05-06
# Version:  0.4
# License:  Public Domain
# URL:      http://seegras.discordia.ch/Programs/

# 
# Does not exactly use spaces, but rather underscores.
#
use strict;
use Getopt::Long;
use Pod::Usage;

my $needshelp;
my $dname;
my @dir_contents;
my $filename;
my $oldname;

&Getopt::Long::Configure( 'pass_through', 'no_autoabbrev');
&Getopt::Long::GetOptions(
    'help|h'	=> \$needshelp,
);

if (!$ARGV[0]) {
    $dname = ".";
} else { 
    $dname=$ARGV[0]; 
}

if ($needshelp) {
    pod2usage(1);
}

opendir(my $in_dir, $dname) || die "I am unable to access that directory...Sorry";
@dir_contents = readdir($in_dir);
closedir($in_dir);

@dir_contents = sort(@dir_contents);
    foreach my $filename (@dir_contents) {
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
