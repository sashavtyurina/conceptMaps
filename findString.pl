#! /usr/bin/perl

#name of file that contains entities divided by \n character.
#it can be TFIDF or NPMI
my $entitiesFilename = @ARGV[0];

#name of the file with main article. 
#it will be searched first, then other articles will be searched
my $mainArticleFilename = @ARGV[1];

my $outputFile = @ARGV[2];
open (OUT, ">$outputFile") or die "can't open $outputFile";

#use for NPMI format: <npmi score> <newline> <tab> <ent1> <tab> <ent2> <newline>
my @entities = readEntitiesNPMI($entitiesFilename);
for my $pair (@entities) {
	open (ARTICLE, "<$mainArticleFilename") or die "Could not open article file $mainArticleFilename.\n";
	while (my $paragraph = <ARTICLE>) {
		if (index($paragraph, $pair->{ENT1}) != -1){
			if (index($paragraph, $pair->{ENT2}) != -1){
				print OUT "ENT1: $pair->{ENT1},\nENT2: $pair->{ENT2},\nRELATION: $paragraph\n\n *** \n\n";
			}
		}
	}
}


#use for TFIDF file format: <tfidf_rank> <tab> <entity> <newline_character>
#generates array of entities read from entitiesFilename
# my @entities = readEntitiesTFIFD($entitiesFilename);
# my $n = @entities;
# for (my $i = 0; $i < $n; ++$i) {
# 	# print "ok\n";
# 	# print "i = $i\n";
# 	open (ARTICLE, "<$mainArticleFilename") or die "Could not open article file $mainArticleFilename.\n";
# 	while (my $paragraph = <ARTICLE>) {
# 		# print "ok\n";
		
# 		# print "entity[i] = $entities[$i]\n";
# 		$paragraph = lc($paragraph);

# 		# print "$entity\n";
# 		 # print "paragraph = $paragraph\n";
# 		if (index($paragraph, $entities[$i]) != -1){

# 			# print "ok\n";
# 			for (my $j = $i+1; $j < $n; ++$j) {
# 				# print "entity[j] = $entities[$j]\n";
# 				# print "j = $j\n";
#  				if (index($paragraph, $entities[$j]) != -1){
#  					print OUT "ENT1: $entities[$i],\nENT2: $entities[$j],\nRELATION: $paragraph\n\n *** \n\n";
#  				}
# 			}
# 		}
# 	}
# 	close (ARTICLE);
# }

#takes entities filename as an input
#returns an array of entities
#file format is as follows: <tfidf_rank> <tab> <entity> <newline_character> 
sub readEntitiesTFIFD {
	my $entitiesFilename = $_[0];
	open (ENT_FILE, "<$entitiesFilename") or die "Could not read fil with entities, $entitiesFilename.\n";

	my @entitiesArray = ();
	while (my $line = <ENT_FILE>) {
		my @spl = split("\t", $line);
		my $entity = @spl[1];
		chomp($entity);
		push(@entitiesArray, $entity);
	}

	return @entitiesArray;
}

#use for NPMI format: <npmi score> <newline> <tab> <ent1> <tab> <ent2> <newline>
#takes filename as input
#returns array of pairs ent1-ent2
sub readEntitiesNPMI {
	my $entitiesFilename = $_[0];
	open (ENT_FILE, "<$entitiesFilename") or die "Could not read fil with entities, $entitiesFilename.\n";

	my @entitiesArray = ();
	while (my $rankLine = <ENT_FILE>) {
		my $entitiesLine = <ENT_FILE>;
		chomp($entitiesLine); #remove <newline_character> at the end of the line
		my @spl = split("\t", $entitiesLine); #output array is <empty>, <ent1>, <ent2>
		my $pair = {};
		$pair->{ENT1} = $spl[1];
		$pair->{ENT2} = $spl[2];
		push (@entitiesArray, $pair);
	}
	return @entitiesArray;
}