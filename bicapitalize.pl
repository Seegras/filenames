#!/usr/bin/perl
# 
# Author:  Peter Keel <seegras@discordia.ch>
# Date:    20.11.2003
# Revised: 20.04.2015
# Version: 1.1
# License: Public Domain
# URL:     http://seegras.discordia.ch/Programs/
#
# BiCapitalizes filenames. And strips spaces.
# 
# My First attempts of finding a suitable regexp failed, so this is the 
# stupid version which does it one at a time. And besides takes care 
# nothing non-ascii and no special characters turn up in the filename.
#
# 1.0 is nearly a complete rewrite from 0.99 and fixes a lot of issues
# with wrong character mappings, and also adds a lot of character mappings.
#

use Getopt::Long;
use Pod::Usage;

# Config Options
$dontbicap = 0; 
#$debug = 1;

&Getopt::Long::Configure( 'pass_through', 'no_autoabbrev');
&Getopt::Long::GetOptions(
		'dontbicapitalize|d!'	=> \$dontbicap,
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

$OK_CHARS='.a-zA-Z0-9-';  # dashes

sub utf8toascii {
    # UTF8 Latin 1
    my $string = $_[0];
    if ($debug) { print (stderr "utf8toascii   string-in : '$string'\n"); };
	$string =~ s/\x00\x21/_/g; # EXCLAMATION MARK
	$string =~ s/\x00\x22/_/g; # QUOTATION MARK
	$string =~ s/\x00\x23/_number_/g; # NUMBER SIGN
	$string =~ s/\x00\x24/_dollar_/g; # DOLLAR SIGN
	$string =~ s/\x00\x25/_percent_/g; # PERCENT SIGN
	$string =~ s/\x00\x26/_and_/g; # AMPERSAND
	$string =~ s/\x00\x27/_/g; # APOSTROPHE
	$string =~ s/\x00\x28/_/g; # LEFT PARENTHESIS
	$string =~ s/\x00\x29/_/g; # RIGHT PARENTHESIS
	$string =~ s/\x00\x2a/_/g; # ASTERISK
	$string =~ s/\x00\x2b/+/g; # PLUS SIGN
	$string =~ s/\x00\x2c/,/g; # COMMA
	$string =~ s/\x00\x2d/-/g; # HYPHEN-MINUS
	$string =~ s/\x00\x2e/./g; # FULL STOP
	$string =~ s/\x00\x2f/_/g; # SOLIDUS
	$string =~ s/\x00\x30/0/g; # DIGIT ZERO
	$string =~ s/\x00\x31/1/g; # DIGIT ONE
	$string =~ s/\x00\x32/2/g; # DIGIT TWO
	$string =~ s/\x00\x33/3/g; # DIGIT THREE
	$string =~ s/\x00\x34/4/g; # DIGIT FOUR
	$string =~ s/\x00\x35/5/g; # DIGIT FIVE
	$string =~ s/\x00\x36/6/g; # DIGIT SIX
	$string =~ s/\x00\x37/7/g; # DIGIT SEVEN
	$string =~ s/\x00\x38/8/g; # DIGIT EIGHT
	$string =~ s/\x00\x39/9/g; # DIGIT NINE
	$string =~ s/\x00\x3a/_/g; # COLON
	$string =~ s/\x00\x3b/_/g; # SEMICOLON
	$string =~ s/\x00\x3c/_/g; # LESS-THAN SIGN
	$string =~ s/\x00\x3d/=/g; # EQUALS SIGN
	$string =~ s/\x00\x3e/_/g; # GREATER-THAN SIGN
	$string =~ s/\x00\x3f/_/g; # QUESTION MARK
	$string =~ s/\x00\x40/_at_/g; # COMMERCIAL AT
	$string =~ s/\x00\x41/A/g; # LATIN CAPITAL LETTER A
	$string =~ s/\x00\x42/B/g; # LATIN CAPITAL LETTER B
	$string =~ s/\x00\x43/C/g; # LATIN CAPITAL LETTER C
	$string =~ s/\x00\x44/D/g; # LATIN CAPITAL LETTER D
	$string =~ s/\x00\x45/E/g; # LATIN CAPITAL LETTER E
	$string =~ s/\x00\x46/F/g; # LATIN CAPITAL LETTER F
	$string =~ s/\x00\x47/G/g; # LATIN CAPITAL LETTER G
	$string =~ s/\x00\x48/H/g; # LATIN CAPITAL LETTER H
	$string =~ s/\x00\x49/I/g; # LATIN CAPITAL LETTER I
	$string =~ s/\x00\x4a/J/g; # LATIN CAPITAL LETTER J
	$string =~ s/\x00\x4b/K/g; # LATIN CAPITAL LETTER K
	$string =~ s/\x00\x4c/L/g; # LATIN CAPITAL LETTER L
	$string =~ s/\x00\x4d/M/g; # LATIN CAPITAL LETTER M
	$string =~ s/\x00\x4e/N/g; # LATIN CAPITAL LETTER N
	$string =~ s/\x00\x4f/O/g; # LATIN CAPITAL LETTER O
	$string =~ s/\x00\x50/P/g; # LATIN CAPITAL LETTER P
	$string =~ s/\x00\x51/Q/g; # LATIN CAPITAL LETTER Q
	$string =~ s/\x00\x52/R/g; # LATIN CAPITAL LETTER R
	$string =~ s/\x00\x53/S/g; # LATIN CAPITAL LETTER S
	$string =~ s/\x00\x54/T/g; # LATIN CAPITAL LETTER T
	$string =~ s/\x00\x55/U/g; # LATIN CAPITAL LETTER U
	$string =~ s/\x00\x56/V/g; # LATIN CAPITAL LETTER V
	$string =~ s/\x00\x57/W/g; # LATIN CAPITAL LETTER W
	$string =~ s/\x00\x58/X/g; # LATIN CAPITAL LETTER X
	$string =~ s/\x00\x59/Y/g; # LATIN CAPITAL LETTER Y
	$string =~ s/\x00\x5a/Z/g; # LATIN CAPITAL LETTER Z
	$string =~ s/\x00\x5b/_/g; # LEFT SQUARE BRACKET
	$string =~ s/\x00\x5c/_/g; # REVERSE SOLIDUS
	$string =~ s/\x00\x5d/_/g; # RIGHT SQUARE BRACKET
	$string =~ s/\x00\x5e/_/g; # CIRCUMFLEX ACCENT
	$string =~ s/\x00\x5f/_/g; # LOW LINE
	$string =~ s/\x00\x60/_/g; # GRAVE ACCENT
	$string =~ s/\x00\x61/a/g; # LATIN SMALL LETTER A
	$string =~ s/\x00\x62/b/g; # LATIN SMALL LETTER B
	$string =~ s/\x00\x63/c/g; # LATIN SMALL LETTER C
	$string =~ s/\x00\x64/d/g; # LATIN SMALL LETTER D
	$string =~ s/\x00\x65/e/g; # LATIN SMALL LETTER E
	$string =~ s/\x00\x66/f/g; # LATIN SMALL LETTER F
	$string =~ s/\x00\x67/g/g; # LATIN SMALL LETTER G
	$string =~ s/\x00\x68/h/g; # LATIN SMALL LETTER H
	$string =~ s/\x00\x69/i/g; # LATIN SMALL LETTER I
	$string =~ s/\x00\x6a/j/g; # LATIN SMALL LETTER J
	$string =~ s/\x00\x6b/k/g; # LATIN SMALL LETTER K
	$string =~ s/\x00\x6c/l/g; # LATIN SMALL LETTER L
	$string =~ s/\x00\x6d/m/g; # LATIN SMALL LETTER M
	$string =~ s/\x00\x6e/n/g; # LATIN SMALL LETTER N
	$string =~ s/\x00\x6f/o/g; # LATIN SMALL LETTER O
	$string =~ s/\x00\x70/p/g; # LATIN SMALL LETTER P
	$string =~ s/\x00\x71/q/g; # LATIN SMALL LETTER Q
	$string =~ s/\x00\x72/r/g; # LATIN SMALL LETTER R
	$string =~ s/\x00\x73/s/g; # LATIN SMALL LETTER S
	$string =~ s/\x00\x74/t/g; # LATIN SMALL LETTER T
	$string =~ s/\x00\x75/u/g; # LATIN SMALL LETTER U
	$string =~ s/\x00\x76/v/g; # LATIN SMALL LETTER V
	$string =~ s/\x00\x77/w/g; # LATIN SMALL LETTER W
	$string =~ s/\x00\x78/x/g; # LATIN SMALL LETTER X
	$string =~ s/\x00\x79/y/g; # LATIN SMALL LETTER Y
	$string =~ s/\x00\x7a/z/g; # LATIN SMALL LETTER Z
	$string =~ s/\x00\x7b/_/g; # LEFT CURLY BRACKET
	$string =~ s/\x00\x7c/_/g; # VERTICAL LINE
	$string =~ s/\x00\x7d/_/g; # RIGHT CURLY BRACKET
	$string =~ s/\x00\x7e/~/g; # TILDE
	$string =~ s/\xc2\xa1/_/g; # INVERTED EXCLAMATION MARK
	$string =~ s/\xc2\xa2/_cent_/g; # CENT SIGN
	$string =~ s/\xc2\xa3/_pount_/g; # POUND SIGN
	$string =~ s/\xc2\xa4/_/g; # CURRENCY SIGN
	$string =~ s/\xc2\xa5/_yen_/g; # YEN SIGN
	$string =~ s/\xc2\xa6/_/g; #BROKEN BAR
	$string =~ s/\xc2\xa7/_/g; #SECTION SIGN
	$string =~ s/\xc2\xa8/_/g; #DIAERESIS
	$string =~ s/\xc2\xa9/c/g; #COPYRIGHT SIGN
	$string =~ s/\xc2\xaa/a/g; #FEMININE ORDINAL INDICATOR
	$string =~ s/\xc2\xab/_/g; #LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
	$string =~ s/\xc2\xac/_/g; #NOT SIGN
	$string =~ s/\xc2\xad/_/g; #SOFT HYPHEN
	$string =~ s/\xc2\xae/R/g; #REGISTERED SIGN
	$string =~ s/\xc2\xaf/_/g; #MACRON
	$string =~ s/\xc2\xb0/_/g; #DEGREE SIGN
	$string =~ s/\xc2\xb1/_/g; #PLUS-MINUS SIGN
	$string =~ s/\xc2\xb2/2/g; #SUPERSCRIPT TWO
	$string =~ s/\xc2\xb3/3/g; #SUPERSCRIPT THREE
	$string =~ s/\xc2\xb4/_/g; #ACUTE ACCENT
	$string =~ s/\xc2\xb5/m/g; #MICRO SIGN
	$string =~ s/\xc2\xb6/_/g; #PILCROW SIGN
	$string =~ s/\xc2\xb7/_/g; #MIDDLE DOT
	$string =~ s/\xc2\xb8/_/g; #CEDILLA
	$string =~ s/\xc2\xb9/1/g; #SUPERSCRIPT ONE
	$string =~ s/\xc2\xba/_/g; #MASCULINE ORDINAL INDICATOR
	$string =~ s/\xc2\xbb/_/g; #RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
	$string =~ s/\xc2\xbc/_one_quarter_/g; #VULGAR FRACTION ONE QUARTER
	$string =~ s/\xc2\xbd/_one_half_/g; #VULGAR FRACTION ONE HALF
	$string =~ s/\xc2\xbe/_three_quarters_/g; #VULGAR FRACTION THREE QUARTERS
	$string =~ s/\xc2\xbf/_/g; #INVERTED QUESTION MARK
	$string =~ s/\xc3\x80/A/g; #LATIN CAPITAL LETTER A WITH GRAVE
	$string =~ s/\xc3\x81/A/g; #LATIN CAPITAL LETTER A WITH ACUTE
	$string =~ s/\xc3\x82/A/g; #LATIN CAPITAL LETTER A WITH CIRCUMFLEX
	$string =~ s/\xc3\x83/A/g; #LATIN CAPITAL LETTER A WITH TILDE
	$string =~ s/\xc3\x84/Ae/g; #LATIN CAPITAL LETTER A WITH DIAERESIS
	$string =~ s/\xc3\x85/A/g; #LATIN CAPITAL LETTER A WITH RING ABOVE
	$string =~ s/\xc3\x86/AE/g; #LATIN CAPITAL LETTER AE
	$string =~ s/\xc3\x87/C/g; #LATIN CAPITAL LETTER C WITH CEDILLA
	$string =~ s/\xc3\x88/E/g; #LATIN CAPITAL LETTER E WITH GRAVE
	$string =~ s/\xc3\x89/E/g; #LATIN CAPITAL LETTER E WITH ACUTE
	$string =~ s/\xc3\x8a/E/g; #LATIN CAPITAL LETTER E WITH CIRCUMFLEX
	$string =~ s/\xc3\x8b/E/g; #LATIN CAPITAL LETTER E WITH DIAERESIS
	$string =~ s/\xc3\x8c/I/g; #LATIN CAPITAL LETTER I WITH GRAVE
	$string =~ s/\xc3\x8d/I/g; #LATIN CAPITAL LETTER I WITH ACUTE
	$string =~ s/\xc3\x8e/I/g; #LATIN CAPITAL LETTER I WITH CIRCUMFLEX
	$string =~ s/\xc3\x8f/I/g; #LATIN CAPITAL LETTER I WITH DIAERESIS
	$string =~ s/\xc3\x90/D/g; #LATIN CAPITAL LETTER ETH
	$string =~ s/\xc3\x91/N/g; #LATIN CAPITAL LETTER N WITH TILDE
	$string =~ s/\xc3\x92/O/g; #LATIN CAPITAL LETTER O WITH GRAVE
	$string =~ s/\xc3\x93/O/g; #LATIN CAPITAL LETTER O WITH ACUTE
	$string =~ s/\xc3\x94/O/g; #LATIN CAPITAL LETTER O WITH CIRCUMFLEX
	$string =~ s/\xc3\x95/O/g; #LATIN CAPITAL LETTER O WITH TILDE
	$string =~ s/\xc3\x96/O/g; #LATIN CAPITAL LETTER O WITH DIAERESIS
	$string =~ s/\xc3\x97/x/g; #MULTIPLICATION SIGN
	$string =~ s/\xc3\x98/O/g; #LATIN CAPITAL LETTER O WITH STROKE
	$string =~ s/\xc3\x99/U/g; #LATIN CAPITAL LETTER U WITH GRAVE
	$string =~ s/\xc3\x9a/U/g; #LATIN CAPITAL LETTER U WITH ACUTE
	$string =~ s/\xc3\x9b/U/g; #LATIN CAPITAL LETTER U WITH CIRCUMFLEX
	$string =~ s/\xc3\x9c/U/g; #LATIN CAPITAL LETTER U WITH DIAERESIS
	$string =~ s/\xc3\x9d/Y/g; #LATIN CAPITAL LETTER Y WITH ACUTE
	$string =~ s/\xc3\x9e/Th/g; #LATIN CAPITAL LETTER THORN
	$string =~ s/\xc3\x9f/ss/g; #LATIN SMALL LETTER SHARP S
	$string =~ s/\xc3\xa0/a/g; #LATIN SMALL LETTER A WITH GRAVE
	$string =~ s/\xc3\xa1/a/g; #LATIN SMALL LETTER A WITH ACUTE
	$string =~ s/\xc3\xa2/a/g; #LATIN SMALL LETTER A WITH CIRCUMFLEX
	$string =~ s/\xc3\xa3/a/g; #LATIN SMALL LETTER A WITH TILDE
	$string =~ s/\xc3\xa4/ae/g; #LATIN SMALL LETTER A WITH DIAERESIS
	$string =~ s/\xc3\xa5/a/g; #LATIN SMALL LETTER A WITH RING ABOVE
	$string =~ s/\xc3\xa6/ae/g; #LATIN SMALL LETTER AE
	$string =~ s/\xc3\xa7/c/g; #LATIN SMALL LETTER C WITH CEDILLA
	$string =~ s/\xc3\xa8/e/g; #LATIN SMALL LETTER E WITH GRAVE
	$string =~ s/\xc3\xa9/e/g; #LATIN SMALL LETTER E WITH ACUTE
	$string =~ s/\xc3\xaa/e/g; #LATIN SMALL LETTER E WITH CIRCUMFLEX
	$string =~ s/\xc3\xab/e/g; #LATIN SMALL LETTER E WITH DIAERESIS
	$string =~ s/\xc3\xac/i/g; #LATIN SMALL LETTER I WITH GRAVE
	$string =~ s/\xc3\xad/i/g; #LATIN SMALL LETTER I WITH ACUTE
	$string =~ s/\xc3\xae/i/g; #LATIN SMALL LETTER I WITH CIRCUMFLEX
	$string =~ s/\xc3\xaf/i/g; #LATIN SMALL LETTER I WITH DIAERESIS
	$string =~ s/\xc3\xb0/d/g; #LATIN SMALL LETTER ETH
	$string =~ s/\xc3\xb1/n/g; #LATIN SMALL LETTER N WITH TILDE
	$string =~ s/\xc3\xb2/o/g; #LATIN SMALL LETTER O WITH GRAVE
	$string =~ s/\xc3\xb3/o/g; #LATIN SMALL LETTER O WITH ACUTE
	$string =~ s/\xc3\xb4/o/g; #LATIN SMALL LETTER O WITH CIRCUMFLEX
	$string =~ s/\xc3\xb5/o/g; #LATIN SMALL LETTER O WITH TILDE
	$string =~ s/\xc3\xb6/oe/g; #LATIN SMALL LETTER O WITH DIAERESIS
	$string =~ s/\xc3\xb7/_/g; #DIVISION SIGN
	$string =~ s/\xc3\xb8/o/g; #LATIN SMALL LETTER O WITH STROKE
	$string =~ s/\xc3\xb9/u/g; #LATIN SMALL LETTER U WITH GRAVE
	$string =~ s/\xc3\xba/u/g; #LATIN SMALL LETTER U WITH ACUTE
	$string =~ s/\xc3\xbb/u/g; #LATIN SMALL LETTER U WITH CIRCUMFLEX
	$string =~ s/\xc3\xbc/ue/g; #LATIN SMALL LETTER U WITH DIAERESIS
	$string =~ s/\xc3\xbd/y/g; #LATIN SMALL LETTER Y WITH ACUTE
	$string =~ s/\xc3\xbe/th/g; #LATIN SMALL LETTER THORN
	$string =~ s/\xc3\xbf/y/g; #LATIN SMALL LETTER Y WITH DIAERESIS
	$string =~ s/\xc4\x80/A/g; #LATIN CAPITAL LETTER A WITH MACRON
	$string =~ s/\xc4\x81/a/g; #LATIN SMALL LETTER A WITH MACRON
	$string =~ s/\xc4\x82/A/g; #LATIN CAPITAL LETTER A WITH BREVE
	$string =~ s/\xc4\x83/a/g; #LATIN SMALL LETTER A WITH BREVE
	$string =~ s/\xc4\x84/A/g; #LATIN CAPITAL LETTER A WITH OGONEK
	$string =~ s/\xc4\x85/a/g; #LATIN SMALL LETTER A WITH OGONEK
	$string =~ s/\xc4\x86/C/g; #LATIN CAPITAL LETTER C WITH ACUTE
	$string =~ s/\xc4\x87/c/g; #LATIN SMALL LETTER C WITH ACUTE
	$string =~ s/\xc4\x88/C/g; #LATIN CAPITAL LETTER C WITH CIRCUMFLEX
	$string =~ s/\xc4\x89/c/g; #LATIN SMALL LETTER C WITH CIRCUMFLEX
	$string =~ s/\xc4\x8a/C/g; #LATIN CAPITAL LETTER C WITH DOT ABOVE
	$string =~ s/\xc4\x8b/c/g; #LATIN SMALL LETTER C WITH DOT ABOVE
	$string =~ s/\xc4\x8c/C/g; #LATIN CAPITAL LETTER C WITH CARON
	$string =~ s/\xc4\x8d/c/g; #LATIN SMALL LETTER C WITH CARON
	$string =~ s/\xc4\x8e/D/g; #LATIN CAPITAL LETTER D WITH CARON
	$string =~ s/\xc4\x8f/d/g; #LATIN SMALL LETTER D WITH CARON
	$string =~ s/\xc4\x90/D/g; #LATIN CAPITAL LETTER D WITH STROKE
	$string =~ s/\xc4\x91/d/g; #LATIN SMALL LETTER D WITH STROKE
	$string =~ s/\xc4\x92/E/g; #LATIN CAPITAL LETTER E WITH MACRON
	$string =~ s/\xc4\x93/e/g; #LATIN SMALL LETTER E WITH MACRON
	$string =~ s/\xc4\x94/E/g; #LATIN CAPITAL LETTER E WITH BREVE
	$string =~ s/\xc4\x95/e/g; #LATIN SMALL LETTER E WITH BREVE
	$string =~ s/\xc4\x96/E/g; #LATIN CAPITAL LETTER E WITH DOT ABOVE
	$string =~ s/\xc4\x97/e/g; #LATIN SMALL LETTER E WITH DOT ABOVE
	$string =~ s/\xc4\x98/E/g; #LATIN CAPITAL LETTER E WITH OGONEK
	$string =~ s/\xc4\x99/e/g; #LATIN SMALL LETTER E WITH OGONEK
	$string =~ s/\xc4\x9a/E/g; #LATIN CAPITAL LETTER E WITH CARON
	$string =~ s/\xc4\x9b/e/g; #LATIN SMALL LETTER E WITH CARON
	$string =~ s/\xc4\x9c/G/g; #LATIN CAPITAL LETTER G WITH CIRCUMFLEX
	$string =~ s/\xc4\x9d/g/g; #LATIN SMALL LETTER G WITH CIRCUMFLEX
	$string =~ s/\xc4\x9e/G/g; #LATIN CAPITAL LETTER G WITH BREVE
	$string =~ s/\xc4\x9f/g/g; #LATIN SMALL LETTER G WITH BREVE
	$string =~ s/\xc4\xa0/G/g; #LATIN CAPITAL LETTER G WITH DOT ABOVE
	$string =~ s/\xc4\xa1/g/g; #LATIN SMALL LETTER G WITH DOT ABOVE
	$string =~ s/\xc4\xa2/G/g; #LATIN CAPITAL LETTER G WITH CEDILLA
	$string =~ s/\xc4\xa3/G/g; #LATIN SMALL LETTER G WITH CEDILLA
	$string =~ s/\xc4\xa4/H/g; #LATIN CAPITAL LETTER H WITH CIRCUMFLEX
	$string =~ s/\xc4\xa5/h/g; #LATIN SMALL LETTER H WITH CIRCUMFLEX
	$string =~ s/\xc4\xa6/H/g; #LATIN CAPITAL LETTER H WITH STROKE
	$string =~ s/\xc4\xa7/h/g; #LATIN SMALL LETTER H WITH STROKE
	$string =~ s/\xc4\xa8/I/g; #LATIN CAPITAL LETTER I WITH TILDE
	$string =~ s/\xc4\xa9/i/g; #LATIN SMALL LETTER I WITH TILDE
	$string =~ s/\xc4\xaa/I/g; #LATIN CAPITAL LETTER I WITH MACRON
	$string =~ s/\xc4\xab/i/g; #LATIN SMALL LETTER I WITH MACRON
	$string =~ s/\xc4\xac/I/g; #LATIN CAPITAL LETTER I WITH BREVE
	$string =~ s/\xc4\xad/i/g; #LATIN SMALL LETTER I WITH BREVE
	$string =~ s/\xc4\xae/I/g; #LATIN CAPITAL LETTER I WITH OGONEK
	$string =~ s/\xc4\xaf/i/g; #LATIN SMALL LETTER I WITH OGONEK
	$string =~ s/\xc4\xb0/I/g; #LATIN CAPITAL LETTER I WITH DOT ABOVE
	$string =~ s/\xc4\xb1/i/g; #LATIN SMALL LETTER DOTLESS I
	$string =~ s/\xc4\xb2/IJ/g; #LATIN CAPITAL LIGATURE IJ
	$string =~ s/\xc4\xb3/ij/g; #LATIN SMALL LIGATURE IJ
	$string =~ s/\xc4\xb4/J/g; #LATIN CAPITAL LETTER J WITH CIRCUMFLEX
	$string =~ s/\xc4\xb5/j/g; #LATIN SMALL LETTER J WITH CIRCUMFLEX
	$string =~ s/\xc4\xb6/K/g; #LATIN CAPITAL LETTER K WITH CEDILLA
	$string =~ s/\xc4\xb7/k/g; #LATIN SMALL LETTER K WITH CEDILLA
	$string =~ s/\xc4\xb8/k/g; #LATIN SMALL LETTER KRA
	$string =~ s/\xc4\xb9/L/g; #LATIN CAPITAL LETTER L WITH ACUTE
	$string =~ s/\xc4\xba/l/g; #LATIN SMALL LETTER L WITH ACUTE
	$string =~ s/\xc4\xbb/L/g; #LATIN CAPITAL LETTER L WITH CEDILLA
	$string =~ s/\xc4\xbc/l/g; #LATIN SMALL LETTER L WITH CEDILLA
	$string =~ s/\xc4\xbd/L/g; #LATIN CAPITAL LETTER L WITH CARON
	$string =~ s/\xc4\xbe/l/g; #LATIN SMALL LETTER L WITH CARON
	$string =~ s/\xc4\xbf/L/g; #LATIN CAPITAL LETTER L WITH MIDDLE DOT
	$string =~ s/\xc5\x80/l/g; #LATIN SMALL LETTER L WITH MIDDLE DOT
	$string =~ s/\xc5\x81/L/g; #LATIN CAPITAL LETTER L WITH STROKE
	$string =~ s/\xc5\x82/l/g; #LATIN SMALL LETTER L WITH STROKE
	$string =~ s/\xc5\x83/N/g; #LATIN CAPITAL LETTER N WITH ACUTE
	$string =~ s/\xc5\x84/n/g; #LATIN SMALL LETTER N WITH ACUTE
	$string =~ s/\xc5\x85/N/g; #LATIN CAPITAL LETTER N WITH CEDILLA
	$string =~ s/\xc5\x86/n/g; #LATIN SMALL LETTER N WITH CEDILLA
	$string =~ s/\xc5\x87/N/g; #LATIN CAPITAL LETTER N WITH CARON
	$string =~ s/\xc5\x88/n/g; #LATIN SMALL LETTER N WITH CARON
	$string =~ s/\xc5\x89/n/g; #LATIN SMALL LETTER N PRECEDED BY APOSTROPHE
	$string =~ s/\xc5\x8a/N/g; #LATIN CAPITAL LETTER ENG
	$string =~ s/\xc5\x8b/n/g; #LATIN SMALL LETTER ENG
	$string =~ s/\xc5\x8c/O/g; #LATIN CAPITAL LETTER O WITH MACRON
	$string =~ s/\xc5\x8d/o/g; #LATIN SMALL LETTER O WITH MACRON
	$string =~ s/\xc5\x8e/O/g; #LATIN CAPITAL LETTER O WITH BREVE
	$string =~ s/\xc5\x8f/o/g; #LATIN SMALL LETTER O WITH BREVE
	$string =~ s/\xc5\x90/O/g; #LATIN CAPITAL LETTER O WITH DOUBLE ACUTE
	$string =~ s/\xc5\x91/o/g; #LATIN SMALL LETTER O WITH DOUBLE ACUTE
	$string =~ s/\xc5\x92/OE/g; #LATIN CAPITAL LIGATURE OE
	$string =~ s/\xc5\x93/oe/g; #LATIN SMALL LIGATURE OE
	$string =~ s/\xc5\x94/R/g; #LATIN CAPITAL LETTER R WITH ACUTE
	$string =~ s/\xc5\x95/r/g; #LATIN SMALL LETTER R WITH ACUTE
	$string =~ s/\xc5\x96/R/g; #LATIN CAPITAL LETTER R WITH CEDILLA
	$string =~ s/\xc5\x97/r/g; #LATIN SMALL LETTER R WITH CEDILLA
	$string =~ s/\xc5\x98/R/g; #LATIN CAPITAL LETTER R WITH CARON
	$string =~ s/\xc5\x99/r/g; #LATIN SMALL LETTER R WITH CARON
	$string =~ s/\xc5\x9a/S/g; #LATIN CAPITAL LETTER S WITH ACUTE
	$string =~ s/\xc5\x9b/s/g; #LATIN SMALL LETTER S WITH ACUTE
	$string =~ s/\xc5\x9c/S/g; #LATIN CAPITAL LETTER S WITH CIRCUMFLEX
	$string =~ s/\xc5\x9d/s/g; #LATIN SMALL LETTER S WITH CIRCUMFLEX
	$string =~ s/\xc5\x9e/S/g; #LATIN CAPITAL LETTER S WITH CEDILLA
	$string =~ s/\xc5\x9f/s/g; #LATIN SMALL LETTER S WITH CEDILLA
	$string =~ s/\xc5\xa0/S/g; #LATIN CAPITAL LETTER S WITH CARON
	$string =~ s/\xc5\xa1/s/g; #LATIN SMALL LETTER S WITH CARON
	$string =~ s/\xc5\xa2/T/g; #LATIN CAPITAL LETTER T WITH CEDILLA
	$string =~ s/\xc5\xa3/t/g; #LATIN SMALL LETTER T WITH CEDILLA
	$string =~ s/\xc5\xa4/T/g; #LATIN CAPITAL LETTER T WITH CARON
	$string =~ s/\xc5\xa5/t/g; #LATIN SMALL LETTER T WITH CARON
	$string =~ s/\xc5\xa6/T/g; #LATIN CAPITAL LETTER T WITH STROKE
	$string =~ s/\xc5\xa7/t/g; #LATIN SMALL LETTER T WITH STROKE
	$string =~ s/\xc5\xa8/U/g; #LATIN CAPITAL LETTER U WITH TILDE
	$string =~ s/\xc5\xa9/u/g; #LATIN SMALL LETTER U WITH TILDE
	$string =~ s/\xc5\xaa/U/g; #LATIN CAPITAL LETTER U WITH MACRON
	$string =~ s/\xc5\xab/u/g; #LATIN SMALL LETTER U WITH MACRON
	$string =~ s/\xc5\xac/U/g; #LATIN CAPITAL LETTER U WITH BREVE
	$string =~ s/\xc5\xad/u/g; #LATIN SMALL LETTER U WITH BREVE
	$string =~ s/\xc5\xae/U/g; #LATIN CAPITAL LETTER U WITH RING ABOVE
	$string =~ s/\xc5\xaf/u/g; #LATIN SMALL LETTER U WITH RING ABOVE
	$string =~ s/\xc5\xb0/U/g; #LATIN CAPITAL LETTER U WITH DOUBLE ACUTE
	$string =~ s/\xc5\xb1/u/g; #LATIN SMALL LETTER U WITH DOUBLE ACUTE
	$string =~ s/\xc5\xb2/U/g; #LATIN CAPITAL LETTER U WITH OGONEK
	$string =~ s/\xc5\xb3/u/g; #LATIN SMALL LETTER U WITH OGONEK
	$string =~ s/\xc5\xb4/W/g; #LATIN CAPITAL LETTER W WITH CIRCUMFLEX
	$string =~ s/\xc5\xb5/w/g; #LATIN SMALL LETTER W WITH CIRCUMFLEX
	$string =~ s/\xc5\xb6/Y/g; #LATIN CAPITAL LETTER Y WITH CIRCUMFLEX
	$string =~ s/\xc5\xb7/y/g; #LATIN SMALL LETTER Y WITH CIRCUMFLEX
	$string =~ s/\xc5\xb8/Y/g; #LATIN CAPITAL LETTER Y WITH DIAERESIS
	$string =~ s/\xc5\xb9/Z/g; #LATIN CAPITAL LETTER Z WITH ACUTE
	$string =~ s/\xc5\xba/z/g; #LATIN SMALL LETTER Z WITH ACUTE
	$string =~ s/\xc5\xbb/Z/g; #LATIN CAPITAL LETTER Z WITH DOT ABOVE
	$string =~ s/\xc5\xbc/z/g; #LATIN SMALL LETTER Z WITH DOT ABOVE
	$string =~ s/\xc5\xbd/Z/g; #LATIN CAPITAL LETTER Z WITH CARON
	$string =~ s/\xc5\xbe/z/g; #LATIN SMALL LETTER Z WITH CARON
	$string =~ s/\xc5\xbf/s/g; #LATIN SMALL LETTER LONG S
	$string =~ s/\xc6\x80/b/g; #LATIN SMALL LETTER B WITH STROKE
	$string =~ s/\xc6\x81/B/g; #LATIN CAPITAL LETTER B WITH HOOK
	$string =~ s/\xc6\x82/B/g; #LATIN CAPITAL LETTER B WITH TOPBAR
	$string =~ s/\xc6\x83/b/g; #LATIN SMALL LETTER B WITH TOPBAR
	$string =~ s/\xc6\x84/B/g; #LATIN CAPITAL LETTER TONE SIX
	$string =~ s/\xc6\x85/b/g; #LATIN SMALL LETTER TONE SIX
	$string =~ s/\xc6\x86/O/g; #LATIN CAPITAL LETTER OPEN O
	$string =~ s/\xc6\x87/C/g; #LATIN CAPITAL LETTER C WITH HOOK
	$string =~ s/\xc6\x88/c/g; #LATIN SMALL LETTER C WITH HOOK
	$string =~ s/\xc6\x89/D/g; #LATIN CAPITAL LETTER AFRICAN D
	$string =~ s/\xc6\x8a/D/g; #LATIN CAPITAL LETTER D WITH HOOK
	$string =~ s/\xc6\x8b/D/g; #LATIN CAPITAL LETTER D WITH TOPBAR
	$string =~ s/\xc6\x8c/d/g; #LATIN SMALL LETTER D WITH TOPBAR
	$string =~ s/\xc6\x8d/d/g; #LATIN SMALL LETTER TURNED DELTA
	$string =~ s/\xc6\x8e/E/g; #LATIN CAPITAL LETTER REVERSED E
	$string =~ s/\xc6\x8f/e/g; #LATIN CAPITAL LETTER SCHWA
	$string =~ s/\xc6\x90/E/g; #LATIN CAPITAL LETTER OPEN E
	$string =~ s/\xc6\x91/F/g; #LATIN CAPITAL LETTER F WITH HOOK
	$string =~ s/\xc6\x92/F/g; #LATIN SMALL LETTER F WITH HOOK
	$string =~ s/\xc6\x93/G/g; #LATIN CAPITAL LETTER G WITH HOOK
	$string =~ s/\xc6\x94/Y/g; #LATIN CAPITAL LETTER GAMMA
	$string =~ s/\xc6\x95/hv/g; #LATIN SMALL LETTER HV
	$string =~ s/\xc6\x96/I/g; #LATIN CAPITAL LETTER IOTA
	$string =~ s/\xc6\x97/I/g; #LATIN CAPITAL LETTER I WITH STROKE
	$string =~ s/\xc6\x98/K/g; #LATIN CAPITAL LETTER K WITH HOOK
	$string =~ s/\xc6\x99/k/g; #LATIN SMALL LETTER K WITH HOOK
	$string =~ s/\xc6\x9a/l/g; #LATIN SMALL LETTER L WITH BAR
	$string =~ s/\xc6\x9b//g; #LATIN SMALL LETTER LAMBDA WITH STROKE
	$string =~ s/\xc6\x9c/M/g; #LATIN CAPITAL LETTER TURNED M
	$string =~ s/\xc6\x9d/N/g; #LATIN CAPITAL LETTER N WITH LEFT HOOK
	$string =~ s/\xc6\x9e/n/g; #LATIN SMALL LETTER N WITH LONG RIGHT LEG
	$string =~ s/\xc6\x9f/O/g; #LATIN CAPITAL LETTER O WITH MIDDLE TILDE
	$string =~ s/\xc6\xa0/O/g; #LATIN CAPITAL LETTER O WITH HORN
	$string =~ s/\xc6\xa1/o/g; #LATIN SMALL LETTER O WITH HORN
	$string =~ s/\xc6\xa2/OI/g; #LATIN CAPITAL LETTER OI
	$string =~ s/\xc6\xa3/oi/g; #LATIN SMALL LETTER OI
	$string =~ s/\xc6\xa4/P/g; #LATIN CAPITAL LETTER P WITH HOOK
	$string =~ s/\xc6\xa5/p/g; #LATIN SMALL LETTER P WITH HOOK
	$string =~ s/\xc6\xa6/yr/g; #LATIN LETTER YR
	$string =~ s/\xc6\xa7/S/g; #LATIN CAPITAL LETTER TONE TWO
	$string =~ s/\xc6\xa8/s/g; #LATIN SMALL LETTER TONE TWO
	$string =~ s/\xc6\xa9/E/g; #LATIN CAPITAL LETTER ESH
	$string =~ s/\xc6\xaa/e/g; #LATIN LETTER REVERSED ESH LOOP
	$string =~ s/\xc6\xab/t/g; #LATIN SMALL LETTER T WITH PALATAL HOOK
	$string =~ s/\xc6\xac/T/g; #LATIN CAPITAL LETTER T WITH HOOK
	$string =~ s/\xc6\xad/t/g; #LATIN SMALL LETTER T WITH HOOK
	$string =~ s/\xc6\xae/T/g; #LATIN CAPITAL LETTER T WITH RETROFLEX HOOK
	$string =~ s/\xc6\xaf/U/g; #LATIN CAPITAL LETTER U WITH HORN
	$string =~ s/\xc6\xb0/u/g; #LATIN SMALL LETTER U WITH HORN
	$string =~ s/\xc6\xb1/U/g; #LATIN CAPITAL LETTER UPSILON
	$string =~ s/\xc6\xb2/V/g; #LATIN CAPITAL LETTER V WITH HOOK
	$string =~ s/\xc6\xb3/Y/g; #LATIN CAPITAL LETTER Y WITH HOOK
	$string =~ s/\xc6\xb4/y/g; #LATIN SMALL LETTER Y WITH HOOK
	$string =~ s/\xc6\xb5/Z/g; #LATIN CAPITAL LETTER Z WITH STROKE
	$string =~ s/\xc6\xb6/z/g; #LATIN SMALL LETTER Z WITH STROKE
	$string =~ s/\xc6\xb7/Z/g; #LATIN CAPITAL LETTER EZH
	$string =~ s/\xc6\xb8/Z/g; #LATIN CAPITAL LETTER EZH REVERSED
	$string =~ s/\xc6\xb9/z/g; #LATIN SMALL LETTER EZH REVERSED
	$string =~ s/\xc6\xba/z/g; #LATIN SMALL LETTER EZH WITH TAIL
	$string =~ s/\xc6\xbb/2/g; #LATIN LETTER TWO WITH STROKE
	$string =~ s/\xc6\xbc/5/g; #LATIN CAPITAL LETTER TONE FIVE
	$string =~ s/\xc6\xbd/5/g; #LATIN SMALL LETTER TONE FIVE
	$string =~ s/\xc6\xbe//g; #LATIN LETTER INVERTED GLOTTAL STOP WITH STROKE
	$string =~ s/\xc6\xbf//g; #LATIN LETTER WYNN
	$string =~ s/\xc7\x80//g; #LATIN LETTER DENTAL CLICK
	$string =~ s/\xc7\x81//g; #LATIN LETTER LATERAL CLICK
	$string =~ s/\xc7\x82//g; #LATIN LETTER ALVEOLAR CLICK
	$string =~ s/\xc7\x83//g; #LATIN LETTER RETROFLEX CLICK
	$string =~ s/\xc7\x84/DZ/g; #LATIN CAPITAL LETTER DZ WITH CARON
	$string =~ s/\xc7\x85/Dz/g; #LATIN CAPITAL LETTER D WITH SMALL LETTER Z WITH CARON
	$string =~ s/\xc7\x86/dz/g; #LATIN SMALL LETTER DZ WITH CARON
	$string =~ s/\xc7\x87/LJ/g; #LATIN CAPITAL LETTER LJ
	$string =~ s/\xc7\x88/Lj/g; #LATIN CAPITAL LETTER L WITH SMALL LETTER J
	$string =~ s/\xc7\x89/lj/g; #LATIN SMALL LETTER LJ
	$string =~ s/\xc7\x8a/NJ/g; #LATIN CAPITAL LETTER NJ
	$string =~ s/\xc7\x8b/Nj/g; #LATIN CAPITAL LETTER N WITH SMALL LETTER J
	$string =~ s/\xc7\x8c/nj/g; #LATIN SMALL LETTER NJ
	$string =~ s/\xc7\x8d/A/g; #LATIN CAPITAL LETTER A WITH CARON
	$string =~ s/\xc7\x8e/a/g; #LATIN SMALL LETTER A WITH CARON
	$string =~ s/\xc7\x8f/I/g; #LATIN CAPITAL LETTER I WITH CARON
	$string =~ s/\xc7\x90/i/g; #LATIN SMALL LETTER I WITH CARON
	$string =~ s/\xc7\x91/O/g; #LATIN CAPITAL LETTER O WITH CARON
	$string =~ s/\xc7\x92/o/g; #LATIN SMALL LETTER O WITH CARON
	$string =~ s/\xc7\x93/U/g; #LATIN CAPITAL LETTER U WITH CARON
	$string =~ s/\xc7\x94/u/g; #LATIN SMALL LETTER U WITH CARON
	$string =~ s/\xc7\x95/U/g; #LATIN CAPITAL LETTER U WITH DIAERESIS AND MACRON
	$string =~ s/\xc7\x96/u/g; #LATIN SMALL LETTER U WITH DIAERESIS AND MACRON
	$string =~ s/\xc7\x97/U/g; #LATIN CAPITAL LETTER U WITH DIAERESIS AND ACUTE
	$string =~ s/\xc7\x98/u/g; #LATIN SMALL LETTER U WITH DIAERESIS AND ACUTE
	$string =~ s/\xc7\x99/U/g; #LATIN CAPITAL LETTER U WITH DIAERESIS AND CARON
	$string =~ s/\xc7\x9a/u/g; #LATIN SMALL LETTER U WITH DIAERESIS AND CARON
	$string =~ s/\xc7\x9b/U/g; #LATIN CAPITAL LETTER U WITH DIAERESIS AND GRAVE
	$string =~ s/\xc7\x9c/u/g; #LATIN SMALL LETTER U WITH DIAERESIS AND GRAVE
	$string =~ s/\xc7\x9d/e/g; #LATIN SMALL LETTER TURNED E
	$string =~ s/\xc7\x9e/A/g; #LATIN CAPITAL LETTER A WITH DIAERESIS AND MACRON
	$string =~ s/\xc7\x9f/a/g; #LATIN SMALL LETTER A WITH DIAERESIS AND MACRON
	$string =~ s/\xc7\xa0/A/g; #LATIN CAPITAL LETTER A WITH DOT ABOVE AND MACRON
	$string =~ s/\xc7\xa1/a/g; #LATIN SMALL LETTER A WITH DOT ABOVE AND MACRON
	$string =~ s/\xc7\xa2/AE/g; #LATIN CAPITAL LETTER AE WITH MACRON
	$string =~ s/\xc7\xa3/ae/g; #LATIN SMALL LETTER AE WITH MACRON
	$string =~ s/\xc7\xa4/G/g; #LATIN CAPITAL LETTER G WITH STROKE
	$string =~ s/\xc7\xa5/g/g; #LATIN SMALL LETTER G WITH STROKE
	$string =~ s/\xc7\xa6/G/g; #LATIN CAPITAL LETTER G WITH CARON
	$string =~ s/\xc7\xa7/g/g; #LATIN SMALL LETTER G WITH CARON
	$string =~ s/\xc7\xa8/K/g; #LATIN CAPITAL LETTER K WITH CARON
	$string =~ s/\xc7\xa9/k/g; #LATIN SMALL LETTER K WITH CARON
	$string =~ s/\xc7\xaa/O/g; #LATIN CAPITAL LETTER O WITH OGONEK
	$string =~ s/\xc7\xab/o/g; #LATIN SMALL LETTER O WITH OGONEK
	$string =~ s/\xc7\xac/O/g; #LATIN CAPITAL LETTER O WITH OGONEK AND MACRON
	$string =~ s/\xc7\xad/o/g; #LATIN SMALL LETTER O WITH OGONEK AND MACRON
	$string =~ s/\xc7\xae/Z/g; #LATIN CAPITAL LETTER EZH WITH CARON
	$string =~ s/\xc7\xaf/z/g; #LATIN SMALL LETTER EZH WITH CARON
	$string =~ s/\xc7\xb0/j/g; #LATIN SMALL LETTER J WITH CARON
	$string =~ s/\xc7\xb1/DZ/g; #LATIN CAPITAL LETTER DZ
	$string =~ s/\xc7\xb2/Dz/g; #LATIN CAPITAL LETTER D WITH SMALL LETTER Z
	$string =~ s/\xc7\xb3/dz/g; #LATIN SMALL LETTER DZ
	$string =~ s/\xc7\xb4/G/g; #LATIN CAPITAL LETTER G WITH ACUTE
	$string =~ s/\xc7\xb5/g/g; #LATIN SMALL LETTER G WITH ACUTE
	$string =~ s/\xc7\xb6//g; #LATIN CAPITAL LETTER HWAIR
	$string =~ s/\xc7\xb7//g; #LATIN CAPITAL LETTER WYNN
	$string =~ s/\xc7\xb8/N/g; #LATIN CAPITAL LETTER N WITH GRAVE
	$string =~ s/\xc7\xb9/n/g; #LATIN SMALL LETTER N WITH GRAVE
	$string =~ s/\xc7\xba/A/g; #LATIN CAPITAL LETTER A WITH RING ABOVE AND ACUTE
	$string =~ s/\xc7\xbb/a/g; #LATIN SMALL LETTER A WITH RING ABOVE AND ACUTE
	$string =~ s/\xc7\xbc/AE/g; #LATIN CAPITAL LETTER AE WITH ACUTE
	$string =~ s/\xc7\xbd/ae/g; #LATIN SMALL LETTER AE WITH ACUTE
	$string =~ s/\xc7\xbe/O/g; #LATIN CAPITAL LETTER O WITH STROKE AND ACUTE
	$string =~ s/\xc7\xbf/o/g; #LATIN SMALL LETTER O WITH STROKE AND ACUTE
	$string =~ s/\xc8\x80/A/g; #LATIN CAPITAL LETTER A WITH DOUBLE GRAVE
	$string =~ s/\xc8\x81/a/g; #LATIN SMALL LETTER A WITH DOUBLE GRAVE
	$string =~ s/\xc8\x82/A/g; #LATIN CAPITAL LETTER A WITH INVERTED BREVE
	$string =~ s/\xc8\x83/a/g; #LATIN SMALL LETTER A WITH INVERTED BREVE
	$string =~ s/\xc8\x84/E/g; #LATIN CAPITAL LETTER E WITH DOUBLE GRAVE
	$string =~ s/\xc8\x85/e/g; #LATIN SMALL LETTER E WITH DOUBLE GRAVE
	$string =~ s/\xc8\x86/E/g; #LATIN CAPITAL LETTER E WITH INVERTED BREVE
	$string =~ s/\xc8\x87/e/g; #LATIN SMALL LETTER E WITH INVERTED BREVE
	$string =~ s/\xc8\x88/I/g; #LATIN CAPITAL LETTER I WITH DOUBLE GRAVE
	$string =~ s/\xc8\x89/i/g; #LATIN SMALL LETTER I WITH DOUBLE GRAVE
	$string =~ s/\xc8\x8a/I/g; #LATIN CAPITAL LETTER I WITH INVERTED BREVE
	$string =~ s/\xc8\x8b/i/g; #LATIN SMALL LETTER I WITH INVERTED BREVE
	$string =~ s/\xc8\x8c/O/g; #LATIN CAPITAL LETTER O WITH DOUBLE GRAVE
	$string =~ s/\xc8\x8d/o/g; #LATIN SMALL LETTER O WITH DOUBLE GRAVE
	$string =~ s/\xc8\x8e/O/g; #LATIN CAPITAL LETTER O WITH INVERTED BREVE
	$string =~ s/\xc8\x8f/o/g; #LATIN SMALL LETTER O WITH INVERTED BREVE
	$string =~ s/\xc8\x90/R/g; #LATIN CAPITAL LETTER R WITH DOUBLE GRAVE
	$string =~ s/\xc8\x91/r/g; #LATIN SMALL LETTER R WITH DOUBLE GRAVE
	$string =~ s/\xc8\x92/R/g; #LATIN CAPITAL LETTER R WITH INVERTED BREVE
	$string =~ s/\xc8\x93/r/g; #LATIN SMALL LETTER R WITH INVERTED BREVE
	$string =~ s/\xc8\x94/U/g; #LATIN CAPITAL LETTER U WITH DOUBLE GRAVE
	$string =~ s/\xc8\x95/u/g; #LATIN SMALL LETTER U WITH DOUBLE GRAVE
	$string =~ s/\xc8\x96/U/g; #LATIN CAPITAL LETTER U WITH INVERTED BREVE
	$string =~ s/\xc8\x97/u/g; #LATIN SMALL LETTER U WITH INVERTED BREVE
	$string =~ s/\xc8\x98/S/g; #LATIN CAPITAL LETTER S WITH COMMA BELOW
	$string =~ s/\xc8\x99/s/g; #LATIN SMALL LETTER S WITH COMMA BELOW
	$string =~ s/\xc8\x9a/T/g; #LATIN CAPITAL LETTER T WITH COMMA BELOW
	$string =~ s/\xc8\x9b/t/g; #LATIN SMALL LETTER T WITH COMMA BELOW
	$string =~ s/\xc8\x9c//g; #LATIN CAPITAL LETTER YOGH
	$string =~ s/\xc8\x9d//g; #LATIN SMALL LETTER YOGH
	$string =~ s/\xc8\x9e/H/g; #LATIN CAPITAL LETTER H WITH CARON
	$string =~ s/\xc8\x9f/h/g; #LATIN SMALL LETTER H WITH CARON
	$string =~ s/\xc8\xa0/N/g; #LATIN CAPITAL LETTER N WITH LONG RIGHT LEG
	$string =~ s/\xc8\xa1/d/g; #LATIN SMALL LETTER D WITH CURL
	$string =~ s/\xc8\xa2/Ou/g; #LATIN CAPITAL LETTER OU
	$string =~ s/\xc8\xa3/ou/g; #LATIN SMALL LETTER OU
	$string =~ s/\xc8\xa4/Z/g; #LATIN CAPITAL LETTER Z WITH HOOK
	$string =~ s/\xc8\xa5/z/g; #LATIN SMALL LETTER Z WITH HOOK
	$string =~ s/\xc8\xa6/A/g; #LATIN CAPITAL LETTER A WITH DOT ABOVE
	$string =~ s/\xc8\xa7/a/g; #LATIN SMALL LETTER A WITH DOT ABOVE
	$string =~ s/\xc8\xa8/E/g; #LATIN CAPITAL LETTER E WITH CEDILLA
	$string =~ s/\xc8\xa9/e/g; #LATIN SMALL LETTER E WITH CEDILLA
	$string =~ s/\xc8\xaa/O/g; #LATIN CAPITAL LETTER O WITH DIAERESIS AND MACRON
	$string =~ s/\xc8\xab/o/g; #LATIN SMALL LETTER O WITH DIAERESIS AND MACRON
	$string =~ s/\xc8\xac/O/g; #LATIN CAPITAL LETTER O WITH TILDE AND MACRON
	$string =~ s/\xc8\xad/o/g; #LATIN SMALL LETTER O WITH TILDE AND MACRON
	$string =~ s/\xc8\xae/O/g; #LATIN CAPITAL LETTER O WITH DOT ABOVE
	$string =~ s/\xc8\xaf/o/g; #LATIN SMALL LETTER O WITH DOT ABOVE
	$string =~ s/\xc8\xb0/O/g; #LATIN CAPITAL LETTER O WITH DOT ABOVE AND MACRON
	$string =~ s/\xc8\xb1/o/g; #LATIN SMALL LETTER O WITH DOT ABOVE AND MACRON
	$string =~ s/\xc8\xb2/Y/g; #LATIN CAPITAL LETTER Y WITH MACRON
	$string =~ s/\xc8\xb3/y/g; #LATIN SMALL LETTER Y WITH MACRON
	$string =~ s/\xc8\xb4/l/g; #LATIN SMALL LETTER L WITH CURL
	$string =~ s/\xc8\xb5/n/g; #LATIN SMALL LETTER N WITH CURL
	$string =~ s/\xc8\xb6/t/g; #LATIN SMALL LETTER T WITH CURL
	$string =~ s/\xc8\xb7/j/g; #LATIN SMALL LETTER DOTLESS J
	$string =~ s/\xc8\xb8/db/g; #LATIN SMALL LETTER DB DIGRAPH
	$string =~ s/\xc8\xb9/qp/g; #LATIN SMALL LETTER QP DIGRAPH
	$string =~ s/\xc8\xba/A/g; #LATIN CAPITAL LETTER A WITH STROKE
	$string =~ s/\xc8\xbb/C/g; #LATIN CAPITAL LETTER C WITH STROKE
	$string =~ s/\xc8\xbc/c/g; #LATIN SMALL LETTER C WITH STROKE
	$string =~ s/\xc8\xbd/L/g; #LATIN CAPITAL LETTER L WITH BAR
	$string =~ s/\xc8\xbe/t/g; #LATIN CAPITAL LETTER T WITH DIAGONAL STROKE
	$string =~ s/\xc8\xbf/s/g; #LATIN SMALL LETTER S WITH SWASH TAIL
	$string =~ s/\xc9\x80/z/g; #LATIN SMALL LETTER Z WITH SWASH TAIL
	$string =~ s/\xc9\x81//g; #LATIN CAPITAL LETTER GLOTTAL STOP
	$string =~ s/\xc9\x82//g; #LATIN SMALL LETTER GLOTTAL STOP
	$string =~ s/\xc9\x83/B/g; #LATIN CAPITAL LETTER B WITH STROKE
	$string =~ s/\xc9\x84/U/g; #LATIN CAPITAL LETTER U BAR
	$string =~ s/\xc9\x85/V/g; #LATIN CAPITAL LETTER TURNED V
	$string =~ s/\xc9\x86/E/g; #LATIN CAPITAL LETTER E WITH STROKE
	$string =~ s/\xc9\x87/e/g; #LATIN SMALL LETTER E WITH STROKE
	$string =~ s/\xc9\x88/J/g; #LATIN CAPITAL LETTER J WITH STROKE
	$string =~ s/\xc9\x89/j/g; #LATIN SMALL LETTER J WITH STROKE
	$string =~ s/\xc9\x8a/Q/g; #LATIN CAPITAL LETTER SMALL Q WITH HOOK TAIL
	$string =~ s/\xc9\x8b/q/g; #LATIN SMALL LETTER Q WITH HOOK TAIL
	$string =~ s/\xc9\x8c/R/g; #LATIN CAPITAL LETTER R WITH STROKE
	$string =~ s/\xc9\x8d/r/g; #LATIN SMALL LETTER R WITH STROKE
	$string =~ s/\xc9\x8e/Y/g; #LATIN CAPITAL LETTER Y WITH STROKE
	$string =~ s/\xc9\x8f/y/g; #LATIN SMALL LETTER Y WITH STROKE
	$string =~ s/\xc9\x90//g; #LATIN SMALL LETTER TURNED A
	$string =~ s/\xc9\x91/a/g; #LATIN SMALL LETTER ALPHA
	$string =~ s/\xc9\x92/a/g; #LATIN SMALL LETTER TURNED ALPHA
	$string =~ s/\xc9\x93/b/g; #LATIN SMALL LETTER B WITH HOOK
	$string =~ s/\xc9\x94/o/g; #LATIN SMALL LETTER OPEN O
	$string =~ s/\xc9\x95/c/g; #LATIN SMALL LETTER C WITH CURL
	$string =~ s/\xc9\x96/d/g; #LATIN SMALL LETTER D WITH TAIL
	$string =~ s/\xc9\x97/d/g; #LATIN SMALL LETTER D WITH HOOK
	$string =~ s/\xc9\x98/e/g; #LATIN SMALL LETTER REVERSED E
	$string =~ s/\xc9\x99/e/g; #LATIN SMALL LETTER SCHWA
	$string =~ s/\xc9\x9a/e/g; #LATIN SMALL LETTER SCHWA WITH HOOK
	$string =~ s/\xc9\x9b/e/g; #LATIN SMALL LETTER OPEN E
	$string =~ s/\xc9\x9c/e/g; #LATIN SMALL LETTER REVERSED OPEN E
	$string =~ s/\xc9\x9d/e/g; #LATIN SMALL LETTER REVERSED OPEN E WITH HOOK
	$string =~ s/\xc9\x9e/e/g; #LATIN SMALL LETTER CLOSED REVERSED OPEN E
	$string =~ s/\xc9\x9f/j/g; #LATIN SMALL LETTER DOTLESS J WITH STROKE
	$string =~ s/\xc9\xa0/g/g; #LATIN SMALL LETTER G WITH HOOK
	$string =~ s/\xc9\xa1/g/g; #LATIN SMALL LETTER SCRIPT G
	$string =~ s/\xc9\xa2/G/g; #LATIN LETTER SMALL CAPITAL G
	$string =~ s/\xc9\xa3/y/g; #LATIN SMALL LETTER GAMMA
	$string =~ s/\xc9\xa4/y/g; #LATIN SMALL LETTER RAMS HORN
	$string =~ s/\xc9\xa5/h/g; #LATIN SMALL LETTER TURNED H
	$string =~ s/\xc9\xa6/h/g; #LATIN SMALL LETTER H WITH HOOK
	$string =~ s/\xc9\xa7/h/g; #LATIN SMALL LETTER HENG WITH HOOK
	$string =~ s/\xc9\xa8/i/g; #LATIN SMALL LETTER I WITH STROKE
	$string =~ s/\xc9\xa9/i/g; #LATIN SMALL LETTER IOTA
	$string =~ s/\xc9\xaa/I/g; #LATIN LETTER SMALL CAPITAL I
	$string =~ s/\xc9\xab/l/g; #LATIN SMALL LETTER L WITH MIDDLE TILDE
	$string =~ s/\xc9\xac/l/g; #LATIN SMALL LETTER L WITH BELT
	$string =~ s/\xc9\xad/l/g; #LATIN SMALL LETTER L WITH RETROFLEX HOOK
	$string =~ s/\xc9\xae/lz/g; #LATIN SMALL LETTER LEZH
	$string =~ s/\xc9\xaf/m/g; #LATIN SMALL LETTER TURNED M
	$string =~ s/\xc9\xb0/m/g; #LATIN SMALL LETTER TURNED M WITH LONG LEG
	$string =~ s/\xc9\xb1/m/g; #LATIN SMALL LETTER M WITH HOOK
	$string =~ s/\xc9\xb2/n/g; #LATIN SMALL LETTER N WITH LEFT HOOK
	$string =~ s/\xc9\xb3/n/g; #LATIN SMALL LETTER N WITH RETROFLEX HOOK
	$string =~ s/\xc9\xb4/N/g; #LATIN LETTER SMALL CAPITAL N
	$string =~ s/\xc9\xb5/o/g; #LATIN SMALL LETTER BARRED O
	$string =~ s/\xc9\xb6/oe/g; #LATIN LETTER SMALL CAPITAL OE
	$string =~ s/\xc9\xb7/o/g; #LATIN SMALL LETTER CLOSED OMEGA
	$string =~ s/\xc9\xb8/p/g; #LATIN SMALL LETTER PHI
	$string =~ s/\xc9\xb9/r/g; #LATIN SMALL LETTER TURNED R
	$string =~ s/\xc9\xba/r/g; #LATIN SMALL LETTER TURNED R WITH LONG LEG
	$string =~ s/\xc9\xbb/r/g; #LATIN SMALL LETTER TURNED R WITH HOOK
	$string =~ s/\xc9\xbc/r/g; #LATIN SMALL LETTER R WITH LONG LEG
	$string =~ s/\xc9\xbd/r/g; #LATIN SMALL LETTER R WITH TAIL
	$string =~ s/\xc9\xbe/r/g; #LATIN SMALL LETTER R WITH FISHHOOK
	$string =~ s/\xc9\xbf/r/g; #LATIN SMALL LETTER REVERSED R WITH FISHHOOK
	$string =~ s/\xca\x80/R/g; #LATIN LETTER SMALL CAPITAL R
	$string =~ s/\xca\x81/R/g; #LATIN LETTER SMALL CAPITAL INVERTED R
	$string =~ s/\xca\x82/s/g; #LATIN SMALL LETTER S WITH HOOK
	$string =~ s/\xca\x83/s/g; #LATIN SMALL LETTER ESH
	$string =~ s/\xca\x84/j/g; #LATIN SMALL LETTER DOTLESS J WITH STROKE AND HOOK
	$string =~ s/\xca\x85/s/g; #LATIN SMALL LETTER SQUAT REVERSED ESH
	$string =~ s/\xca\x86/s/g; #LATIN SMALL LETTER ESH WITH CURL
	$string =~ s/\xca\x87/t/g; #LATIN SMALL LETTER TURNED T
	$string =~ s/\xca\x88/t/g; #LATIN SMALL LETTER T WITH RETROFLEX HOOK
	$string =~ s/\xca\x89/u/g; #LATIN SMALL LETTER U BAR
	$string =~ s/\xca\x8a/u/g; #LATIN SMALL LETTER UPSILON
	$string =~ s/\xca\x8b/v/g; #LATIN SMALL LETTER V WITH HOOK
	$string =~ s/\xca\x8c/v/g; #LATIN SMALL LETTER TURNED V
	$string =~ s/\xca\x8d/w/g; #LATIN SMALL LETTER TURNED W
	$string =~ s/\xca\x8e/y/g; #LATIN SMALL LETTER TURNED Y
	$string =~ s/\xca\x8f/Y/g; #LATIN LETTER SMALL CAPITAL Y
	$string =~ s/\xca\x90/z/g; #LATIN SMALL LETTER Z WITH RETROFLEX HOOK
	$string =~ s/\xca\x91/z/g; #LATIN SMALL LETTER Z WITH CURL
	$string =~ s/\xca\x92/z/g; #LATIN SMALL LETTER EZH
	$string =~ s/\xca\x93/z/g; #LATIN SMALL LETTER EZH WITH CURL
	$string =~ s/\xca\x94//g; #LATIN LETTER GLOTTAL STOP
	$string =~ s/\xca\x95//g; #LATIN LETTER PHARYNGEAL VOICED FRICATIVE
	$string =~ s/\xca\x96//g; #LATIN LETTER INVERTED GLOTTAL STOP
	$string =~ s/\xca\x97/C/g; #LATIN LETTER STRETCHED C
	$string =~ s/\xca\x98//g; #LATIN LETTER BILABIAL CLICK
	$string =~ s/\xca\x99/B/g; #LATIN LETTER SMALL CAPITAL B
	$string =~ s/\xca\x9a/e/g; #LATIN SMALL LETTER CLOSED OPEN E
	$string =~ s/\xca\x9b/G/g; #LATIN LETTER SMALL CAPITAL G WITH HOOK
	$string =~ s/\xca\x9c/H/g; #LATIN LETTER SMALL CAPITAL H
	$string =~ s/\xca\x9d/j/g; #LATIN SMALL LETTER J WITH CROSSED-TAIL
	$string =~ s/\xca\x9e/k/g; #LATIN SMALL LETTER TURNED K
	$string =~ s/\xca\x9f/L/g; #LATIN LETTER SMALL CAPITAL L
	$string =~ s/\xca\xa0/q/g; #LATIN SMALL LETTER Q WITH HOOK
	$string =~ s/\xca\xa1//g; #LATIN LETTER GLOTTAL STOP WITH STROKE
	$string =~ s/\xca\xa2//g; #LATIN LETTER REVERSED GLOTTAL STOP WITH STROKE
	$string =~ s/\xca\xa3/dz/g; #LATIN SMALL LETTER DZ DIGRAPH
	$string =~ s/\xca\xa4/dz/g; #LATIN SMALL LETTER DEZH DIGRAPH
	$string =~ s/\xca\xa5/dz/g; #LATIN SMALL LETTER DZ DIGRAPH WITH CURL
	$string =~ s/\xca\xa6/ts/g; #LATIN SMALL LETTER TS DIGRAPH
	$string =~ s/\xca\xa7/ts/g; #LATIN SMALL LETTER TESH DIGRAPH
	$string =~ s/\xca\xa8/tc/g; #LATIN SMALL LETTER TC DIGRAPH WITH CURL
	$string =~ s/\xca\xa9/fn/g; #LATIN SMALL LETTER FENG DIGRAPH
	$string =~ s/\xca\xaa/ls/g; #LATIN SMALL LETTER LS DIGRAPH
	$string =~ s/\xca\xab/lz/g; #LATIN SMALL LETTER LZ DIGRAPH
	$string =~ s/\xca\xac//g; #LATIN LETTER BILABIAL PERCUSSIVE
	$string =~ s/\xca\xad//g; #LATIN LETTER BIDENTAL PERCUSSIVE
	$string =~ s/\xca\xae/h/g; #LATIN SMALL LETTER TURNED H WITH FISHHOOK
	$string =~ s/\xca\xaf/h/g; #LATIN SMALL LETTER TURNED H WITH FISHHOOK AND TAIL
	$string =~ s/\xca\xb0/h/g; #MODIFIER LETTER SMALL H
	$string =~ s/\xca\xb1/h/g; #MODIFIER LETTER SMALL H WITH HOOK
	$string =~ s/\xca\xb2/j/g; #MODIFIER LETTER SMALL J
	$string =~ s/\xca\xb3/r/g; #MODIFIER LETTER SMALL R
	$string =~ s/\xca\xb4/r/g; #MODIFIER LETTER SMALL TURNED R
	$string =~ s/\xca\xb5/r/g; #MODIFIER LETTER SMALL TURNED R WITH HOOK
	$string =~ s/\xca\xb6/R/g; #MODIFIER LETTER SMALL CAPITAL INVERTED R
	$string =~ s/\xca\xb7/w/g; #MODIFIER LETTER SMALL W
	$string =~ s/\xca\xb8/y/g; #MODIFIER LETTER SMALL Y
	$string =~ s/\xca\xb9/_/g; #MODIFIER LETTER PRIME
	$string =~ s/\xca\xba/_/g; #MODIFIER LETTER DOUBLE PRIME
	$string =~ s/\xca\xbb/_/g; #MODIFIER LETTER TURNED COMMA
	$string =~ s/\xca\xbc/_/g; #MODIFIER LETTER APOSTROPHE
	$string =~ s/\xca\xbd/_/g; #MODIFIER LETTER REVERSED COMMA
	$string =~ s/\xca\xbe/_/g; #MODIFIER LETTER RIGHT HALF RING
	$string =~ s/\xca\xbf/_/g; #MODIFIER LETTER LEFT HALF RING
	$string =~ s/\xcb\x80/_/g; #MODIFIER LETTER GLOTTAL STOP
	$string =~ s/\xcb\x81/_/g; #MODIFIER LETTER REVERSED GLOTTAL STOP
	$string =~ s/\xcb\x82/_/g; #MODIFIER LETTER LEFT ARROWHEAD
	$string =~ s/\xcb\x83/_/g; #MODIFIER LETTER RIGHT ARROWHEAD
	$string =~ s/\xcb\x84/_/g; #MODIFIER LETTER UP ARROWHEAD
	$string =~ s/\xcb\x85/_/g; #MODIFIER LETTER DOWN ARROWHEAD
	$string =~ s/\xcb\x86/_/g; #MODIFIER LETTER CIRCUMFLEX ACCENT
	$string =~ s/\xcb\x87/_/g; #CARON
	$string =~ s/\xcb\x88/_/g; #MODIFIER LETTER VERTICAL LINE
	$string =~ s/\xcb\x89/_/g; #MODIFIER LETTER MACRON
	$string =~ s/\xcb\x8a/_/g; #MODIFIER LETTER ACUTE ACCENT
	$string =~ s/\xcb\x8b/_/g; #MODIFIER LETTER GRAVE ACCENT
	$string =~ s/\xcb\x8c/_/g; #MODIFIER LETTER LOW VERTICAL LINE
	$string =~ s/\xcb\x8d/_/g; #MODIFIER LETTER LOW MACRON
	$string =~ s/\xcb\x8e/_/g; #MODIFIER LETTER LOW GRAVE ACCENT
	$string =~ s/\xcb\x8f/_/g; #MODIFIER LETTER LOW ACUTE ACCENT
	$string =~ s/\xcb\x90/_/g; #MODIFIER LETTER TRIANGULAR COLON
	$string =~ s/\xcb\x91/_/g; #MODIFIER LETTER HALF TRIANGULAR COLON
	$string =~ s/\xcb\x92/_/g; #MODIFIER LETTER CENTRED RIGHT HALF RING
	$string =~ s/\xcb\x93/_/g; #MODIFIER LETTER CENTRED LEFT HALF RING
	$string =~ s/\xcb\x94/_/g; #MODIFIER LETTER UP TACK
	$string =~ s/\xcb\x95/_/g; #MODIFIER LETTER DOWN TACK
	$string =~ s/\xcb\x96/_/g; #MODIFIER LETTER PLUS SIGN
	$string =~ s/\xcb\x97/_/g; #MODIFIER LETTER MINUS SIGN
	$string =~ s/\xcb\x98/_/g; #BREVE
	$string =~ s/\xcb\x99/_/g; #DOT ABOVE
	$string =~ s/\xcb\x9a/_/g; #RING ABOVE
	$string =~ s/\xcb\x9b/_/g; #OGONEK
	$string =~ s/\xcb\x9c/_/g; #SMALL TILDE
	$string =~ s/\xcb\x9d/_/g; #DOUBLE ACUTE ACCENT
	$string =~ s/\xcb\x9e/_/g; #MODIFIER LETTER RHOTIC HOOK
	$string =~ s/\xcb\x9f/_/g; #MODIFIER LETTER CROSS ACCENT
	$string =~ s/\xcb\xa0/y/g; #MODIFIER LETTER SMALL GAMMA
	$string =~ s/\xcb\xa1/l/g; #MODIFIER LETTER SMALL L
	$string =~ s/\xcb\xa2/s/g; #MODIFIER LETTER SMALL S
	$string =~ s/\xcb\xa3/x/g; #MODIFIER LETTER SMALL X
	$string =~ s/\xcb\xa4/_/g; #MODIFIER LETTER SMALL REVERSED GLOTTAL STOP
	$string =~ s/\xcb\xa5/_/g; #MODIFIER LETTER EXTRA-HIGH TONE BAR
	$string =~ s/\xcb\xa6/_/g; #MODIFIER LETTER HIGH TONE BAR
	$string =~ s/\xcb\xa7/_/g; #MODIFIER LETTER MID TONE BAR
	$string =~ s/\xcb\xa8/_/g; #MODIFIER LETTER LOW TONE BAR
	$string =~ s/\xcb\xa9/_/g; #MODIFIER LETTER EXTRA-LOW TONE BAR
	$string =~ s/\xcb\xaa/_/g; #MODIFIER LETTER YIN DEPARTING TONE MARK
	$string =~ s/\xcb\xab/_/g; #MODIFIER LETTER YANG DEPARTING TONE MARK
	$string =~ s/\xcb\xac/_/g; #MODIFIER LETTER VOICING
	$string =~ s/\xcb\xad/_/g; #MODIFIER LETTER UNASPIRATED
	$string =~ s/\xcb\xae/_/g; #MODIFIER LETTER DOUBLE APOSTROPHE
	$string =~ s/\xcb\xaf/_/g; #MODIFIER LETTER LOW DOWN ARROWHEAD
	$string =~ s/\xcb\xb0/_/g; #MODIFIER LETTER LOW UP ARROWHEAD
	$string =~ s/\xcb\xb1/_/g; #MODIFIER LETTER LOW LEFT ARROWHEAD
	$string =~ s/\xcb\xb2/_/g; #MODIFIER LETTER LOW RIGHT ARROWHEAD
	$string =~ s/\xcb\xb3/_/g; #MODIFIER LETTER LOW RING
	$string =~ s/\xcb\xb4/_/g; #MODIFIER LETTER MIDDLE GRAVE ACCENT
	$string =~ s/\xcb\xb5/_/g; #MODIFIER LETTER MIDDLE DOUBLE GRAVE ACCENT
	$string =~ s/\xcb\xb6/_/g; #MODIFIER LETTER MIDDLE DOUBLE ACUTE ACCENT
	$string =~ s/\xcb\xb7/_/g; #MODIFIER LETTER LOW TILDE
	$string =~ s/\xcb\xb8/_/g; #MODIFIER LETTER RAISED COLON
	$string =~ s/\xcb\xb9/_/g; #MODIFIER LETTER BEGIN HIGH TONE
	$string =~ s/\xcb\xba/_/g; #MODIFIER LETTER END HIGH TONE
	$string =~ s/\xcb\xbb/_/g; #MODIFIER LETTER BEGIN LOW TONE
	$string =~ s/\xcb\xbc/_/g; #MODIFIER LETTER END LOW TONE
	$string =~ s/\xcb\xbd/_/g; #MODIFIER LETTER SHELF
	$string =~ s/\xcb\xbe/_/g; #MODIFIER LETTER OPEN SHELF
	$string =~ s/\xcb\xbf/_/g; #MODIFIER LETTER LOW LEFT ARROW
    if ($debug) { print (stderr "utf8toascii   string-out: '$string'\n"); };
    return $string; 
}

sub cyrtoascii {
    # UTF8 Cyrillic to ascii.
    my $string = $_[0];
    if ($debug) { print (stderr "cyrtoascii string-in : '$string'\n"); };
	$string =~ s/xd0x80/Ie/g; # CYRILLIC CAPITAL LETTER IE WITH GRAVE
	$string =~ s/xd0x81/Io/g; # CYRILLIC CAPITAL LETTER IO
	$string =~ s/xd0x82/Dje/g; # CYRILLIC CAPITAL LETTER DJE
	$string =~ s/xd0x83/Gje/g; # CYRILLIC CAPITAL LETTER GJE
	$string =~ s/xd0x84/Ie/g; # CYRILLIC CAPITAL LETTER UKRAINIAN IE
	$string =~ s/xd0x85/Dze/g; # CYRILLIC CAPITAL LETTER DZE
	$string =~ s/xd0x86/I/g; # CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I
	$string =~ s/xd0x87/Yi/g; # CYRILLIC CAPITAL LETTER YI
	$string =~ s/xd0x88/Je/g; # CYRILLIC CAPITAL LETTER JE
	$string =~ s/xd0x89/Lje/g; # CYRILLIC CAPITAL LETTER LJE
	$string =~ s/xd0x8a/Nje/g; # CYRILLIC CAPITAL LETTER NJE
	$string =~ s/xd0x8b/Tshe/g; # CYRILLIC CAPITAL LETTER TSHE
	$string =~ s/xd0x8c/Kje/g; # CYRILLIC CAPITAL LETTER KJE
	$string =~ s/xd0x8d/I/g; # CYRILLIC CAPITAL LETTER I WITH GRAVE
	$string =~ s/xd0x8e/U/g; # CYRILLIC CAPITAL LETTER SHORT U
	$string =~ s/xd0x8f/Dzhe/g; # CYRILLIC CAPITAL LETTER DZHE
	$string =~ s/xd0x90/A/g; # CYRILLIC CAPITAL LETTER A
	$string =~ s/xd0x91/B/g; # CYRILLIC CAPITAL LETTER BE
	$string =~ s/xd0x92/V/g; # CYRILLIC CAPITAL LETTER VE
	$string =~ s/xd0x93/G/g; # CYRILLIC CAPITAL LETTER GHE
	$string =~ s/xd0x94/D/g; # CYRILLIC CAPITAL LETTER DE
	$string =~ s/xd0x95/Ie/g; # CYRILLIC CAPITAL LETTER IE
	$string =~ s/xd0x96/C/g; # CYRILLIC CAPITAL LETTER ZHE
	$string =~ s/xd0x97/Z/g; # CYRILLIC CAPITAL LETTER ZE
	$string =~ s/xd0x98/I/g; # CYRILLIC CAPITAL LETTER I
	$string =~ s/xd0x99/I/g; # CYRILLIC CAPITAL LETTER SHORT I
	$string =~ s/xd0x9a/K/g; # CYRILLIC CAPITAL LETTER KA
	$string =~ s/xd0x9b/L/g; # CYRILLIC CAPITAL LETTER EL
	$string =~ s/xd0x9c/M/g; # CYRILLIC CAPITAL LETTER EM
	$string =~ s/xd0x9d/N/g; # CYRILLIC CAPITAL LETTER EN
	$string =~ s/xd0x9e/O/g; # CYRILLIC CAPITAL LETTER O
	$string =~ s/xd0x9f/P/g; # CYRILLIC CAPITAL LETTER PE
	$string =~ s/xd0xa0/R/g; # CYRILLIC CAPITAL LETTER ER
	$string =~ s/xd0xa1/S/g; # CYRILLIC CAPITAL LETTER ES
	$string =~ s/xd0xa2/T/g; # CYRILLIC CAPITAL LETTER TE
	$string =~ s/xd0xa3/U/g; # CYRILLIC CAPITAL LETTER U
	$string =~ s/xd0xa4/F/g; # CYRILLIC CAPITAL LETTER EF
	$string =~ s/xd0xa5/H/g; # CYRILLIC CAPITAL LETTER HA
	$string =~ s/xd0xa6/C/g; # CYRILLIC CAPITAL LETTER TSE
	$string =~ s/xd0xa7/Ch/g; # CYRILLIC CAPITAL LETTER CHE
	$string =~ s/xd0xa8/Sh/g; # CYRILLIC CAPITAL LETTER SHA
	$string =~ s/xd0xa9/Shch/g; # CYRILLIC CAPITAL LETTER SHCHA
	$string =~ s/xd0xaa//g; # CYRILLIC CAPITAL LETTER HARD SIGN
	$string =~ s/xd0xab//g; # CYRILLIC CAPITAL LETTER YERU
	$string =~ s/xd0xac//g; # CYRILLIC CAPITAL LETTER SOFT SIGN
	$string =~ s/xd0xad/E/g; # CYRILLIC CAPITAL LETTER E
	$string =~ s/xd0xae/Yu/g; # CYRILLIC CAPITAL LETTER YU
	$string =~ s/xd0xaf/Ya/g; # CYRILLIC CAPITAL LETTER YA
	$string =~ s/xd0xb0/a/g; # CYRILLIC SMALL LETTER A
	$string =~ s/xd0xb1/b/g; # CYRILLIC SMALL LETTER BE
	$string =~ s/xd0xb2/v/g; # CYRILLIC SMALL LETTER VE
	$string =~ s/xd0xb3/g/g; # CYRILLIC SMALL LETTER GHE
	$string =~ s/xd0xb4/d/g; # CYRILLIC SMALL LETTER DE
	$string =~ s/xd0xb5/ie/g; # CYRILLIC SMALL LETTER IE
	$string =~ s/xd0xb6/c/g; # CYRILLIC SMALL LETTER ZHE
	$string =~ s/xd0xb7/z/g; # CYRILLIC SMALL LETTER ZE
	$string =~ s/xd0xb8/i/g; # CYRILLIC SMALL LETTER I
	$string =~ s/xd0xb9/i/g; # CYRILLIC SMALL LETTER SHORT I
	$string =~ s/xd0xba/k/g; # CYRILLIC SMALL LETTER KA
	$string =~ s/xd0xbb/l/g; # CYRILLIC SMALL LETTER EL
	$string =~ s/xd0xbc/m/g; # CYRILLIC SMALL LETTER EM
	$string =~ s/xd0xbd/n/g; # CYRILLIC SMALL LETTER EN
	$string =~ s/xd0xbe/o/g; # CYRILLIC SMALL LETTER O
	$string =~ s/xd0xbf/p/g; # CYRILLIC SMALL LETTER PE
	$string =~ s/xd1x80/r/g; # CYRILLIC SMALL LETTER ER
	$string =~ s/xd1x81/s/g; # CYRILLIC SMALL LETTER ES
	$string =~ s/xd1x82/t/g; # CYRILLIC SMALL LETTER TE
	$string =~ s/xd1x83/u/g; # CYRILLIC SMALL LETTER U
	$string =~ s/xd1x84/f/g; # CYRILLIC SMALL LETTER EF
	$string =~ s/xd1x85/h/g; # CYRILLIC SMALL LETTER HA
	$string =~ s/xd1x86/c/g; # CYRILLIC SMALL LETTER TSE
	$string =~ s/xd1x87/ch/g; # CYRILLIC SMALL LETTER CHE
	$string =~ s/xd1x88/sh/g; # CYRILLIC SMALL LETTER SHA
	$string =~ s/xd1x89/shch/g; # CYRILLIC SMALL LETTER SHCHA
	$string =~ s/xd1x8a//g; # CYRILLIC SMALL LETTER HARD SIGN
	$string =~ s/xd1x8b//g; # CYRILLIC SMALL LETTER YERU
	$string =~ s/xd1x8c//g; # CYRILLIC SMALL LETTER SOFT SIGN
	$string =~ s/xd1x8d/e/g; # CYRILLIC SMALL LETTER E
	$string =~ s/xd1x8e/yu/g; # CYRILLIC SMALL LETTER YU
	$string =~ s/xd1x8f/ya/g; # CYRILLIC SMALL LETTER YA
	$string =~ s/xd1x90/ie/g; # CYRILLIC SMALL LETTER IE WITH GRAVE
	$string =~ s/xd1x91/io/g; # CYRILLIC SMALL LETTER IO
	$string =~ s/xd1x92/dje/g; # CYRILLIC SMALL LETTER DJE
	$string =~ s/xd1x93/gje/g; # CYRILLIC SMALL LETTER GJE
	$string =~ s/xd1x94/ie/g; # CYRILLIC SMALL LETTER UKRAINIAN IE
	$string =~ s/xd1x95/dze/g; # CYRILLIC SMALL LETTER DZE
	$string =~ s/xd1x96/i/g; # CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I
	$string =~ s/xd1x97/yi/g; # CYRILLIC SMALL LETTER YI
	$string =~ s/xd1x98/je/g; # CYRILLIC SMALL LETTER JE
	$string =~ s/xd1x99/lje/g; # CYRILLIC SMALL LETTER LJE
	$string =~ s/xd1x9a/nje/g; # CYRILLIC SMALL LETTER NJE
	$string =~ s/xd1x9b/tshe/g; # CYRILLIC SMALL LETTER TSHE
	$string =~ s/xd1x9c/kje/g; # CYRILLIC SMALL LETTER KJE
	$string =~ s/xd1x9d/i/g; # CYRILLIC SMALL LETTER I WITH GRAVE
	$string =~ s/xd1x9e/u/g; # CYRILLIC SMALL LETTER SHORT U
	$string =~ s/xd1x9f/dzhe/g; # CYRILLIC SMALL LETTER DZHE
	$string =~ s/xd1xa0/_/g; # CYRILLIC CAPITAL LETTER OMEGA
	$string =~ s/xd1xa1/_/g; # CYRILLIC SMALL LETTER OMEGA
	$string =~ s/xd1xa2/_/g; # CYRILLIC CAPITAL LETTER YAT
	$string =~ s/xd1xa3/_/g; # CYRILLIC SMALL LETTER YAT
	$string =~ s/xd1xa4/_/g; # CYRILLIC CAPITAL LETTER IOTIFIED E
	$string =~ s/xd1xa5/_/g; # CYRILLIC SMALL LETTER IOTIFIED E
	$string =~ s/xd1xa6/_/g; # CYRILLIC CAPITAL LETTER LITTLE YUS
	$string =~ s/xd1xa7/_/g; # CYRILLIC SMALL LETTER LITTLE YUS
	$string =~ s/xd1xa8/_/g; # CYRILLIC CAPITAL LETTER IOTIFIED LITTLE YUS
	$string =~ s/xd1xa9/_/g; # CYRILLIC SMALL LETTER IOTIFIED LITTLE YUS
	$string =~ s/xd1xaa/_/g; # CYRILLIC CAPITAL LETTER BIG YUS
	$string =~ s/xd1xab/_/g; # CYRILLIC SMALL LETTER BIG YUS
	$string =~ s/xd1xac/_/g; # CYRILLIC CAPITAL LETTER IOTIFIED BIG YUS
	$string =~ s/xd1xad/_/g; # CYRILLIC SMALL LETTER IOTIFIED BIG YUS
	$string =~ s/xd1xae/_/g; # CYRILLIC CAPITAL LETTER KSI
	$string =~ s/xd1xaf/_/g; # CYRILLIC SMALL LETTER KSI
	$string =~ s/xd1xb0/_/g; # CYRILLIC CAPITAL LETTER PSI
	$string =~ s/xd1xb1/_/g; # CYRILLIC SMALL LETTER PSI
	$string =~ s/xd1xb2/_/g; # CYRILLIC CAPITAL LETTER FITA
	$string =~ s/xd1xb3/_/g; # CYRILLIC SMALL LETTER FITA
	$string =~ s/xd1xb4/_/g; # CYRILLIC CAPITAL LETTER IZHITSA
	$string =~ s/xd1xb5/_/g; # CYRILLIC SMALL LETTER IZHITSA
	$string =~ s/xd1xb6/_/g; # CYRILLIC CAPITAL LETTER IZHITSA WITH DOUBLE GRAVE ACCENT
	$string =~ s/xd1xb7/_/g; # CYRILLIC SMALL LETTER IZHITSA WITH DOUBLE GRAVE ACCENT
	$string =~ s/xd1xb8/_/g; # CYRILLIC CAPITAL LETTER UK
	$string =~ s/xd1xb9/_/g; # CYRILLIC SMALL LETTER UK
	$string =~ s/xd1xba/_/g; # CYRILLIC CAPITAL LETTER ROUND OMEGA
	$string =~ s/xd1xbb/_/g; # CYRILLIC SMALL LETTER ROUND OMEGA
	$string =~ s/xd1xbc/_/g; # CYRILLIC CAPITAL LETTER OMEGA WITH TITLO
	$string =~ s/xd1xbd/_/g; # CYRILLIC SMALL LETTER OMEGA WITH TITLO
	$string =~ s/xd1xbe/_/g; # CYRILLIC CAPITAL LETTER OT
	$string =~ s/xd1xbf/_/g; # CYRILLIC SMALL LETTER OT
	$string =~ s/xd2x80/_/g; # CYRILLIC CAPITAL LETTER KOPPA
	$string =~ s/xd2x81/_/g; # CYRILLIC SMALL LETTER KOPPA
	$string =~ s/xd2x82/_/g; # CYRILLIC THOUSANDS SIGN
	$string =~ s/xd2x83/_/g; # COMBINING CYRILLIC TITLO
	$string =~ s/xd2x84/_/g; # COMBINING CYRILLIC PALATALIZATION
	$string =~ s/xd2x85/_/g; # COMBINING CYRILLIC DASIA PNEUMATA
	$string =~ s/xd2x86/_/g; # COMBINING CYRILLIC PSILI PNEUMATA
	$string =~ s/xd2x87/_/g; # COMBINING CYRILLIC POKRYTIE
	$string =~ s/xd2x88/_/g; # COMBINING CYRILLIC HUNDRED THOUSANDS SIGN
	$string =~ s/xd2x89/_/g; # COMBINING CYRILLIC MILLIONS SIGN
	$string =~ s/xd2x8a/_/g; # CYRILLIC CAPITAL LETTER SHORT I WITH TAIL
	$string =~ s/xd2x8b/_/g; # CYRILLIC SMALL LETTER SHORT I WITH TAIL
	$string =~ s/xd2x8c/_/g; # CYRILLIC CAPITAL LETTER SEMISOFT SIGN
	$string =~ s/xd2x8d/_/g; # CYRILLIC SMALL LETTER SEMISOFT SIGN
	$string =~ s/xd2x8e/_/g; # CYRILLIC CAPITAL LETTER ER WITH TICK
	$string =~ s/xd2x8f/_/g; # CYRILLIC SMALL LETTER ER WITH TICK
	$string =~ s/xd2x90/_/g; # CYRILLIC CAPITAL LETTER GHE WITH UPTURN
	$string =~ s/xd2x91/_/g; # CYRILLIC SMALL LETTER GHE WITH UPTURN
	$string =~ s/xd2x92/_/g; # CYRILLIC CAPITAL LETTER GHE WITH STROKE
	$string =~ s/xd2x93/_/g; # CYRILLIC SMALL LETTER GHE WITH STROKE
	$string =~ s/xd2x94/_/g; # CYRILLIC CAPITAL LETTER GHE WITH MIDDLE HOOK
	$string =~ s/xd2x95/_/g; # CYRILLIC SMALL LETTER GHE WITH MIDDLE HOOK
	$string =~ s/xd2x96/_/g; # CYRILLIC CAPITAL LETTER ZHE WITH DESCENDER
	$string =~ s/xd2x97/_/g; # CYRILLIC SMALL LETTER ZHE WITH DESCENDER
	$string =~ s/xd2x98/_/g; # CYRILLIC CAPITAL LETTER ZE WITH DESCENDER
	$string =~ s/xd2x99/_/g; # CYRILLIC SMALL LETTER ZE WITH DESCENDER
	$string =~ s/xd2x9a/_/g; # CYRILLIC CAPITAL LETTER KA WITH DESCENDER
	$string =~ s/xd2x9b/_/g; # CYRILLIC SMALL LETTER KA WITH DESCENDER
	$string =~ s/xd2x9c/_/g; # CYRILLIC CAPITAL LETTER KA WITH VERTICAL STROKE
	$string =~ s/xd2x9d/_/g; # CYRILLIC SMALL LETTER KA WITH VERTICAL STROKE
	$string =~ s/xd2x9e/_/g; # CYRILLIC CAPITAL LETTER KA WITH STROKE
	$string =~ s/xd2x9f/_/g; # CYRILLIC SMALL LETTER KA WITH STROKE
	$string =~ s/xd2xa0/_/g; # CYRILLIC CAPITAL LETTER BASHKIR KA
	$string =~ s/xd2xa1/_/g; # CYRILLIC SMALL LETTER BASHKIR KA
	$string =~ s/xd2xa2/_/g; # CYRILLIC CAPITAL LETTER EN WITH DESCENDER
	$string =~ s/xd2xa3/_/g; # CYRILLIC SMALL LETTER EN WITH DESCENDER
	$string =~ s/xd2xa4/_/g; # CYRILLIC CAPITAL LIGATURE EN GHE
	$string =~ s/xd2xa5/_/g; # CYRILLIC SMALL LIGATURE EN GHE
	$string =~ s/xd2xa6/_/g; # CYRILLIC CAPITAL LETTER PE WITH MIDDLE HOOK
	$string =~ s/xd2xa7/_/g; # CYRILLIC SMALL LETTER PE WITH MIDDLE HOOK
	$string =~ s/xd2xa8/_/g; # CYRILLIC CAPITAL LETTER ABKHASIAN HA
	$string =~ s/xd2xa9/_/g; # CYRILLIC SMALL LETTER ABKHASIAN HA
	$string =~ s/xd2xaa/_/g; # CYRILLIC CAPITAL LETTER ES WITH DESCENDER
	$string =~ s/xd2xab/_/g; # CYRILLIC SMALL LETTER ES WITH DESCENDER
	$string =~ s/xd2xac/_/g; # CYRILLIC CAPITAL LETTER TE WITH DESCENDER
	$string =~ s/xd2xad/_/g; # CYRILLIC SMALL LETTER TE WITH DESCENDER
	$string =~ s/xd2xae/_/g; # CYRILLIC CAPITAL LETTER STRAIGHT U
	$string =~ s/xd2xaf/_/g; # CYRILLIC SMALL LETTER STRAIGHT U
	$string =~ s/xd2xb0/_/g; # CYRILLIC CAPITAL LETTER STRAIGHT U WITH STROKE
	$string =~ s/xd2xb1/_/g; # CYRILLIC SMALL LETTER STRAIGHT U WITH STROKE
	$string =~ s/xd2xb2/_/g; # CYRILLIC CAPITAL LETTER HA WITH DESCENDER
	$string =~ s/xd2xb3/_/g; # CYRILLIC SMALL LETTER HA WITH DESCENDER
	$string =~ s/xd2xb4/_/g; # CYRILLIC CAPITAL LIGATURE TE TSE
	$string =~ s/xd2xb5/_/g; # CYRILLIC SMALL LIGATURE TE TSE
	$string =~ s/xd2xb6/_/g; # CYRILLIC CAPITAL LETTER CHE WITH DESCENDER
	$string =~ s/xd2xb7/_/g; # CYRILLIC SMALL LETTER CHE WITH DESCENDER
	$string =~ s/xd2xb8/_/g; # CYRILLIC CAPITAL LETTER CHE WITH VERTICAL STROKE
	$string =~ s/xd2xb9/_/g; # CYRILLIC SMALL LETTER CHE WITH VERTICAL STROKE
	$string =~ s/xd2xba/_/g; # CYRILLIC CAPITAL LETTER SHHA
	$string =~ s/xd2xbb/_/g; # CYRILLIC SMALL LETTER SHHA
	$string =~ s/xd2xbc/_/g; # CYRILLIC CAPITAL LETTER ABKHASIAN CHE
	$string =~ s/xd2xbd/_/g; # CYRILLIC SMALL LETTER ABKHASIAN CHE
	$string =~ s/xd2xbe/_/g; # CYRILLIC CAPITAL LETTER ABKHASIAN CHE WITH DESCENDER
	$string =~ s/xd2xbf/_/g; # CYRILLIC SMALL LETTER ABKHASIAN CHE WITH DESCENDER
	$string =~ s/xd3x80/_/g; # CYRILLIC LETTER PALOCHKA
	$string =~ s/xd3x81/_/g; # CYRILLIC CAPITAL LETTER ZHE WITH BREVE
	$string =~ s/xd3x82/_/g; # CYRILLIC SMALL LETTER ZHE WITH BREVE
	$string =~ s/xd3x83/_/g; # CYRILLIC CAPITAL LETTER KA WITH HOOK
	$string =~ s/xd3x84/_/g; # CYRILLIC SMALL LETTER KA WITH HOOK
	$string =~ s/xd3x85/_/g; # CYRILLIC CAPITAL LETTER EL WITH TAIL
	$string =~ s/xd3x86/_/g; # CYRILLIC SMALL LETTER EL WITH TAIL
	$string =~ s/xd3x87/_/g; # CYRILLIC CAPITAL LETTER EN WITH HOOK
	$string =~ s/xd3x88/_/g; # CYRILLIC SMALL LETTER EN WITH HOOK
	$string =~ s/xd3x89/_/g; # CYRILLIC CAPITAL LETTER EN WITH TAIL
	$string =~ s/xd3x8a/_/g; # CYRILLIC SMALL LETTER EN WITH TAIL
	$string =~ s/xd3x8b/_/g; # CYRILLIC CAPITAL LETTER KHAKASSIAN CHE
	$string =~ s/xd3x8c/_/g; # CYRILLIC SMALL LETTER KHAKASSIAN CHE
	$string =~ s/xd3x8d/_/g; # CYRILLIC CAPITAL LETTER EM WITH TAIL
	$string =~ s/xd3x8e/_/g; # CYRILLIC SMALL LETTER EM WITH TAIL
	$string =~ s/xd3x8f/_/g; # CYRILLIC SMALL LETTER PALOCHKA
	$string =~ s/xd3x90/_/g; # CYRILLIC CAPITAL LETTER A WITH BREVE
	$string =~ s/xd3x91/_/g; # CYRILLIC SMALL LETTER A WITH BREVE
	$string =~ s/xd3x92/_/g; # CYRILLIC CAPITAL LETTER A WITH DIAERESIS
	$string =~ s/xd3x93/_/g; # CYRILLIC SMALL LETTER A WITH DIAERESIS
	$string =~ s/xd3x94/_/g; # CYRILLIC CAPITAL LIGATURE A IE
	$string =~ s/xd3x95/_/g; # CYRILLIC SMALL LIGATURE A IE
	$string =~ s/xd3x96/_/g; # CYRILLIC CAPITAL LETTER IE WITH BREVE
	$string =~ s/xd3x97/_/g; # CYRILLIC SMALL LETTER IE WITH BREVE
	$string =~ s/xd3x98/_/g; # CYRILLIC CAPITAL LETTER SCHWA
	$string =~ s/xd3x99/_/g; # CYRILLIC SMALL LETTER SCHWA
	$string =~ s/xd3x9a/_/g; # CYRILLIC CAPITAL LETTER SCHWA WITH DIAERESIS
	$string =~ s/xd3x9b/_/g; # CYRILLIC SMALL LETTER SCHWA WITH DIAERESIS
	$string =~ s/xd3x9c/_/g; # CYRILLIC CAPITAL LETTER ZHE WITH DIAERESIS
	$string =~ s/xd3x9d/_/g; # CYRILLIC SMALL LETTER ZHE WITH DIAERESIS
	$string =~ s/xd3x9e/_/g; # CYRILLIC CAPITAL LETTER ZE WITH DIAERESIS
	$string =~ s/xd3x9f/_/g; # CYRILLIC SMALL LETTER ZE WITH DIAERESIS
	$string =~ s/xd3xa0/_/g; # CYRILLIC CAPITAL LETTER ABKHASIAN DZE
	$string =~ s/xd3xa1/_/g; # CYRILLIC SMALL LETTER ABKHASIAN DZE
	$string =~ s/xd3xa2/_/g; # CYRILLIC CAPITAL LETTER I WITH MACRON
	$string =~ s/xd3xa3/_/g; # CYRILLIC SMALL LETTER I WITH MACRON
	$string =~ s/xd3xa4/_/g; # CYRILLIC CAPITAL LETTER I WITH DIAERESIS
	$string =~ s/xd3xa5/_/g; # CYRILLIC SMALL LETTER I WITH DIAERESIS
	$string =~ s/xd3xa6/_/g; # CYRILLIC CAPITAL LETTER O WITH DIAERESIS
	$string =~ s/xd3xa7/_/g; # CYRILLIC SMALL LETTER O WITH DIAERESIS
	$string =~ s/xd3xa8/_/g; # CYRILLIC CAPITAL LETTER BARRED O
	$string =~ s/xd3xa9/_/g; # CYRILLIC SMALL LETTER BARRED O
	$string =~ s/xd3xaa/_/g; # CYRILLIC CAPITAL LETTER BARRED O WITH DIAERESIS
	$string =~ s/xd3xab/_/g; # CYRILLIC SMALL LETTER BARRED O WITH DIAERESIS
	$string =~ s/xd3xac/_/g; # CYRILLIC CAPITAL LETTER E WITH DIAERESIS
	$string =~ s/xd3xad/_/g; # CYRILLIC SMALL LETTER E WITH DIAERESIS
	$string =~ s/xd3xae/_/g; # CYRILLIC CAPITAL LETTER U WITH MACRON
	$string =~ s/xd3xaf/_/g; # CYRILLIC SMALL LETTER U WITH MACRON
	$string =~ s/xd3xb0/_/g; # CYRILLIC CAPITAL LETTER U WITH DIAERESIS
	$string =~ s/xd3xb1/_/g; # CYRILLIC SMALL LETTER U WITH DIAERESIS
	$string =~ s/xd3xb2/_/g; # CYRILLIC CAPITAL LETTER U WITH DOUBLE ACUTE
	$string =~ s/xd3xb3/_/g; # CYRILLIC SMALL LETTER U WITH DOUBLE ACUTE
	$string =~ s/xd3xb4/_/g; # CYRILLIC CAPITAL LETTER CHE WITH DIAERESIS
	$string =~ s/xd3xb5/_/g; # CYRILLIC SMALL LETTER CHE WITH DIAERESIS
	$string =~ s/xd3xb6/_/g; # CYRILLIC CAPITAL LETTER GHE WITH DESCENDER
	$string =~ s/xd3xb7/_/g; # CYRILLIC SMALL LETTER GHE WITH DESCENDER
	$string =~ s/xd3xb8/_/g; # CYRILLIC CAPITAL LETTER YERU WITH DIAERESIS
	$string =~ s/xd3xb9/_/g; # CYRILLIC SMALL LETTER YERU WITH DIAERESIS
	$string =~ s/xd3xba/_/g; # CYRILLIC CAPITAL LETTER GHE WITH STROKE AND HOOK
	$string =~ s/xd3xbb/_/g; # CYRILLIC SMALL LETTER GHE WITH STROKE AND HOOK
	$string =~ s/xd3xbc/_/g; # CYRILLIC CAPITAL LETTER HA WITH HOOK
	$string =~ s/xd3xbd/_/g; # CYRILLIC SMALL LETTER HA WITH HOOK
	$string =~ s/xd3xbe/_/g; # CYRILLIC CAPITAL LETTER HA WITH STROKE
	$string =~ s/xd3xbf/_/g; # CYRILLIC SMALL LETTER HA WITH STROKE
    if ($debug) { print (stderr "cyrtoascii   string-out: '$string'\n"); };
    return $string; 
}


sub latin1toascii {
    # ISO-8885-1 Latin 1
    # This of course conflicts with other ISO-8859-codes.
    my $string = $_[0];
    if ($debug) { print (stderr "latin1toascii string-in : '$string'\n"); };
	$string =~ s/\xa0/_/g; # NO-BREAK SPACE
	$string =~ s/\xa1/_/g; # INVERTED EXCLAMATION MARK
	$string =~ s/\xa2/_cent_/g; # CENT SIGN
	$string =~ s/\xa3/_pound_/g; # POUND SIGN
	$string =~ s/\xa4/_/g; # CURRENCY SIGN
	$string =~ s/\xa5/_yen_/g; # YEN SIGN
	$string =~ s/\xa6/_/g; # BROKEN BAR
	$string =~ s/\xa7/_/g; # SECTION SIGN
	$string =~ s/\xa8/_/g; # DIAERESIS
	$string =~ s/\xa9/_/g; # COPYRIGHT SIGN
	$string =~ s/\xaa/_/g; # FEMININE ORDINAL INDICATOR
	$string =~ s/\xab/_/g; # LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
	$string =~ s/\xac/_/g; # NOT SIGN
	$string =~ s/\xad/-/g; # SOFT HYPHEN
	$string =~ s/\xae/_/g; # REGISTERED SIGN
	$string =~ s/\xaf/_/g; # MACRON
	$string =~ s/\xb0/_/g; # DEGREE SIGN
	$string =~ s/\xb1/_/g; # PLUS-MINUS SIGN
	$string =~ s/\xb2/2/g; # SUPERSCRIPT TWO
	$string =~ s/\xb3/3/g; # SUPERSCRIPT THREE
	$string =~ s/\xb4/_/g; # ACUTE ACCENT
	$string =~ s/\xb5/_/g; # MICRO SIGN
	$string =~ s/\xb6/_/g; # PILCROW SIGN
	$string =~ s/\xb7/_/g; # MIDDLE DOT
	$string =~ s/\xb8/_/g; # CEDILLA
	$string =~ s/\xb9/1/g; # SUPERSCRIPT ONE
	$string =~ s/\xba/_/g; # MASCULINE ORDINAL INDICATOR
	$string =~ s/\xbb/_/g; # RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
	$string =~ s/\xbc/_/g; # VULGAR FRACTION ONE QUARTER
	$string =~ s/\xbd/_/g; # VULGAR FRACTION ONE HALF
	$string =~ s/\xbe/_/g; # VULGAR FRACTION THREE QUARTERS
	$string =~ s/\xbf/_/g; # INVERTED QUESTION MARK
	$string =~ s/\xc0/A/g; # LATIN CAPITAL LETTER A WITH GRAVE
	$string =~ s/\xc1/A/g; # LATIN CAPITAL LETTER A WITH ACUTE
	$string =~ s/\xc2/A/g; # LATIN CAPITAL LETTER A WITH CIRCUMFLEX
	$string =~ s/\xc3/A/g; # LATIN CAPITAL LETTER A WITH TILDE
	$string =~ s/\xc4/Ae/g; # LATIN CAPITAL LETTER A WITH DIAERESIS
	$string =~ s/\xc5/A/g; # LATIN CAPITAL LETTER A WITH RING ABOVE
	$string =~ s/\xc6/AE/g; # LATIN CAPITAL LETTER AE
	$string =~ s/\xc7/C/g; # LATIN CAPITAL LETTER C WITH CEDILLA
	$string =~ s/\xc8/E/g; # LATIN CAPITAL LETTER E WITH GRAVE
	$string =~ s/\xc9/E/g; # LATIN CAPITAL LETTER E WITH ACUTE
	$string =~ s/\xca/E/g; # LATIN CAPITAL LETTER E WITH CIRCUMFLEX
	$string =~ s/\xcb/E/g; # LATIN CAPITAL LETTER E WITH DIAERESIS
	$string =~ s/\xcc/I/g; # LATIN CAPITAL LETTER I WITH GRAVE
	$string =~ s/\xcd/I/g; # LATIN CAPITAL LETTER I WITH ACUTE
	$string =~ s/\xce/I/g; # LATIN CAPITAL LETTER I WITH CIRCUMFLEX
	$string =~ s/\xcf/I/g; # LATIN CAPITAL LETTER I WITH DIAERESIS
	$string =~ s/\xd0/Eth/g; # LATIN CAPITAL LETTER ETH (Icelandic)
	$string =~ s/\xd1/N/g; # LATIN CAPITAL LETTER N WITH TILDE
	$string =~ s/\xd2/O/g; # LATIN CAPITAL LETTER O WITH GRAVE
	$string =~ s/\xd3/O/g; # LATIN CAPITAL LETTER O WITH ACUTE
	$string =~ s/\xd4/O/g; # LATIN CAPITAL LETTER O WITH CIRCUMFLEX
	$string =~ s/\xd5/O/g; # LATIN CAPITAL LETTER O WITH TILDE
	$string =~ s/\xd6/Oe/g; # LATIN CAPITAL LETTER O WITH DIAERESIS
	$string =~ s/\xd7/x/g; # MULTIPLICATION SIGN
	$string =~ s/\xd8/O/g; # LATIN CAPITAL LETTER O WITH STROKE
	$string =~ s/\xd9/U/g; # LATIN CAPITAL LETTER U WITH GRAVE
	$string =~ s/\xda/U/g; # LATIN CAPITAL LETTER U WITH ACUTE
	$string =~ s/\xdb/U/g; # LATIN CAPITAL LETTER U WITH CIRCUMFLEX
	$string =~ s/\xdc/Ue/g; # LATIN CAPITAL LETTER U WITH DIAERESIS
	$string =~ s/\xdd/Y/g; # LATIN CAPITAL LETTER Y WITH ACUTE
	$string =~ s/\xde/Th/g; # LATIN CAPITAL LETTER THORN (Icelandic)
	$string =~ s/\xdf/ss/g; # LATIN SMALL LETTER SHARP S (German)
	$string =~ s/\xe0/a/g; # LATIN SMALL LETTER A WITH GRAVE
	$string =~ s/\xe1/a/g; # LATIN SMALL LETTER A WITH ACUTE
	$string =~ s/\xe2/a/g; # LATIN SMALL LETTER A WITH CIRCUMFLEX
	$string =~ s/\xe3/a/g; # LATIN SMALL LETTER A WITH TILDE
	$string =~ s/\xe4/ae/g; # LATIN SMALL LETTER A WITH DIAERESIS
	$string =~ s/\xe5/a/g; # LATIN SMALL LETTER A WITH RING ABOVE
	$string =~ s/\xe6/ae/g; # LATIN SMALL LETTER AE
	$string =~ s/\xe7/c/g; # LATIN SMALL LETTER C WITH CEDILLA
	$string =~ s/\xe8/e/g; # LATIN SMALL LETTER E WITH GRAVE
	$string =~ s/\xe9/e/g; # LATIN SMALL LETTER E WITH ACUTE
	$string =~ s/\xea/e/g; # LATIN SMALL LETTER E WITH CIRCUMFLEX
	$string =~ s/\xeb/e/g; # LATIN SMALL LETTER E WITH DIAERESIS
	$string =~ s/\xec/i/g; # LATIN SMALL LETTER I WITH GRAVE
	$string =~ s/\xed/i/g; # LATIN SMALL LETTER I WITH ACUTE
	$string =~ s/\xee/i/g; # LATIN SMALL LETTER I WITH CIRCUMFLEX
	$string =~ s/\xef/i/g; # LATIN SMALL LETTER I WITH DIAERESIS
	$string =~ s/\xf0/eth/g; # LATIN SMALL LETTER ETH (Icelandic)
	$string =~ s/\xf1/n/g; # LATIN SMALL LETTER N WITH TILDE
	$string =~ s/\xf2/o/g; # LATIN SMALL LETTER O WITH GRAVE
	$string =~ s/\xf3/o/g; # LATIN SMALL LETTER O WITH ACUTE
	$string =~ s/\xf4/o/g; # LATIN SMALL LETTER O WITH CIRCUMFLEX
	$string =~ s/\xf5/o/g; # LATIN SMALL LETTER O WITH TILDE
	$string =~ s/\xf6/oe/g; # LATIN SMALL LETTER O WITH DIAERESIS
	$string =~ s/\xf7/_/g; # DIVISION SIGN
	$string =~ s/\xf8/o/g; # LATIN SMALL LETTER O WITH STROKE
	$string =~ s/\xf9/u/g; # LATIN SMALL LETTER U WITH GRAVE
	$string =~ s/\xfa/u/g; # LATIN SMALL LETTER U WITH ACUTE
	$string =~ s/\xfb/u/g; # LATIN SMALL LETTER U WITH CIRCUMFLEX
	$string =~ s/\xfc/ue/g; # LATIN SMALL LETTER U WITH DIAERESIS
	$string =~ s/\xfd/y/g; # LATIN SMALL LETTER Y WITH ACUTE
	$string =~ s/\xfe/th/g; # LATIN SMALL LETTER THORN (Icelandic)
	$string =~ s/\xff/y/g; # LATIN SMALL LETTER Y WITH DIAERESIS
    if ($debug) { print (stderr "latin1toascii string-out: '$string'\n"); };
    return $string; 
}

sub cp1252toascii {
    # CP1252. Should not collide with ISO-8859-1.
    my $string = $_[0];
    if ($debug) { print (stderr "cp1252toascii string-in : '$string'\n"); };
	$string =~ s/\x80/_euro_/g; # EURO SIGN
	$string =~ s/\x81/_/g; # UNDEFINED
	$string =~ s/\x82/_/g; # SINGLE LOW-9 QUOTATION MARK
	$string =~ s/\x83/f/g; # LATIN SMALL LETTER F WITH HOOK
	$string =~ s/\x84/_/g; # DOUBLE LOW-9 QUOTATION MARK
	$string =~ s/\x85/.../g; # HORIZONTAL ELLIPSIS
	$string =~ s/\x86/_/g; # DAGGER
	$string =~ s/\x87/_/g; # DOUBLE DAGGER
	$string =~ s/\x88/^/g; # MODIFIER LETTER CIRCUMFLEX ACCENT
	$string =~ s/\x89/_permille_/g; # PER MILLE SIGN
	$string =~ s/\x8a/S/g; # LATIN CAPITAL LETTER S WITH CARON
	$string =~ s/\x8b/_/g; # SINGLE LEFT-POINTING ANGLE QUOTATION MARK
	$string =~ s/\x8c/OE/g; # LATIN CAPITAL LIGATURE OE
	$string =~ s/\x8d/_/g; # UNDEFINED
	$string =~ s/\x8e/Z/g; # LATIN CAPITAL LETTER Z WITH CARON
	$string =~ s/\x8f/_/g; # UNDEFINED
	$string =~ s/\x90/_/g; # UNDEFINED
	$string =~ s/\x91/_/g; # LEFT SINGLE QUOTATION MARK
	$string =~ s/\x92/_/g; # RIGHT SINGLE QUOTATION MARK
	$string =~ s/\x93/_/g; # LEFT DOUBLE QUOTATION MARK
	$string =~ s/\x94/_/g; # RIGHT DOUBLE QUOTATION MARK
	$string =~ s/\x95/-/g; # BULLET
	$string =~ s/\x96/-/g; # EN DASH
	$string =~ s/\x97/-/g; # EM DASH
	$string =~ s/\x98/_/g; # SMALL TILDE
	$string =~ s/\x99/_tm_/g; # TRADE MARK SIGN
	$string =~ s/\x9a/s/g; # LATIN SMALL LETTER S WITH CARON
	$string =~ s/\x9b/_/g; # SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
	$string =~ s/\x9c/oe/g; # LATIN SMALL LIGATURE OE
	$string =~ s/\x9d/_/g; # UNDEFINED
	$string =~ s/\x9e/z/g; # LATIN SMALL LETTER Z WITH CARON
	$string =~ s/\x9f/Y/g; # LATIN CAPITAL LETTER Y WITH DIAERESIS
    if ($debug) { print (stderr "cp1252toascii string-out: '$string'\n"); };
    return $string; 
}

sub convertspecials {
    # convert ascii special characters to underscore. This is mostly for the shell,
    # since filenames with special characters like ! or & which have special meaning
    # are a nusiance to handle. And / is the only character not allowed in filenames
    # on unix.
    my $string = $_[0];
    if ($debug) { print (stderr "convertspecials string-in : '$string'\n"); };
	$string =~ s/\x20/_/g;	# space
	$string =~ s/\x21/_/g;	# !
	$string =~ s/\x22/_/g;	# "
	$string =~ s/\x23/-/g;	# hash
	$string =~ s/\x24/_/g;	# $
	$string =~ s/\x27/_/g;	# '
	$string =~ s/\x2a/_/g;	# *
	$string =~ s/\x2f/_/g;	# /
	$string =~ s/\x3a/_/g;	# :
	$string =~ s/\x3b/_/g;	# ;
	$string =~ s/\x3c/_/g;	# <
	$string =~ s/\x3e/_/g;	# >
	$string =~ s/\x3f/_/g;	# ?
	$string =~ s/\x40/_/g;	# @
	$string =~ s/\x5c/_/g;	# \
	$string =~ s/\x60/_/g;	# `
	$string =~ s/\x7c/_/g;	# |
	# special characters to dash
	$string =~ s/\x3d/-/g;	# equals
	$string =~ s/\x5e/-/g;	# caret
	$string =~ s/\x7e/-/g;	# tilde
	$string =~ s/\x28/-/g;	# (
	$string =~ s/\x29/-/g;	# )
	$string =~ s/\x5b/-/g;	# [
	$string =~ s/\x5d/-/g;	# ]
	$string =~ s/\x7b/-/g;	# {
	$string =~ s/\x7d/-/g;	# }
	# Other
	$string =~ s/\x26/_and_/g;	# &
	$string =~ s/\x2b/_and_/g;	# plus
	$string =~ s/\x25/_percent_/g;	# percent
	# remove weird dash-combos
	$string =~ s/-_-_/_-_/g;
	$string =~ s/_-_-/_-_/g;
    if ($debug) { print (stderr "convertspecials string-out: '$string'\n"); };
    return $string; 
}

sub bicapitalize {
    # Now that we've got everything alphanumeric, we can bicapitalize the filenames
    my $string = $_[0];
    if ($debug) { print (stderr "convertspecials string-in : '$string'\n"); };
	# on dashes
	$string =~ s/-a/-A/g;
	$string =~ s/-b/-B/g;
	$string =~ s/-c/-C/g;
	$string =~ s/-d/-D/g;
	$string =~ s/-e/-E/g;
	$string =~ s/-f/-F/g;
	$string =~ s/-g/-G/g;
	$string =~ s/-h/-H/g;
	$string =~ s/-i/-I/g;
	$string =~ s/-j/-J/g;
	$string =~ s/-k/-K/g;
	$string =~ s/-l/-L/g;
	$string =~ s/-m/-M/g;
	$string =~ s/-n/-N/g;
	$string =~ s/-o/-O/g;
	$string =~ s/-p/-P/g;
	$string =~ s/-q/-Q/g;
	$string =~ s/-r/-R/g;
	$string =~ s/-s/-S/g;
	$string =~ s/-t/-T/g;
	$string =~ s/-u/-U/g;
	$string =~ s/-v/-V/g;
	$string =~ s/-w/-W/g;
	$string =~ s/-x/-X/g;
	$string =~ s/-y/-Y/g;
	$string =~ s/-z/-Z/g;
	# then on underscores
	$string =~ s/_a/A/g;
	$string =~ s/_b/B/g;
	$string =~ s/_c/C/g;
	$string =~ s/_d/D/g;
	$string =~ s/_e/E/g;
	$string =~ s/_f/F/g;
	$string =~ s/_g/G/g;
	$string =~ s/_h/H/g;
	$string =~ s/_i/I/g;
	$string =~ s/_j/J/g;
	$string =~ s/_k/K/g;
	$string =~ s/_l/L/g;
	$string =~ s/_m/M/g;
	$string =~ s/_n/N/g;
	$string =~ s/_o/O/g;
	$string =~ s/_p/P/g;
	$string =~ s/_q/Q/g;
	$string =~ s/_r/R/g;
	$string =~ s/_s/S/g;
	$string =~ s/_t/T/g;
	$string =~ s/_u/U/g;
	$string =~ s/_v/V/g;
	$string =~ s/_w/W/g;
	$string =~ s/_x/X/g;
	$string =~ s/_y/Y/g;
	$string =~ s/_z/Z/g;
	# and of course, on the beginning of the name
	$string =~ s/^a/A/g;
	$string =~ s/^b/B/g;
	$string =~ s/^c/C/g;
	$string =~ s/^d/D/g;
	$string =~ s/^e/E/g;
	$string =~ s/^f/F/g;
	$string =~ s/^g/G/g;
	$string =~ s/^h/H/g;
	$string =~ s/^i/I/g;
	$string =~ s/^j/J/g;
	$string =~ s/^k/K/g;
	$string =~ s/^l/L/g;
	$string =~ s/^m/M/g;
	$string =~ s/^n/N/g;
	$string =~ s/^o/O/g;
	$string =~ s/^p/P/g;
	$string =~ s/^q/Q/g;
	$string =~ s/^r/R/g;
	$string =~ s/^s/S/g;
	$string =~ s/^t/T/g;
	$string =~ s/^u/U/g;
	$string =~ s/^v/V/g;
	$string =~ s/^w/W/g;
	$string =~ s/^x/X/g;
	$string =~ s/^y/Y/g;
	$string =~ s/^z/Z/g;
    if ($debug) { print (stderr "convertspecials string-out: '$string'\n"); };
    return $string;
}

sub fixsuffixes {
    # fix chaotic suffix cases
    my $string = $_[0];
    if ($debug) { print (stderr "fixsuffixes string-in : '$string'\n"); };
	$string =~ s/\.[Pp][Dd][Ff]$/\.pdf/g;
	$string =~ s/\.[Dd][Jj][Vv][Uu]$/\.djvu/g;
	$string =~ s/\.[Rr][Tt][Ff]$/\.rtf/g;
	$string =~ s/\.[Tt][Xx][Tt]$/\.txt/g;
	$string =~ s/\.[Hh][Tt][Mm]$/\.html/g;
	$string =~ s/\.[Hh][Tt][Mm][Ll]$/\.html/g;
	$string =~ s/\.[Jj][Pp][Gg]$/\.jpg/g;
	$string =~ s/\.[Jj][Pp][Ee][Gg]$/\.jpg/g;
	$string =~ s/\.[Ee][Pp][Uu][Bb]$/\.epub/g;
	$string =~ s/\.[Mm][Oo][Bb][Ii]$/\.mobi/g;
	$string =~ s/\.[Ll][Ii][Tt]$/\.lit/g;
	$string =~ s/\.[Tt][Ii][Ff][Ff]$/\.tif/g;
	$string =~ s/\.[Tt][Ii][Ff]$/\.tif/g;
	$string =~ s/\.[Aa][Vv][Ii]$/\.avi/g;
	$string =~ s/\.[Xx][Vv][Ii][Dd]$\.avi/\.avi/g;
	$string =~ s/\.[Mm][Pp]3$/\.mp3/g;
	$string =~ s/\.[Mm][Pp][Gg]$/\.mpeg/g;
	$string =~ s/\.[Mm][Pp][Ee][Gg]$/\.mpeg/g;
    if ($debug) { print (stderr "fixsuffixes string-out: '$string'\n"); };
    return $string;
}

opendir(IN_DIR, $dname) || die "I am unable to access that directory...Sorry";
@dir_contents = readdir(IN_DIR);
closedir(IN_DIR);

@dir_contents = sort(@dir_contents);
    foreach $filename (@dir_contents) {
	if ($filename ne ".." and $filename ne ".") {
	    $oldname = $filename;
	    $filename = utf8toascii($filename);     #
	    $filename = cyrtoascii($filename);      # incomplete, but doesn't do damage
	    $filename = latin1toascii($filename);   #
	    $filename = cp1252toascii($filename);   # subset, should not conflict with utf8/latin1
	    $filename = convertspecials($filename); # converts ascii special characters to underscore/dash

	    if (!$dontbicap) {
		$filename = bicapitalize($filename); # only works with sanitized filenames
	    }
	    $filename = fixsuffixes($filename);
	    # fixes
	    # remove multiple dashes
	    $filename =~ s/--/-/g;	# double dash
	    $filename =~ s/-\./\./g;	# dash-dot combo
	    $filename =~ s/^ //g; 	# don't start a filename with a space
	    $filename =~ s/^-//g; 	# never start a filename with a dash
	    if (!$dontbicap) {
		# fix-it-all.. maybe not the best idea
		$filename =~ s/[^$OK_CHARS]//go;
	    }
	    rename ("$dname/$oldname", "$dname/$filename") unless (($filename eq $oldname) || (-e "$dname/$filename")) ;
	}
    }


__END__

=head1 NAME

bicapitalize - BiCapitalize filenames

=head1 SYNOPSIS

bicapitalize [options] [directory ...]

 Options:
   -h|--help
   -d|--dontbicapitalize

=head1 OPTIONS

=over 8

=item B<-h|--help>

Print a brief help message and exit.

=item B<-d|--dontbicapitalize>

Don't bicapitalize, just sanitize input and replace spaces et. al
with underscore. 

=back

=head1 DESCRIPTION

B<This program> will sanitize and bicapitalize the filenames of the 
whole content of the directory you're in, unless given another directory. 

It will map any utf-8 latin and some cryillic characters to roughly 
equivalent ascii characters or strings; do the same with iso-8859-1 
and a subset of cp1252, and finally, strip out any special characters
that have special meaning in most shells. The words then will be 
capitzalized and the remaining spaces eliminated.

=cut
