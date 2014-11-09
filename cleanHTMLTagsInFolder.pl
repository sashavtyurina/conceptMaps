#!/usr/bin/perl

use Unicode::Normalize;
use strict;

my $fromFolder = @ARGV[0];
my $toFolder = @ARGV[1];
my @listOfFiles = listOfFilesInFolder($fromFolder);

foreach my $file (@listOfFiles) {
	# print $file."\n";
	# clean file from HTML tags
	cleanDocText("$fromFolder/$file", "$toFolder/$file.txt");
}

#requires folderName
#goes through all the files inside the specified folder and removes HTML tags from the files
#returns an array of file names 
sub listOfFilesInFolder {
	my $directoryName = $_[0];
	my @listOfFiles = ();
	opendir (DIR, $directoryName) or die "Could not open directory $directoryName";

	while (my $file = readdir(DIR)) {
		# print $file . "\n";
		push (@listOfFiles, $file);
	}

	close (DIR);
	# print @listOfFiles;
	return @listOfFiles;
}




# my $filename = "RussianPolitics.html";
# cleanDocText($filename);

#cleans specified document from HTML tags. 
#saves clean version of the file inside cleanDocs/$filename.txt, so make sure to create cleanDocs folder prior to calling this method
#calls cleanDoc function inside
sub cleanDocText {
			my $htmlfile = $_[0];
			my $cleanfile = $_[1];
			# my $cleanfile = "$basePath/cleanDocs/$htmlfile.txt";
			open (OUT, ">$cleanfile") or die "can't open $cleanfile";
			open (IN, "$htmlfile") or print "File not found: $htmlfile";
			my $str = "";
			my $init = 0; 
			while (my $in = <IN>) { 
				chomp $in;
				$in =~ s/[\r|\n]//g;
				$in =~ s/\t/ /g;	# Remove all tabs.
				$in =~ s/[ ]+/ /g;	# Remove all duplicate spaces.
				$in =~ s/^[ ]*//g;	# Remove all leading spaces.
				$in =~ s/[ ]*$//g;	# Remove all trailing spaces.
				$str = $str . " " . $in;
			}

			my $cleanText = cleanDoc ($str);
			print OUT "$cleanText\n";
			close (IN);
			close (OUT);
}

sub cleanDoc {
				my $str = $_[0];
				#get clean text
				$str =~ s/\n//sg;	# Remove all obsolete newlines.
				$str =~ s/%(..)/pack("C",hex($1))/eg; #remove all URI encoded strings
				$str =~s/\P{IsPrint}//g; # remove all non-printing characters
#				$str =~ s/\P{IsASCII}//g;	#remove all non-ascii characters	
		
				# Decode some commonly used special characters:
				$str =~ s/(&nbsp;|&#32;)/ /g;	# Non-breaking space
				#$str =~ s/&amp;/&/g;		#
				$str =~ s/&amp;/ and /g;	#
				$str =~ s/&hellip;/ ... /g;	# three-dot symbol used to show an incomplete statement
				$str =~ s/&rsquo;/’/g;		# right single quote ’
				$str =~ s/&lsquo;/‘/g;		# left single quote ‘
				$str =~ s/&sbquo;/‚/g;		# single low-9 quote ‚
				
				$str =~ s/&ldquo;/“/g;		# left double quote “
				$str =~ s/&rdquo;/”/g;		# right double quote ”
				$str =~ s/&bdquo;/„/g;		# double low-9 quote „
				
				$str =~ s/&lsaquo;/‹/g;		# single left-pointing angle quote ‹
				$str =~ s/&rsaquo;/›/g;		# single right-pointing angle quote ›
				
				#$str =~ s/&oline;/?/g;		# overline (spacing overscore) ?
				#$str =~ s/&larr;/?/g;		# leftward arrow ?
				#$str =~ s/&uarr;/?/g;		# upward arrow ?
				#$str =~ s/&larr;/?/g;		# rightward arrow ?
				#$str =~ s/&rarr;/?/g;		# leftward arrow ?
				 		
					 		
				$str =~ s/&#44;/,/g;		# 
				$str =~ s/&#59;/;/g;		# 
				$str =~ s/&#33;/!/g;		# 
				$str =~ s/&#63;/?/g;		# 
				$str =~ s/&#46;/./g;		# 
				$str =~ s/&#58;/:/g;		# 
				$str =~ s/&#40;/(/g;		# 
				$str =~ s/&#41;/)/g;		# 
				$str =~ s/&#91;/[/g;		# 
				$str =~ s/&#93;/]/g;		# 
				$str =~ s/&#123;/{/g;		# 
				$str =~ s/&#125;/}/g;		# 
				$str =~ s/(&#60;|&lt;|&#8249;)/</g;		# 
				$str =~ s/(&#62;|&#8250;|&gt;)/>/g;		# 
				$str =~ s/&#95;/_/g;		# 
				$str =~ s/&#47;/\//g;		# 
				$str =~ s/&#92;/\\/g;		# 
				$str =~ s/(&#124;|&#166;)/|/g;		# 
				$str =~ s/&#133;/.../g;		# 
				$str =~ s/(&#8211;|&#8212;|&#45;|&shy;|&#150;|&#151;)/-/g;		# 
				$str =~ s/(&#8216;|&#96;)/`/g;		# 
				$str =~ s/(&#8217;|&#39;)/'/g;		# 
				$str =~ s/(&#8221;|&#8220;|&quot;)/"/g;		# 
				$str =~ s/&([a-zA-Z])uml;/$1/g;
				$str =~ s/&#*\w+;//g;		# 
			        $str =~ s/\xe4/ae/g;
			       	$str =~ s/\xf6/oe/g;
			        $str =~ s/\xf1/ny/g;
			        $str =~ s/\xfc/ue/g;
			        $str =~ s/\xff/yu/g;
			        $str = NFD( $str );
			        $str =~ s/\pM//g;
			        $str =~ s/\x{00df}/ss/g;
			        $str =~ s/\x{00e6}/ae/g;
			        $str =~ s/\x{0132}/IJ/g;
			        $str =~ s/\x{0133}/ij/g;
			        $str =~ s/\x{0152}/Oe/g;
			        $str =~ s/\x{0153}/oe/g;
			        $str =~ tr/\x{00d0}\x{0110}\x{00f0}\x{0111}\x{0126}\x{0127}/DDddHh/;
			        $str =~ tr/\x{0131}\x{0138}\x{013f}\x{0141}\x{0140}\x{0142}/ikLLll/;
			        $str =~ tr/\x{014a}\x{0149}\x{014b}\x{00d8}\x{00f8}\x{017f}/NnnOos/;
			        $str =~ tr/\x{00de}\x{0166}\x{00fe}\x{0167}/TTtt/;
			        $str =~ s/[^\0-\x80]//g;  ##  clear everything else; optional
        			$str =~ s/\P{IsASCII}//g;     #remove all non-ascii characters

				# Remove links:
				
				#$str =~ s/<a[ ]+.*?>/[[/ig;
				#$str =~ s/<\/a>/]]/ig;
				
				$str =~ s/<a[ ]+.*?>//ig;
				$str =~ s/<\/a>//ig;
				$str =~ s/<a[ ]+.*?>(.+)<\/a>/$1/ig;
			
				# Script:
				$str =~ s%<script.*?>.*?</script>%%gsi;	
		
				# Style:
				$str =~ s%<style.*?>.*?</style>%%gsi;	
		
				# Comment:
				$str =~ s/<!--.*?-->//ig;
			
				# Title:
				$str =~ s/<\/*title>/\n/gsi;
			
				# Line break:
				$str =~ s/<br[ ]*.*?>/\n/gsi;
			
				# Horizontal line:
				$str =~ s/<hr[ ]*.*?>/\n/gsi;
			
				# Paragraph:
				$str =~ s/<\/?p[ ]*.*?>/\n/gsi;
			
				# Headings:
				$str =~ s/<\/?h[1-6][ ]*.*?>/\n/gsi;
			
				# List items:
				$str =~ s/<li[ ].*?>/ /gsi;
				$str =~ s/<li>/ /gsi;
				$str =~ s/<\/li[ ]*.*?>/,/gsi;
				$str =~ s/<\/ul[ ]*.*?>/. /gsi;

				# Option items:
				$str =~ s/<option[ ]*.*?>/,/gsi;
				$str =~ s/<\/option[ ]*.*?>/,/gsi;

				# Table:
				$str =~ s/<\/?table[ ]*.*?>/\n/gsi;
				$str =~ s/<\/td[ ]*.*?>/,/gsi;
				$str =~ s/<tr[ ]*.*?>/ /gsi;
			
				# Cleaning up:

				$str =~ s/<.*?>/ /sg;		# Remove all tags.
				$str =~ s/,+/, /sg; # remove duplicate commas
				$str =~ s/(,\s+)+/, /sg;
				$str =~ s/\n[ ]+\n/\n/sg;	# Remove all obsolete spaces.
				$str =~ s/\n[ ]+/\n/sg;
				$str =~ s/\n+/\n/sg;	# Remove all obsolete newlines.
				$str =~ s/^[ ]*//g;		# Remove all leading spaces (again).
				$str =~ s/[ ]+/ /g;		# Remove all duplicate spaces (again).
				$str =~ s/\]\]\s+\[\[/]] , [[/g;
		return $str;
}