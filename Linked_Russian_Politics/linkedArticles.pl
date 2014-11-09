#!/usr/bin/perl
use LWP::Simple;
use strict;
use WWW::Mechanize;
use warnings;
use Text::CSV;

my $url = "http://en.wikipedia.org/wiki/Politics_of_Russia";
my $filename = "linkedArticles_modified.txt";
open(my $fh, '<', $filename) or die "Could not open file $filename!\n";

my $fileextension = ".html";
while (my $line = <$fh>) {
		if (defined $line){
			my @fields = split ",", $line;
			saveURLContentToFile($fields[1], $fields[0].$fileextension);
	}
}

#write to file text,url for all links of the article
#will ignore urls with empty text, for ex. pictures
#returns hash name-link. With all the links from the article
sub getLinkedArticles {
	my $base_url = $_[0]; #url of the main article
	my $filename = $_[1]; #name of the output file
	
	my $mech = WWW::Mechanize->new();
	$mech->get($base_url);
	my @links = $mech->links();

	open (my $fh, '>>', $filename) or die "Couldn't open file $filename $!";
	my %namedLinks;
	for my $link (@links) {
		if (!($link->text eq "")) {
			printf $fh "%s,%s\n", $link->text, absolutize($link->url, $url);
			$namedLinks{$link->text} = absolutize($link->url, $url);
		}
	}
	close($fh);
	return %namedLinks;
}

#absolutizes the link.
#Needs link and base_link. 
#for example, makes "http://en.wikipedia.org/wiki/United_Russia" out of "wiki/United_Russia"
sub absolutize {
  my($url, $base) = @_;
  use URI;
  return URI->new_abs($url, $base)->canonical;
}

#saves contents of the url to corresponding file in current directory
#requires 2 parameters - url and filename
sub saveURLContentToFile {
	my $size = @_;
	die "I want 2 parameters - url and filename!" unless $size == 2; 
	my $url = $_[0];
	my $filename = $_[1];

	my $content = get $url;
	#die "Couldn't get $url" unless defined $content;
	if (!(defined $content)){
		print "Couldn't get $url";
		return 1;
	}
	
	open (my $fh, '>', $filename) or return 2;#die "Couldn't open file $filename $!";
	print $fh $content;
	close($fh);
}