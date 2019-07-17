#!/usr/bin/perl
#
# Re-Spaces BiCapitalized strings.
#
# Author:  Peter Keel <seegras@discordia.ch>
# Date:    08.07.2013
# Version: 0.1
# License: Public Domain
# URL:     http://seegras.discordia.ch/Programs/

use Getopt::Long;
use Pod::Usage;

&Getopt::Long::Configure( 'pass_through', 'no_autoabbrev');
&Getopt::Long::GetOptions(
                'help|h'                => \$needshelp,
);

if ($needshelp) {
pod2usage(1);
}

if (!$ARGV[0]) {
while (<>) {
    $string = $_;
    $string =~ s/([A-Z-])/_$1/g;
    $string =~ s/([0-9]+)/_$1/g;
    $string =~ s/_/ /g; # replace underscores with spaces
    $string =~ s/  / /g; # no double spaces
    $string =~ s/^-//g; # never start with a dash
    $string =~ s/^ //g; # don't start with a space
    print $string; 
}
} else { 
    $string = $ARGV[0]; 
    $string =~ s/([A-Z-])/_$1/g;
    $string =~ s/([0-9]+)/_$1/g;
    $string =~ s/_/ /g; # replace underscores with spaces
    $string =~ s/  / /g; # no double spaces
    $string =~ s/^-//g; # never start with a dash
    $string =~ s/^ //g; # don't start with a space
    print "$string\n"; 
}

__END__

=head1 NAME

respacefilter - re-space BiCapitalized strings

=head1 SYNOPSIS

B<This program> [options] [string ...]

 Options:
   -h|--help

=head1 OPTIONS

=over 8

=item B<-h|--help>

Print a brief help message and exit.

=back

=head1 DESCRIPTION

B<This program> will re-space bicapitalized strings. it wotrks with input from 
a pipe, as well as with input given as an argument.

=cut
