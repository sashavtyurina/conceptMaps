#! /usr/bin/perl
#export PERL5LIB=/data/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Spreadsheet-ParseExcel-0.59/lib/Spreadsheet
#export PERL5LIB=/data/bsarrafzadeh/OpenIE/InsightNG/all-sentences/OLE-Storage_Lite-0.19/lib

use strict;
require Encode;
use Unicode::Normalize;
use CGI;
use HTTP::Request::Common qw(GET);
use LWP::UserAgent;
use Cwd;

use Lingua::StanfordCoreNLP;
#use Spreadsheet::ParseExcel;
#use OLE::Storage_Lite;
#use Text::CSV;

####GLOBAL VARIABLES:####
my %dependencyGraph = ();
my $dependencyStart = "";
my $dependencyStop = "";
my %entityPairsWithRelations = ();
my %candidatePaths = ();
my %candidatePathsFull = ();
my $pipeline;
my $mergeType = 2; #1 - Stage 1 merge; 2 - Stage 1 and 2.

my %dishes = ();
my %discounts = loadDiscounts();
my @topicNums = loadTopicNums();

my $tempDir = "data";
require "config.pl";
require "wumpusLib.pl";

my ($wumpus_connection) = newConnection();
my $wumpus = $wumpus_connection->{sock};

my $threshold = 1; #select entities from only those sentences where $matchedEntities >= $threshold (for getWindows subroutine) 
my $extractionMode = 3; # 3 - extract the current (containing query terms), preceeding and following sentences; 1 - extract only the current sentence (for getWindows subroutine)
my $collocationSpan = 100; #max span within which two words are considered to be collocates (for collocationCount subroutine)
my $maxSentLength = 100; #remove all sentences with the sentence length > $maxSentLength (for getWindows subroutine)
my %queries = loadQueries(); #load queries
my %MLL_IDs = loadMLLIDs(); #load MLL IDs
my %singleQueries = loadQueriesSingle(); #load single words from queries
my %queriesForWindows = loadQueriesforWindowExtraction();
my %queriesForCollocation = loadQueriesforCollocation();
my %titles = loadTitles(); #load titles
my %entityTypes = loadEntityTypes(); #load target entity types (not used currently)
my %stopwords = loadStopwords();

# Run MongoDB first!!!!!!
# Source EnvVars manually
#runCurator();

#killCurator();
# Create a new NLP pipeline (don't silence messages, do make corefs bidirectional)
# $pipeline = new Lingua::StanfordCoreNLP::Pipeline(0, 1);

my ($p, $l);
#my $t = 10; # go vegan!
#my $t = 11;
#my $t = 12;
#my $t = 13;
#my $t = 2794; # becoming financially independent
#my $t = 11848; # only a list of countries ...
#my $t = 53026; # irrational parents
#my $t = 12344;
#my $t = 733; #non English
#my $t = 5991;
#my $t = 63061;
#my $t = 39307;

#my $t = 42226;
#my $t = 46967; # labels extracted!
#my $t = 11193;
#my $t = 3902;
#my $t = 42142;
#my $t = 50172;
#my $t = 11965;  # parser crashed! --> added 2 dots for sent 33 to fix it.
#my $t = 41018;
#my $t = 0;

#my $t = 92256;
#my $t = 92267;
#my $t = 14; # igor_stravinsky
#my $t = 1; # coffee query
#my $t = 2; # football query
#my $t = 3; # ontology query
#my $t = 34;
#my $t = 1000; 
#my $t = "Aspirin";
#my $t = "Viagra_TREC";
#my $t = "StemCell_TREC"; # Query ID: 74 from CiQA 2007
#my $t = "Lyme_TREC"; # Query ID: 251 from QA 2007
#my $t = "StemCell_TREC_noN"; # QueryID: 74 from CiQA 2007 - These are the high ranked docs which contain NO nuggets
#my $t = "Lyme_TREC_noN"; # QueryID: 251 from QA 2007 - These are the high ranked docs which contain NO nuggets
#my $t = "Aspirin_TREC";
#my $t = "napoleonRussia";
#my $t = "NapoleonRussia_Wiki";
my $t = "CanadaCapitals";
#my $t = "OllieSet";
#my $t = "WWIeconomy";
#my $t = "StartUP";
#my $t = "IranEarthquake";
#cleanDiacritics($t);
#	loadMLL_IDs();
#	loadMLL();
#	cleanMLL();

#getTopDocTexts ($t, 13);
#cleanDiacritics ($t);

#my $docNum = 4;

#getTFIDF_all($t, 1);
	#tagEntities($t, 1);
	#getEntities($t, 1);
	#fixEntities_1($t, 1 ,1);
	#fixEntities_2($t, 3);
	#fixEntities_2($t, 1, 1);
	

#foreach my $topic (sort numerically keys %queries) {
for (my $docNum = 1; $docNum <= 13; $docNum++){
	#if ($docNum == 4 || $docNum == 13)
	{
#my $docNum = "1_relaxed";
#foreach my $topic (sort numerically keys %MLL_IDs) {	

	#getTopBingDocsTexts ($t, 50);
	
	#cleanDiacritics ($t);
	
	#print "TOPIC: $topic\n";
	#my $t = $topic;
	#tagEntities($t, $docNum);
	#getEntities($t, $docNum);
	
	#opendir (THISDIR, "windows/$t/taggedEntities") or die "$!";
        #my @docfiles = grep !/^\./, readdir THISDIR;
        #closedir THISDIR;
	
#	fixEntities_1($t, $docNum, $docNum);
#	fixEntities_2($t, $docNum, $docNum);
	
	#fixEntities_1($t, 1 ,1);
	#fixEntities_2($t, 3);
	#fixEntities_2($t, 1, 1);
	#fixEntities_2($t, 7);
	#fixEntities_2($t, 9);
	
	#fixEntities_1($t, 18);
	#fixEntities_1($t, 19);
	#fixEntities_1($t, 25);
	#fixEntities_1($t, 30);
	
	#fixEntities_2($t, 18);
	#fixEntities_2($t, 19);
	#fixEntities_2($t, 25);
	#fixEntities_2($t, 30);
	#fixEntities_2($t, 19);
	#fixEntities_2($t, 25);
	#fixEntities_2($t, 23);
	#foreach my $docfile (@docfiles)
	{
		#print "--- $docfile ---\n";
		#if ($docfile != 2 && $docfile != 3 && $docfile != 1 && $docfile != 7 || $docfile == 9) #&& $docfile == 25 && $docfile == 30)# && $docfile != 24 && $docfile != 7 && $docfile != 36 && $docfile != 13 && $docfile != 28 && $docfile != 16)
		{
		#print "$docfile\n\n";
		#fixEntities_1($t, $docfile);
		#fixEntities_2($t, $docfile);
		#fixEntities($t);
		}
	}
	#getTF_all($t); # In case fixEntities did not create the TF file, you can run this subroutine to fix that.
	
	#getTFIDF_all($t, $docNum);
#	
	#rankAverageTFIDF($t, $docNum);
        #rankAverageTFIDFbySent($t, $docNum);
##	rankNPMI($t);
#	#rankNPMIbySent($t);
#	#rankRRF($t);
##	
#	extractCandidateRelations($t, $docNum);
#	parseText_Entities($t, $docNum);
#	getPaths_EN($t, $docNum);
##	
######	getPaths_Entities($t);
##
	#selectPaths($t, $docNum);
	#augmentPaths($t, $docNum);
#	rankRelations($t, $docNum, 0); # the second argument indicates the ranking method: 0 for average TF-IDF; 1 for NPMI
#	
#	getTuples($t, $docNum); # Generates tuples for each query in the following format: entity1   entity2   label   sentence (tab separated)
	#getRankedTuples($t, $docNum, 0); # Generates ranked tuples for each query in the following format: entity1   entity2   label   sentence (tab separated)
	#summarizeResults($t); # Generates stats for each query in the following format: NPMI	TF.IDF	Entity1	Entity2	label	original_sentence   (tab separated)
	
	


	#parseDoc($sentNum, $sent, $topic, $mergeType, $path);
	
	#($p, $l) = parseDoc(1, "British_colonialists made Kenya their home", 1, 1, "British_colonialists-1 -<-nsubj-<- made-2 ->-dobj->- Kenya-3");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "The_United_States and Kenya have enjoyed cordial relations since Kenya's independence", 1, 2, "The_United_States-1 -<-nsubj-<- enjoyed-5 ->-advcl->- independence-11");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "Since that event, the Kenyan and U.S. Governments have intensified cooperation to address all forms of insecurity in Kenya including terrorism", 1, 2, "Kenyan-6 -<-nn-<- Governments-9 -<-nsubj-<- intensified-11 ->-xcomp->- address-14 ->-prep_in->- Kenya-20");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "Subsequent cabinet appointments are made by the president in consultation with the prime_minister in accord with the power-sharing agreement's proportional_division of cabinet positions.", 1, 2, "cabinet-2 -<-nn-<- appointments-3 -<-nsubjpass-<- made-5 ->-prep_with->- prime_minister-13");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "After independence Kenya promoted rapid economic_growth through public_investment encouragement of smallholder agricultural production, and incentives for private (often foreign) industrial investment.", 1, 2, "independence-2 -<-prep_after-<- promoted-4 ->-dobj->- economic_growth-6");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "Kenya does not systematically collect foreign_direct_investment (FDI statistics and its historical_performance in attracting FDI has been relatively weak.", 1, 2, "Kenya-1 -<-nsubj-<- collect-5 ->-dobj->- FDI-8");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "The_Customs_Union and a Common_External_Tariff were established on January_1 2005 but the EAC countries are still working out exceptions to the tariff", 1, 2, "EAC-12 -<-nn-<- countries-13 -<-nsubj-<- working-16 ->-prep_to->- tariff-21");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "The_Protectorate promoted settlement of the fertile central highlands by Europeans dispossessing the Kikuyu and others of their land.", 1, 2, "The_Protectorate-1 -<-nsubj-<- promoted-2 ->-prepc_by->- dispossessing-11 ->-dobj->- Kikuyu-13");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "Eventually, in 1963 Kenya gained independence electing Jomo_Kenyatta as the first president.", 1, 2, "Kenya-5 -<-nsubj-<- gained-6 ->-xcomp->- electing-8 ->-dobj->- Jomo_Kenyatta-9");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "Kenya is sub-Saharan Africa's fifth largest economy (GDP of USD 33.62 billion in 2012), after South_Africa Nigeria Angola and Sudan", 1, 2, "Kenya-1 -<-nsubj-<- Africa-4 ->-prep_after->- Angola-21");
	#($p, $l) = parseDoc(1, "Neither the USA nor South_Africa have double_taxation_treaties with Kenya .", 1, 2, "South_Africa-5 -<-nsubj-<- have-6 ->-dobj->- double_taxation_treaties-7");
	#($p, $l) = parseDoc(1, "Kenya has the most sophisticated financial and capital_markets in the East African_region .", 1, 2, "Kenya-1 -<-nsubj-<- has-2 ->-dobj->- capital_markets-8 ->-prep_in->- African_region-12");
#	($p, $l) = parseDoc(1, "On the other hand, Kenya has been exporting coffee tea flowers, fruits and vegetables to the UAE albeit in comparatively smaller quantities.", 1, 2, "Kenya-6 -<-nsubj-<- exporting-9 ->-dobj->- flowers-12 ->-prep_to->- UAE-19");
	#($p, $l) = parseDoc(1, "The liberalization of the coffee industry had some serious financial implications for the Board, which is currently allowed by law to charge only a 1evy on the marketed coffee.", 1, 2, "coffee	liberalization-2 -<-nsubj-<- had-7 ->-dobj->- implications-11 ->-prep_for->- Board-14 ->-rcmod->- allowed-19 ->-xcomp->- charge-23 ->-prep_on->- coffee-30");
	#($p, $l) = parseDoc(1, "Kenya is also a member of the_Preferential_Trade_Area (PTA) agreement embracing countries in Eastern and Southern_Africa which has been transformed to the_Common_Market for Eastern and Southern_Africa (COMESA) with a population of approximately 400 million.", 1, 2, "Kenya-1 -<-nsubj-<- member-5 ->-dep->- agreement-11 ->-partmod->- embracing-12 ->-dobj->- countries-13 ->-prep_in->- Southern_Africa-17");
	#($p, $l) = parseDoc(1, "There is an increasing concern among local manufacturers that South_Africa is gaining an unfair advantage over Kenya by monopolising the Kenyan market.", 1, 2, "South_Africa-10 -<-nsubj-<- gaining-12 ->-dobj->- advantage-15 ->-prep_over->- Kenya-17");
	#($p, $l) = parseDoc(1, "In addition to being the major supplier of oil to Kenya, the UAE has emerged as a favoured shopping destination to which Kenyans travel regularly to purchase household and office electronic appliances, automobile spare-parts and even motor_vehicles, '' the former Ambassador said.", 1, 2, "UAE-14 -<-nsubj-<- emerged-16 ->-prep_as->- destination-21 ->-rcmod->- travel-25 ->-nsubj->- appliances-33 ->-appos->- motor_vehicles-39");
	#($p, $l) = parseDoc(1, "So... Hubby entered into negotiations with the existing owner who just happened to be anxious to sell and bibbity bobbity boo, next thing we knew, we were the proud owners.", 1, 2, "Hubby-3 -<-nsubj-<- entered-4 ->-prep_with->- owner-10 ->-rcmod->- happened-13 ->-nsubj->- boo-22");
	#($p, $l) = parseDoc(1, "My 7-year-old daughter over the summer developed the \"\" Rules of Friendship , \"\" basically, what does it take to be a good friend ?", 1, 2, "daughter-3 -<-nsubj-<- developed-7 ->-dobj->- the-8 ->-partmod->- Rules-11 ->-prep_of->- Friendship-13");
	#($p, $l) = parseDoc(1, "After a while you realize that our lives have gone into different directions , that our  dreams and goals, our interests and even our taste in music don't match any more.", 1, 2, "lives-8 -<-nsubj-<- gone-10 ->-prep_into->- directions-13");
	#($p, $l) = parseDoc(1, "My world  is expanding with new perspectives  and fun  opportunities .", 1, 2, "world-2 -<-nsubj-<- expanding-4 ->-prep_with->- perspectives-7");
	#($p, $l) = parseDoc(1, "My world  is expanding with new perspectives  and fun  opportunities .", 1, 2, "world-2 -<-nsubj-<- expanding-4 ->-prep_with->- opportunities-10");
	#($p, $l) = parseDoc(1, "The ability  to capture moments in real_time  with a picture or  video  and post a  comment  directly to your My_Life_List_Profile .", 1, 2, "ability-2 -<-nsubj-<- capture-4 ->-dobj->- moments-5 ->-prep_in->- real_time-7");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "Practice distraction techniques .", 1, 2, "Practice-1 -<-nsubj-<- distraction-2 ->-dobj->- techniques-3");
	#($p, $l) = parseDoc(1, "Charlotte  doesn't currently have a local group , so until it does, I will get my  practice  online.", 1, 2, "Charlotte-1 -<-nsubj-<- have-5 ->-dobj->- group-8");
	#($p, $l) = parseDoc(1, "In  order  for the show  to succeed we need to find a partner willing to sponsor the show and help it develop into a nationally syndicated Radio_Show .", 1, 2, "partner-13 -<-nsubj-<- willing-14 ->-xcomp->- sponsor-16 ->-dobj->- show-18");
	
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	
	#($p, $l) = parseDoc(1, "The ability  to capture moments in real_time  with a picture or  video  and post a  comment  directly to your My_Life_List_Profile .", 1, 2, "ability-2 -<-nsubj-<- capture-4 ->-prep_with->- video-12");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	#($p, $l) = parseDoc(1, "Compassionate  communication  is another term (my prefered term) for  NonViolent_Communication  (NVC).", 1, 2, "communication-2 -<-nsubj-<- term-5 ->-prep_for->- NonViolent_Communication-12");
	#($p, $l) = parseDoc(1, "I found out that my  family  is likely linked to King_William  I of the Scots , possibly, but not as likely, to King_Edward  I of  England .", 1, 2, "family-6 -<-nsubj-<- likely-8 ->-dep->- linked-9 ->-prep_to->- I-12 ->-prep_of->- Scots-15");
	#print "\nAugmentedPath is $p\nLabel is $l\n";
	

#	tagNEs($topic, $extractionMode);
#	getNEs($topic, $entityTypes{$topic}, $extractionMode, $titles{$topic});
#	oneSentperLine($topic);
#	wikifier($topic);
#	getEs($topic);
#	getTFIDF_wiki($topic);
#	underscoreEs($topic);
#	combineEntities($topic);
#	getTFIDF($topic, $titles{$topic}, $extractionMode, $queriesForCollocation{$topic}); #calculates IDF and TFIDF
##	collocationCount($topic, $titles{$topic}, $extractionMode, $collocationSpan, $queriesForCollocation{$topic}); #calculates MI, Z, CHI-square (currently with respect to $titles{$topic}), TF.IDF and IDF.
#	underscoreNEs($topic, $entityTypes{$topic}, $extractionMode, $titles{$topic});
#	parseText($topic);
#	getPaths($topic);
#	getPaths_E($topic);
	}
}
#getTF_all($t);
#getTFIDF_collection($t);
#rankAverageTFIDF_all($t);
#rankAverageTFIDFbySentDoc($t);
##rankNPMI($t);
##rankNPMIbySentDoc($t);
#rankRelations_all($t, 0); # the second argument indicates the ranking method: 0 for average TF-IDF; 1 for NPMI
#getRankedTuples_all($t, 0); # Generates ranked tuples for each query in the following format: entity1   entity2   label   sentence (tab separated)
#
#extractCandidateSentences($t);

#extractCandidateLabels($t);

getEntitiesFreqs($t);

#filterReverbExtractions($t);

#getNuggets($t, 74, 50);
#getAllEntities($t, 50);
#parseCanvasData($t, 2);
###########SUBROUTINES:#################

sub loadMLL_IDs # reads the MLL database and creates one doc per Goal (ActID). This version distinguishes different users writing a comment
{
	my %DOCS = ();
	my $ActID;
	my $UserID;
	my $ID;
	my $text;
	my $in;
	
	#open (GOAL, "Data/MyLifeList/mylifelist_db_05Dec2012_activity_working_summarized.txt") or die "$!";
	#open (COMMENT, "Data/MyLifeList/mylifelist_db_export_05Dec2012_activity_comments_working_summarized.txt") or die "$!";
	open (GOAL, "Data/MyLifeList/MyLifeList_db_export_05Feb2013_Goals.txt") or die "$!";
	open (COMMENT, "Data/MyLifeList/MyLifeList_db_export_05Feb2013_Comments.txt") or die "$!";
	#open (OUT, ">Data/MyLifeList/MLL.out") or die "$!";
	open (LOG, ">Data/MyLifeList/log.txt") or die "$!";
	open (M, ">Data/MyLifeList/matched.txt") or die "$!";
	
	#print "******************\n";
	$in = <GOAL>; # skip the header:  ActID        UserID  Title   WhyInspired     NeedHappen1     NeedHappen2     NeedHappen3     BiggestBarrier  AdditionalNotes
	while (my $in = <GOAL>)
	{
		my $col;
		$text = "";
		chomp $in;
		#print "$in\n\n";
		my @columns = split /\t/, $in;
		
		$ActID = $columns[0];
		$UserID = $columns[1];
		for (my $i = 2; $i < @columns; $i++)
		{
			my $col = $columns[$i];
			$col =~ s/^\"//;
			$col =~ s/\"$//;
			$text = $text . $col . " .\n";
			print "-- $col\n";
		}
		print "\n";
		
		$DOCS{$ActID}{"UserID"} = $UserID;
		$DOCS{$ActID}{"Content"} = $text;
		$DOCS{$ActID}{"Comments"} = "";
		
	}
	
	$in = <COMMENT>; # skip the header:  ID	ActID	UserID	Note
	while (my $in = <COMMENT>)
	{
		$text = "";
		chomp $in;
		print "$in\n\n";
		my @columns = split /\t/, $in;
		
		$ID = $columns[0];
		$ActID = $columns[1];
		$UserID = $columns[2];
		print "ID is $ID - ActID is $ActID - UserID is $UserID\n";
		for (my $i = 3; $i < @columns; $i++)
		{
			my $col = $columns[$i];
			$col =~ s/^\"//;
			$col =~ s/\"$//;
			$text = $text . $col . " .\n";
			print "-- $col\n";
		}
		print "\n";
		
		if (exists $DOCS{$ActID} && defined $DOCS{$ActID})
		{
			# XXXX$UserIDXXXX is a dummy word to distinguish pronouns "I" and "We" as they refer to different users.
			$DOCS{$ActID}{"Comments"} = $DOCS{$ActID}{"Comments"} . "\nXXXX" . $UserID . "XXXX\n\n" . $text . "\n"; 
			print "******* $in\n";
			print M "$in\n";
		}
		else
		{
			print LOG "$in\n";
		}
	}
	
	my $rm = `rm -rf Data/MyLifeList/docs`;
	my $mkdir = `mkdir Data/MyLifeList/docs`;
	foreach my $actId ( keys %DOCS )
	{
		#my $actId = $_;
     		open (OUT, ">Data/MyLifeList/docs/$actId");
		
		my $mainGoal = "XXXX" . $DOCS{$ActID}{"UserID"} . "XXXX\n\n" . $DOCS{$actId}{"Content"};
     		
		print OUT "$mainGoal \n $DOCS{$actId}{\"Comments\"}";
		
		close (OUT);
 	} 
}
sub loadMLL # reads the MLL database and creates one doc per Goal (ActID).
{
	my %DOCS = ();
	my $ActID;
	my $UserID;
	my $ID;
	my $text;
	my $in;
	
	open (GOAL, "Data/MyLifeList/mylifelist_db_05Dec2012_activity_working_summarized.txt") or die "$!";
	open (COMMENT, "Data/MyLifeList/mylifelist_db_export_05Dec2012_activity_comments_working_summarized.txt") or die "$!";
	#open (OUT, ">Data/MyLifeList/MLL.out") or die "$!";
	open (LOG, ">Data/MyLifeList/log.txt") or die "$!";
	open (M, ">Data/MyLifeList/matched.txt") or die "$!";
	
	$in = <GOAL>; # skip the header:  ActID        UserID  Title   WhyInspired     NeedHappen1     NeedHappen2     NeedHappen3     BiggestBarrier  AdditionalNotes
	while (my $in = <GOAL>)
	{
		my $col;
		$text = "";
		chomp $in;
		#print "$in\n\n";
		my @columns = split /\t/, $in;
		
		$ActID = $columns[0];
		$UserID = $columns[1];
		for (my $i = 2; $i < @columns; $i++)
		{
			my $col = $columns[$i];
			$col =~ s/^\"//;
			$col =~ s/\"$//;
			$text = $text . $col . " .\n";
			#print "-- $col\n";
		}
		print "\n";
		
		$DOCS{$ActID}{"UserID"} = $UserID;
		$DOCS{$ActID}{"Content"} = $text;
		$DOCS{$ActID}{"Comments"} = "";
		
	}
	
	$in = <COMMENT>; # skip the header:  ID	ActID	UserID	Note
	while (my $in = <COMMENT>)
	{
		$text = "";
		chomp $in;
		print "$in\n\n";
		my @columns = split /\t/, $in;
		
		$ID = $columns[0];
		$ActID = $columns[1];
		$UserID = $columns[2];
		print "ID is $ID - ActID is $ActID - UserID is $UserID\n";
		for (my $i = 3; $i < @columns; $i++)
		{
			my $col = $columns[$i];
			$col =~ s/^\"//;
			$col =~ s/\"$//;
			$text = $text . $col . " .\n";
			print "-- $col\n";
		}
		print "\n";
		
		if (exists $DOCS{$ActID} && defined $DOCS{$ActID})
		{
			$DOCS{$ActID}{"Comments"} = $DOCS{$ActID}{"Comments"} . $text . "\n";
			print "******* $in\n";
			print M "$in\n";
		}
		else
		{
			print LOG "$in\n";
		}
	}
	
	my $rm = `rm -rf Data/MyLifeList/docs`;
	my $mkdir = `mkdir Data/MyLifeList/docs`;
	foreach my $actId ( keys %DOCS )
	{
		#my $actId = $_;
     		open (OUT, ">Data/MyLifeList/docs/$actId");
     		
		print OUT "$DOCS{$actId}{\"Content\"} \n $DOCS{$actId}{\"Comments\"}";
		
		close (OUT);
 	} 
}
sub loadExcel
{
	#open (GOAL, "Data/MyLifeList/mylifelist_db_05Dec2012_activity_working_summarized.csv") or die "$!";
	#open (COMMENT, "Data/MyLifeList/mylifelist_db_05Dec2012_activity_working_summarized.csv") or die "$!";
	
	my $oExcel = new Spreadsheet::ParseExcel;
	
	die "You must provide a filename to $0 to be parsed as an Excel file" unless @ARGV;
	
	my $oBook = $oExcel->Parse($ARGV[0]);
	my($iR, $iC, $oWkS, $oWkC);
	print "FILE  :", $oBook->{File} , "\n";
	print "COUNT :", $oBook->{SheetCount} , "\n";
	
	print "AUTHOR:", $oBook->{Author} , "\n"
	if defined $oBook->{Author};
	
	for(my $iSheet=0; $iSheet < $oBook->{SheetCount} ; $iSheet++)
	{
		$oWkS = $oBook->{Worksheet}[$iSheet];
		print "--------- SHEET:", $oWkS->{Name}, "\n";
		for(my $iR = $oWkS->{MinRow}; defined $oWkS->{MaxRow} && $iR <= $oWkS->{MaxRow}; $iR++)
		{
			for(my $iC = $oWkS->{MinCol}; defined $oWkS->{MaxCol} && $iC <= $oWkS->{MaxCol}; $iC++)
			{
				$oWkC = $oWkS->{Cells}[$iR][$iC];
				print "( $iR , $iC ) =>", $oWkC->Value, "\n" if($oWkC);
			}
		}
	}
}
sub loadCSV
{
	my @rows;
	my $csv = Text::CSV->new ( { binary => 1 } )  # should set binary attribute.
		 or die "Cannot use CSV: ".Text::CSV->error_diag ();
	
	open my $fh, "<:encoding(utf8)", "Data//MyLifeList//mylifelist_db_05Dec2012_activity_working_summarized.csv" or die "csv file: $!";
	while ( my $row = $csv->getline( $fh ) ) {
		$row->[2] =~ m/pattern/ or next; # 3rd field should match
		push @rows, $row;
	}
	$csv->eof or $csv->error_diag();
	close $fh;
	
	$csv->eol ("\r\n");
	
	open $fh, ">:encoding(utf8)", "new.csv" or die "new.csv: $!";
	$csv->print ($fh, $_) for @rows;
	close $fh or die "new.csv: $!";
	
	#
	# parse and combine style
	#
	
	my ($status, @columns, $line, $bad_argument, $diag, $colref, $ref, $eof, $io, @names, @t_array);
	$status = $csv->combine(@columns);    # combine columns into a string
	$line   = $csv->string();             # get the combined string
	
	$status  = $csv->parse($line);        # parse a CSV string into fields
	@columns = $csv->fields();            # get the parsed fields
	
	$status       = $csv->status ();      # get the most recent status
	$bad_argument = $csv->error_input (); # get the most recent bad argument
	$diag         = $csv->error_diag ();  # if an error occured, explains WHY
	
	$status = $csv->print ($io, $colref); # Write an array of fields
				       # immediately to a file $io
	$colref = $csv->getline ($io);        # Read a line from file $io,
				       # parse it and return an array
				       # ref of fields
	$csv->column_names (@names);          # Set column names for getline_hr ()
	$ref = $csv->getline_hr ($io);        # getline (), but returns a hashref
	$eof = $csv->eof ();                  # Indicate if last parse or
				       # getline () hit End Of File
	
	$csv->types(\@t_array);               # Set column types
}
sub parseText {
	my $topic = $_[0];
#	my $mkdir = `mkdir windows/$topic/parsedWithNEs`;
#	opendir (THISDIR, "windows/$topic/underscoreNEs") or die "$!";
#	my @files = grep !/^\./, readdir THISDIR;
#        closedir THISDIR;
#        foreach my $file (@files){
#        	my $parse = `/home/ovechtom/Stanford/stanford-parser-2012-07-09/lexparser-dependencies.sh windows/$topic/underscoreNEs/$file > windows/$topic/parsedWithNEs/$file`;
#	}
	
	my $mkdir = `mkdir windows/$topic/parsedWithEs`;
	opendir (THISDIR, "windows/$topic/underscoreEs") or die "$!";
	my @files = grep !/^\./, readdir THISDIR;
	closedir THISDIR;
	foreach my $file (@files){
		my $parse = `/home/ovechtom/Stanford/stanford-parser-2012-07-09/lexparser-dependencies.sh windows/$topic/underscoreEs/$file > windows/$topic/parsedWithEs/$file`;
	}
}
sub parseText_Entities {
	my $topic = $_[0];
	my $dN = $_[1];
#	my $mkdir = `mkdir windows/$topic/parsedWithNEs`;
#	opendir (THISDIR, "windows/$topic/underscoreNEs") or die "$!";
#	my @files = grep !/^\./, readdir THISDIR;
#        closedir THISDIR;
#        foreach my $file (@files){
#        	my $parse = `/home/ovechtom/Stanford/stanford-parser-2012-07-09/lexparser-dependencies.sh windows/$topic/underscoreNEs/$file > windows/$topic/parsedWithNEs/$file`;
#	}
	
	my $rm = `rm -rf windows/$topic/$dN/parsedWithEntities`;
	my $mkdir = `mkdir windows/$topic/$dN/parsedWithEntities`;
	opendir (THISDIR, "windows/$topic/$dN/underscoreEntities") or die "$!";
	my @files = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        foreach my $file (@files){
        	#my $parse = `/home/ovechtom/Stanford/stanford-parser-2012-07-09/lexparser-dependencies.sh windows/$topic/underscoreEntities/$file > windows/$topic/parsedWithEntities/$file`;
		my $parse = `/data/bsarrafzadeh/NLP-Tools/stanford-parser-2012-11-12/lexparser-dependencies.sh windows/$topic/$dN/underscoreEntities/$file > windows/$topic/$dN/parsedWithEntities/$file`;
	}
}
sub getTFIDF {
	my $topic = $_[0];
	my $title = $_[1];
	my $extractionMode = $_[2];
	my $queryForCollocation = $_[3];
	
	my %collocates = ();
	my $corpus = 30230685715;
	my $bigN = 50220423;
	my $mkdir = `mkdir data/$topic`;
	my $mkdir = `mkdir data/$topic/collocation-$collocationSpan`;
	my $mkdir = `mkdir data/$topic/collocation-$collocationSpan/title`;
	open (IDF, ">data/$topic/collocation-$collocationSpan/title/IDF") or die "$!";
	open (TFIDF, ">data/$topic/collocation-$collocationSpan/title/TFIDF") or die "$!";
        open (IN, "data/$topic/NEs") or die "$!";

	#get queryForCollocation terms
        my @queryTerms = split /[\,\s|\|]/, $queryForCollocation;
        my @queryForColloc = ();
        foreach my $queryTerm (@queryTerms){
                if ($queryTerm =~ /\w/){
                        push @queryForColloc, $queryTerm;
                }
        }

	while (my $in = <IN>){
		chomp $in;
		my @elements = split /\t/, $in;
		my $count = $elements[0];
		my $sumSentScore = $elements[1];
		my $maxSentScore = $elements[2];
		my $collocate = $elements[3];
		$collocate =~ s/_ampersand_/&/g;
		my $entityType = $elements[4];
		#check if the collocate is not a subset of the title
		my $validCollocate = 1;
                if ($collocate eq ""){
                  $validCollocate = 0;
                }
                #for (my $a=0; $a<@queryForColloc; $a++){
                #    if ($queryForColloc[$a] =~ /$collocate/){
		#	print "<$topic>$collocate\n";
                #        $validCollocate = 0;
                #    }
                #}

		if ($validCollocate == 1){
	#		if ($count > 1){
				#get $docsF (i.e. number of documents containing the collocate (for calculating idf))
				my ($command ) = "\@count (\"<doc>\"..\"</doc>\") >  \"$collocate\" \n";
                                my (@response) = wumpusResponse($wumpus, $command);
                                my $docsF = $response[0];
                                chop $docsF;

				#initialize variables
				my $idf = 0;
				my $tfidf = 0;
				#calculate idf and tfidf
				if ($docsF == 0) # for MLL only
				{
					$docsF = 1;
				}
				if ($docsF > 0){
					$idf = log ($bigN / $docsF);
					#print "IDF($collocate): $idf = log ($bigN / $docsF)\n";
					$tfidf = $idf * $count;
					#print "\tTFIDF($collocate):$tfidf = $idf * $count\n";
					print IDF "$idf\t$collocate\t$entityType\n";
					print TFIDF "$tfidf\t$collocate\t$entityType\n";
				}
			#}
		}
	}
	close (IN);
	close (TFIDF);
	close (IDF);
	my $sort = `sort -rg data/$topic/collocation-$collocationSpan/title/IDF > data/$topic/collocation-$collocationSpan/title/IDF-s`;
	my $sort = `sort -rg data/$topic/collocation-$collocationSpan/title/TFIDF > data/$topic/collocation-$collocationSpan/title/TFIDF-s`;
	my $mv = `mv data/$topic/collocation-$collocationSpan/title/IDF-s data/$topic/collocation-$collocationSpan/title/IDF`;
	my $mv = `mv data/$topic/collocation-$collocationSpan/title/TFIDF-s data/$topic/collocation-$collocationSpan/title/TFIDF`;
}

sub collocationCount {
	my $topic = $_[0];
	my $title = $_[1];
	my $extractionMode = $_[2];
	my $collocationSpan = $_[3];
	my $queryForCollocation = $_[4];
	my %collocates = ();
	my $corpus = 30230685715; #Clueweb B (total number of word occurrences)
	my $bigN = 50220423; #Clueweb B (number of documents)
	my $mkdir = `mkdir data/$topic`;
	my $mkdir = `mkdir data/$topic/collocation-$collocationSpan`;
	my $mkdir = `mkdir data/$topic/collocation-$collocationSpan/title`;
        open (MI, ">data/$topic/collocation-$collocationSpan/title/MI") or die "$!";
        open (Z, ">data/$topic/collocation-$collocationSpan/title/Z") or die "$!";
        open (IDF, ">data/$topic/collocation-$collocationSpan/title/IDF") or die "$!";
        open (TFIDF, ">data/$topic/collocation-$collocationSpan/title/TFIDF") or die "$!";
        open (CHI, ">data/$topic/collocation-$collocationSpan/title/CHI") or die "$!";
        open (ALL, ">data/$topic/collocation-$collocationSpan/ALL-stats") or die "$!";
        open (IN, "data/$topic/NEs") or die "$!";

	#get queryForCollocation terms
	my @queryTerms = split /[\,\s|\|]/, $queryForCollocation;
	my @queryForColloc = ();
	foreach my $queryTerm (@queryTerms){
        	if ($queryTerm =~ /\w/){
        	        push @queryForColloc, $queryTerm;
        	}
	}


	#get frequency of the title
	my ($command ) = "\@count \"$title\" \n";
	print "$command\n";
	my (@response) = wumpusResponse($wumpus, $command);
	my $titleF = $response[0];
	chop $titleF;
	#check if collection frequency of title = 0, then remove the first word (i.e. likely modifier) and get the frequency for the new shortened title
	if ($titleF == 0){
		$title =~ s/^.+?[ ](.+)$/$1/;
		$command = "\@count \"$title\" \n";
	        @response = wumpusResponse($wumpus, $command);
        	$titleF = $response[0];
        	chop $titleF;
		#print "<$topic>$titleF:$title\n";
	}

	while (my $in = <IN>){
		chomp $in;
		my @elements = split /\t/, $in;
		my $count = $elements[0];
		my $sumSentScore = $elements[1];
		my $maxSentScore = $elements[2];
		my $collocate = $elements[3];
		$collocate =~ s/_ampersand_/&/g;
		my $entityType = $elements[4];
		#check if the collocate is not a subset of the title
		my $validCollocate = 1;
                if ($collocate eq ""){
                  $validCollocate = 0;
                }
                for (my $a=0; $a<@queryForColloc; $a++){
                    if ($queryForColloc[$a] =~ /$collocate/){
			print "<$topic>$collocate\n";
                        $validCollocate = 0;
                    }
                }

		if ($validCollocate == 1){
	#		if ($count > 1){
				#get joint frequency
				my ($command ) = "\@count (\"$collocate\" ^ \"$title\") < [$collocationSpan] \n";
	#			print "$command";
				my (@response) = wumpusResponse($wumpus, $command);
				my $JF = $response[0];
				chop $JF;
				#get frequency of the collocate
				my ($command ) = "\@count \"$collocate\" \n";
	#			print "$command";
				my (@response) = wumpusResponse($wumpus, $command);
				my $colF = $response[0];
				chop $colF;
				#get $docsF (i.e. number of documents containing the collocate (for calculating idf))
				my ($command ) = "\@count (\"<doc>\"..\"</doc>\") >  \"$collocate\" \n";
                                my (@response) = wumpusResponse($wumpus, $command);
                                my $docsF = $response[0];
                                chop $docsF;

				#initialize variables
				my $idf = 0;
				my $tfidf = 0;
				my $MI = 0;
				my $Z = 0;
				my $X2 = 0;
				#calculate idf and tfidf
				if ($colF > 0){
					$idf = log ($bigN / $docsF);
					#print "IDF($collocate): $idf = log ($bigN / $docsF)\n";
					$tfidf = $idf * $count;
					#print "\tTFIDF($collocate):$tfidf = $idf * $count\n";
					print IDF "$idf\t$collocate\t$entityType\n";
					print TFIDF "$tfidf\t$collocate\t$entityType\n";
				}
				#calculate MI and Z
				my $jointProb = $JF / $corpus;
				my $MIdenominator = ($colF / $corpus) * ( $titleF / $corpus );
				my $ZstdDev = (( $colF * $titleF * $collocationSpan ) / $corpus );
				if ($MIdenominator > 0){
					if ($jointProb > 0){
						$MI = log2($jointProb / $MIdenominator );
						$Z = ( $JF - $ZstdDev ) / sqrt ($ZstdDev);
						print MI "$MI\t$collocate\t$entityType\n";
						print Z "$Z\t$collocate\t$entityType\n";
					}
				}

				#calculate chi-square
				my $a = $JF;
				my $b = $titleF - $JF;
				my $c = $colF - $JF;
				my $d = $corpus - $c - $b - 1;
				my $X2numerator = $corpus * ($a * $d - $c * $b)**2;
				my $X2denominator = ($a + $c) * ($a + $b) * ($c + $d) * ($b + $d);
				if ($X2denominator > 0){
					$X2 = $X2numerator / $X2denominator;
				}
				print CHI "$X2\t$collocate\t$entityType\n";
				#ALL structure: entityTFinTop50docs sumSentScore maxSentScore IDF TFIDF entityCorpusFrequency JF CHI Z MI entity entityType
				print ALL "$count\t$sumSentScore\t$maxSentScore\t$idf\t$tfidf\t$colF\t$JF\t$X2\t$Z\t$MI\t$collocate\t$entityType\n";
			#}
		}
	}
	close (IN);
	close (ALL);
	close (MI);	
	close (Z);
	close (CHI);
	close (TFIDF);
	close (IDF);

        my $sort = `sort -rg data/$topic/collocation-$collocationSpan/title/MI > data/$topic/collocation-$collocationSpan/title/MI-s`;
        my $sort = `sort -rg data/$topic/collocation-$collocationSpan/title/Z > data/$topic/collocation-$collocationSpan/title/Z-s`;
        my $sort = `sort -rg data/$topic/collocation-$collocationSpan/title/IDF > data/$topic/collocation-$collocationSpan/title/IDF-s`;
        my $sort = `sort -rg data/$topic/collocation-$collocationSpan/title/TFIDF > data/$topic/collocation-$collocationSpan/title/TFIDF-s`;
        my $sort = `sort -rg data/$topic/collocation-$collocationSpan/title/CHI > data/$topic/collocation-$collocationSpan/title/CHI-s`;

        my $mv = `mv data/$topic/collocation-$collocationSpan/title/MI-s data/$topic/collocation-$collocationSpan/title/MI`;
        my $mv = `mv data/$topic/collocation-$collocationSpan/title/Z-s data/$topic/collocation-$collocationSpan/title/Z`;
        my $mv = `mv data/$topic/collocation-$collocationSpan/title/IDF-s data/$topic/collocation-$collocationSpan/title/IDF`;
        my $mv = `mv data/$topic/collocation-$collocationSpan/title/TFIDF-s data/$topic/collocation-$collocationSpan/title/TFIDF`;
        my $mv = `mv data/$topic/collocation-$collocationSpan/title/CHI-s data/$topic/collocation-$collocationSpan/title/CHI`;


}



sub log2 {
 my $n = shift;
 return log($n)/log(2);	
}

sub cleanDiacritics {
        my $topic = $_[0];
        my $rm = `rm -rf docs/$topic/sentDocs`;
        my $mkdir = `mkdir docs/$topic/sentDocs`;

        open (IN, "junk-char.txt"); #load junk characters
        my $junk = <IN>;
        close (IN);
        opendir (THISDIR, "docs/$topic/cleanDocs") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        foreach my $docfile (@docfiles){
          open (OUT, ">docs/$topic/sentDocs/$docfile") or die "$!";
          open (IN, "docs/$topic/cleanDocs/$docfile") or die "$!";
          while (my $in = <IN>){
                chomp $in;
                $in =~ s/$junk//g;
		$in =~ s/è/e/g;
		$in =~ s/¢/ cent/g;
                $in =~ s/(\[|\])//g;
                $in =~ s/,+/, /g;
                $in =~ s/(,\s+)+/, /g;
                $in =~ s/(\.\s*,)+/. /g;
                $in =~ s/(,\s*\.)+/. /g;
                $in =~ s/^\s*,//;
                $in =~ s/\s+/ /g;
                $in =~ s/^\s+//;
		  if ($in !~ /[.,;!?]$/)
		  {
		 	$in = $in . " .";
		  }
                if ($in =~ /[a-zA-Z]/){
                        print OUT "$in\n\n";
                }
          }
          close (IN);
          close (OUT);
          my $breaksent = `./breaksent-multi-3.pl docs/$topic/sentDocs/$docfile`;
          open (OUT, ">docs/$topic/temp") or die $!;
          open (IN, "docs/$topic/sentDocs/$docfile") or die $!;
          while (my $in = <IN>){
                chomp $in;
                if ($in =~ /[a-zA-Z]/){
                        print OUT "$in\n";
                }
          }
          close (OUT);
          close (IN);
          my $mv = `mv docs/$topic/temp docs/$topic/sentDocs/$docfile`;
        }
}

sub getWindows {
	my $topic = $_[0];
	my $title = $_[1];
	my $threshold = $_[2];
	my $extractionMode = $_[3];
	my $maxSentLength = $_[4];
	my @titles = split / /, $title;
	my $mkdir = `mkdir windows`;
        my $mkdir = `mkdir windows/$topic`;
        my $mkdir = `mkdir windows/$topic/windows`;

        opendir (THISDIR, "docs/$topic/sentDocs") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;

        foreach my $docfile (@docfiles){
		my @sentences = ();
		my %selected = ();
        	my %selectedContent = ();
 		open (IN, "docs/$topic/sentDocs/$docfile") or die "$!";
		while (my $in = <IN>){
		      chomp $in;
		      push @sentences, "<docRank:" . $docfile . "> " . $in;
		}
		close (IN);
	
		my @sentenceLength = ();
		for (my $a=0; $a<@sentences; $a++){
			my $sent = $sentences[$a];
			my @sentWords = split / /, $sent;
			my $sentLength = scalar (@sentWords);
			$sentenceLength[$a] = $sentLength - 1;
		}
		foreach my $titleWord (@titles){
			my %writtenSent = (); #written sentences matching query term occurrences
			my %sentenceLength = ();
			for (my $a=0; $a<@sentences; $a++){
				#current sentence
				my $sent = $sentences[$a];
				my $match = matchQueryWithSentence ($titleWord, $sent);
				if ($match == 1){
					if (exists $writtenSent{$a}){
						#already extracted
					}else{
						if ($sentenceLength[$a] <= $maxSentLength){
							$selected{$a}++;
							$selectedContent{$a} = $sent;
							$writtenSent{$a} = 1;
						}
					}
				}
			}
		}
		my %printedSentences = ();
		open (OUT, ">windows/$topic/windows/$docfile") or die "$!";
		foreach my $key (keys %selected){
			if ($selected{$key} >= $threshold){
				if (exists($printedSentences{$key})){
					#do not write
				}else{
					print OUT "<match:$selected{$key}>$selectedContent{$key}\n";
					$printedSentences{$key} = 1;
				}
				if ($extractionMode == 3){
					#print preceeding sentence
					my $prevID = $key - 1;
					if (exists($printedSentences{$prevID})){
						#do not write
					}else{
						print OUT "<before:$selected{$key}>$sentences[$prevID]\n";
        	                		$printedSentences{$prevID} = 1;
					}
				#print following sentence
					my $nextID = $key + 1;
        	                        if (exists($printedSentences{$nextID})){
        	                        }else{  
        	                                print OUT "<after:$selected{$key}>$sentences[$nextID]\n";
        	                                $printedSentences{$nextID} = 1;
        	                        }
				}
	  		}
		}
		close (OUT);
	}
}

sub matchQueryWithSentence {
	my $title = $_[0];
	my $sent = $_[1];

	$title = lc($title);
	my $apostropheInTitle = 0;
	if ($title =~ /'s/){
		$apostropheInTitle = 1;
	}
	my @titleWords = split /\|/, $title;

	$sent = lc($sent);
	my @sentWords = split / /, $sent;
	
	my $match = 0;

	foreach my $sentWord (@sentWords){
		if ($sentWord =~ /\w/){
			$sentWord =~ s/^\W*(.+)$/$1/;
			$sentWord =~ s/\W*$//;
			if ($apostropheInTitle == 0){ #if there is no 's in title, remove it from the sentence words
				$sentWord =~ s/'s//g;
			}
			foreach my $titleWord (@titleWords){
				if ($titleWord eq $sentWord){
					$match = 1;
				}
			}
		}
	}
	return $match;
}

sub getNEs {
	my $topic = $_[0];
	my $type = $_[1];
	my $extractionMode = $_[2];
	my $title = $_[3];
	my %NEs = ();
	my %NEtags = ();
	my %NESentStats = ();
	my $mkdir = `mkdir data`;
	my $mkdir = `mkdir data/$topic`;
	my $rm = `rm data/$topic/NEs*`;
	open (OUT, "|sort -rn >data/$topic/NEs") or die "$!";
        opendir (THISDIR, "windows/$topic/taggedNE-windows") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        foreach my $docfile (@docfiles){
          open (IN, "windows/$topic/taggedNE-windows/$docfile") or die "$!";
	  my @sentences = ();
	  my $lastSentStatistic = "";
	  while (my $in = <IN>){
		chomp $in;
		push @sentences, $in;
	  }
	  close (IN);
	  foreach my $sentence (@sentences){
		#print "$sentence\n";
		my $sentMatchScore = $sentence;
		$sentMatchScore =~ s/^\<(.+?)\>\<docRank:(.+?)>.+$/$1:$2/;
		my ($sentType, $numMatchQtermsInSent, $bingRank) = split /:/, $sentMatchScore;
		$sentType =~ s/^(.).+$/$1/;
		my @elements = split /\]/, $sentence;
		foreach my $element (@elements){
			my ($pre, $post) = split /\[/, $element;
                        $post =~ s/\s+$//;
                        my $foundType = $post;
                        my $entity = $post;
                        $foundType =~ s/^(.+?)\s.+$/$1/;
                        $entity =~ s/^.+?\s(.+)$/$1/;
			$entity = cleanEntity($entity);
			$entity = lc($entity);
			my $valid = checkIfValid($entity, $title);
			if ($valid == 1){
				my $matchingEntityType = 0;
				if ($type =~ /person/){
					if ($foundType eq "PER"){
						$matchingEntityType = 1;
					}
				}
				if ($type =~ /product/){
					if ($foundType =~ /(ORG|MISC)/){
						$matchingEntityType = 1;
					}				
				}
				if ($type =~ /organization/){
					if ($foundType eq "ORG"){
						$matchingEntityType = 1;
					}
				}
				if ($type =~ /location/){
                                        if ($foundType eq "LOC"){
                                                $matchingEntityType = 1;
                                        }
                                }

				#if ($matchingEntityType == 1){
					$NEs{$entity}++;
					#record sentence statistiscs
					$NESentStats{$entity}[0] = $NESentStats{$entity}[0] + $numMatchQtermsInSent; #sum of sentence scores
					if ($numMatchQtermsInSent > $NESentStats{$entity}[1]){
						$NESentStats{$entity}[1] = $numMatchQtermsInSent; #maximum sentence score
					}
					#record entity types
					$NEtags{$entity}{$foundType}++;
				#}
			}
		}
	  }
	}
	#print out the entities
	
	foreach my $entity (keys %NEs){
		#NEs format: TF sumSentScores maxSentScore entity entityTypes with their frequencies (an entity may have several tags)
		#where: sumSentScores - sum of the numbers of matching query terms for all sentences containing the entity
		#maxSentScore - maximum number of matching query terms for all sentences containing the entity
		#sentType: m - matching query terms; b - sentence before; a - sentence after 
		print OUT "$NEs{$entity}\t$NESentStats{$entity}[0]\t$NESentStats{$entity}[1]\t$entity\t";
		my $allTypes = "";
		foreach my $type (keys %{ $NEtags{$entity} } ) {
			$allTypes = $allTypes . $type . " " . $NEtags{$entity}{$type} . "|";
		}
		chop $allTypes;
		print OUT "$allTypes\n";
	}
	close (OUT);
}

sub underscoreNEs {
	my $topic = $_[0];
	my $type = $_[1];
	my $extractionMode = $_[2];
	my $title = $_[3];
	my %NEs = ();
	my %NEtags = ();
	my %NESentStats = ();
	#load top TFIDF-ranked entities
	my %TFIDFentities = ();
	my $count = 0;
	open (IN, "data/$topic/collocation-100/title/TFIDF") or die $!;
	while (my $in = <IN>){
		chomp $in;
		my ($tfidf, $entity, $entityType) = split /\t/, $in;
		#print "$entity\n";
		if ($count < 1500){
			$entity =~ s/\s/_/g;
			$TFIDFentities{$entity} = $tfidf;
		}
		$count++;
	}
	close (IN);
	my $mkdir = `mkdir windows/$topic/underscoreNEs`;
	my $mkdir = `mkdir windows/$topic/entitiesBySent`;
        opendir (THISDIR, "windows/$topic/taggedNE-windows") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
	my %entitiesIndex = ();
        foreach my $docfile (@docfiles){
	  open (OUT, ">windows/$topic/underscoreNEs/$docfile") or die "$!";
	  open (ENT, ">windows/$topic/entitiesBySent/$docfile") or die "$!";
          open (IN, "windows/$topic/taggedNE-windows/$docfile") or die "$!";
	  my @sentences = ();
	  my $lastSentStatistic = "";
	  while (my $in = <IN>){
		chomp $in;
		push @sentences, $in;
	  }
	  close (IN);
	  my $sentNum = 0;
	  foreach my $sentence (@sentences){
		$sentNum++;
		$sentence =~ s/\s+/ /g;
		#print "$sentence\n";
		my @elements = split /\s/, $sentence;
		my $status = 0;
		my $newsentence = "";
		my $entities = "";
		for (my $a=0; $a<@elements; $a++){
			if ($elements[$a] =~ /\[\w+/){
				$status = 1;
			}elsif ($elements[$a] eq "]"){
				$status = 0;
				$newsentence = $newsentence . $elements[$a] . " ";
				$entities = $entities . $elements[$a] . " ";
			}else{
				if ($status == 1){
					$entities = $entities . $elements[$a] . "_";
					$newsentence = $newsentence . $elements[$a] . "_";
				}else{
					$newsentence = $newsentence . $elements[$a] . " ";
				}
			}	
		}
		$entities =~ s/_+$//;
		$entities =~ s/_+\]//g;
		$entities =~ s/_\s+/ /g;
		$entities =~ s/\s+$//;
		$newsentence =~ s/_\]//g;

		#clean entities
		my @entitiesAr = split / /, $entities;
		my $cleanEntities = "";
		foreach my $entity (@entitiesAr){
                        $entity = cleanEntity($entity);
                        $entity =~ s/_+/_/g;
			$entity =~ s/_\s*$//;
			$entity =~ s/_\s/ /g;
			$entity =~ s/\s_/ /g;
			$entity =~ s/^_//;
			$cleanEntities = $cleanEntities . $entity . " ";
		}
		$cleanEntities =~ s/\s+/ /g;
		$cleanEntities =~ s/\s$//;

		#filter entities by the top TFIDF-ranked entities
		my @cleanEntitiesAR = split / /, $cleanEntities;
		my $filteredEntities = "";
		my %filteredCleanEntitiesHash = ();
		foreach my $cleanEntity (@cleanEntitiesAR){
			my $LCentity = lc($cleanEntity);
			if (exists($TFIDFentities{$LCentity})){
				if (exists($filteredCleanEntitiesHash{$LCentity})){
				}else{
					$filteredEntities = $filteredEntities . $cleanEntity . " ";
					$filteredCleanEntitiesHash{$LCentity} = 1;
				}
			}
		}

		#print entities and sentences into the file used for parsing
		my $numEntities = scalar(keys %filteredCleanEntitiesHash);
		if ($numEntities > 1){
			$filteredEntities =~ s/\s+/ /g;
			$filteredEntities =~ s/\s$//;
			print ENT "$sentNum\t$filteredEntities\n";
                	print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n" . $newsentence . ".\n\n"; #this is needed so that we can extract the ID of the sentence from the parser output
		}

		#prepare the index of entities co-occurring in the same sentence
		foreach my $entity (keys %filteredCleanEntitiesHash){
			foreach my $collocateEntity (keys %filteredCleanEntitiesHash){
				if ($entity ne $collocateEntity){
					$entitiesIndex{$entity}{$collocateEntity} = $entitiesIndex{$entity}{$collocateEntity} + 1;
				}
			}
		}
	  }
	  #the following is dummy sentence ID at the end (needed for the getPaths subroutine)
	  $sentNum++;
	  print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n";
	  close (OUT);
	  close (ENT);
	}
	#print out the index of entities
	my $mkdir = `mkdir windows/$topic/entitiesIndex`;
	foreach my $entity ( keys %entitiesIndex ) {
     		open (OUT, "|sort -rn > windows/$topic/entitiesIndex/$entity");
     		for my $collocateEntity ( keys %{ $entitiesIndex{$entity} } ) {
         		print OUT "$entitiesIndex{$entity}{$collocateEntity}\t$collocateEntity\n";
     		}
		close (OUT);
 	}
	
}

sub getPaths {
	my $topic = $_[0];
	my $mkdir = `mkdir windows/$topic/pathsBetweenNEs`;
	opendir (THISDIR, "windows/$topic/entitiesBySent") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        my %entitiesIndex = ();
        foreach my $docfile (@docfiles){
	   #if ($docfile != 18){
		open (OUT, ">windows/$topic/pathsBetweenNEs/$docfile") or die $!;
		#read entities by sentence
		my %entities = ();
		open (IN, "windows/$topic/entitiesBySent/$docfile") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($sentID, $entityList) = split /\t/, $in;
			$entities{$sentID} = $entityList;
		}
		close (IN);
		#read parsed sentences
		open (IN, "windows/$topic/parsedWithNEs/$docfile") or die $!;
		%dependencyGraph = ();
		my %matchingEntities = ();
		my %sentEntities = ();
		my $sentID = 0;
		while (my $in = <IN>){
			chomp $in;
			if ($in =~ /ZZZZ/){
				if ($sentID > 0){ #if not the first sentence
					####process previous sentence
					#generate beginning and end points
					foreach my $key1 ( sort {$a<=>$b} keys %matchingEntities) {
						foreach my $key2 ( sort {$a<=>$b} keys %matchingEntities) {
							if ($key1 < $key2){
								$dependencyStart = $matchingEntities{$key1};
								$dependencyStop = $matchingEntities{$key2};
								#print "\t<START><KEY>$key1</KEY>$dependencyStart</START><END><KEY>$key2</KEY>$dependencyStop</END>\n";
								%candidatePaths = ();
								%candidatePathsFull = ();
								track($dependencyStart);
								#select the shortest path between key1 and key2
								my $shortestPath = "";
								my $shortestPathLength = 1000;
  								foreach my $key (keys %candidatePathsFull){
        								if ($candidatePathsFull{$key} < $shortestPathLength){
                								$shortestPath = $key;
                								$shortestPathLength = $candidatePathsFull{$key};
        								}
  								}
								#process the shortest path
								if ($shortestPathLength < 1000){
									#apply rules to check if it is a valid path (...can add more rules later)
									my $validPath = 1;
									#rule 1: path is not valid if it only consists of one conj_and relation
									if ($shortestPathLength == 1){
										if ($shortestPath =~ /conj_and/){
											$validPath = 0;
										#}elsif ($shortestPath =~ /dep/){
                                                                                #        $validPath = 0;
										}
									}
									###end of validation rules
									#print the shortest path
									if ($validPath == 1){
										#print OUT "\t\t" . "<NUMRELS>" . $shortestPathLength . "</NUMRELS>" . $shortestPath . "\n"; #print the complete path
										#print OUT $candidatePaths{$shortestPath} . "\n"; #print only the beginning and end (tab-separated)
										print OUT $candidatePaths{$shortestPath} . "\t" . $shortestPath . "\n"; #print: Beginning \t End \t Complete Path
									}
  								}

							}
						}
					}
				}
				#clear all hashes and arrays from the previous sentence
				%matchingEntities = ();
				%dependencyGraph = ();
				%sentEntities = ();
				%entityPairsWithRelations = ();
				###

				$sentID = $in;
				$sentID =~ s/^root\(ROOT\-0,\sZZZZ(\d+)ZZZZ.+$/$1/;
				#print "<DOCID>$docfile</DOCID><SENTID>$sentID</SENTID>\n";
				my @currentSentEntities = split /\s/, $entities{$sentID};
				foreach my $entity (@currentSentEntities){
					$sentEntities{$entity} = 1;
				}
			}else{
				if ($in ne ""){
					#nn(student-3, Fergus-2)
					my $depRel = $in;
					$depRel =~ s/^(.+?)\(.+$/$1/;
					my $Args = $in;
					$Args =~ s/^.+?\((.+?),\s(.+?)\)$/$1$2/;
					my $arg1 = $1;
					my $arg2 = $2;
					$entityPairsWithRelations{$arg1}{$arg2} = " ->-" . $depRel . "->- ";
					$entityPairsWithRelations{$arg2}{$arg1} = " -<-" . $depRel . "-<- ";
					push @{ $dependencyGraph{$arg1} }, $arg2;
					push @{ $dependencyGraph{$arg2} }, $arg1;
					my ($word1, $id1) = split /\-/, $arg1;
					if (exists($sentEntities{$word1})){
						$matchingEntities{$id1} = $arg1;
					}
					my ($word2, $id2) = split /\-/, $arg2;
					if (exists($sentEntities{$word2})){
                                                $matchingEntities{$id2} = $arg2;
                                        }
				}
			}
		}
		close (IN);
		close (OUT);
	  #}
	}
}

sub track {
  my @path=@_;
  my $last=$path[-1];
  my $completePath = "";
  my $startANDend = "";
  my $numRels = 0;

  for my $next (@{$dependencyGraph{$last}}) {
    next if $next ~~ @path;
    if ($next eq $dependencyStop){
	my @newPath = ();
	push @newPath, @path,$dependencyStop;
	my $previous = "";
	my $previousNum = 0;
	my $print = 1;
	my $dependencyStart = "";
	foreach my $element (@newPath){
		my @temp = split /\-/, $element;
		my $number = pop (@temp);
		if ($previous ne ""){
			if ($number < $previousNum){
				$print = 0;
			}
			my $rel = $entityPairsWithRelations{$previous}{$element};
			$completePath = $completePath . $previous . $rel; #use if want to output the entire path
			$numRels++;
		}else{
			$dependencyStart = $element;
		}
		$previous = $element;
		$previousNum = $number;
	}
	$completePath = $completePath . $dependencyStop; #use if you want to output the entire path
	#enable the following if you want to output only the beginning and end of the path (without positional numbers)
		my $dependencyStartWithoutNum = $dependencyStart;
		$dependencyStartWithoutNum =~ s/\-\d+$//;
		my $dependencyStopWithoutNum = $dependencyStop;
		$dependencyStopWithoutNum =~ s/\-\d+$//;
		$startANDend = "$dependencyStartWithoutNum\t$dependencyStopWithoutNum";
	###
	if ($print == 1){
		$candidatePathsFull{$completePath} = $numRels;
		$candidatePaths{$completePath} = $startANDend;
		$startANDend = "";
		$completePath = "";
		$numRels = 0;
	}
    } else {
      track(@path,$next);
    }
  }
}

sub tagNEs {
        my $topic = $_[0];
        my $extractionMode = $_[1];
        my $rm = `rm -rf windows/$topic/taggedNE-windows`;
        my $mkdir = `mkdir windows/$topic/taggedNE-windows`;
        opendir (THISDIR, "docs/$topic/sentDocs/") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        foreach my $docfile (@docfiles){
#                my $NEtagger = `java -classpath LBJ2.jar:LBJ2Library.jar:LbjNerTagger.jar -Xmx2000m LbjTagger.NerTagger -annotate $tempDir/$topic/windows/$docfile $tempDir/$topic/taggedNE-windows/$docfile true Config/allFeaturesBigTrainingSet.config`;
		my $NEtagger = `java -classpath LBJ2.jar:LBJ2Library.jar:LbjNerTagger.jar -Xmx2000m LbjTagger.NerTagger -annotate docs/$topic/sentDocs/$docfile windows/$topic/taggedNE-windows/$docfile true Config/allLayer1.config`;
        }
}

sub loadQueries {
	my %queries = ();
	open (IN, "queries.txt") or die "$!";
	while (my $in = <IN>){
		chomp $in;
		my ($topic, $text) = split /:/, $in;
		$queries{$topic} = $text;
	}
	close (IN);
	return %queries;
}
sub loadMLLIDs {
	my %MLL_IDs = ();
	open (IN, "MLL-IDs.txt") or die "$!";
	while (my $in = <IN>){
		chomp $in;
		#my ($topic, $text) = split /:/, $in;
		my $topic = $in;
		$MLL_IDs{$topic} = 1;
		my $mkdir = `mkdir docs/$topic/`;
		$mkdir = `mkdir docs/$topic/sentDocs/`;
	}
	close (IN);
	return %MLL_IDs;
}
sub loadQueriesSingle {
	my %queries = ();
	open (IN, "queries-single.txt") or die "$!";
	while (my $in = <IN>){
		chomp $in;
		my ($topic, $text) = split /:/, $in;
		$queries{$topic} = $text;
	}
	close (IN);
	return %queries;
}

sub loadQueriesforWindowExtraction {
        my %queries = ();
        open (IN, "queries-for-window-extraction.txt") or die "$!";
        while (my $in = <IN>){
                chomp $in;
                my ($topic, $text) = split /:/, $in;
                $queries{$topic} = $text;
        }
        close (IN);
        return %queries;
}

sub loadQueriesforCollocation {
        my %queries = ();
        open (IN, "queries-for-collocation.txt") or die "$!";
        while (my $in = <IN>){
                chomp $in;
                my ($topic, $text) = split /:/, $in;
                $queries{$topic} = $text;
        }
        close (IN);
        return %queries;
}


sub loadTitles {
	my %titles = ();
	my $count = 1;
	open (IN, "titles.txt") or die "$!";
	while (my $in = <IN>){
		chomp $in;
		$in =~ s/\<entity_name\>(.+)\<\/entity_name\>/$1/;
		$titles{$count} = $in;
		$count++;
	}
	close (IN);
	return %titles;
}

sub loadEntityTypes {
	my %types = ();
	my $count = 1;
	open (IN, "entity-type.txt") or die "$!";
	while (my $in = <IN>){
		chomp $in;
		$in =~ s/\<target_entity\>(.+)\<\/target_entity\>/$1/;
		$types{$count} = $in;
		$count++;
	}
	close (IN);
	return %types;	
}

sub loadStopwords{
	my %stoplist = ();
	open (IN, "stoplist") or die "$!";
	while (my $in=<IN>){
		chomp $in;
		$stoplist{$in} = 1;
	}
	close(IN);
	return %stoplist;
}

sub cleanEntity {
	my $entity = $_[0];
	$entity =~ s/(\#|,|;|\\|\/|\||\?|!|:|\$|\@|\*|\(|\)|\"|\+|\`)/ /g;
	$entity =~ s/\&/_ampersand_/g;
	$entity =~ s/\s+/ /g;
	$entity =~ s/^\s+//;
	$entity =~ s/\s+$//;
	$entity =~ s/\W+$//;
	$entity =~ s/^\W+//;
	$entity =~ s/_+$//;
#	$entity = lc($entity);
	return $entity;
}

sub checkIfValid {
	my $entity = $_[0];
	my $title = $_[1];
	my $valid = 1;
	#check if entity is a stopword
	if (exists($stopwords{$entity})){
		$valid = 0;
	}
	#check if it is a title
	$title = lc($title);
	if ($entity =~ /$title/){
		$valid = 0;
	}
	#check if it contains at least one letter
	if ($entity !~ /[a-z]/){
		$valid = 0;
	}
	return $valid;
}

sub numerically { $a <=> $b };

sub getTopBingDocsTexts {
        my $topic = $_[0];
        my $numDocs = $_[1];
        #my $mkdir = `mkdir docs`;
        my $mkdir = `mkdir docs/$topic`;
        my $mkdir = `mkdir docs/$topic/html`;
        my $mkdir = `mkdir docs/$topic/cleanDocs`;
        print "<TOPIC>$topic\n";
        my $fileNum = 0;
        open (URL, "BingTopDocs-$numDocs/$topic") or die "$!";
        while (my $url = <URL>){
	#while ($fileNum < $numDocs){
                chomp $url;
                $fileNum++;
		#if ($fileNum == 5 || $fileNum == 34){
                $url =~ s/[\r|\n]//g;
                my $htmlfile = "docs/$topic/html/$fileNum";
                my $cleanfile = "docs/$topic/cleanDocs/$fileNum";
                my $command = "wget -t 5 -O - '" . $url . "' > $htmlfile";
                print "$command\n";
                my $wget = `$command`;
                open (OUT, ">$cleanfile") or die "can't open $cleanfile";
                open (IN, "$htmlfile") or print "File not found: $htmlfile";
                my $str = "";
                my $init = 0;
                while (my $in = <IN>){
                        chomp $in;
                        $in =~ s/[\r|\n]//g;
                        $in =~ s/\t/ /g;        # Remove all tabs.
                        $in =~ s/[ ]+/ /g;      # Remove all duplicate spaces.
                        $in =~ s/^[ ]*//g;      # Remove all leading spaces.
                        $in =~ s/[ ]*$//g;      # Remove all trailing spaces.
			
#			if ($in =~ /\w$/)
#			if ($in !~ /[\.|\,|\!|\?|\:|\;]+$/)
#			{
#				$in = $in . " .";
#			}
                    $str = $str . " " . $in;
                }
                my $cleanText = cleanDoc ($str);
#	         if ($cleanText =~ /[\w+]$/)
#		  {
#			print ">>>>> $cleanText <<<<  ";

#			print "bingo $topic -> $fileNum !!!!!! \n";
#			$cleanText = $cleanText . " **********";
#		  }
                print OUT "$cleanText\n";
                close (IN);
                close (OUT);
        }
	#}
        close (URL);
}
sub getTopDocTexts { #top 50 docs are retrieved from Bing by a separate script (written by Kaheer) -- 22/08/2012
	my $topic = $_[0];
	my $numDocs = $_[1];
	my $mkdir = `mkdir docs`;
	my $mkdir = `mkdir docs/$topic`;
	#my $mkdir = `mkdir docs/$topic/html`; 
	my $mkdir = `mkdir docs/$topic/cleanDocs`;
	print "<TOPIC>$topic\n";
	for (my $fileNum=1; $fileNum<=$numDocs; $fileNum++){
		my $htmlfile = "docs/$topic/html/$fileNum";
		my $cleanfile = "docs/$topic/cleanDocs/$fileNum";
		open (OUT, ">$cleanfile") or die "can't open $cleanfile";
		open (IN, "$htmlfile") or print "File not found: $htmlfile";
		my $str = "";
		my $init = 0;
		while (my $in = <IN>){
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
	close (URL);
}

sub cleanMLL
{
        my $topic = $_[0];
        my $numDocs = $_[1];
	my $rm = `rm -rf Data/MyLifeList/cleanDocs`;
	my $mkdir = `mkdir Data/MyLifeList/cleanDocs`;
        #my $mkdir = `mkdir docs`;

	opendir (THISDIR, "Data/MyLifeList/docs/") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        foreach my $docfile (@docfiles)
	{
			open (IN, "Data/MyLifeList/docs/$docfile") or die "$!";
			open (OUT, ">Data/MyLifeList/cleanDocs/$docfile") or die "$!";
			
			
			my $init = 0;
			while (my $in = <IN>)
			{
				my $str = "";
				#print "Original: $in\n\n";
				chomp $in;
				$in =~ s/[\r|\n]//g;
				$in =~ s/\[//g;      # Remove all [[.
				$in =~ s/\]//g;      # Remove all [[.
				$in =~ s/"/ /g;
				#$in =~ s/'/ /g;
				$in =~ s/\t/ /g;        # Remove all tabs.
				$in =~ s/[ ]+/ /g;      # Remove all duplicate spaces.
				$in =~ s/^[ ]*//g;      # Remove all leading spaces.
				$in =~ s/[ ]*$//g;      # Remove all trailing spaces.


				
				$str = $str . " " . $in;
				
				#print "before: $str\n";
				my $cleanText = cleanDoc ($str);
				#print "after: $cleanText\n";
				
				print OUT "$cleanText\n";
			}

			close (IN);
			close (OUT);
		
	}
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


sub oneSentperLine {
	my $topic = $_[0];
	
	my $mkdir = `mkdir windows/$topic/SentperLineDocs`;
	opendir (THISDIR, "windows/$topic/taggedNE-windows/") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        foreach my $docfile (@docfiles){
		open (IN, "windows/$topic/taggedNE-windows/$docfile") or die "$!";
		open (OUT, ">windows/$topic/SentperLineDocs/$docfile") or die "$!";
		my @sentences = ();
		#	  my $lastSentStatistic = "";
		while (my $in = <IN>){
		      chomp $in;
		      push @sentences, $in;
		}
		close (IN);
		my $sentNum = 0;
		foreach my $sentence (@sentences){
		      $sentNum++;
		      $sentence =~ s/\s+/ /g;
		      #print "$sentence\n";
		      my @elements = split /\s/, $sentence;
		      my $status = 0;
		      my $newsentence = "";
		      my $entities = "";
		      for (my $a=0; $a<@elements; $a++){
			      if ($elements[$a] =~ /\[\w+/){
				      $status = 1;
			      }elsif ($elements[$a] eq "]"){
				      $status = 0;
		#		      $newsentence = $newsentence . " ";
		#			$entities = $entities . $elements[$a] . " ";
			      }else{
		#				if ($status == 1){
		#					$entities = $entities . $elements[$a] . "_";
		#					$newsentence = $newsentence . $elements[$a] . "_";
		#				}else{
					      $newsentence = $newsentence . $elements[$a] . " ";
		#				}
			      }
			     
		      }
		      print OUT $newsentence . "\n";
		}
	}
}

sub wikifier{
	my $topic = $_[0];
#        my $extractionMode = $_[1];
        my $rm = `rm -rf windows/$topic/taggedPhrases-wikifier`;
        my $mkdir = `mkdir windows/$topic/taggedPhrases-wikifier`;
        opendir (THISDIR, "windows/$topic/taggedNE-windows/") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        foreach my $docfile (@docfiles){
#		my $wikifier = `java -Xmx8g -classpath ./Wikifier/Wikifier.jar:./Wikifier/lib/edison-0.2.9.jar:./Wikifier/lib/jwnl.jar:./Wikifier/lib/curator-interfaces.jar:./Wikifier/lib/hadoop-0.17.0-core.jar:./Wikifier/lib/LbjNerTagger.jar:./Wikifier/lib/log4j-1.2.13.jar:./Wikifier/lib/commons-cli-1.2.jar:./Wikifier/lib/LBJChunk.jar:./Wikifier/lib/LBJ2.jar:./Wikifier/lib/secondstring-20060615.jar:./Wikifier/lib/lucene-core-2.4.1.jar:./Wikifier/lib/slf4j-simple-1.5.8.jar:./Wikifier/lib/LBJ2Library.jar:./Wikifier/lib/commons-logging-1.1.1.jar:./Wikifier/lib/liblinear-1.5-with-deps.jar:./Wikifier/lib/commons-lang-2.4.jar:./Wikifier/lib/Wikifier.jar:./Wikifier/lib/commons-collections-3.2.1.jar:./Wikifier/lib/commons-configuration-1.5.jar:./Wikifier/lib/slf4j-api-1.5.8.jar:./Wikifier/lib/lingpipe-4.0.1.jar:./Wikifier/lib/LBJPOS.jar:./Wikifier/lib/Jama-1.0.2.jar:./Wikifier/lib/coreUtilities-0.1.1.jar:./Wikifier/lib/libthrift.jar:./Wikifier/lib/protobuf-java-2.3.0.jar CommonSenseWikifier.ReferenceAssistant -annotateData windows/$topic/SentperLineDocs/$docfile windows/$topic/taggedPhrases-wikifier/$docfile false Config/Demo_Config_Deployed`;
		my $wikifier = `java -Xmx8g -classpath /home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/dist/Wikifier.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/edison-0.2.9.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/jwnl.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/curator-interfaces.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/hadoop-0.17.0-core.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/LbjNerTagger.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/log4j-1.2.13.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/commons-cli-1.2.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/LBJChunk.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/LBJ2.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/secondstring-20060615.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/lucene-core-2.4.1.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/slf4j-simple-1.5.8.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/LBJ2Library.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/commons-logging-1.1.1.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/liblinear-1.5-with-deps.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/commons-lang-2.4.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/commons-collections-3.2.1.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/commons-configuration-1.5.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/slf4j-api-1.5.8.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/lingpipe-4.0.1.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/LBJPOS.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/Jama-1.0.2.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/coreUtilities-0.1.1.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/libthrift.jar:/home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Code/lib/protobuf-java-2.3.0.jar CommonSenseWikifier.ReferenceAssistant -annotateData /home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/windows/1/input /home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/windows/1/output false /home/bsarrafzadeh/OpenIE/InsightNG/all-sentences/Wikifier/Wikifier_ACL2011_Package/Config/Demo_Config_Deployed`;

        }
}

sub underscoreEs { # a modified version of underscoreNEs for entities extracted by Wikifier
	my $topic = $_[0];
	my $type = $_[1];
	my $extractionMode = $_[2];
	my $title = $_[3];
	my %Es = ();
#	my %NEtags = ();
#	my %NESentStats = ();
	#load top TFIDF-ranked entities
	my %TFIDFentities = ();
	my $count = 0;
	open (IN, "data/$topic/TFIDF") or die $!;
	while (my $in = <IN>){
		chomp $in;
		my ($tfidf, $entity, $entityType) = split /\t/, $in;
		#print "$entity\n";
		if ($count < 1500){
			$entity =~ s/\s/_/g;
			$TFIDFentities{$entity} = $tfidf;
		}
		$count++;
	}
	close (IN);
	my $mkdir = `mkdir windows/$topic/underscoreEs`;
	my $mkdir = `mkdir windows/$topic/wiki-entitiesBySent`;
        opendir (THISDIR, "windows/$topic/taggedPhrases-wikifier") or die "$!";
        #my @docfiles = grep !/^\./, readdir THISDIR;
	my @docfiles = grep /\.html$/, readdir THISDIR;
        closedir THISDIR;
	my %entitiesIndex = ();
        foreach my $docfile (@docfiles)
	{
	  my $docfile_out = $docfile;
	  $docfile_out =~ s/\..*//;
	  open (OUT, ">windows/$topic/underscoreEs/$docfile_out") or die "$!";
	  open (ENT, ">windows/$topic/wiki-entitiesBySent/$docfile_out") or die "$!";
          open (IN, "windows/$topic/taggedPhrases-wikifier/$docfile") or die "$!";
	  my @sentences = ();
	  my $lastSentStatistic = "";
	  while (my $in = <IN>){
		chomp $in;
		push @sentences, $in;
	  }
	  close (IN);
# 	smaple sentence:
#	the removal of  <a href="http://en.wikipedia.org/wiki/Price_controls">price controls</a>   ,  <a href="http://en.wikipedia.org/wiki/Foreign_exchange_controls">foreign exchange controls</a>   and
	  my $sentNum = 0;
	  
	  foreach my $sentence (@sentences)
	  {
		$sentNum++;
		$sentence =~ s/\s+/ /g;
		
		my $newsentence = "";
		
		my $entities = "";
		
		print "Sentence # $sentNum: $sentence\n";
		while ($sentence =~ m%([^<]*)<a href="http://en.wikipedia.org/wiki/([^"]+)">([^<]+)</a>([^<]*)%g)
		{
			print "text1: $1\n";
			print "matched phrase: $3\n";
			my @elements = split ' ', $3;
			my $underlinedEntity = $elements[0];
			for (my $a = 1; $a < @elements; $a++)
			{
				$underlinedEntity = $underlinedEntity . '_' . $elements[$a];
			}
			print "underlined entity: $underlinedEntity\n\n";
			print "text2: $4\n";
			
			$entities = $entities . $underlinedEntity . " ";
			$newsentence = $newsentence . ' ' . $1 . ' ' . $underlinedEntity . ' ' . $4;
		}
		print "new sentence ... \n$newsentence\n";
		print "before cleaning ... \n$sentNum\t$entities\n";
#		#print "$sentence\n";
#		#my @elements = split /'<a href="http:\/\/en.wikipedia.org\/wiki\/'/, $sentence;
#		my $status = 0;
#		my $newsentence = "";
#		my $entities = "";
#		for (my $a=0; $a<@elements; $a++){
##			if ($elements[$a] =~ /\[\w+/){
#			if ($element[$a] =~ /href="http:\/\/en.wikipedia.org/wiki\//)
#				$status = 1;
#			}elsif ($elements[$a] eq "]"){
#				$status = 0;
#				$newsentence = $newsentence . $elements[$a] . " ";
#				$entities = $entities . $elements[$a] . " ";
#			}else{
#				if ($status == 1){
#					$entities = $entities . $elements[$a] . "_";
#					$newsentence = $newsentence . $elements[$a] . "_";
#				}else{
#					$newsentence = $newsentence . $elements[$a] . " ";
#				}
#			}	
#		}
		$entities =~ s/_+$//;
		$entities =~ s/_+\]//g;
		$entities =~ s/_\s+/ /g;
		$entities =~ s/\s+$//;
		$newsentence =~ s/_\]//g;
		$newsentence =~ s/^\s+//;
		$newsentence =~ s/\s+/ /g;

		#clean entities
		my @entitiesAr = split / /, $entities;
		my $cleanEntities = "";
		my $entID = 1;
		foreach my $entity (@entitiesAr)
		{
                        $entity = cleanEntity($entity);
                        $entity =~ s/_+/_/g;
			$entity =~ s/_\s*$//;
			$entity =~ s/_\s/ /g;
			$entity =~ s/\s_/ /g;
			$entity =~ s/^_//;
			$cleanEntities = $cleanEntities . $entity . " ";
			#$Es{$entity} = $entID;
			#$entID++;
		}
		$cleanEntities =~ s/\s+/ /g;
		$cleanEntities =~ s/\s$//;
		
		@entitiesAr = split / /, $cleanEntities;
		my $numEntities = @entitiesAr;
		my %hashEs = ();
		#@hashEs{@entitiesAr} = ();
		my @uniqueEs = keys %hashEs;
		
		
		#if ($numEntities > 0)
		#{
		#	print "after cleaning ... \n$sentNum\t$cleanEntities\n";
		#	print ENT "$sentNum\t";
		#
		#	for (@entitiesAr)
		#	{
		#		$hashEs{lc($_)} = 0;
		#	}
		#	print "unique entities\n";
		#	foreach my $e (@entitiesAr)
		#	{
		#		if ($hashEs{lc($e)} == 0)
		#		{
		#			$hashEs{lc($e)} = 1;
		#			print ENT "$e ";
		#		}
		#	}
		#	print "\n\n";
		#	print ENT "\n";
		#	
		#	print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n" . $newsentence . ".\n\n"; #this is needed so that we can extract the ID of the sentence from the parser output
		#	
		#	#print ENT "$sentNum\t$cleanEntities\n";
		#}

		#filter entities by the top TFIDF-ranked entities
		my @cleanEntitiesAR = split / /, $cleanEntities;
		my $filteredEntities = "";
		my %filteredCleanEntitiesHash = ();
		foreach my $cleanEntity (@cleanEntitiesAR){
			my $LCentity = lc($cleanEntity);
			if (exists($TFIDFentities{$LCentity})){
				if (exists($filteredCleanEntitiesHash{$LCentity})){
				}else{
					$filteredEntities = $filteredEntities . $cleanEntity . " ";
					$filteredCleanEntitiesHash{$LCentity} = 1;
				}
			}
		}

		#print entities and sentences into the file used for parsing
		my $numEntities = scalar(keys %filteredCleanEntitiesHash);
		if ($numEntities > 1){
			$filteredEntities =~ s/\s+/ /g;
			$filteredEntities =~ s/\s$//;
			print ENT "$sentNum\t$filteredEntities\n";
                	print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n" . $newsentence . ".\n\n"; #this is needed so that we can extract the ID of the sentence from the parser output
		}
#
#		#prepare the index of entities co-occurring in the same sentence
#		foreach my $entity (keys %filteredCleanEntitiesHash){
#			foreach my $collocateEntity (keys %filteredCleanEntitiesHash){
#				if ($entity ne $collocateEntity){
#					$entitiesIndex{$entity}{$collocateEntity} = $entitiesIndex{$entity}{$collocateEntity} + 1;
#				}
#			}
#		}
		#if ($numEntities > 0)
		#{
		#	print ENT "$sentNum\t$cleanEntities\n";
		#}
	  }
	  ##the following is dummy sentence ID at the end (needed for the getPaths subroutine)
	  #$sentNum++;
	  #print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n";
	  close (OUT);
	  close (ENT);
	}
#	#print out the index of entities
#	my $mkdir = `mkdir windows/$topic/entitiesIndex`;
#	foreach my $entity ( keys %entitiesIndex ) {
#     		open (OUT, "|sort -rn > windows/$topic/entitiesIndex/$entity");
#     		for my $collocateEntity ( keys %{ $entitiesIndex{$entity} } ) {
#         		print OUT "$entitiesIndex{$entity}{$collocateEntity}\t$collocateEntity\n";
#     		}
#		close (OUT);
# 	}
	
}
sub getEs { # a modified version of getNEs for entities extracted by Wikifier
	my $topic = $_[0];
	my $type = $_[1];
	my $extractionMode = $_[2];
	my $title = $_[3];
	my %Es = ();
	my %hashterm;
	my %sorted;
	my $mkdir = `mkdir data`;
	my $mkdir = `mkdir data/$topic`;
	my $rm = `rm data/$topic/Es*`;
	open (OUT, "|sort -rn >data/$topic/Es") or die "$!";
#	open (IDF, ">data/$topic/title/IDF") or die "$!";
#	open (TFIDF, ">data/$topic/title/TFIDF") or die "$!";
       opendir (THISDIR, "windows/$topic/taggedPhrases-wikifier") or die "$!";
       #my @docfiles = grep !/^\./, readdir THISDIR;
	my @docfiles = grep /\.html$/, readdir THISDIR;
        closedir THISDIR;
	my %entitiesIndex = ();
        foreach my $docfile (@docfiles)
	{
		my $docfile_out = $docfile;
		$docfile_out =~ s/\..*//;
		open (IN, "windows/$topic/taggedPhrases-wikifier/$docfile") or die "$!";
		my @sentences = ();
		my $lastSentStatistic = "";
		while (my $in = <IN>)
		{
			chomp $in;
			push @sentences, $in;
		}
		close (IN);
	# 	smaple sentence:
	#	the removal of  <a href="http://en.wikipedia.org/wiki/Price_controls">price controls</a>   ,  <a href="http://en.wikipedia.org/wiki/Foreign_exchange_controls">foreign exchange controls</a>   and
		my $sentNum = 0;
		  
		my $entities = "";
		foreach my $sentence (@sentences)
		{
			$sentNum++;
			$sentence =~ s/\s+/ /g;
			
			#print "Sentence # $sentNum: $sentence\n";
			while ($sentence =~ m%([^<]*)<a href="http://en.wikipedia.org/wiki/([^"]+)">([^<]+)</a>([^<]*)%g)
			{
				#print "text1: $1\n";
				#print "matched phrase: $3\n";
				my @elements = split ' ', $3;
				my $underlinedEntity = $elements[0];
				for (my $a = 1; $a < @elements; $a++)
				{
					$underlinedEntity = $underlinedEntity . '_' . $elements[$a];
				}
				#print "underlined entity: $underlinedEntity\n\n";
				#print "text2: $4\n";
				
				$entities = $entities . $underlinedEntity . " ";
			}
			#print "new sentence ... \n$newsentence\n";
			#print "before cleaning ... \n$sentNum\t$entities\n";
			#print "$sentence\n";
		}
		$entities =~ s/_+$//;
		$entities =~ s/_+\]//g;
		$entities =~ s/_\s+/ /g;
		$entities =~ s/\s+$//;
	
		#clean entities
		my @entitiesAr = split / /, $entities;
		my $cleanEntities = "";
		my $entID = 1;
		foreach my $entity (@entitiesAr)
		{
			$entity = cleanEntity($entity);
			$entity =~ s/_+/_/g;
			$entity =~ s/_\s*$//;
			$entity =~ s/_\s/ /g;
			$entity =~ s/\s_/ /g;
			$entity =~ s/^_//;
			$cleanEntities = $cleanEntities . $entity . " ";
			
			#if (exists $hashterm{lc($entity)} && !defined $hashterm{lc($entity)}) # the entity is not in the hash yet.
			if ($hashterm{lc($entity)}{freq} < 1)
			{
				$hashterm{lc($entity)}{freq} = 1; 
				print "**** seeing the entity $entity for the first time !!!\n";

			}
			elsif ($hashterm{lc($entity)}{freq} >= 1)
			{
				$hashterm{lc($entity)}{freq}++;
				print "**** seeing the entity $entity for $hashterm{lc($entity)}{freq} times !!!\n";

			}
			#$Es{$entity} = $entID;
			#$entID++;
		}
		$cleanEntities =~ s/\s+/ /g;
		$cleanEntities =~ s/\s$//;
	}
	#print out the entities
	
	foreach my $entity (keys %hashterm){
		#Es format: TF	entity 
		print OUT "$hashterm{lc($entity)}{freq}\t$entity\n";
		print "$entity\t$hashterm{lc($entity)}{freq}\n";
	}
	close (OUT);
}
sub combineEntities{
	my $topic = $_[0];
	#my $type = $_[1];
	
	my $mkdir = `mkdir windows/$topic/underscoreEs_merged`;
       opendir (THISDIR, "windows/$topic/underscoreEs") or die "$!";
       my @docfiles1 = grep !/^\./, readdir THISDIR;
	closedir THISDIR;
	opendir (THISDIR, "windows/$topic/underscoreNEs") or die "$!";
	my @docfiles2 = grep !/^\./, readdir THISDIR;
	closedir THISDIR;
	
	foreach my $docfile1 (@docfiles1)
	{
		open (OUT, ">windows/$topic/underscoreEs_merged/$docfile1") or die "$!";
		open (IN, "windows/$topic/underscoreEs/$docfile1") or die "$!";
	  
		my @sentences1 = ();
		while (my $in = <IN>){
			chomp $in;
			push @sentences1, $in;
		}
		close (IN);
		
		open (IN, "windows/$topic/underscoreNEs/$docfile1") or die "$!";
		my @sentences2 = ();
		while (my $in = <IN>){
			chomp $in;
			push @sentences2, $in;
		}
		close (IN);

# 		smaple sentence:
#		ZZZZ2ZZZZ.
#		- - Select - - , TradeInvest South_Africa , TradeInvest Nigeria
		my $sentence1;
		my $sentence2;
		my ($sentNum1, $sentNum2);
		my ($i, $j, $k1, $k2);
		$i = $j = 0;
		while ($i < @sentences1)
		{
			$sentNum1 = $sentences1[$i];
			$sentNum1 =~ s/ZZZZ//;
			$sentNum2 = $sentences2[$j];
			$sentNum2 =~ s/ZZZZ//;
			
			$i += 2; #skip the blank line
			$j += 2;
			while ($sentNum1 != $sentNum2)
			{
				while ($sentNum1 < $sentNum2)
				{
					print OUT "ZZZZ" . $sentNum1 . "ZZZZ.\n\n";
					$sentence1 = $sentences1[$i];
					$sentence1 =~ s/\s+/ /g;
					print OUT "$sentence1\n\n";
					
					$i += 2;
					$sentNum1 = $sentences1[$i];
					$sentNum1 =~ s/ZZZZ//;
					
					$i += 2;
				}
				while ($sentNum1 > $sentNum2)
				{
					print OUT "ZZZZ" . $sentNum2 . "ZZZZ.\n\n";
					$sentence2 = $sentences2[$j];
					$sentence2 =~ s/\s+/ /g;
					print OUT "$sentence2\n\n";
					
					$j += 2;
					$sentNum2 = $sentences2[$j];
					$sentNum2 =~ s/ZZZZ//;
					
					$j += 2;
				}
			}
			while ($sentNum1 == $sentNum2) # both NER and Wikifier tagged the same sentence --> tagged phrases should be merged.
			{
				my ($ii, $jj);
				$ii = $jj = 0;
				
				print OUT "ZZZZ" . $sentNum1 . "ZZZZ.\n\n";
				
				$i += 2;
				$j += 2;
				
				$sentence1 = $sentences1[$i];
				$sentence1 =~ s/\s+/ /g;
				my @words1 = split ' ', $sentence1; 
				
				$sentence2 = $sentences2[$j];
				$sentence2 =~ s/\s+/ /g;
				my @words2 = split ' ', $sentence2;
				
				print "$words1[$ii] --- $words2[$jj]\n";
				while ($words1[$ii] == $words2[$jj])
				{
					print OUT "$words1[$ii] ";
					$ii++;
					$jj++;
				}
				print "$words1[$ii] --- $words2[$jj]\n";
				while ($ii < @words1 && $jj < @words2)
				{
					if ($words1[$ii] =~ /_/)
					{
						$k1 = $k2 = 0;
						my ($w1, $w2) = "";
						my @elements1 = split '_', $words1[$ii];
						my @elements2 = split '_', $words2[$jj];
						
						if (@elements1 > @elements2)
						{
							print "E is longer: @elements1 --- @elements2\n";
							while ($k1 < @elements1)
							{
								while ($k2 < @elements2 && $elements1[$k1] eq $elements2[$k2])
								{
									$w1 = $w1 . $elements1[$k1] . ' ';
									$w2 = $w2 . $elements2[$k2] . ' ';
									$k1++;
									$k2++;
								}
								$jj++;
								@elements2 = split '_', $words2[$jj];
								$k2 = 0;
							}
							print "$w1 --- $w2\n";
							if ($k1 == @elements1 && $w1 eq $w2)
							{
								print OUT "$words1[$ii] ";
								$ii++;
								$jj++;
							}
						}
						elsif (@elements1 < @elements2)
						{
							print "NE is longer: @elements1 --- @elements2\n";
							while ($k2 < @elements2)
							{
								while ($k1 < @elements1 && $elements2[$k2] eq $elements1[$k1])
								{
									$w1 = $w1 . $elements1[$k1] . ' ';
									$w2 = $w2 . $elements2[$k2] . ' ';
									$k1++;
									$k2++;
								}
								$ii++;
								@elements1 = split '_', $words1[$ii];
								$k1 = 0;
							}
							print "$w1 --- $w2\n";
							if ($k2 == @elements2 && $w1 eq $w2)
							{
								print OUT "$words2[$jj] ";
								$ii++;
								$jj++;
							}
						}
						
					}
					elsif ($words2[$jj] =~ '_')
					{
						$k1 = $k2 = 0;
						my ($w1, $w2) = "";
						my @elements1 = split '_', $words1[$ii];
						my @elements2 = split '_', $words2[$jj];
						
						if (@elements1 > @elements2)
						{
							while ($k1 < @elements1)
							{
								while ($k2 < @elements2 && $elements1[$k1] eq $elements2[$k2])
								{
									$w1 = $w1 . $elements1[$k1] . ' ';
									$w2 = $w2 . $elements2[$k2] . ' ';
									$k1++;
									$k2++;
								}
								$jj++;
								@elements2 = split '_', $words2[$jj];
								$k2 = 0;
							}
							if ($k1 == @elements1 && $w1 eq $w2)
							{
								print OUT "$words1[$ii] ";
								$ii++;
								$jj++;
							}
						}
						elsif (@elements1 < @elements2)
						{
							while ($k2 < @elements2)
							{
								while ($k1 < @elements1 && $elements2[$k2] eq $elements1[$k1])
								{
									$w1 = $w1 . $elements1[$k1] . ' ';
									$w2 = $w2 . $elements2[$k2] . ' ';
									$k1++;
									$k2++;
								}
								$ii++;
								@elements1 = split '_', $words1[$ii];
								$k1 = 0;
							}
							if ($k2 == @elements2 && $w1 eq $w2)
							{
								print OUT "$words2[$jj] ";
								$ii++;
								$jj++;
							}
						}
						
					}
				}
			}
			

		
				
		}
	}
	
	
	
	
}
sub getPaths_E {
	my $topic = $_[0];
	my $mkdir = `mkdir windows/$topic/pathsBetweenEs`;
	opendir (THISDIR, "windows/$topic/wiki-entitiesBySent") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        my %entitiesIndex = ();
        foreach my $docfile (@docfiles){
	   if ($docfile != 18){
		open (OUT, ">windows/$topic/pathsBetweenEs/$docfile") or die $!;
		#read entities by sentence
		my %entities = ();
		open (IN, "windows/$topic/wiki-entitiesBySent/$docfile") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($sentID, $entityList) = split /\t/, $in;
			$entities{$sentID} = $entityList;
		}
		close (IN);
		#read parsed sentences
		open (IN, "windows/$topic/parsedWithEs/$docfile") or die $!;
		%dependencyGraph = ();
		my %matchingEntities = ();
		my %sentEntities = ();
		my $sentID = 0;
		while (my $in = <IN>){
			chomp $in;
			if ($in =~ /ZZZZ/){
				if ($sentID > 0){ #if not the first sentence
					####process previous sentence
					#generate beginning and end points
					foreach my $key1 ( sort {$a<=>$b} keys %matchingEntities) {
						foreach my $key2 ( sort {$a<=>$b} keys %matchingEntities) {
							if ($key1 < $key2){
								$dependencyStart = $matchingEntities{$key1};
								$dependencyStop = $matchingEntities{$key2};
								#print "\t<START><KEY>$key1</KEY>$dependencyStart</START><END><KEY>$key2</KEY>$dependencyStop</END>\n";
								%candidatePaths = ();
								%candidatePathsFull = ();
								track($dependencyStart);
								#select the shortest path between key1 and key2
								my $shortestPath = "";
								my $shortestPathLength = 1000;
  								foreach my $key (keys %candidatePathsFull){
        								if ($candidatePathsFull{$key} < $shortestPathLength){
                								$shortestPath = $key;
                								$shortestPathLength = $candidatePathsFull{$key};
        								}
  								}
								#process the shortest path
								if ($shortestPathLength < 1000){
									#apply rules to check if it is a valid path (...can add more rules later)
									my $validPath = 1;
									#rule 1: path is not valid if it only consists of one conj_and relation
									if ($shortestPathLength == 1){
										if ($shortestPath =~ /conj_and/){
											$validPath = 0;
										#}elsif ($shortestPath =~ /dep/){
                                                                                #        $validPath = 0;
										}
									}
									###end of validation rules
									#print the shortest path
									if ($validPath == 1){
										#print OUT "\t\t" . "<NUMRELS>" . $shortestPathLength . "</NUMRELS>" . $shortestPath . "\n"; #print the complete path
										#print OUT $candidatePaths{$shortestPath} . "\n"; #print only the beginning and end (tab-separated)
										print OUT $candidatePaths{$shortestPath} . "\t" . $shortestPath . "\n"; #print: Beginning \t End \t Complete Path
									}
  								}

							}
						}
					}
				}
				#clear all hashes and arrays from the previous sentence
				%matchingEntities = ();
				%dependencyGraph = ();
				%sentEntities = ();
				%entityPairsWithRelations = ();
				###

				$sentID = $in;
				$sentID =~ s/^root\(ROOT\-0,\sZZZZ(\d+)ZZZZ.+$/$1/;
				#print "<DOCID>$docfile</DOCID><SENTID>$sentID</SENTID>\n";
				my @currentSentEntities = split /\s/, $entities{$sentID};
				foreach my $entity (@currentSentEntities){
					$sentEntities{$entity} = 1;
				}
			}else{
				if ($in ne ""){
					#nn(student-3, Fergus-2)
					my $depRel = $in;
					$depRel =~ s/^(.+?)\(.+$/$1/;
					my $Args = $in;
					$Args =~ s/^.+?\((.+?),\s(.+?)\)$/$1$2/;
					my $arg1 = $1;
					my $arg2 = $2;
					$entityPairsWithRelations{$arg1}{$arg2} = " ->-" . $depRel . "->- ";
					$entityPairsWithRelations{$arg2}{$arg1} = " -<-" . $depRel . "-<- ";
					push @{ $dependencyGraph{$arg1} }, $arg2;
					push @{ $dependencyGraph{$arg2} }, $arg1;
					my ($word1, $id1) = split /\-/, $arg1;
					if (exists($sentEntities{$word1})){
						$matchingEntities{$id1} = $arg1;
					}
					my ($word2, $id2) = split /\-/, $arg2;
					if (exists($sentEntities{$word2})){
                                                $matchingEntities{$id2} = $arg2;
                                        }
				}
			}
		}
		close (IN);
		close (OUT);
	  }
	}
}
sub getTF_all
{
	my $topic = $_[0];
	my %hashterm = (); # Stores the frequency of each entity to calculate TF
	
	open (TF, ">data/$topic/TF_all") or die "$!";
	
	for (my $docNum = 1; $docNum <= 5; $docNum++)
	{
		#opendir (THISDIR, "windows/$topic/$docNum/allEntitiesBySent") or die "$!";
		#my @docfiles = grep /_allEntities/, readdir THISDIR;
		
		print "DOCs ARE: $docNum\n\n";
		#foreach my $docfile (@docfiles)
		{
			#my $outFile = $docfile . "_allEntities";
			open (IN, "windows/$topic/$docNum/allEntitiesBySent/$docNum") or die "$!";
			while (my $in = <IN>){ # read entities by sentence
				chomp $in;
				print "in - $in\n";
				my ($sentNum, $entities) = split /\t/, $in;
				my @elements = split / /, $entities;
				print "@elements\n";
				#my $sentNum = $elements[0];
				
				for (my $i = 0; $i < @elements; $i++)
				{
					my $entity = $elements[$i];
														
					if (length($entity) > 0)
					{
						$entity = lc ($entity);
						print "ENT - $entity\n";
	
						if ($hashterm{lc($entity)}{freq} < 1) # the term is not already in the hash
						{
							$hashterm{lc($entity)}{freq} = 1;
							print "**** seeing the entity $entity for the first time !!!\n";
						}
						elsif ($hashterm{lc($entity)}{freq} >= 1) # update the TF for the term
						{
							$hashterm{lc($entity)}{freq}++;
							print "**** seeing the entity $entity for $hashterm{$entity}{freq} times !!!\n";
						}
						else
						{
							#print "\n**** HOW IS THAT POSSIBLE??? -- $entity **** \n";
						}
					}
				}
			}
		}
	}
	
	foreach my $k (keys(%hashterm))
	{
	      print "$hashterm{$k}{freq}\t$k\n";
	      print TF "$hashterm{$k}{freq}\t$k\n";
	}
	close TF;
	
}
sub getEntitiesFreqs
{
     my $topic = $_[0];
     my %hashterm = (); # Stores the frequency of each entity to calculate TF
     
     print "$topic\n";
     #open (ENTS, "data/$topic/Unique_Entities") or die "$!";
     open (EDGES, "data/$topic/graph") or die "$!";
     
     print "1\n";
     
     open (ENF, ">data/$topic/Entities_Counts") or die "$!";
     #open (NODES, "data/$topic/Unique_Entities") or die "$!";
     
     print "2\n";
     
#    Source,Target,Label
#    Toronto,Canada,Toronto is the largest city in Canada

    my $in = <EDGES>; # first line to be removed
    chomp $in;
    while ($in = <EDGES>)
    {      
        chomp $in;
        print "in - $in\n";
        my ($ent1, $ent2, $label) = split /,/, $in;
                                                                                     
        if (length($ent1) > 0)
        {
                #$ent1 = lc ($ent1);
                print "ENT - $ent1\n";

                if ($hashterm{$ent1}{freq} < 1) # the term is not already in the hash
                {
                        $hashterm{$ent1}{freq} = 1;
                        print "**** seeing the entity $ent1 for the first time !!!\n";
                }
                elsif ($hashterm{$ent1}{freq} >= 1) # update the TF for the term
                {
                        $hashterm{$ent1}{freq}++;
                        print "**** seeing the entity $ent1 for $hashterm{$ent1}{freq} times !!!\n";
                }
                else
                {
                        #print "\n**** HOW IS THAT POSSIBLE??? -- $entity **** \n";
                }
        }
        
        if (length($ent2) > 0)
        {
                #$ent2 = lc ($ent2);
                print "ENT - $ent2\n";

                if ($hashterm{$ent2}{freq} < 1) # the term is not already in the hash
                {
                        $hashterm{$ent2}{freq} = 1;
                        print "**** seeing the entity $ent2 for the first time !!!\n";
                }
                elsif ($hashterm{$ent2}{freq} >= 1) # update the TF for the term
                {
                        $hashterm{$ent2}{freq}++;
                        print "**** seeing the entity $ent2 for $hashterm{$ent2}{freq} times !!!\n";
                }
                else
                {
                        #print "\n**** HOW IS THAT POSSIBLE??? -- $entity **** \n";
                }
        }
    }
    
    foreach my $k (keys(%hashterm))
    {
          print "$hashterm{$k}{freq}\t$k\n";
          print ENF "$hashterm{$k}{freq}\t$k\n";
    }
    close TF;
}
sub getTFIDF_all {
	my $topic = $_[0];
	my $dN = $_[1];
	my $queryForCollocation = $_[3];
	#my %collocates = ();
	my $corpus = 30230685715;
	my $bigN = 50220423;

	my $mkdir = `mkdir data/$topic`;
	my $mkdir = `mkdir data/$topic/$dN`;
	open (IDF, ">data/$topic/$dN/IDF_all") or die "$!";
	open (TFIDF, ">data/$topic/$dN/TFIDF_all") or die "$!";
	open (TFIDF_ALL, ">data/$topic/TFIDF_all") or die "$!";
        open (IN, "data/$topic/$dN/TF_all") or die "$!";
#	open (INN, "data/$topic/TF_all") or die "$!";

#	#get queryForCollocation terms
#        my @queryTerms = split /[\,\s|\|]/, $queryForCollocation;
#        my @queryForColloc = ();
#        foreach my $queryTerm (@queryTerms){
#                if ($queryTerm =~ /\w/){
#                        push @queryForColloc, $queryTerm;
#                }
#        }

	while (my $in = <IN>){ # read another file with TF - term
		chomp $in;
		my @elements = split /\t/, $in;
		my $count = $elements[0];
		my $entity = $elements[1];

		if ($entity !~ /XXXX/){
			#get $docsF (i.e. number of documents containing the entity (for calculating idf))
			my ($command ) = "\@count (\"<doc>\"..\"</doc>\") >  \"$entity\" \n";
			my (@response) = wumpusResponse($wumpus, $command);
			my $docsF = $response[0];
			chop $docsF;

			#initialize variables
			my $idf = 0;
			my $tfidf = 0;
			#calculate idf and tfidf
			if ($docsF > 0){
				$idf = log ($bigN / $docsF);
				#print "IDF($collocate): $idf = log ($bigN / $docsF)\n";
				$tfidf = $idf * $count;
				print "\tTFIDF($entity):$tfidf = $idf * $count\n";
				print IDF "$idf\t$entity\n";
				print TFIDF "$tfidf\t$entity\n";
			}
			elsif ($docsF == 0 && $count > 0) # if TF > 0, DF cannot be 0 --> DF = TF
			{
				$docsF = $count;
				$idf = log ($bigN / $docsF);
				#print "IDF($collocate): $idf = log ($bigN / $docsF)\n";
				$tfidf = $idf * $count;
				print "\tTFIDF($entity):$tfidf = $idf * $count\n";
				print IDF "$idf\t$entity\n";
				print TFIDF "$tfidf\t$entity\n";
			}
		}
	}
	close (IN);
	close (TFIDF);
	close (IDF);
	my $sort = `sort -rg data/$topic/$dN/IDF > data/$topic/$dN/IDF-s`;
	my $sort = `sort -rg data/$topic/$dN/TFIDF_all > data/$topic/$dN/TFIDF-s`;
	my $mv = `mv data/$topic/$dN/IDF-s data/$topic/$dN/IDF`;
	my $mv = `mv data/$topic/$dN/TFIDF-s data/$topic/$dN/TFIDF_all`;
}

sub getTFIDF_collection {
	my $topic = $_[0];
	my $queryForCollocation = $_[3];
	#my %collocates = ();
	my $corpus = 30230685715;
	my $bigN = 50220423;

	my $mkdir = `mkdir data/$topic`;
	#my $mkdir = `mkdir data/$topic/$dN`;
	open (IDF, ">data/$topic/IDF_all") or die "$!";
	open (TFIDF, ">data/$topic/TFIDF_all") or die "$!";
	open (IN, "data/$topic/TF_all") or die "$!";

#	#get queryForCollocation terms
#        my @queryTerms = split /[\,\s|\|]/, $queryForCollocation;
#        my @queryForColloc = ();
#        foreach my $queryTerm (@queryTerms){
#                if ($queryTerm =~ /\w/){
#                        push @queryForColloc, $queryTerm;
#                }
#        }

	while (my $in = <IN>){ # read another file with TF - term
		chomp $in;
		my @elements = split /\t/, $in;
		my $count = $elements[0];
		my $entity = $elements[1];

		if ($entity !~ /XXXX/){
			#get $docsF (i.e. number of documents containing the entity (for calculating idf))
			my ($command ) = "\@count (\"<doc>\"..\"</doc>\") >  \"$entity\" \n";
			my (@response) = wumpusResponse($wumpus, $command);
			my $docsF = $response[0];
			chop $docsF;

			#initialize variables
			my $idf = 0;
			my $tfidf = 0;
			#calculate idf and tfidf
			if ($docsF > 0){
				$idf = log ($bigN / $docsF);
				#print "IDF($collocate): $idf = log ($bigN / $docsF)\n";
				$tfidf = $idf * $count;
				print "\tTFIDF($entity):$tfidf = $idf * $count\n";
				print IDF "$idf\t$entity\n";
				print TFIDF "$tfidf\t$entity\n";
			}
			elsif ($docsF == 0 && $count > 0) # if TF > 0, DF cannot be 0 --> DF = TF
			{
				$docsF = $count;
				$idf = log ($bigN / $docsF);
				#print "IDF($collocate): $idf = log ($bigN / $docsF)\n";
				$tfidf = $idf * $count;
				print "\tTFIDF($entity):$tfidf = $idf * $count\n";
				print IDF "$idf\t$entity\n";
				print TFIDF "$tfidf\t$entity\n";
			}
		}
	}
	close (IN);
	close (TFIDF);
	close (IDF);
	my $sort = `sort -rg data/$topic/IDF_all > data/$topic/IDF-s`;
	my $sort = `sort -rg data/$topic/TFIDF_all > data/$topic/TFIDF-s`;
	my $mv = `mv data/$topic/IDF-s data/$topic/IDF_all`;
	my $mv = `mv data/$topic/TFIDF-s data/$topic/TFIDF_all`;
}
sub rankAverageTFIDF # takes a list of entity pairs and their calculated TF-IDF and sorts them based on the average of the TF-IDF for every pair
{
	my $topic = $_[0];
	my $docNum = $_[1];
	my %TFIDFentities = ();
	my %TFIDFentityPairs = ();
	
	open (IN, "data/$topic/$docNum/TFIDF_all") or die $!;
	open (OUT, ">data/$topic/$docNum/TFIDF_pairs") or die $!;
	
	
	while (my $in = <IN>)
	{
		chomp $in;
		my ($tfidf, $entity) = split /\t/, $in;
		print "$entity\n";
		
		$entity =~ s/\s+/ /g;
		$entity =~ s/\s/_/g;
		$TFIDFentities{$entity} = $tfidf;
	}
	close (IN);
	
	foreach my $key1 ( sort {$a<=>$b} keys %TFIDFentities) {
	foreach my $key2 ( sort {$a<=>$b} keys %TFIDFentities) {
		if ($key1 lt $key2)
		#if (! (defined $TFIDFentityPairs{$key2}{$key1} && exists $TFIDFentityPairs{$key2}{$key1}))
		{
			$TFIDFentityPairs{$key1}{$key2} = ($TFIDFentities{$key1} + $TFIDFentities{$key2}) / 2;
			print OUT "$TFIDFentityPairs{$key1}{$key2}\t$key1\t$key2\n";
		}
	}
	}
	
	close (OUT);
	
	#my @sorted = sort {$TFIDFentityPairs{$a}{$key2} <=> $hashsentence{$b}{$key2}} keys($TFIDFentityPairs);
	
	my $sort = `sort -rg data/$topic/$docNum/TFIDF_pairs > data/$topic/$docNum/TFIDF_pairs-s`;
	my $mv = `mv data/$topic/$docNum/TFIDF_pairs-s data/$topic/$docNum/TFIDF_pairs`;	
}
sub rankAverageTFIDF_all # takes a list of entity pairs and their calculated TF-IDF and sorts them based on the average of the TF-IDF for every pair
{
	my $topic = $_[0];
	my %TFIDFentities = ();
	my %TFIDFentityPairs = ();
	
	open (IN, "data/$topic/TFIDF_all") or die $!;
	open (OUT, ">data/$topic/TFIDF_pairs") or die $!;
	
	
	while (my $in = <IN>)
	{
		chomp $in;
		my ($tfidf, $entity) = split /\t/, $in;
		print "$entity\n";
		
		$entity =~ s/\s+/ /g;
		$entity =~ s/\s/_/g;
		$TFIDFentities{$entity} = $tfidf;
	}
	close (IN);
	
	foreach my $key1 ( sort {$a<=>$b} keys %TFIDFentities) {
	foreach my $key2 ( sort {$a<=>$b} keys %TFIDFentities) {
		if ($key1 lt $key2)
		#if (! (defined $TFIDFentityPairs{$key2}{$key1} && exists $TFIDFentityPairs{$key2}{$key1}))
		{
			$TFIDFentityPairs{$key1}{$key2} = ($TFIDFentities{$key1} + $TFIDFentities{$key2}) / 2;
			print OUT "$TFIDFentityPairs{$key1}{$key2}\t$key1\t$key2\n";
		}
	}
	}
	
	close (OUT);
	
	#my @sorted = sort {$TFIDFentityPairs{$a}{$key2} <=> $hashsentence{$b}{$key2}} keys($TFIDFentityPairs);
	
	my $sort = `sort -rg data/$topic/TFIDF_pairs > data/$topic/TFIDF_pairs-s`;
	my $mv = `mv data/$topic/TFIDF_pairs-s data/$topic/TFIDF_pairs`;	
}
sub rankAverageTFIDFbySent # takes a list of entity pairs and their calculated TF-IDF and sorts them based on the average of the TF-IDF for every pair
{
	my $topic = $_[0];
	my $docNum = $_[1];
	
	my %TFIDFentities = ();
	my %TFIDFentityPairs = ();
	my %Entities = ();
	
	open (IN, "data/$topic/$docNum/TFIDF_all") or die $!;
	open (OUT, ">data/$topic/$docNum/TFIDF_pairs_bySent") or die $!;
	
	my $count = 0;
	while (my $in = <IN>)
	{
		chomp $in;
		my ($tfidf, $entity) = split /\t/, $in;
		#print "$entity\n";
		
		$entity =~ s/\s+/ /g;
		$entity =~ s/\s/_/g;
		$TFIDFentities{$entity} = $tfidf;
	}
	close (IN);
	
	opendir (THISDIR, "windows/$topic/$docNum/taggedFixedEntities") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
	
	print "*** @docfiles\n\n";
	
	foreach my $docfile (@docfiles)
	{
		open (IN, "windows/$topic/$docNum/allEntitiesBySent/$docfile") or die $!; # Later, put this in a loop and replace /$topic with /$docfile
		
		while (my $in = <IN>)
		{
			chomp $in;
			my ($sentID, $entitiesPerSent) = split /\t/, $in;
			my @entities = split / /, $entitiesPerSent;
			#my $sentID = $elements[0];
			print "@entities\n";
			
			foreach my $entity (@entities)
			#for (my $i = 1; $i < @elements; $i++)
			{
				#my @entities = split / /, $entitiesPerSent;
				#print "---- @entities\n";
				#my $entity = $elements[$i];
				
				#$entity =~ s/\s+/ /g;
				#$entity =~ s/\s/_/g;
				$entity = lc ($entity);
				$Entities{$entity} = $sentID;
				print "- $Entities{$entity} - $entity\n";
				
			
				foreach my $key1 ( sort {$a<=>$b} keys %Entities) {
				foreach my $key2 ( sort {$a<=>$b} keys %Entities) {
					if ($key1 lt $key2)
					{
						$TFIDFentityPairs{$key1}{$key2} = ($TFIDFentities{$key1} + $TFIDFentities{$key2}) / 2;
						print OUT "$TFIDFentityPairs{$key1}{$key2}\t$key1\t$key2\t$sentID\n";
						$count++;
					}
				}
				}
				
			}
			%Entities = ();
		}
		print "\n There are $count lines\n";
		close (IN);
	}
	close (OUT);
	
	#my @sorted = sort {$TFIDFentityPairs{$a}{$key2} <=> $hashsentence{$b}{$key2}} keys($TFIDFentityPairs);
	
	my $sort = `sort -rg data/$topic/$docNum/TFIDF_pairs_bySent > data/$topic/TFIDF_pairs_bySent-s`;
	my $mv = `mv data/$topic/$docNum/TFIDF_pairs_bySent-s data/$topic/TFIDF_pairs_bySent`;	
}
sub rankAverageTFIDFbySentDoc # takes a list of entity pairs and their calculated TF-IDF and sorts them based on the average of the TF-IDF for every pair
{
	my $topic = $_[0];
	
	my %TFIDFentities = ();
	my %TFIDFentityPairs = ();
	my %Entities = ();
	
	open (IN, "data/$topic/TFIDF_all") or die $!;
	open (OUT, ">data/$topic/TFIDF_pairs_bySentDoc") or die $!;
	
	my $count = 0;
	while (my $in = <IN>)
	{
		chomp $in;
		my ($tfidf, $entity) = split /\t/, $in;
		#print "$entity\n";
		
		$entity =~ s/\s+/ /g;
		$entity =~ s/\s/_/g;
		$TFIDFentities{$entity} = $tfidf;
	}
	close (IN);
	
#	opendir (THISDIR, "windows/$topic/$docNum/taggedFixedEntities") or die "$!";
#        my @docfiles = grep !/^\./, readdir THISDIR;
#	
#	print "*** @docfiles\n\n";
	
	for (my $docNum = 1; $docNum <= 5; $docNum++)
	{
		open (IN, "windows/$topic/$docNum/allEntitiesBySent/$docNum") or die $!; # Later, put this in a loop and replace /$topic with /$docfile
		
		while (my $in = <IN>)
		{
			chomp $in;
			my ($sentID, $entitiesPerSent) = split /\t/, $in;
			my @entities = split / /, $entitiesPerSent;
			#my $sentID = $elements[0];
			print "@entities\n";
			
			foreach my $entity (@entities)
			#for (my $i = 1; $i < @elements; $i++)
			{
				#my @entities = split / /, $entitiesPerSent;
				#print "---- @entities\n";
				#my $entity = $elements[$i];
				
				#$entity =~ s/\s+/ /g;
				#$entity =~ s/\s/_/g;
				$entity = lc ($entity);
				$Entities{$entity} = $sentID;
				print "- $Entities{$entity} - $entity\n";
				
			
				foreach my $key1 ( sort {$a<=>$b} keys %Entities) {
				foreach my $key2 ( sort {$a<=>$b} keys %Entities) {
					if ($key1 lt $key2)
					{
						$TFIDFentityPairs{$key1}{$key2} = ($TFIDFentities{$key1} + $TFIDFentities{$key2}) / 2;
						print OUT "$TFIDFentityPairs{$key1}{$key2}\t$key1\t$key2\t$docNum\t$sentID\n";
						$count++;
					}
				}
				}
				
			}
			%Entities = ();
		}
		print "\n There are $count lines\n";
		close (IN);
	}
	close (OUT);
	
	#my @sorted = sort {$TFIDFentityPairs{$a}{$key2} <=> $hashsentence{$b}{$key2}} keys($TFIDFentityPairs);
	
	my $sort = `sort -rg data/$topic/TFIDF_pairs_bySentDoc > data/$topic/TFIDF_pairs_bySentDoc-s`;
	my $mv = `mv data/$topic/TFIDF_pairs_bySentDoc-s data/$topic/TFIDF_pairs_bySentDoc`;	
}
sub rankNPMI # takes a list of entities and for every entity pair, calculates the NPMI and sorts the pairs based on this associasion measure
{
	my $topic = $_[0];
	my %TFIDFentities = ();
	my %NPMIentityPairs = ();
	
	open (IN, "data/$topic/TFIDF_all") or die $!; # you can get this list from TF_all file too.
	open (OUT, ">data/$topic/NPMI_pairs") or die $!;
	
	my $count = 0;
	while (my $in = <IN>)
	{
		if ($count > 300)
		{
			last;
		}
		$count++;
		print "count is $count\n";
		chomp $in;
		my ($tfidf, $entity) = split /\t/, $in;
		print "$entity\n";
		
		$entity =~ s/\s+/ /g;
		$entity =~ s/\s/_/g;
		$TFIDFentities{$entity} = $tfidf;
		
	}
	close (IN);
	
	foreach my $key1 ( sort {$a<=>$b} keys %TFIDFentities) { # creates entity pairs and calculates NPMI for every pair
	foreach my $key2 ( sort {$a<=>$b} keys %TFIDFentities) {
		if ($key1 lt $key2)
		{
			$NPMIentityPairs{$key1}{$key2} = calcPMI($key1, $key2, "", "");
			print OUT "$NPMIentityPairs{$key1}{$key2}\t$key1\t$key2\n";
		}
	}
	}
	
	close (OUT);
	
	#my @sorted = sort {$TFIDFentityPairs{$a}{$key2} <=> $hashsentence{$b}{$key2}} keys($TFIDFentityPairs);
	
	my $sort = `sort -rg data/$topic/NPMI_pairs > data/$topic/NPMI_pairs-s`;
	my $mv = `mv data/$topic/NPMI_pairs-s data/$topic/NPMI_pairs`;
}
sub rankNPMIbySent # takes a list of entities per sentence and for every entity pair, calculates the NPMI and sorts the pairs based on this associasion measure
{
	my $topic = $_[0];
	my %Entities = ();
	my %NPMIentityPairs = ();
	my $joinFreq;
	
	#open (IN, "windows/$topic/allEntitiesBySent/$topic") or die $!; # Later, put this in a loop and replace /$topic with /$docfile
	open (OUT, ">data/$topic/NPMI_pairs_bySent") or die $!;
	
	opendir (THISDIR, "windows/$topic/taggedFixedEntities") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
	
	print "*** @docfiles\n\n";
	
	foreach my $docfile (@docfiles)
	{
		open (IN, "windows/$topic/allEntitiesBySent/$docfile");
		while (my $in = <IN>)
		{
			chomp $in;
			print "IN: $in\n";
			my ($sentID, $entitiesPerSent) = split /\t/, $in;
			print "sentID: $sentID | $entitiesPerSent\n";
			#my @elements = split /\t/, $in;
			#print ">> $elements[0] - $elements[1] - $elements[2]\n";
			#my $sentID = $elements[0];
			my @entities = split / /, $entitiesPerSent;
			print "$sentID -- @entities\n";
			
			foreach my $entity (@entities)
			#for (my $i = 1; $i < @elements; $i++)
			{
			#	my $entity = $elements[$i];
				#$entity =~ s/\s+/ /g;
				#$entity =~ s/\s/_/g;
				$entity = lc ($entity);
				$Entities{$entity} = $sentID;
				print "XXX $Entities{$entity} - $entity\n";
			}
			foreach my $key1 ( sort {$a<=>$b} keys %Entities) { # creates entity pairs and calculates NPMI for every pair
			foreach my $key2 ( sort {$a<=>$b} keys %Entities) {
				if ($key1 lt $key2)
				{
					print "OOOOO  $NPMIentityPairs{$key1}{$key2}\t$key1\t$key2\t$sentID\n";
					($NPMIentityPairs{$key1}{$key2}, $joinFreq) = calcPMI($key1, $key2, "", "");
					print OUT "$NPMIentityPairs{$key1}{$key2}\t$key1\t$key2\t$sentID\t$joinFreq\n";
				}
			}
			}
			%Entities = ();
		}
		close (IN);
	}
		
	close (OUT);
	
	#my @sorted = sort {$TFIDFentityPairs{$a}{$key2} <=> $hashsentence{$b}{$key2}} keys($TFIDFentityPairs);
	
	my $sort = `sort -rg data/$topic/NPMI_pairs_bySent > data/$topic/NPMI_pairs_bySent-s`;
	my $mv = `mv data/$topic/NPMI_pairs_bySent-s data/$topic/NPMI_pairs_bySent`;
}
sub rankNPMIbySentDoc # takes a list of entities per sentence and for every entity pair, calculates the NPMI and sorts the pairs based on this associasion measure
{
	my $topic = $_[0];
	my %Entities = ();
	my %NPMIentityPairs = ();
	my $joinFreq;
	
	#open (IN, "windows/$topic/allEntitiesBySent/$topic") or die $!; # Later, put this in a loop and replace /$topic with /$docfile
	open (OUT, ">data/$topic/NPMI_pairs_bySentDoc") or die $!;
	
#	opendir (THISDIR, "windows/$topic/taggedFixedEntities") or die "$!";
#        my @docfiles = grep !/^\./, readdir THISDIR;
#	
#	print "*** @docfiles\n\n";
	
	for (my $dN = 1; $dN <= 13; $dN++)
	{
		open (IN, "windows/$topic/$dN/allEntitiesBySent/$dN");
		while (my $in = <IN>)
		{
			chomp $in;
			print "IN: $in\n";
			my ($sentID, $entitiesPerSent) = split /\t/, $in;
			print "sentID: $sentID | $entitiesPerSent\n";
			#my @elements = split /\t/, $in;
			#print ">> $elements[0] - $elements[1] - $elements[2]\n";
			#my $sentID = $elements[0];
			my @entities = split / /, $entitiesPerSent;
			print "$sentID -- @entities\n";
			
			foreach my $entity (@entities)
			#for (my $i = 1; $i < @elements; $i++)
			{
			#	my $entity = $elements[$i];
				#$entity =~ s/\s+/ /g;
				#$entity =~ s/\s/_/g;
				$entity = lc ($entity);
				$Entities{$entity} = $sentID;
				print "XXX $Entities{$entity} - $entity\n";
			}
			foreach my $key1 ( sort {$a<=>$b} keys %Entities) { # creates entity pairs and calculates NPMI for every pair
			foreach my $key2 ( sort {$a<=>$b} keys %Entities) {
				if ($key1 lt $key2)
				{
					print "OOOOO  $NPMIentityPairs{$key1}{$key2}\t$key1\t$key2\t$sentID\n";
					($NPMIentityPairs{$key1}{$key2}, $joinFreq) = calcPMI($key1, $key2, "", "");
					print OUT "$NPMIentityPairs{$key1}{$key2}\t$key1\t$key2\t$dN\t$sentID\t$joinFreq\n";
				}
			}
			}
			%Entities = ();
		}
		close (IN);
	}
		
	close (OUT);
	
	#my @sorted = sort {$TFIDFentityPairs{$a}{$key2} <=> $hashsentence{$b}{$key2}} keys($TFIDFentityPairs);
	
	my $sort = `sort -rg data/$topic/NPMI_pairs_bySentDoc > data/$topic/NPMI_pairs_bySentDoc-s`;
	my $mv = `mv data/$topic/NPMI_pairs_bySentDoc-s data/$topic/NPMI_pairs_bySentDoc`;
}
sub rankRRF
{
	my $topic = $_[0];
	my %rank_TFIDF = ();
	my %rank_NPMI = ();
	my $r;
	my $smoothingFactor = 60;
	
	open (OUT, ">data/$topic/RRF_pairs_bySent") or die $!;
	open (IN, "data/$topic/TFIDF_pairs_bySent") or die $!;
	
	$r = 1;
	while (my $in = <IN>)
	{
		chomp $in;
		my ($tfidf, $entity1, $entity2, $sentID) = split /\t/, $in;
		
		$entity1 =~ s/\s+/ /g;
		$entity1 =~ s/\s/_/g;
		$entity2 =~ s/\s+/ /g;
		$entity2 =~ s/\s/_/g;
		$rank_TFIDF{$entity1}{$entity2}{$sentID} = $r;
		$r++;
	}
	close (IN);
	
	open (IN, "data/$topic/NPMI_pairs_bySent") or die $!;
	
	$r = 1;
	while (my $in = <IN>)
	{
		chomp $in;
		my ($npmi, $entity1, $entity2, $sentID) = split /\t/, $in;
		
		$entity1 =~ s/\s+/ /g;
		$entity1 =~ s/\s/_/g;
		$entity2 =~ s/\s+/ /g;
		$entity2 =~ s/\s/_/g;
		$rank_NPMI{$entity1}{$entity2}{$sentID} = $r;
		
		my $rrf = (1 / ($smoothingFactor + $rank_TFIDF{$entity1}{$entity2}{$sentID}) + (1 / $r));
		print OUT "$rrf\t$entity1\t$entity2\t$sentID\n";
		
		$r++;
	}
	close (IN);
	close (OUT);
	
	my $sort = `sort -rg data/$topic/RRF_pairs_bySent > data/$topic/RRF_pairs_bySent-s`;
	my $mv = `mv data/$topic/RRF_pairs_bySent-s data/$topic/RRF_pairs_bySent`;
	
	
}
sub getEntities
{
	my $topic = $_[0];
	my $dN = $_[1];
	my %hashterm;
	my %hashsentence;
	my @sorted;
	my @ranges;
	my $length;
	my $overlaps_log;
	
	#my $rm = `rm -rf windows/$topic/multipleTaggedEntities`;
	#my $rm = `rm -rf windows/$topic/taggedEntities`;
	#my $rm = `rm -rf windows/$topic/allEntitiesBySent`;
	
	#my $rm = `rm -rf windows/$topic/taggedEntities-NPs`;
	#my $rm = `rm -rf windows/$topic/allEntitiesNPsBySent`;
	
	my $mkdir = `mkdir windows/$topic/$dN/multipleTaggedEntities`;
	my $mkdir = `mkdir windows/$topic/$dN/taggedEntities`;
	my $mkdir = `mkdir windows/$topic/$dN/allEntitiesBySent`;
	
	my $mkdir = `mkdir windows/$topic/$dN/taggedEntities-NPs`;
	my $mkdir = `mkdir windows/$topic/$dN/allEntitiesNPsBySent`;
	
	my $mkdir = `mkdir data/$topic`;
	my $mkdir = `mkdir data/$topic/$dN`;
	
	opendir (THISDIR, "windows/$topic/$dN/taggedPhrases") or die "$!";
	my @docfiles = grep !/^\./, readdir THISDIR;

	print "@docfiles \n";
	
	foreach my $docfile (@docfiles)
	{
		#if ($docfile == 5 || $docfile == 34){
		my $docfile_name = $docfile;
		$docfile_name =~ s/_.*//;
		open (OUT, ">windows/$topic/$dN/taggedEntities/$docfile_name") or die "$!";
		open (ENT, ">windows/$topic/$dN/allEntitiesBySent/$docfile_name") or die "$!";
		
		open (OUTNP, ">windows/$topic/$dN/taggedEntities-NPs/$docfile_name") or die "$!";
		open (ENTNP, ">windows/$topic/$dN/allEntitiesNPsBySent/$docfile_name") or die "$!";
		
		open (OVERLAPS, ">windows/$topic/$dN/multipleTaggedEntities/$docfile_name") or die "$!";
		open (TFIDF, ">data/$topic/$dN/TFIDF_all") or die "$!";
		open (TF, "|sort -rn >data/$topic/$dN/TF_all") or die "$!";
		open (IN, "windows/$topic/$dN/taggedPhrases/$docfile") or die "there is no such file! $!";
		my @lines;
		while (my $in = <IN>){
		      chomp $in;
		      push @lines, $in;
		}
		close (IN);
		
		# sample input file format:
		#  # Mr. Smith saw the dog with two telescopes.
		#  4	9	Smith	PERSON	ExNER
		#  start	end	term	label	annotator
		
		my $line;
		my $i = 0;
		my $j = 0;
		my $overlap;
		my $key_2b_removed;
		my $sentNum = 0;
		while ($i < @lines)
		{
			my $newsentence = "";
			my $entities_per_sentence = "";
			my $sentence = $lines[$i];
			$sentence =~ s/# //;
			$sentence =~ s/\s+/ /g;
			print "\n---- Sentence -----\n\n";
			print "$sentence \n\n";
			
			$i++;
			$sentNum++;
			
			$length = length($sentence);
			for (my $j = 0; $j < $length; $j++)
			{
				$ranges[$j] = "";
			}
			while ($i < @lines && $lines[$i] !~ /^#/)
			{
				$line = $lines[$i];
				print "$line \n";
				my @elements = split '\t', $line;
				my $key = $elements[0] . "-" . $elements[1];
				
				$hashsentence{$key}{start} = $elements[0]; 
				$hashsentence{$key}{end} = $elements[1];
				$hashsentence{$key}{term} = $elements[2]; 
				$hashsentence{$key}{label} = $elements[3]; 
				$hashsentence{$key}{source} = $elements[4];
				
				$i++;
			
			}
			@sorted = sort {$hashsentence{$a}{start} <=> $hashsentence{$b}{start} || $hashsentence{$a}{end} <=> $hashsentence{$b}{end}} keys(%hashsentence);
			
			print "\n---- Tagged Entities -----\n\n";
			foreach my $k (keys(%hashsentence))
			{
				print "$k : $hashsentence{$k}{start} - $hashsentence{$k}{end} - $hashsentence{$k}{term} - $hashsentence{$k}{source} \n";
			}
			
			print "\n---- SORTED -----\n\n";
			
			$newsentence = $sentence;
			foreach my $k (@sorted)
			{
				print "$k : $hashsentence{$k}{start} - $hashsentence{$k}{end} - $hashsentence{$k}{term} - $hashsentence{$k}{source} \n";
				if ($hashsentence{$k}{source} ne "Chunker") # we need to merge the phrases tagged by the NER or the Wikifier first.
				{
					$overlap = 0;
					for (my $j = $hashsentence{$k}{start}; $j <= $hashsentence{$k}{end}; $j++)
					{
						if ($ranges[$j] eq "")
						{
							$ranges[$j] = $k;
							#print "\n***** $hashsentence{$k}{term} is added to the ranges: $k ******* \n\n";
						}
						else
						{
							$overlap = 1;
							#print "\n>>>> overlaps: $hashsentence{$ranges[$j]}{term} with $hashsentence{$k}{term} <<<<\n\n";
							$overlaps_log = "$ranges[$j]\t$hashsentence{$ranges[$j]}{start}-$hashsentence{$ranges[$j]}{end}\t$hashsentence{$ranges[$j]}{term}\t$hashsentence{$ranges[$j]}{label}\t$hashsentence{$ranges[$j]}{source}\n";
							$overlaps_log = $overlaps_log . "$k\t$hashsentence{$k}{start}-$hashsentence{$k}{end}\t$hashsentence{$k}{term}\t$hashsentence{$k}{label}\t$hashsentence{$k}{source}\n";
		#					print OVERLAPS "$ranges[$j]\t$hashsentence{$ranges[$j]}{start}-$hashsentence{$ranges[$j]}{end}\t$hashsentence{$ranges[$j]}{term}\t$hashsentence{$ranges[$j]}{label}\t$hashsentence{$ranges[$j]}{source}\n";
		#					print OVERLAPS "$key\t$hashsentence{$key}{start}-$hashsentence{$key}{end}\t$hashsentence{$key}{term}\t$hashsentence{$key}{label}\t$hashsentence{$key}{source}\n";
							
							#remove the shorter tagged entity
							if (length($hashsentence{$k}{term}) > length($hashsentence{$ranges[$j]}{term})) # remove the old entity and add the new one
							{
								$key_2b_removed = $ranges[$j];
								$ranges[$j] = $k;
								#print "\nKEY 2B REMOVED: $key_2b_removed -  new key: $k \n";
							}
							elsif (length($hashsentence{$k}{term}) < length($hashsentence{$ranges[$j]}{term}))
							{
								$key_2b_removed = $k;
								#print "\nKEY 2B REMOVED: $key_2b_removed \n";
							}						
						}
					}
				}
				if ($overlap)
				{
					# remove the shorter overlapping entities
					#print "\n^^^^ $key_2b_removed\t$hashsentence{$key_2b_removed}{term} ^^^^ \n\n";
					delete($hashsentence{$key_2b_removed});
					#print OVERLAPS "$overlaps_log";
					#print OVERLAPS "\n ----------------------------------------------------------- \n\n";
				}		
					
			}
			my @sorted = sort {$hashsentence{$a}{start} <=> $hashsentence{$b}{start} || $hashsentence{$a}{end} <=> $hashsentence{$b}{end}} keys(%hashsentence);
					
			print "\n\n ------- Unique entities per sentence ------------- \n\n";
			my $entityNum = 0;
			my $offset = 0;
			foreach my $k (@sorted) # creating the new sentence with underlined entities
			{
				if ($hashsentence{$k}{source} ne "Chunker")
				{
					$entityNum++;
					print "$k - $hashsentence{$k}{term} \n";
	
					my $entity = $hashsentence{$k}{term};
					my @elements = split / /, $entity;
					my $indx;
					
					if (@elements > 1) #multi-word entity
					{
						my $ent = $entity;
						$entity =~ s/ /_/g;
						print "OOOOOOO newsentence - before: $newsentence\n";
						#substr($newsentence, $hashsentence{$k}{start} + $offset, $hashsentence{$k}{end} - $hashsentence{$k}{start}) = $entity;
						
						$indx = index($newsentence, $ent, $hashsentence{$k}{start} + $offset - 2);
						substr($newsentence, $indx, $hashsentence{$k}{end} - $hashsentence{$k}{start}) = $entity;
						print "@ $entity, - $hashsentence{$k}{start} - $hashsentence{$k}{end} - $offset - $indx\n";
						print "OOOOOOO updated sentence: $newsentence\n";
					}
					
					#my $pre = substr $newsentence, 0, $hashsentence{$k}{start} + $offset;
					#my $post = substr $newsentence, $hashsentence{$k}{end} + $offset;
					#
					#print "XXXXXXX pre: $pre - post: $post\n";
					#$newsentence = $pre . " [EN " . $entity . "] " . $post;
					
					my $label = " [EN " . $entity . "] ";
					#$newsentence =~ s/$entity/$label/e;
					print "$newsentence\n";
					$indx = index($newsentence, $entity, $hashsentence{$k}{start} + $offset - 2);
					substr($newsentence, $indx, $hashsentence{$k}{end} - $hashsentence{$k}{start}) = $label;
					print "@@ $entity, - $hashsentence{$k}{start} - $hashsentence{$k}{end} - $offset - $indx\n";
					
					$offset += 7; 
					
					#print "$pre --- $entity --- $post\n ---> $newsentence\n\n";
					
					$entity =~ s/ //g;
		
					if (length($entity) > 0)
					{
						#print ENT "$entity\t";
						$entities_per_sentence = $entities_per_sentence . "\t" . $entity;
	
						if ($hashterm{lc($hashsentence{$k}{term})}{freq} < 1) # the term is not already in the hash
						{
							$hashterm{lc($hashsentence{$k}{term})}{freq} = 1;
							#print "**** seeing the entity $hashsentence{$k}{term} for the first time !!!\n";
						}
						elsif ($hashterm{lc($hashsentence{$k}{term})}{freq} >= 1) # update the TF for the term
						{
							$hashterm{lc($hashsentence{$k}{term})}{freq}++;
							#print "**** seeing the entity $hashsentence{$k}{term} for $hashterm{$hashsentence{$k}{term}}{freq} times !!!\n";
						}
						else
						{
							#print "\n**** HOW IS THAT POSSIBLE??? -- $hashsentence{$k}{term} **** \n";
						}
					}
					
					print "********** sentence: $sentence\n\n";
					print "********** new sentence: $newsentence\n\n";				
					
				}
			}
			$entities_per_sentence =~ s/^\t//;
			my @elements = split /\t/, $entities_per_sentence;
			if (@elements > 1)
			{
				print ENT "$sentNum\t$entities_per_sentence\n";
			}
	
			print OUT "$newsentence\n";
				
			
			# ------------------------------  The new part added to add in NPs to the list of extracted entities -----------------------------
			
			print "\n\n --------------------- NEW PHASE: Adding NPs ----------------- \n\n";
			# Now we need to remove all NPs which overlap with the ENs.
			$entities_per_sentence = "";
			$length = length($sentence);
			for (my $j = 0; $j < $length; $j++)
			{
				$ranges[$j] = "";
			}
			foreach my $k (@sorted)
			{
				print "$k : $hashsentence{$k}{start} - $hashsentence{$k}{end} - $hashsentence{$k}{term} - $hashsentence{$k}{source} \n";
	
				$overlap = 0;
				for (my $j = $hashsentence{$k}{start}; $j <= $hashsentence{$k}{end}; $j++)
				{
					if ($ranges[$j] eq "")
					{
						$ranges[$j] = $k;
						#print "\n***** $hashsentence{$k}{term} is added to the ranges: $k ******* \n\n";
					}
					else
					{
						$overlap = 1;
						#print "\n>>>> overlaps: $hashsentence{$ranges[$j]}{term} with $hashsentence{$k}{term} <<<<\n\n";
						#$overlaps_log = "$ranges[$j]\t$hashsentence{$ranges[$j]}{start}-$hashsentence{$ranges[$j]}{end}\t$hashsentence{$ranges[$j]}{term}\t$hashsentence{$ranges[$j]}{label}\t$hashsentence{$ranges[$j]}{source}\n";
						#$overlaps_log = $overlaps_log . "$k\t$hashsentence{$k}{start}-$hashsentence{$k}{end}\t$hashsentence{$k}{term}\t$hashsentence{$k}{label}\t$hashsentence{$k}{source}\n";
	#					print OVERLAPS "$ranges[$j]\t$hashsentence{$ranges[$j]}{start}-$hashsentence{$ranges[$j]}{end}\t$hashsentence{$ranges[$j]}{term}\t$hashsentence{$ranges[$j]}{label}\t$hashsentence{$ranges[$j]}{source}\n";
	#					print OVERLAPS "$key\t$hashsentence{$key}{start}-$hashsentence{$key}{end}\t$hashsentence{$key}{term}\t$hashsentence{$key}{label}\t$hashsentence{$key}{source}\n";
						
						#remove the NP
						if ($hashsentence{$k}{source} ne "Chunker") # remove the NP and add the entity instead
						{
							$key_2b_removed = $ranges[$j];
							$ranges[$j] = $k;
							#print "\nKEY 2B REMOVED: $key_2b_removed -  new key: $k \n";
						}
						else # just remove the overlapping NP from the hash
						{
							$key_2b_removed = $k;
							#print "\nKEY 2B REMOVED: $key_2b_removed \n";
						}						
					}
				}
				if ($overlap)
				{
					# remove the shorter overlapping entities
					#print "\n^^^^ $key_2b_removed\t$hashsentence{$key_2b_removed}{term} ^^^^ \n\n";
					delete($hashsentence{$key_2b_removed});
					#print OVERLAPS "$overlaps_log";
					#print OVERLAPS "\n ----------------------------------------------------------- \n\n";
				}		
					
			}
			
			my @sorted = sort {$hashsentence{$a}{start} <=> $hashsentence{$b}{start} || $hashsentence{$a}{end} <=> $hashsentence{$b}{end}} keys(%hashsentence);
						
			print "\n\n ------- Unique entities and NPs per sentence ------------- \n\n";
			my $entityNum = 0;
			my $offset = 0;
			$newsentence = $sentence;
			foreach my $k (@sorted) # creating the new sentence with underlined entities
			{
				if ($hashsentence{$k}{source} ne "Chunker")
				{
					$entityNum++;
				}
				print "$k - $hashsentence{$k}{term} \n";
	
				my $entity = $hashsentence{$k}{term};
				my @elements = split / /, $entity;
				
				if (@elements > 1) #multi-word entity
				{
					$entity =~ s/ /_/g;
					print "OOOOOOO newsentence - before: $newsentence\n";
					substr($newsentence, $hashsentence{$k}{start} + $offset, $hashsentence{$k}{end} - $hashsentence{$k}{start}) = $entity;
					print "OOOOOOO updated sentence: $newsentence\n";
				}
				
				my $pre = substr $newsentence, 0, $hashsentence{$k}{start} + $offset;
				my $post = substr $newsentence, $hashsentence{$k}{end} + $offset;
				
				print "XXXXXXX pre: $pre - post: $post\n";
				if ($hashsentence{$k}{source} ne "Chunker")
				{
					$newsentence = $pre . " [EN " . $entity . "]" . $post;
				}
				else
				{
					$newsentence = $pre . " [NP " . $entity . "]" . $post;
				}
				
				$offset += 6; 
				
				print "$pre --- $entity --- $post\n ---> $newsentence\n\n";
				
				$entity =~ s/ //g;
	
				if (length($entity) > 0)
				{
					#print ENT "$entity\t";
					$entities_per_sentence = $entities_per_sentence . "\t" . $entity;
	
					if ($hashterm{lc($hashsentence{$k}{term})}{freq} < 1) # the term is not already in the hash
					{
						$hashterm{lc($hashsentence{$k}{term})}{freq} = 1;
						#print "**** seeing the entity $hashsentence{$k}{term} for the first time !!!\n";
					}
					elsif ($hashterm{lc($hashsentence{$k}{term})}{freq} >= 1) # update the TF for the term
					{
						$hashterm{lc($hashsentence{$k}{term})}{freq}++;
						#print "**** seeing the entity $hashsentence{$k}{term} for $hashterm{$hashsentence{$k}{term}}{freq} times !!!\n";
					}
					else
					{
						#print "\n**** HOW IS THAT POSSIBLE??? -- $hashsentence{$k}{term} **** \n";
					}
				}
				
				print "********** sentence: $sentence\n\n";
				print "********** new sentence: $newsentence\n\n";				
				
			}
			$entities_per_sentence =~ s/^\t//;
			#my @elements = split /\t/, $entities_per_sentence;
			#if (@elements > 1)
			if ($entityNum > 0) # if there is at least one entity (NP does not count as EN)
			{
				print ENTNP "$sentNum\t$entities_per_sentence\n";
			}
	
			print OUTNP "$newsentence\n";	
			%hashsentence = ();
		}
		foreach my $k (keys(%hashterm))
		{
		      print "$hashterm{$k}{freq}\t$k\n";
		      print TF "$hashterm{$k}{freq}\t$k\n";
		}
		#}
	}
	
	close ENT;
	close OUT;
	close TF;
}
sub extractCandidateRelations { # a modified version of underscoreNEs for selecting sentences with at least 2 high-ranked entities extracted by both Wikifier and NER
	my $topic = $_[0];
	my $dN = $_[1];
	my $selectMode = $_[2]; # $selectMode is referring to the criterion used for ranking entities: 0: TFIDF for individual entities; 1: average TFIDF for entity pairs; 2: NPMI for entity pairs
	my %Es = ();
#	my %NEtags = ();
#	my %NESentStats = ();
	#load top TFIDF-ranked entities
	my %TFIDFentities = ();
	my %stopWords = ();
	my $count = 0;
	
	open (IN, "data/StopWords") or die $!;
	while (my $in = <IN>)
	{
		chomp $in;
		$stopWords{$in} = 1;
	}
	close (IN);
	
	#if ($selectMode == 0) # entities are ranked by TFIDF
	#{
		open (IN, "data/$topic/$dN/TFIDF_all") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($tfidf, $entity, $entityType) = split /\t/, $in;
			#print "$entity\n";
			#if ($count < 100){
			#if ($tfidf > 3 || lc($entity) eq "i" || lc($entity) eq "we")
			#{
				$entity =~ s/\s/_/g;
				$TFIDFentities{$entity} = $tfidf;
			#}
			$count++;
		}
		close (IN);
	#}
	#elsif ($selectMode == 1) # entity pairs are ranked by average TFIDF
	#{
	#	open (IN, "data/$topic/TFIDF_pairs") or die $!;
	#	while (my $in = <IN>){
	#		chomp $in;
	#		my ($tfidf, $entity1, $entity2) = split /\t/, $in;
	#		#print "$entity\n";
	#		#if ($count < 100){
	#		#if ($tfidf > 3 || lc($entity) eq "i" || lc($entity) eq "we")
	#		#{
	#			$entity =~ s/\s/_/g;
	#			$TFIDFentityPairs{$entity1}{$entity2} = $tfidf;
	#		#}
	#		$count++;
	#	}
	#	close (IN);
	#}
	#elsif ($selectMode == 2) # entity pairs are ranked by NPMI
	#{
	#	open (IN, "data/$topic/NPMI_pairs_bySent") or die $!;
	#	while (my $in = <IN>){
	#		chomp $in;
	#		my ($npmi, $entity1, $entity2, $sentID) = split /\t/, $in;
	#		#print "$entity\n";
	#		#if ($count < 100){
	#		#if ($tfidf > 3 || lc($entity) eq "i" || lc($entity) eq "we")
	#		#{
	#			$entity =~ s/\s/_/g;
	#			$NPMIentityPairs{$entity1}{$entity2}{$sentID} = $npmi;
	#		#}
	#		$count++;
	#	}
	#	close (IN);
	#}
	
	#my $rm = `rm -rf windows/$topic/underscoreEntities`;
	#my $rm = `rm -rf windows/$topic/allEntitiesBySent`;
	#
	#my $mkdir = `mkdir windows/$topic/underscoreEntities`;
	#my $mkdir = `mkdir windows/$topic/allEntitiesBySent`;
	#my $mkdir = `mkdir windows/$topic/allEntitiesBySent/singleENTs`;
	#my $mkdir = `mkdir windows/$topic/underscoreEntities/singleENTs
	
	my $rm = `rm -rf windows/$topic/$dN/underscoreEntities`;
	my $rm = `rm -rf windows/$topic/$dN/allEntitiesBySent`;
	
	my $mkdir = `mkdir windows/$topic/$dN/underscoreEntities`;
	my $mkdir = `mkdir windows/$topic/$dN/allEntitiesBySent`;
	my $mkdir = `mkdir windows/$topic/$dN/allEntitiesBySent/singleENTs`;
	my $mkdir = `mkdir windows/$topic/$dN/underscoreEntities/singleENTs`;
        #opendir (THISDIR, "windows/$topic/taggedEntities") or die "$!";
	#opendir (THISDIR, "windows/$topic/taggedFixedEntities") or die "$!";
	opendir (THISDIR, "windows/$topic/$dN/taggedFixedEntities") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
	my %entitiesIndex = ();
	foreach my $docfile (@docfiles)
	{
		#my $docfile = 2;
		print "doc is $docfile\n";
		my $docfile_out = $docfile;
		$docfile_out =~ s/\..*//;
		#open (OUT, ">windows/$topic/underscoreEntities/$docfile_out") or die "$!";
		#open (ENT, ">windows/$topic/allEntitiesBySent/$docfile_out") or die "$!";
		#open (OUT_SINGLE, ">windows/$topic/underscoreEntities/singleENTs/$docfile_out") or die "$!";
		#open (ENT_SINGLE, ">windows/$topic/allEntitiesBySent/singleENTs/$docfile") or die "$!";
		##open (IN, "windows/$topic/taggedEntities/$docfile") or die "$!";
		#open (IN, "windows/$topic/taggedFixedEntities/$docfile") or die "$!";
		
		open (OUT, ">windows/$topic/$dN/underscoreEntities/$docfile_out") or die "$!";
		open (ENT, ">windows/$topic/$dN/allEntitiesBySent/$docfile_out") or die "$!";
		open (OUT_SINGLE, ">windows/$topic/$dN/underscoreEntities/singleENTs/$docfile_out") or die "$!";
		open (ENT_SINGLE, ">windows/$topic/$dN/allEntitiesBySent/singleENTs/$docfile") or die "$!";
		#open (IN, "windows/$topic/taggedEntities/$docfile") or die "$!";
		open (IN, "windows/$topic/$dN/taggedFixedEntities/$docfile") or die "$!";
		my @sentences = ();
		my $lastSentStatistic = "";
		while (my $in = <IN>){
		      chomp $in;
		      print "in - $in";
		      push @sentences, $in;
		}
		close (IN);
	# 	smaple sentence:
	#	Best  [EN football] team in  [EN Europe] ?
	
		  my $sentNum = 0;
		  
		  foreach my $sentence (@sentences)
		  {
			$sentNum++;
			
			if ($sentence =~ /XXXX/) # dummy word for userIDs in comments
			{
				print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n" . $sentence . ".\n\n";
			}
			else
			{
				$sentence =~ s/\s+/ /g;
				
				my $newsentence = "";
				
				my $entities = "";
				
				print "Sentence # $sentNum: $sentence\n";
				while ($sentence =~ m%([^\[]*)\[EN ([^\]]*)]([^\[]*)%g)
				{
					print "text1: $1\n";
					print "matched phrase: $2\n";
					print "text2: $3\n";
					
					$entities = $entities . $2 . " ";
					$newsentence = $newsentence . " " . $1 . " " . $2 . " " . $3;				
				}
				print "NEWSENTENCE: $newsentence\n\n";
				print "ENTITIES: $entities\n";
				
				
				#print "new sentence ... \n$newsentence\n";
				#print "before cleaning ... \n$sentNum\t$entities\n";
				
				$entities =~ s/_+$//;
				$entities =~ s/_+\]//g;
				$entities =~ s/_\s+/ /g;
				$entities =~ s/\s+$//;
				#$newsentence =~ s/_\]//g;
				$newsentence =~ s/^\s+//;
				$newsentence =~ s/\s+/ /g;
		
				print "CLEAN ENTITIES: $entities\n";
				
				#clean entities
				my @entitiesAr = split / /, $entities;
				my $cleanEntities = "";
				my $entID = 1;
				foreach my $entity (@entitiesAr)
				{
					$entity = cleanEntity($entity);
					$entity =~ s/_+/_/g;
					$entity =~ s/_\s*$//;
					$entity =~ s/_\s/ /g;
					$entity =~ s/\s_/ /g;
					$entity =~ s/^_//;
					$cleanEntities = $cleanEntities . $entity . " ";
					#$Es{$entity} = $entID;
					#$entID++;
				}
				$cleanEntities =~ s/\s+/ /g;
				$cleanEntities =~ s/\s$//;
				
				print "CLEAN*ER* ENTITIES: $entities\n";
				
				@entitiesAr = split / /, $cleanEntities;
				my $numEntities = @entitiesAr;
				my %hashEs = ();
				#@hashEs{@entitiesAr} = ();
				my @uniqueEs = keys %hashEs;
				
		
				#if ($selectMode == 0) # entities are ranked by TFIDF
				#{
					#filter entities by the top TFIDF-ranked entities
					my @cleanEntitiesAR = split / /, $cleanEntities;
					my $filteredEntities = "";
					my %filteredCleanEntitiesHash = ();
					foreach my $cleanEntity (@cleanEntitiesAR){
						my $LCentity = lc($cleanEntity);
						if (exists($TFIDFentities{$LCentity}) && ! exists($stopWords{$LCentity})){
							if (exists($filteredCleanEntitiesHash{$LCentity})){
							}else{
								$filteredEntities = $filteredEntities . $cleanEntity . " ";
								$filteredCleanEntitiesHash{$LCentity} = 1;
							}
						}
						else
						{
							print "$LCentity is NOT added as an entity!\n\n";
							if (exists($TFIDFentities{$LCentity}))
							{
								print "- the problem is with the stop words \n";
							}
							else
							{
								print "- the problem is with TFIDF --  \n";
							}
						}
					}
				#}
				#elsif ($selectMode == 1) # entity pairs are ranked by average TFIDF
				#{
				#	#filter sentences by the top TFIDF-ranked entity pairs
				#	my @cleanEntitiesAR = split / /, $cleanEntities;
				#	my $filteredEntities = "";
				#	my %filteredCleanEntitiesHash = ();
				#	foreach my $cleanEntity (@cleanEntitiesAR){
				#		my $LCentity = lc($cleanEntity);
				#		if (exists($TFIDFentities{$LCentity}) && ! exists($stopWords{$LCentity})){
				#			if (exists($filteredCleanEntitiesHash{$LCentity})){
				#			}else{
				#				$filteredEntities = $filteredEntities . $cleanEntity . " ";
				#				$filteredCleanEntitiesHash{$LCentity} = 1;
				#			}
				#		}
				#	}
				#}
				#elsif ($selectMode == 2) # entity pairs are ranked by NPMI
				#{
				#	#filter sentences by the top NPMI-ranked entity pairs
				#	my @cleanEntitiesAR = split / /, $cleanEntities;
				#	my $filteredEntities = "";
				#	my %filteredCleanEntitiesHash = ();
				#	foreach my $cleanEntity (@cleanEntitiesAR){
				#		my $LCentity = lc($cleanEntity);
				#		if (exists($TFIDFentities{$LCentity}) && ! exists($stopWords{$LCentity})){
				#			if (exists($filteredCleanEntitiesHash{$LCentity})){
				#			}else{
				#				$filteredEntities = $filteredEntities . $cleanEntity . " ";
				#				$filteredCleanEntitiesHash{$LCentity} = 1;
				#			}
				#		}
				#	}
				#	
				#}
				#print entities and sentences into the file used for parsing
				my $numEntities = scalar(keys %filteredCleanEntitiesHash);
				print "#### of Entities: $numEntities\n\n";
				if ($numEntities == 1)
				{
					$filteredEntities =~ s/\s+/ /g;
					$filteredEntities =~ s/\s$//;
					print ENT_SINGLE "$sentNum\t$filteredEntities\n";
					print OUT_SINGLE "ZZZZ" . $sentNum . "ZZZZ.\n\n" . $newsentence . ".\n\n"; #this is needed so that we can extract the ID of the sentence from the parser output
				}
				if ($numEntities > 1){
					$filteredEntities =~ s/\s+/ /g;
					$filteredEntities =~ s/\s$//;
					print ENT "$sentNum\t$filteredEntities\n";
					print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n" . $newsentence . ".\n\n"; #this is needed so that we can extract the ID of the sentence from the parser output
				}
		#
		#		#prepare the index of entities co-occurring in the same sentence
		#		foreach my $entity (keys %filteredCleanEntitiesHash){
		#			foreach my $collocateEntity (keys %filteredCleanEntitiesHash){
		#				if ($entity ne $collocateEntity){
		#					$entitiesIndex{$entity}{$collocateEntity} = $entitiesIndex{$entity}{$collocateEntity} + 1;
		#				}
		#			}
		#		}
			  }
		  }
		  ##the following is dummy sentence ID at the end (needed for the getPaths subroutine)
		  #$sentNum++;
		  #print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n";
		  close (OUT);
		  close (ENT);
	}
#	#print out the index of entities
#	my $mkdir = `mkdir windows/$topic/entitiesIndex`;
#	foreach my $entity ( keys %entitiesIndex ) {
#     		open (OUT, "|sort -rn > windows/$topic/entitiesIndex/$entity");
#     		for my $collocateEntity ( keys %{ $entitiesIndex{$entity} } ) {
#         		print OUT "$entitiesIndex{$entity}{$collocateEntity}\t$collocateEntity\n";
#     		}
#		close (OUT);
# 	}
	
}
sub extractCandidateSentences { # a modified version of extractCandidateRelations for selecting sentences with at least 2 high-ranked entities extracted by both Wikifier and NER
	my $topic = $_[0];
	#my $dN = $_[1];
	my $selectMode = $_[1]; # $selectMode is referring to the criterion used for ranking entities: 0: TFIDF for individual entities; 1: average TFIDF for entity pairs; 2: NPMI for entity pairs
	my %Es = ();
	
	
	my %TFIDFentities = ();
	my %stopWords = ();
	my $count = 0;
	
	#load top TFIDF-ranked entities
	open (IN, "data/$topic/TFIDF_all") or die $!;
	while (my $in = <IN>){
		chomp $in;
		my ($tfidf, $entity) = split /\t/, $in;
		#print "$entity\n";
		if ($count < 150){
			$entity =~ s/\s/_/g;
			$TFIDFentities{$entity} = $tfidf;
		}
		$count++;
	}
	close (IN);
	
	#load StopWords
	open (IN, "data/StopWords") or die $!;
	while (my $in = <IN>)
	{
		chomp $in;
		$stopWords{$in} = 1;
	}
	close (IN);
	
	
	my $rm = `rm -rf windows/$topic/underscoreEntities`;
	my $rm = `rm -rf windows/$topic/allEntitiesBySent`;
	
	my $mkdir = `mkdir windows/$topic/CandidateSentences`;
	my $mkdir = `mkdir windows/$topic/underscoreEntities`;
	my $mkdir = `mkdir windows/$topic/allEntitiesBySent`;
	my $mkdir = `mkdir windows/$topic/allEntitiesBySent/singleENTs`;
	my $mkdir = `mkdir windows/$topic/underscoreEntities/singleENTs`;
	
	open (RELENT, ">windows/$topic/CandidateSentences/RelatedEntities") or die "$!";
	open (RELENT_SINGLE, ">windows/$topic/CandidateSentences/RelatedEntities_single") or die "$!";
	open (OUT, ">windows/$topic/underscoreEntities/underscoreEntities") or die "$!";
	open (ENT, ">windows/$topic/allEntitiesBySent/allEntitiesBySent") or die "$!";
	open (OUT_SINGLE, ">windows/$topic/underscoreEntities/singleENTs/singleENTs") or die "$!";
	open (ENT_SINGLE, ">windows/$topic/allEntitiesBySent/singleENTs/singleENTs") or die "$!";

#	opendir (THISDIR, "windows/$topic/$dN/taggedFixedEntities") or die "$!";
#        my @docfiles = grep !/^\./, readdir THISDIR;
#        closedir THISDIR;
	my %entitiesIndex = ();
#	foreach my $docfile (@docfiles)
	for (my $docfile = 1; $docfile <= 5; $docfile++)
	{
		#my $docfile = 2;
		#print "doc is $docfile\n";
		#my $docfile_out = $docfile;
		#$docfile_out =~ s/\..*//;
		#open (IN, "windows/$topic/taggedEntities/$docfile") or die "$!";
		#open (IN, "windows/$topic/taggedFixedEntities/$docfile") or die "$!";
		
		#open (OUT, ">windows/$topic/$docfile/underscoreEntities/$docfile_out") or die "$!";
		#open (ENT, ">windows/$topic/$docfile/allEntitiesBySent/$docfile_out") or die "$!";
		#open (OUT_SINGLE, ">windows/$topic/$docfile/underscoreEntities/singleENTs/$docfile_out") or die "$!";
		#open (ENT_SINGLE, ">windows/$topic/$docfile/allEntitiesBySent/singleENTs/$docfile") or die "$!";
		open (IN, "windows/$topic/$docfile/taggedFixedEntities/$docfile") or die "$!";
		
		my @sentences = ();
		my $lastSentStatistic = "";
		while (my $in = <IN>){
		      chomp $in;
		      print "in - $in";
		      push @sentences, $in;
		}
		close (IN);
	# 	sample sentence:
	#	Best  [EN football] team in  [EN Europe] ?
	
		my $sentNum = 0;
		
		foreach my $sentence (@sentences)
		{
		      $sentNum++;
		      
		      if ($sentence =~ /XXXX/) # dummy word for userIDs in comments
		      {
			      print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n" . $sentence . ".\n\n";
		      }
		      else
		      {
			      $sentence =~ s/\s+/ /g;
			      
			      my $newsentence = "";
			      
			      my $entities = "";
			      
			      print "Sentence # $sentNum: $sentence\n";
			      while ($sentence =~ m%([^\[]*)\[EN ([^\]]*)]([^\[]*)%g)
			      {
				      print "text1: $1\n";
				      print "matched phrase: $2\n";
				      print "text2: $3\n";
				      
				      $entities = $entities . $2 . " ";
				      $newsentence = $newsentence . " " . $1 . " " . $2 . " " . $3;				
			      }
			      print "NEWSENTENCE: $newsentence\n\n";
			      print "ENTITIES: $entities\n";
			      
			      
			      #print "new sentence ... \n$newsentence\n";
			      #print "before cleaning ... \n$sentNum\t$entities\n";
			      
			      $entities =~ s/_+$//;
			      $entities =~ s/_+\]//g;
			      $entities =~ s/_\s+/ /g;
			      $entities =~ s/\s+$//;
			      #$newsentence =~ s/_\]//g;
			      $newsentence =~ s/^\s+//;
			      $newsentence =~ s/\s+/ /g;
	      
			      print "CLEAN ENTITIES: $entities\n";
			      
			      #clean entities
			      my @entitiesAr = split / /, $entities;
			      my $cleanEntities = "";
			      my $entID = 1;
			      foreach my $entity (@entitiesAr)
			      {
				      $entity = cleanEntity($entity);
				      $entity =~ s/_+/_/g;
				      $entity =~ s/_\s*$//;
				      $entity =~ s/_\s/ /g;
				      $entity =~ s/\s_/ /g;
				      $entity =~ s/^_//;
				      $cleanEntities = $cleanEntities . $entity . " ";
				      #$Es{$entity} = $entID;
				      #$entID++;
			      }
			      $cleanEntities =~ s/\s+/ /g;
			      $cleanEntities =~ s/\s$//;
			      
			      print "CLEAN*ER* ENTITIES: $entities\n";
			      
			      @entitiesAr = split / /, $cleanEntities;
			      my $numEntities = @entitiesAr;
			      my %hashEs = ();
			      #@hashEs{@entitiesAr} = ();
			      my @uniqueEs = keys %hashEs;
			      
	      
			      #filter entities by the top TFIDF-ranked entities
			      my @cleanEntitiesAR = split / /, $cleanEntities;
			      my $filteredEntities = "";
			      my %filteredCleanEntitiesHash = ();
			      foreach my $cleanEntity (@cleanEntitiesAR){
				      my $LCentity = lc($cleanEntity);
				      if (exists($TFIDFentities{$LCentity}) && ! exists($stopWords{$LCentity})){
					      if (exists($filteredCleanEntitiesHash{$LCentity})){
					      }else{
						      $filteredEntities = $filteredEntities . $cleanEntity . " ";
						      $filteredCleanEntitiesHash{$LCentity} = 1;
					      }
				      }
				      else
				      {
					      print "$LCentity is NOT added as an entity!\n\n";
					      if (exists($TFIDFentities{$LCentity}))
					      {
						      print "- the problem is with the stop words \n";
					      }
					      else
					      {
						      print "- the problem is with TFIDF --  \n";
					      }
				      }
			      }
			      
			      #print entities and sentences into the file used for parsing
			      my $numEntities = scalar(keys %filteredCleanEntitiesHash);
			      print "#### of Entities: $numEntities\n\n";
			      if ($numEntities == 1)
			      {
				      $filteredEntities =~ s/\s+/ /g;
				      $filteredEntities =~ s/\s$//;
				      print ENT_SINGLE "$sentNum\t$filteredEntities\n";
				      print OUT_SINGLE "ZZZZ" . $sentNum . "ZZZZ.\n\n" . $newsentence . ".\n\n"; #this is needed so that we can extract the ID of the sentence from the parser output
				      print RELENT_SINGLE "$sentNum\t$filteredEntities\n$sentence\n\n";
			      }
			      if ($numEntities > 1){
				      $filteredEntities =~ s/\s+/ /g;
				      $filteredEntities =~ s/\s$//;
				      print ENT "$sentNum\t$filteredEntities\n";
				      print OUT "ZZZZ" . $sentNum . "ZZZZ.\n\n" . $newsentence . ".\n\n"; #this is needed so that we can extract the ID of the sentence from the parser output
				      print RELENT "$sentNum\t$filteredEntities\n$sentence\n\n";
			      }

			}
		}
	}
	close (OUT);
	close (ENT);
}
sub extractCandidateLabels # retrieves the context in which an entity pair occurs within a window size
{
	my $topic = $_[0];
	my %TFIDFentities = ();
	
	my $mkdir = `mkdir windows/$topic/CandidateLabels`;
	open (OU, ">windows/$topic/CandidateLabels/Snippets") or die "$!";
	
	#load top TFIDF-ranked entities
	open (IN, "data/$topic/TFIDF_top_40") or die $!;
	while (my $in = <IN>){
		chomp $in;
		my ($tfidf, $entity) = split /\t/, $in;
		#print "$entity\n";
		$entity =~ s/\s/_/g;
		$TFIDFentities{$entity} = $tfidf;
	}
	close (IN);

#	@get 468742 468751
	my ($wcommand) = "\@get 468742 468751 \n";
	my @chunk  = wumpusResponse($wumpus, $wcommand );
	print "TEST CHUNK: @chunk\n";
	
	my ($command ) = "\@count ((\"Ottawa\"^\"Canada\")<[10])<(\"<doc>\"..\"</doc>\")\n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $jointF = $response[0];
	
	print "JOINT FREQ: $jointF\n";
	
	
	
	foreach my $key1 ( sort {$a<=>$b} keys %TFIDFentities) { # creates entity pairs and calculates NPMI for every pair
	foreach my $key2 ( sort {$a<=>$b} keys %TFIDFentities) {
		if ($key1 lt $key2)
		{
			#my ($command ) = "\@count ((\"$NP1\"^\"$NP2\")<[10])<(\"<doc>\"..\"</doc>\")\n";
			
			#@qap[3] $DOCS by (("kingston"^"canada") < [30] )
			my ($command ) = "\@qap[50] \$DOCS by ((\"$key1\"^\"$key2\")<[100])\n";
			#my ($command ) = "\@qap[count=50] \$DOCS by ((\"$key1\"^\"$key2\")<[10])\n";
			#my ($command ) = "\@qap[count=50][docid] \$DOCS by ((\"$key1\"^\"$key2\")<[10])\n";
			#my ($command ) = "\@qap[count=50][docid]<(\"<doc>\"..\"</doc>\") by ((\"$key1\"^\"$key2\")<[10]))\n";
			
			
			my (@response) = wumpusResponse($wumpus, $command);
			
			foreach my $entry (@response)
			{
				#11.156852 982338 983275 982485 982490 "FT932-15345"
				$entry =~ s/\n//g;
				
				print "\n *** entry is $entry\n\n";
				#my ($score, $doc_start, $doc_end, $passage_start, $passage_end,$docid)  =split(/\s+/,$entry) ;
				my ($id, $score, $doc_start, $doc_end, $passage_start, $passage_end)  =split(/\s+/,$entry) ;
				
				print "*** score: $score -- doc_start: $doc_start -- doc_end: $doc_end -- passage_start: $passage_start -- passage_end: $passage_end\n\n";
				
				$passage_start =~ s/\n//g;
				$passage_end =~ s/\n//g;
				
				print "**** $passage_start --- $passage_end\n";
				my ($passage_command) = "\@get $passage_start $passage_end \n";
				#my ($passage_command) = "\@get $passage_end $passage_start \n";
				my @passage_chunk  = wumpusResponse($wumpus, $passage_command );
				
				print "*** passage_chunk is @passage_chunk\n";

				print OU "@passage_chunk "; # will print all the passage as a chunk . You can open the OU in each entry to get the passage as separate file .
			}
		}
	}
	}

	close OU;	
}

sub getPaths_EN { # the latest version of getPaths from v15
my $topic = $_[0];
my $dN = $_[1];
	
	#my $mkdir = `mkdir windows/$topic/candidateSentences_RE`;
	#my $mkdir = `mkdir windows/$topic/candidateSentences_RE/EntityPairs`;
	#my $mkdir = `mkdir windows/$topic/candidateSentences_RE/tagged`;
	#my $mkdir = `mkdir windows/$topic/candidateSentences_RE/plain`;
	#my $mkdir = `mkdir windows/$topic/pathsBetweenEntities`;
	#opendir (THISDIR, "windows/$topic/allEntitiesBySent") or die "$!";
	
	my $mkdir = `mkdir windows/$topic/$dN/candidateSentences_RE`;
	my $mkdir = `mkdir windows/$topic/$dN/candidateSentences_RE/EntityPairs`;
	my $mkdir = `mkdir windows/$topic/$dN/candidateSentences_RE/tagged`;
	my $mkdir = `mkdir windows/$topic/$dN/candidateSentences_RE/plain`;
	my $mkdir = `mkdir windows/$topic/$dN/pathsBetweenEntities`;
	opendir (THISDIR, "windows/$topic/$dN/allEntitiesBySent") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        my %entitiesIndex = ();
        foreach my $docfile (@docfiles)
	{
		if ($docfile == $dN)
		{
		print "$docfile\n";
		#open (OUT, ">windows/$topic/pathsBetweenEntities/$docfile") or die $!;
		#open (RNE, ">windows/$topic/candidateSentences_RE/EntityPairs/$docfile") or die $!;
		#open (tagged_OUT, ">windows/$topic/candidateSentences_RE/tagged/$docfile") or die $!;
		#open (plain_OUT, ">windows/$topic/candidateSentences_RE/plain/$docfile") or die $!;
		##read sentences
		##open (IN, "windows/$topic/taggedEntities/$docfile") or die "$!";
		#open (IN, "windows/$topic/taggedFixedEntities/$docfile") or die "$!";
		
		open (OUT, ">windows/$topic/$dN/pathsBetweenEntities/$docfile") or die $!;
		open (RNE, ">windows/$topic/$dN/candidateSentences_RE/EntityPairs/$docfile") or die $!;
		open (tagged_OUT, ">windows/$topic/$dN/candidateSentences_RE/tagged/$docfile") or die $!;
		open (plain_OUT, ">windows/$topic/$dN/candidateSentences_RE/plain/$docfile") or die $!;
		#read sentences
		#open (IN, "windows/$topic/taggedEntities/$docfile") or die "$!";
		open (IN, "windows/$topic/$dN/taggedFixedEntities/$docfile") or die "$!";
		my @sentences = ();
		push @sentences, "dummy";
		while (my $in = <IN>){
			chomp $in;
			push @sentences, $in;
		}
		close (IN);
		#read entities by sentence
		my %entities = ();
		#open (IN, "windows/$topic/allEntitiesBySent/$docfile") or die $!;
		open (IN, "windows/$topic/$dN/allEntitiesBySent/$docfile") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($sentID, $entityList) = split /\t/, $in;
			$entities{$sentID} = $entityList;
		}
		close (IN);
		#read parsed sentences
		#open (IN, "windows/$topic/parsedWithEntities/$docfile") or die $!;
		open (IN, "windows/$topic/$dN/parsedWithEntities/$docfile") or die $!;
		%dependencyGraph = ();
		my %matchingEntities = ();
		my %sentEntities = ();
		my $sentID = 0;
		my $previousSentid = 0;
		my $tempSentid = -1;
		
		print "read sentences, entitiiesPerSent and parse results! \n";
		while (my $in = <IN>){
			chomp $in;
			if ($in =~ /XXXX/) # dummy word for UserIDs with the following format: root(ROOT-0, XXXX1669XXXX-1)
			{
				my $userID = $in;
				$userID =~ s/^root\(ROOT\-0,\sXXXX(\d+)XXXX.+$/$1/;
				print OUT "XXXX" . $userID . "XXXX\n";
			}
			elsif ($in =~ /ZZZZ/){
				if ($sentID > 0){ #if not the first sentence   --- football query crashes on docs 16 and 45
					####process previous sentence
					#generate beginning and end points
					foreach my $key1 ( sort {$a<=>$b} keys %matchingEntities) {
						foreach my $key2 ( sort {$a<=>$b} keys %matchingEntities) {
							if ($key1 < $key2){
								$dependencyStart = $matchingEntities{$key1};
								$dependencyStop = $matchingEntities{$key2};
								#print "\t<START><KEY>$key1</KEY>$dependencyStart</START><END><KEY>$key2</KEY>$dependencyStop</END>\n";
								%candidatePaths = ();
								%candidatePathsFull = ();
								track($dependencyStart);
								#select the shortest path between key1 and key2
								my $shortestPath = "";
								my $shortestPathLength = 1000;
  								foreach my $key (keys %candidatePathsFull){
        								if ($candidatePathsFull{$key} < $shortestPathLength){
                								$shortestPath = $key;
                								$shortestPathLength = $candidatePathsFull{$key};
        								}
  								}
								#process the shortest path
								if ($shortestPathLength < 1000){
									#apply rules to check if it is a valid path (...can add more rules later)
									my $validPath = 1;
									#rule 1: path is not valid if it only consists of one conj_and relation
									if ($shortestPathLength == 1){
										if ($shortestPath =~ /conj_and/){
											$validPath = 0;
										#}elsif ($shortestPath =~ /dep/){
                                                                                #        $validPath = 0;
										}
									}
									###end of validation rules
									print "the shortest path\n";
									if ($validPath == 1){
										print OUT $candidatePaths{$shortestPath} . "\n"; #print only the beginning and end (tab-separated)

										#print out the sentence
										print OUT "\n" . $previousSentid . "\t" .  $sentences[$previousSentid] . "\n";
										
										#print the sentences with a candidate path
										print tagged_OUT $previousSentid . "\t" .  $sentences[$previousSentid] . "\n";
										
										#print the sentences with a candidate path
										my $plainSentence = $sentences[$previousSentid];
										$plainSentence =~ s/\[EN//g;
										$plainSentence =~ s/\]//g;
										$plainSentence =~ s/^\s+//;
										if ($tempSentid == -1 || ($tempSentid != -1 && $tempSentid != $previousSentid))
										{
											print plain_OUT $plainSentence . "\n";
										}
										$tempSentid = $previousSentid;
										#print out the path
										print OUT $candidatePaths{$shortestPath} . "\t" . $shortestPath . "\n"; #print: Beginning \t End \t Complete Path
										print RNE $candidatePaths{$shortestPath} . "\n";
									}
  								}

							}
						}
					}
				}
				#clear all hashes and arrays from the previous sentence
				%matchingEntities = ();
				%dependencyGraph = ();
				%sentEntities = ();
				%entityPairsWithRelations = ();
				###

				$sentID = $in;
				$sentID =~ s/^root\(ROOT\-0,\sZZZZ(\d+)ZZZZ.+$/$1/;
				$previousSentid = $sentID;
				print "<DOCID>$docfile</DOCID><SENTID>$sentID</SENTID>\n";
				my @currentSentEntities = split /\s/, $entities{$sentID};
				foreach my $entity (@currentSentEntities){
					$sentEntities{$entity} = 1;
				}
			}else{
				if ($in ne ""){
					#nn(student-3, Fergus-2)
					my $depRel = $in;
					$depRel =~ s/^(.+?)\(.+$/$1/;
					my $Args = $in;
					$Args =~ s/^.+?\((.+?),\s(.+?)\)$/$1$2/;
					my $arg1 = $1;
					my $arg2 = $2;
					$entityPairsWithRelations{$arg1}{$arg2} = " ->-" . $depRel . "->- ";
					$entityPairsWithRelations{$arg2}{$arg1} = " -<-" . $depRel . "-<- ";
					push @{ $dependencyGraph{$arg1} }, $arg2;
					push @{ $dependencyGraph{$arg2} }, $arg1;
					my ($word1, $id1) = split /\-/, $arg1;
					if (exists($sentEntities{$word1})){
						$matchingEntities{$id1} = $arg1;
					}
					my ($word2, $id2) = split /\-/, $arg2;
					if (exists($sentEntities{$word2})){
                                                $matchingEntities{$id2} = $arg2;
                                        }
				}
			}
		}
		close (IN);
		close (OUT);
		}
	}
}
sub getPaths_Entities { # extracts relations between highly ranked entity pairs occuring in a sentence
	my $topic = $_[0];
	my $mkdir = `mkdir windows/$topic/pathsBetweenEntities`;
	opendir (THISDIR, "windows/$topic/allEntitiesBySent") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
        my %entitiesIndex = ();
        foreach my $docfile (@docfiles)
	{
		print "$docfile\n";
		open (OUT, ">windows/$topic/pathsBetweenEntities/$docfile") or die $!;
		##read sentences
		#open (IN, "windows/$topic/taggedNE-windows/$docfile") or die "$!";
		#my @sentences = ();
		#push @sentences, "dummy";
		#while (my $in = <IN>){
		#	chomp $in;
		#	push @sentences, $in;
		#}
		#close (IN);

		#read entities by sentence
		my %entities = ();
		open (IN, "windows/$topic/allEntitiesBySent/$docfile") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($sentID, $entityList) = split /\t/, $in;
			$entities{$sentID} = $entityList;
		}
		close (IN);
		#read parsed sentences
		open (IN, "windows/$topic/parsedWithEntities/$docfile") or die $!;
		%dependencyGraph = ();
		my %matchingEntities = ();
		my %sentEntities = ();
		my $sentID = 0;
		while (my $in = <IN>){
			chomp $in;
			if ($in =~ /ZZZZ/){
				if ($sentID > 0){ #if not the first sentence
					####process previous sentence
					#generate beginning and end points
					foreach my $key1 ( sort {$a<=>$b} keys %matchingEntities) {
						foreach my $key2 ( sort {$a<=>$b} keys %matchingEntities) {
							if ($key1 < $key2){
								$dependencyStart = $matchingEntities{$key1};
								$dependencyStop = $matchingEntities{$key2};
								#print "\t<START><KEY>$key1</KEY>$dependencyStart</START><END><KEY>$key2</KEY>$dependencyStop</END>\n";
								%candidatePaths = ();
								%candidatePathsFull = ();
								track($dependencyStart);
								#select the shortest path between key1 and key2
								my $shortestPath = "";
								my $shortestPathLength = 1000;
  								foreach my $key (keys %candidatePathsFull){
        								if ($candidatePathsFull{$key} < $shortestPathLength){
                								$shortestPath = $key;
                								$shortestPathLength = $candidatePathsFull{$key};
        								}
  								}
								#process the shortest path
								if ($shortestPathLength < 1000){
									#apply rules to check if it is a valid path (...can add more rules later)
									my $validPath = 1;
									#rule 1: path is not valid if it only consists of one conj_and relation
									if ($shortestPathLength == 1){
										if ($shortestPath =~ /conj_and/){
											$validPath = 0;
										#}elsif ($shortestPath =~ /dep/){
                                                                                #        $validPath = 0;
										}
									}
									###end of validation rules
									#print the shortest path
									if ($validPath == 1){
										#print OUT "\t\t" . "<NUMRELS>" . $shortestPathLength . "</NUMRELS>" . $shortestPath . "\n"; #print the complete path
										#print OUT $candidatePaths{$shortestPath} . "\n"; #print only the beginning and end (tab-separated)
										print OUT $candidatePaths{$shortestPath} . "\t" . $shortestPath . "\n"; #print: Beginning \t End \t Complete Path
									}
  								}

							}
						}
					}
				}
				#clear all hashes and arrays from the previous sentence
				%matchingEntities = ();
				%dependencyGraph = ();
				%sentEntities = ();
				%entityPairsWithRelations = ();
				###

				$sentID = $in;
				$sentID =~ s/^root\(ROOT\-0,\sZZZZ(\d+)ZZZZ.+$/$1/;
				#print "<DOCID>$docfile</DOCID><SENTID>$sentID</SENTID>\n";
				my @currentSentEntities = split /\s/, $entities{$sentID};
				foreach my $entity (@currentSentEntities){
					$sentEntities{$entity} = 1;
				}
			}else{
				if ($in ne ""){
					#nn(student-3, Fergus-2)
					my $depRel = $in;
					$depRel =~ s/^(.+?)\(.+$/$1/;
					my $Args = $in;
					$Args =~ s/^.+?\((.+?),\s(.+?)\)$/$1$2/;
					my $arg1 = $1;
					my $arg2 = $2;
					$entityPairsWithRelations{$arg1}{$arg2} = " ->-" . $depRel . "->- ";
					$entityPairsWithRelations{$arg2}{$arg1} = " -<-" . $depRel . "-<- ";
					push @{ $dependencyGraph{$arg1} }, $arg2;
					push @{ $dependencyGraph{$arg2} }, $arg1;
					my ($word1, $id1) = split /\-/, $arg1;
					if (exists($sentEntities{$word1})){
						$matchingEntities{$id1} = $arg1;
					}
					my ($word2, $id2) = split /\-/, $arg2;
					if (exists($sentEntities{$word2})){
                                                $matchingEntities{$id2} = $arg2;
                                        }
				}
			}
		}
		close (IN);
		close (OUT);
	 
	}
}
sub runCurator
{
	my $start = cwd();

	my $dist_dir = "/data/bsarrafzadeh/NLP-Tools/curator-1.0.0/dist";
	my $curator_dir = "/data/bsarrafzadeh/NLP-Tools/curator-1.0.0";

	my $set_envVars = `source $curator_dir/setEnvVars.sh &`;
	my $runMongoDB = `$curator_dir/startMongo.sh &`; 

	#chdir("/data/bsarrafzadeh/NLP-Tools/curator-1.0.0/dist");
	#my $curatorDIR = `cd /data/bsarrafzadeh/NLP-Tools/curator-1.0.0/dist`;
	#system("cd /data/bsarrafzadeh/NLP-Tools/curator-1.0.0/dist");
	#my $runAnnotators = `cd /data/bsarrafzadeh/NLP-Tools/curator-1.0.0/dist` ; `bin/illinois-pos-server.sh -p 9091 >& log/pos.log &` ; `bin/illinois-chunker-server.sh -p 9092 >& log/chunk.log &` ; `bin/stanford-parser-server.sh -p 9095 >& log/stanford.log &` ; `bin/illinois-wikifier-server.sh -p 15231 >& log/wikifier.log &` ; `bin/illinois-ner-extended-server.pl ner-ext 9096 configs/ner.conll.config >& log/ner-ext-conll.log &` ; `bin/illinois-ner-extended-server.pl ner-ext 9097 configs/ner.ontonotes.config >& logs/ner-ext-ontonotes.log &` ;  `bin/curator.sh --annotators configs/annotators-example.xml --port 9010 --threads 10 >& log/curator.log &`;
	#my $curatorDIR = cwd();
	my $runPOStagger = `$dist_dir/bin/illinois-pos-server.sh -p 9091 >& $dist_dir/log/pos.log &`;
	my $runChunker = `$dist_dir/bin/illinois-chunker-server.sh -p 9092 >& $dist_dir/log/chunk.log &`;
	my $runStanfordParser = `$dist_dir/bin/stanford-parser-server.sh -p 9095 >& $dist_dir/log/stanford.log &`;
	my $runWikifier = `$dist_dir/bin/illinois-wikifier-server.sh -p 15231 >& $dist_dir/log/wikifier.log &`;
	my $NER = `$dist_dir/bin/illinois-ner-extended-server.pl ner-ext 9096 $dist_dir/configs/ner.conll.config >& $dist_dir/log/ner-ext-conll.log &`;
	my $runExNER = `$dist_dir/bin/illinois-ner-extended-server.pl ner-ext 9097 $dist_dir/configs/ner.ontonotes.config >& $dist_dir/log/ner-ext-ontonotes.log &`;
	my $runCurator = `$dist_dir/bin/curator.sh --annotators $dist_dir/configs/annotators-example.xml --port 9010 --threads 10 >& $dist_dir/log/curator.log &`;


	print "curator is bull shivik \n";
}
sub killCurator
{
	my $pos_id = `ps -ef | grep pos-server`;
	my @elements = split (/\s+/, $pos_id);
	print "POS process:\n$pos_id\n\n";
	$pos_id = $elements[1];
	print "POS PID:\n$pos_id\n\n";
	my $kill = `kill -9 $pos_id`;
	
	
	my $chunk_id = `ps -ef | grep chunk`;
	print "Chunker process:\n$chunk_id\n\n";
	@elements = split (/\s+/, $chunk_id);
	$chunk_id = $elements[1];
	print "Chunker PID:\n$chunk_id\n\n";
	$kill = `kill -9 $chunk_id`;
	
	my $ner_id = `ps -ef | grep ner-ext`;
	print "1st NER process:\n$ner_id\n\n";
	@elements = split (/\s+/, $ner_id);
	$ner_id = $elements[1];
	print "1st NER PID:\n$ner_id\n\n";
	$kill = `kill -9 $ner_id`;
	
	$ner_id = `ps -ef | grep ner-ext`; # kill the second ner
	print "2nd NER process:\n$ner_id\n\n";
	@elements = split (/\s+/, $ner_id);
	$ner_id = $elements[1];
	print "2nd NER PID:\n$ner_id\n\n";
	$kill = `kill -9 $ner_id`;
	
	my $stanford_id = `ps -ef | grep stanford`;
	print "Stanford Parser process:\n$stanford_id\n\n";
	@elements = split (/\s+/, $stanford_id);
	$stanford_id = $elements[1];
	print "Stanford Parser PID:\n$stanford_id\n\n";
	$kill = `kill -9 $stanford_id`;
	

	
	my $wikifier_id = `ps -ef | grep wikifier`;
	print "Wikifier process:\n$wikifier_id\n\n";
	@elements = split (/\s+/, $wikifier_id);
	$wikifier_id = $elements[1];
	print "Wikifier PID:\n$wikifier_id\n\n";
	$kill = `kill -9 $wikifier_id`;
	
	my $curator_id = `ps -ef | grep curator`;
	print "Curator process:\n$curator_id\n\n";
	@elements = split (/\s+/, $curator_id);
	$curator_id = $elements[1];
	print "Curator PID:\n$curator_id\n\n";
	$kill = `kill -9 $curator_id`;
	
	my $mongo_id = `ps -ef | grep mongo`;
	print "Wikifier process:\n$mongo_id\n\n";
	@elements = split (/\s+/, $mongo_id);
	$mongo_id = $elements[1];
	print "Wikifier PID:\n$mongo_id\n\n";
	$kill = `kill -9 $mongo_id`;
}
sub tagEntities
{
	my $topic = $_[0];
	my $dN = $_[1];
	my $start = cwd();
	
	my $mkdir = `mkdir windows/$topic`;
	
	#my $rmdir = `rm -rf windows/$topic/CuratorAnnotations`;
	#my $mkdir = `mkdir windows/$topic/CuratorAnnotations`;
	#
	#my $rmdir = `rm -rf windows/$topic/taggedPhrases`;
	#my $mkdir = `mkdir windows/$topic/taggedPhrases`;
	
	my $mkdir = `mkdir windows/$topic/$dN`;
	
	my $rmdir = `rm -rf windows/$topic/$dN/CuratorAnnotations`;
	my $mkdir = `mkdir windows/$topic/$dN/CuratorAnnotations`;
	
	my $rmdir = `rm -rf windows/$topic/$dN/taggedPhrases`;
	my $mkdir = `mkdir windows/$topic/$dN/taggedPhrases`;
	my $curatorDIR = "/data/bsarrafzadeh/NLP-Tools/curator-1.0.0";
	
	#my $cpy = `cp Data/MyLifeList/cleanDocs/$topic docs/$topic/sentDocs/$topic`;
	
	opendir (THISDIR, "docs/$topic/sentDocs") or die "$!";
	my @docfiles = grep !/^\./, readdir THISDIR;
	
	chdir("$curatorDIR/dist/client-examples/java");
	
	#my $command = `./runclient.sh localhost 9010 coffee/25.old $start/windows/3/taggedPhrases`;
	
	foreach my $docfile (@docfiles)
	{
		if ($docfile == $dN){
		open (IN, "$start/docs/$topic/sentDocs/$docfile") or die "there is no such file! $!";
		my @lines;
		while (my $in = <IN>){
		      chomp $in;
		      push @lines, $in;
		}
		close (IN);
		
		print "$start/docs/$topic/sentDocs/$docfile \n";
		
		my $command = `./runclient.sh localhost 9010 $start/docs/$topic/sentDocs/$docfile $start/windows/$topic/$dN/taggedPhrases`;
		}
	}
	print "Start: $start\n";
	chdir("$start");
	my $pwd = cwd();
	print "PWD: $pwd\n";
	
}
sub selectPaths	# select potentially meaningful relations from all extracted paths 
{
	my $topic = $_[0];
	my $dN = $_[1];
	
	#my $rmdir = `rm -rf windows/$topic/selectedPaths`;	
	#my $mkdir = `mkdir windows/$topic/selectedPaths`;
	
	my $rmdir = `rm -rf windows/$topic/$dN/selectedPaths`;	
	my $mkdir = `mkdir windows/$topic/$dN/selectedPaths`;
	
	#opendir (THISDIR, "windows/$topic/pathsBetweenEntities") or die "$!";
	opendir (THISDIR, "windows/$topic/$dN/pathsBetweenEntities") or die "$!";
	my @docfiles = grep !/^\./, readdir THISDIR;
	
	foreach my $docfile (@docfiles)
	{
		print "$docfile\n";
		open (IN, "windows/$topic/$dN/pathsBetweenEntities/$docfile") or die "there is no such file! $!";
		open (OUT, ">windows/$topic/$dN/selectedPaths/$docfile") or die "$!";
		my @lines;
		while (my $in = <IN>){
		      chomp $in;
		      push @lines, $in;
		}
		close (IN);
		
		# sample input file format:
		# Coffee	tea
		
		# 23	 [EN Coffee]   [EN tea]  and  [EN horticultural] exports were all up, but  [EN tourism] was down.
		# Coffee	tea	Coffee-1 -<-nn-<- tea-2

		
		my $line;
		my $block = "";
		my $i = 0;
		my $j = 0;
		my $sentNum = 0;
		while ($i < @lines)
		{
			while ($i < @lines && $lines[$i] =~ /XXXX/) # dummy word for UserID
			{
				print OUT "$lines[$i]\n";
				$i++;
			}
			print "-- entity pair: $lines[$i]\n";
			$block = $block . $lines[$i] . "\n"; # entity pair
			$i += 2; # skipping the blank line
			$block = $block . "\n";
			$block = $block . $lines[$i] . "\n"; # sentenceNum sentence
			print "-- sentence: $lines[$i]\n";
			$i++;
			my ($entity1, $entity2, $path) = split /\t/, $lines[$i];
			print "path: -- $lines[$i]\n";
			$block = $block . $lines[$i];
			
			if ($path !~ /->-dep->/ && $path !~ /->-rcmod->-/ && $path !~ /->-ccomp->-/) # remove any paths with dep, ccomp rcmod in it
			{
			if ($entity1 ne $entity2)
			{
				if ($path =~ m%^$entity1-[0-9]* -<-nsubj-.*-dobj->- $entity2-[0-9]*$%g)
				{
					print "$path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-nsubj-.*-iobj->- $entity2-[0-9]*$%g)
				{
					print "$path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-\(amod\|nn\)-.*-nsubj-.*-dobj-.*\(amod\|nn\)->- $entity2-[0-9]*$%g)
				{
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-\(amod\|nn\)-.*-nsubj-.*-iobj-.*\(amod\|nn\)->- $entity2-[0-9]*$%g)
				{
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-nsubjpass-.*-agent->- $entity2-[0-9]*$%g)
				{
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-xsubj-.*-dobj->- $entity2-[0-9]*$%g) # The [EN BN] is used to operate [EN corporate_income_tax] : BN-2 -<-xsubj-<- operate-6 ->-dobj->- corporate_income_tax-7
				{
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-xsubj-.*-prep_.*->- $entity2-[0-9]*$%g)
				{
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-xsubj-.*-prepc_.*->- $entity2-[0-9]*$%g)
				{
					# 26	 [EN Stravinsky] enrolled to study [EN law] at [EN the_University_of_Saint_Petersburg] in [EN 1901] , but he attended fewer than fifty [EN class_sessions] during his four [EN years] of [EN study] .
					# Stravinsky	the_University_of_Saint_Petersburg	Stravinsky-1 -<-xsubj-<- study-4 ->-prepc_at->- the_University_of_Saint_Petersburg-7
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-nsubj-.*-prep_.*->- $entity2-[0-9]*$%g)
				{
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-nsubj->- $entity2-[0-9]*$%g)
				{
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-prep_.*-dobj-.*->- $entity2-[0-9]*$%g)
				{
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-prep_.*-iobj-.*->- $entity2-[0-9]*$%g)
				{
					print "**** $path\n";
					print OUT "$block\n";
				}
				elsif ($path =~ m%^$entity1-[0-9]* -<-partmod-.*-\(agent\|prep_.*\)->- $entity2-[0-9]*$%g)
				{
					print "**** $path\n";
					print OUT "$block\n";
				}	
			}
			}
			$i++;
			$block = "";
		}
		#my $command = `./runclient.sh localhost 9010 $start/docs/$topic/sentDocs/$docfile $start/windows/$topic/taggedPhrases`;
	}
	close OUT;
}
sub augmentPaths	# augment selected paths by selectPaths by adding missing dependencies from the parser output
{
	my $topic = $_[0];
	my $dN = $_[1];
	
	# Create a new NLP pipeline (don't silence messages, do make corefs bidirectional)
	$pipeline = new Lingua::StanfordCoreNLP::Pipeline(0, 1);
	my %Dependencies = ();
	#my $rmdir = `rm -rf windows/$topic/relationLabels`;
		
	#my $mkdir = `mkdir windows/$topic/relationLabels`;
	
	#opendir (THISDIR, "windows/$topic/selectedPaths") or die "$!";
	
	my $rmdir = `rm -rf windows/$topic/$dN/relationLabels`;
		
	my $mkdir = `mkdir windows/$topic/$dN/relationLabels`;
	
	opendir (THISDIR, "windows/$topic/$dN/selectedPaths") or die "$!";
	my @docfiles = grep !/^\./, readdir THISDIR;
	
	my $sentID;
	my $currentUserID = 0;
	my $mainUserID = 0;
	foreach my $docfile (@docfiles)
	{
		print "$docfile\n";
		#open (IN, "windows/$topic/selectedPaths/$docfile") or die "there is no such file! $!";
		##open (PARSE, "windows/$topic/parsedWithEntities/$docfile") or die "there is no such file! $!";
		#open (OUT, ">windows/$topic/relationLabels/$docfile") or die "$!";
		
		open (IN, "windows/$topic/$dN/selectedPaths/$docfile") or die "there is no such file! $!";
		open (OUT, ">windows/$topic/$dN/relationLabels/$docfile") or die "$!";
		
		my $outFile = $topic . "_triples";
		my $outFile2 = $topic . "_tuples";
		#open (TRIPLES, ">windows/$topic/relationLabels/$outFile") or die "$!";
		#open (TUPLES, ">windows/$topic/relationLabels/$outFile2") or die "$!";
		open (TRIPLES, ">windows/$topic/$dN/relationLabels/$outFile") or die "$!";
		open (TUPLES, ">windows/$topic/$dN/relationLabels/$outFile2") or die "$!";
		my @lines;
		while (my $in = <IN>){
		      chomp $in;
		      push @lines, $in;
		}
		close (IN);
		
		# sample selectedPaths file format:
		# XXXXuserIDXXXX     --> might appear on some lines and not all of them -- indicator of comments made by a user with ID: userID
		# Coffee	tea
		
		# 23	 [EN Coffee]   [EN tea]  and  [EN horticultural] exports were all up, but  [EN tourism] was down.
		# Coffee	tea	Coffee-1 -<-nn-<- tea-2

		
		my $line;
		my $block = "";
		my $i = 0;
		my $j = 0;
		my $augmentedPath;
		my $label;
		my $neatLabel;
		while ($i < @lines)
		{
			my $flag = 0;
			if ($lines[$i] =~ /XXXX/) # the ID for the main user
			{
				$mainUserID = $lines[$i];
				$mainUserID =~ s/^XXXX(\d+)XXXX$/$1/;
				print "main user: XXXX $mainUserID\n";
				$currentUserID = $mainUserID;
				$i++;
			}
			while ($lines[$i] =~ /XXXX/)
			{
				$currentUserID = $lines[$i];
				$currentUserID =~ s/^XXXX(\d+)XXXX$/$1/;
				print "XXXX $currentUserID\n";
				$i++;
			}
			print "-- entity pair: $lines[$i]\n";
			my ($ent1, $ent2) = split /\t/ , $lines[$i];
			print "-- entity1: $ent1 | entity2: $ent2\n";
			if ($currentUserID != $mainUserID && (lc($ent1) eq "i" || lc($ent1) eq "we"))
			{
				$block = $block . $ent1 . "_" . $currentUserID . "\t" . $ent2 . "\n"; # entity pair
				print "revised entity pair: $block\n";
				$flag = 1;
			}
			else
			{
				$block = $block . $lines[$i] . "\n"; # entity pair
			}
			
			$i += 2; # skipping the blank line
			$block = $block . "\n";
			$block = $block . $lines[$i] . "\n"; # sentenceNum sentence
			
			my ($sentNum,  $sentence) = split /\t/, $lines[$i];
			#print "-- sentence: $lines[$i]\n";
			$i++;
			my ($entity1, $entity2, $path) = split /\t/, $lines[$i];
			#print "path: -- $lines[$i]\n";
			if ($flag == 1) # entity1 is either I or We
			{
				$block = $block . $ent1 . "_" . $currentUserID . "\t" . $ent2 . "\t" . $path . "\n";
				print "revised entity pair and path: $block\n";
			}
			else
			{
				$block = $block . $lines[$i] . "\n"; #path
			}
			
			# Parsed sentence sample:
			#root(ROOT-0, ZZZZ28ZZZZ-1)  
			#
			#nsubj(takes-6, October_22-1)
			#num(October_22-1, 2012-2)
			#prep(October_22-1, a-3)
			#det(short_film-5, This-4)
			#pobj(a-3, short_film-5)
			#root(ROOT-0, takes-6)
			#dobj(takes-6, you-7)
			#amod(Kenya-10, remote-9)
			#prep_to(takes-6, Kenya-10)
			#advmod(getting-16, where-11)
			#nsubj(getting-16, women-12)
			#conj_and(women-12, children-14)
			#nsubj(getting-16, children-14)
			#aux(getting-16, are-15)
			#advcl(takes-6, getting-16)
			#amod(services-18, basic-17)
			#dobj(getting-16, services-18)
			#prep_such_as(services-18, checkups-21)
			#nn(immunization-24, pregnancy-23)
			#prep_during(checkups-21, immunization-24)
			#prep_during(checkups-21, more-26)
			#conj_and(immunization-24, more-26)

			
			my $sent = $sentence;

			$sent =~ s/\[EN //g;
			$sent =~ s/\]//g;
			$sent =~ s/"//g;
			chomp $sent;
			if ($sent !~ /.$/)
			{
				$sent = $sent . " .";
			}
			print "The sentence is $sent\n";
			
			#$sent =~ s/\s*'s\s+/'s/;
			
			print "The sentence is $sent\n";
			
			my ($augmentedPath, $label, $neatLabel) = parseDoc($sentNum, $sent, $topic, $mergeType, $path);
			
			$block = $block . $augmentedPath . "\n" . $label . "\n";
			
			print "$block\n";
			
			print OUT "$block\n";
			if ($flag == 1)
			{
				my $e1 = $entity1 . "_" . $currentUserID;
				print TRIPLES "$e1\t$entity2\t$neatLabel\n";
				print TUPLES "$e1\t$entity2\t$neatLabel\t$sent\n";
			}
			else
			{
				print TRIPLES "$entity1\t$entity2\t$neatLabel\n";
				print TUPLES "$entity1\t$entity2\t$neatLabel\t$sent\n";
			}
			
			$block = "";
			$i++;
		}
		# my $command = `./runclient.sh localhost 9010 $start/docs/$topic/sentDocs/$docfile $start/windows/$topic/taggedPhrases`;
	
	}
	close (OUT);
	close (TRIPLES);
	close (TUPLES);
}
sub parseDoc {

	my $docid = $_[0];
	my $doc = $_[1];
	my $topic = $_[2];
	my $mergeType = $_[3];
	my $path = $_[4];
	
	my %labelWords = ();
	
	#my $outFile = $topic . "_triples";
	#open (OUT, ">windows/$topic/relationLabels/$outFile") or die "$!";
	
	#my $mkdir = `mkdir cleanNPs/$topic`;
	#open (OUT, "|sort -rn |uniq > cleanNPs/$topic/$docid") or die "$!";
	
	# Create a new NLP pipeline (don't silence messages, do make corefs bidirectional)
	# my $pipeline = new Lingua::StanfordCoreNLP::Pipeline(0, 1);
	
	# Process text
	# (Will output lots of debug info from the Java classes to STDERR.)
	
	$doc =~ s/"/ /g;
	$doc =~ s/\s+/ /g;
	
	my $result = $pipeline->process($doc);
	
	my %tokenPOS = ();
	my %tokenWord = ();
	my %tokenWordAndPOS = ();
	
	my %dependencies = ();
	my %reversed_dependencies = ();
	my %governors = ();
	my %dependents = ();
	 
	# Print results
	my $sentID = 0;
	my $sentCount = @{$result->toArray};
	for my $sentence (@{$result->toArray}) {
	   #print "there are $sentCount sentences\n" . "$sentence" . "\n";
	   $sentID++;
	   #print "\n[Sentence ID: ", $sentence->getIDString, "]:\n";
	   my $snt = $sentence->getSentence;
	   print "\n\nOriginal sentence:\n\t", $snt, "\n\n";
	   
	   if ($snt =~ /[a-zA-Z]/) # there are subsentences with punctuations only which should be skipped!
	   {
		#get tokens, POS and lemma
		%tokenPOS = ();
		%tokenWord = ();
		%tokenWordAndPOS = ();
		#%allTokenWord = (); # stores all words including preps
		
		my $count = 0;
		for my $token (@{$sentence->getTokens->toArray}) {
		     my @tokens = $token->getWord;
		     my @POS = $token->getPOSTag;
		     my @lemmas = $token->getLemma;
	     
		     my $addToken = 1;
		     if ($tokens[0] eq "'s"){
			     if ($POS[0] eq "POS"){
				     $addToken = 0;
			     }
		     }
		     if ($addToken == 1){
			     $tokenPOS{$count} = $POS[0];
			     $tokenWord{$count} = $tokens[0];
			     $tokenWordAndPOS{$count} = $tokens[0] . "_" . $POS[0];
			     #print "$count - $token[0] - $POS[0]\n";
			}
		     #$allTokenWord = $tokens[0];
		     print "$count<>$tokens[0]<>$POS[0]<>$lemmas[0]<>\n";
		     $count++;
		}
		print "\n";
	     
		#get dependencies
		for my $dep (@{$sentence->getDependencies->toArray}) {
		     my @relations = $dep->getRelation;
		     my @governWord = $dep->getGovernor->getWord;
		     my @governIndex = $dep->getGovernorIndex;
		     my @depWord = $dep->getDependent->getWord;
		     my @depIndex = $dep->getDependentIndex;
		     print "$relations[0] ($governWord[0]-$governIndex[0], $depWord[0]-$depIndex[0])\n";
		     my $governId = $governIndex[0];
		     my $depID = $depIndex[0];
		     $dependencies{$governId}{$depID} = $relations[0];
		     #$reversed_dependencies{$depID}{$governId} = $relations[0];
		     $governors{$depID}{$relations[0]} = $governId;
		     
		     if ($relations[0] =~ /nsubj/)
		     {
			     if (defined $dependents{$governId}{$relations[0]} && exists $dependents{$governId}{$relations[0]}) # a verb can have 2 nsubjs --" we need to combine them both.
			     {
				     $dependents{$governId}{$relations[0]} = $dependents{$governId}{$relations[0]} . "|" . $depID;
				     print "second nsubj is added: $depID\n";
				     print "it looks like: $dependents{$governId}{$relations[0]}\n\n";
			     }
			     else
			     {
				     print "first nsubj is added: $depID\n";
				     $dependents{$governId}{$relations[0]} = $depID;
			     }
		     }
		     elsif ($relations[0] =~ /prep_between/)
		     {
			     if (defined $dependents{$governId}{$relations[0]} && exists $dependents{$governId}{$relations[0]}) # 2 tuples can lead to prep_between dependency --" we need to combine them both.
			     {
				     $dependents{$governId}{$relations[0]} = $dependents{$governId}{$relations[0]} . "|" . $depID;
				     print "second conj for 'between' is added: $depID\n";
				     print "it looks like: $dependents{$governId}{$relations[0]}\n\n";
			     }
			     else
			     {
				     print "first conj for 'between' is added: $depID\n";
				     $dependents{$governId}{$relations[0]} = $depID;
			     }
		     }
		     elsif ($relations[0] =~ /aux/) # a verb can have multiple aux es
		     {
			     if (defined $dependents{$governId}{$relations[0]} && exists $dependents{$governId}{$relations[0]}) # we need to combine them both.
			     {
				     $dependents{$governId}{$relations[0]} = $dependents{$governId}{$relations[0]} . "|" . $depID;
				     print "second aux for $tokenWord{$governId} is added: $depID\n";
				     print "it looks like: $dependents{$governId}{$relations[0]}\n\n";
			     }
			     else
			     {
				     print "first aux for $tokenWord{$governId} is added: $depID\n";
				     $dependents{$governId}{$relations[0]} = $depID;
			     }
		     }
		     else 
		     {	
			     $dependents{$governId}{$relations[0]} = $depID;
		     }
     
		     #print "\t *** $depID -- $tokenWord{$depID} | $governId -- $tokenWord{$governId} | $dependencies{$governId}{$depID} ***\n";
		}
	       ######### STAGE 1: merge simple NPs (i.e. NPs in the form: JJ* NN+) ##########################
	       ##  Identify if there are any nouns that can be merged;
	       ##  merge them in a pairwise manner beginning from the head;
	       ##  iterate until there are no more merges.
	       ##############################################################################################
	       print "#################### STAGE 1 #########################\n";
	       my $mergeMode = 1; #1 - Stage 1: merge contiguous "nn", "amod" and "poss" relations; 2 - Stage 2: merge contiguous prep_ and conj_and relations
	       my $stopIteration = 0;
	       my $iterationNumber = 0;
	       until ($stopIteration == 1){
		$iterationNumber++;
		#print "##################### SENTENCE $sentID ;  ITERATION $iterationNumber ###################################\n";
		my $mergeCount = 0;
		foreach my $governID (keys %dependencies){ #for each governing word
		     if ($tokenPOS{$governID} =~ /NN/){ #if the governing word is a noun
			     foreach my $depID ( keys %{ $dependencies{$governID} } ) { #for each depending word
				     #print "\t$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
				     #check if the dependent word is immediately before the governing word (distance = 1)
				     my $distance = $governID - $depID;
				     my $contiguous = 0;
				     if ($distance == 1){
					     $contiguous = 1;
				     }elsif ($distance > 1){
					     #check if there exist any in-between words
					     my $start = $depID + 1;
					     my $end = $governID;
					     my $inBetweenWordExists = 0;
					     for (my $a=$start; $a<$end; $a++){
							     #print "\t\t\t<$a><$tokenWord{$a}>\n";
						     if (exists($tokenWord{$a})){
							     $inBetweenWordExists = 1;
							     #print "\t\t\t\tEXISTS\n";
						     }
					     }
					     if ($inBetweenWordExists == 0){
						     $contiguous = 1;
					     }
				     }
				     #print "\t\t<CONTIGUOUS>$contiguous<>$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
				     if ($contiguous == 1){  #if the governing and dependent words are contiguous
					     #"checkType" subroutine checks if the type of dependency relation is correct and if they pass the MI and/or t-test
					     #list of arguments for checkType subroutine: (relation type; merge mode; POS of governing word; POS of depending word; governing word; depending word, dummy)
					     my $mergeStatus = checkType($dependencies{$governID}{$depID}, $mergeMode, $tokenPOS{$governID}, $tokenPOS{$depID}, $tokenWord{$governID}, $tokenWord{$depID}, "");
					     if ($mergeStatus == 1){
						     #merge the governing and dependent words
						     $tokenWord{$governID} = $tokenWord{$depID} . " " . $tokenWord{$governID};
						     $tokenWordAndPOS{$governID} = $tokenWordAndPOS{$depID} . " " . $tokenWordAndPOS{$governID};
						     delete($tokenWordAndPOS{$depID});
						     delete($tokenWord{$depID});
						     delete($dependencies{$governID}{$depID});
						     delete($tokenPOS{$depID});
						     $mergeCount++;
					     }
				     }
			     }
		     }
		     elsif ($tokenPOS{$governID} =~ /VB/) #if the governing word is a verb -- we need to find its dobj and iobj
		     {
		       ;
		     }
	       }
	       if ($mergeCount == 0){
		     $stopIteration = 1;
	       }
	      }
	      #### END OF STAGE 1 merge ####
	     
	      ## Weight NPs output by stage 1
	      my %weightedNPs = weightNPs(\%tokenWordAndPOS);
	      ##
	       foreach my $NPid (keys %tokenWord){
		     if ($tokenPOS{$NPid} =~ /NN/){
			     #print "\t<STAGE 1-NP>$tokenWordAndPOS{$NPid}<>\n";
		   
			     #if ($mergeType == 1)
			     #{
			     #  ## calculate weight of the NPs output by Stage 2
			     #  my $NPweight = 0;
			     #  $numOfJointNPs{$NPid} = $numOfJointNPs{$NPid} + 1;
			     #  if ($numOfJointNPs{$NPid} > 1){
			     #	  $NPweight = $weightedNPs{$NPid} / $numOfJointNPs{$NPid};
			     #  }else{
			     #	  if (exists($weightedNPs{$NPid})){
			     #		  $NPweight = $weightedNPs{$NPid};
			     #	  }
			     #  }
			     #  if ($NPweight > 0){
			     #	  my $lowerCaseNP = lc($tokenWord{$NPid});
			     #	  $lowerCaseNP =~ s/\s+/ /g;
			     #	  $lowerCaseNP =~ s/\s,\s/, /g;
			     #	  print OUT "$NPweight\t$lowerCaseNP\n";
			     #	  print "<FINAL-NP>$tokenWord{$NPid}<WEIGHT>$NPweight<>\n";
			     #  }
			     #}
		     }
	       }
	     
	      if ($mergeType == 2){ #do Stage 2 merge
	      #### STAGE 2: merge complex NPs (i.e. NPs with prepositions and conjunctions)
	      ############################################################################
	       print "######################STAGE 2#########################\n";
	       my $stopIteration = 0;
	       my $iterationNumber = 0;
	       my %numOfJointNPs = ();
	       $mergeMode = 2;
	       until ($stopIteration == 1){
		$iterationNumber++;
		my $mergeCount = 0;
		my $article = "";
		foreach my $governID (keys %dependencies){ #for each governing word
		     if ($tokenPOS{$governID} =~ /NN/){ #if the governing word is a noun
			     foreach my $depID ( keys %{ $dependencies{$governID} } ) { #for each depending word
				     #print "\t$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
	     
	     ##
				     my $contiguous = 0;
				     my $rel = $dependencies{$governID}{$depID};
				     $rel =~ s/^\w+_(.+)$/$1/;
				     my $start = $governID + 1;
				     my $end = $depID;
				     my $numOfInBetweenWords = 0;
				     my $inBetweenWords = "";
				     for (my $a=$start; $a<$end; $a++){
					     if (exists($tokenWord{$a})){	
						     if ($tokenWord{$a} eq $rel){ #if the in-between word is the same as the name of the dep. relation, e.g. "and" in "conj_and"
							     #do not count
						     }elsif ($tokenPOS{$a} eq "DT"){
							     #do not count
						     }elsif ($tokenPOS{$a} eq ","){
							     #do not count
						     }else{
							     $numOfInBetweenWords++;
						     }
						     $inBetweenWords = $inBetweenWords . " " . $tokenWord{$a};
					     }
				     }
				     $inBetweenWords =~ s/\s+/ /g;
				     #print "\t\t\t\t<IN-BETWEEN-WORDS>$inBetweenWords<NUM>$numOfInBetweenWords<>\n";
	     ##
				     if ($numOfInBetweenWords == 0){
					     $contiguous = 1;
				     }
				     #print "\t\t<CONTIGUOUS>$contiguous<>$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
				     if ($contiguous == 1){  #if the governing and dependent words are separated by 1 word
					     #"checkType" subroutine checks if the type of dependency relation is correct and if they pass the MI and/or t-test
					     #list of arguments for checkType: (relation type; merge mode; POS of governing word; POS of depending word; governing word; depending word; article before the governing word /if any/)
					     my $mergeStatus = checkType($dependencies{$governID}{$depID}, $mergeMode, $tokenPOS{$governID}, $tokenPOS{$depID}, $tokenWord{$governID}, $tokenWord{$depID}, $inBetweenWords);
					     if ($mergeStatus == 1){
						     #merge the governing and dependent words
						     my $start = $governID + 1;
						     my $end = $depID + 1;
						     for (my $a=$start; $a<$end; $a++){
							     $tokenWord{$governID} = $tokenWord{$governID} . " "  . $tokenWord{$a};
							     delete($tokenWord{$a});
							     delete($tokenPOS{$a});
						     }
						     delete($dependencies{$governID}{$depID});
						     
	     
						     #my $rel = $dependencies{$governID}{$depID};
						     #$rel =~ s/^\w+_(.+)$/$1/;
						     #$tokenWord{$governID} = $tokenWord{$governID} . " " . $rel . " " . $article . " "  . $tokenWord{$depID};
						     #$tokenWord{$governID} =~ s/\s+/ /g;
						     #delete($tokenWord{$depID});
						     #delete($dependencies{$governID}{$depID});
						     #delete($tokenPOS{$depID});
	     
						     $weightedNPs{$governID} = $weightedNPs{$governID} + $weightedNPs{$depID};
						     $numOfJointNPs{$governID} = $numOfJointNPs{$governID} + 1;
						     $mergeCount++;
					     }
				     }
			     }
		     }
	       }
	       if ($mergeCount == 0){
		     $stopIteration = 1;
	       }
	      } #stop iteration
	     
	       
	       foreach my $NPid (keys %tokenWord){
		     if ($tokenPOS{$NPid} =~ /NN/){
			     print "<FINAL-NP>$tokenWord{$NPid}\n";
			     ## calculate weight of the NPs output by Stage 2
			     my $NPweight = 0;
			     $numOfJointNPs{$NPid} = $numOfJointNPs{$NPid} + 1;
			     if ($numOfJointNPs{$NPid} > 1){
				     $NPweight = $weightedNPs{$NPid} / $numOfJointNPs{$NPid};
			     }else{
				     if (exists($weightedNPs{$NPid})){
					     $NPweight = $weightedNPs{$NPid};
				     }
			     }
			     if ($NPweight > 0){
				     my $lowerCaseNP = lc($tokenWord{$NPid});
				     $lowerCaseNP =~ s/\s+/ /g;
				     $lowerCaseNP =~ s/\s,\s/, /g;
				     print OUT "$NPweight\t$lowerCaseNP\n";
				     print "<FINAL-NP>$tokenWord{$NPid}<WEIGHT>$NPweight<>\n";
			     }
		     }
	       }
	      } #end of stage 2
	      #### END OF STAGE 2 merge ####
	    }
	 } #for each sentence
	
	 
	 my @elements = split / /, $path; # elements on even positions (i.e., 0, 2, 4, ...) correspond to words (i.e., nodes; e.g., Coffee-1)
					  # elements on odd positions (i.e., 1, 3, 5, ...) correspond to dependency type  (i.e., edges; e.g., -<-nsubj-<-)
	 my $hasNeither = 0;
	 print "Path is $path\n\n";
	 #foreach my $element (@elements)
	 my $originalPath = $path;
	 
	 #adding the second entity to the label
	 my @items = split /-/, $elements[@elements - 1];
	 my $id = $items[@items - 1];
	 #$labelWords{$id} = $elements[@elements - 1];
	 $labelWords{$id} = $tokenWord{$id - 1}; 
	 print "Second entity is added to label at $id: $labelWords{$id} \n";
	 my $second_entity_ID = $id;
	 my $second_entity = substr $elements[@elements - 1], 0, rindex($elements[@elements - 1], '-');
	 
	 #adding the first entity to the label
	 @items = split /-/, $elements[0];
	 $id = $items[@items - 1]; # e.g for intensified-11, the $id will be 11
	 #$labelWords{$id} = $elements[0];
	$labelWords{$id} = $tokenWord{$id - 1};
	my $first_entity_ID = $id;
	my $first_entity = substr $elements[0], 0, rindex($elements[0], '-');
	# print "%%%%% the first word on the path is $elements[0]; id is $id; $labelWords{$id} added to the label!\n\n";
	
	# if there is neither - nor related to the first entity, turn on the flag.
	if (defined $dependents{$id - 1}{"preconj"} && exists $dependents{$id - 1}{"preconj"})
	{
		my $preconj_id = $dependents{$id - 1}{"preconj"};
		my $preconj_word = $tokenWord{$preconj_id};
		
		$preconj_word = lc $preconj_word;
		if ($preconj_word eq "neither")
		{
			$hasNeither = 1;
			print "There is Neither for the first entity!\n\n";
		}
	}
	
	# if there is a preposition related to the first entity we add it to the very beginning of the label. It can be improved by adding it to the position of that prep instead of 0
	if (defined $governors{$id - 1}{"prep_after"} && exists $governors{$id - 1}{"prep_after"})
	{
		$labelWords{0} = "After";
	}
	elsif (defined $governors{$id - 1}{"prep_since"} && exists $governors{$id - 1}{"prep_since"})
	{
		$labelWords{0} = "Since";
	}
	elsif (defined $governors{$id - 1}{"prep_with"} && exists $governors{$id - 1}{"prep_with"})
	{
		$labelWords{0} = "With";
	}
	elsif (defined $governors{$id - 1}{"prep_by"} && exists $governors{$id - 1}{"prep_by"})
	{
		$labelWords{0} = "By";
	}
	elsif (defined $governors{$id - 1}{"prep_thanks_to"} && exists $governors{$id - 1}{"prep_thanks_to"})
	{
		$labelWords{0} = "Thanks to";
	}
	elsif (defined $governors{$id - 1}{"prep_at"} && exists $governors{$id - 1}{"prep_at"})
	{
		$labelWords{0} = "At";
	}
	elsif (defined $governors{$id - 1}{"prep_among"} && exists $governors{$id - 1}{"prep_among"})
	{
		$labelWords{0} = "Among";
	}
	elsif (defined $governors{$id - 1}{"prep_including"} && exists $governors{$id - 1}{"prep_including"})
	{
		$labelWords{0} = "Including";
	}
	elsif (defined $governors{$id - 1}{"prep_like"} && exists $governors{$id - 1}{"prep_like"})
	{
		$labelWords{0} = "like";
	}
	elsif (defined $governors{$id - 1}{"prep_unlike"} && exists $governors{$id - 1}{"prep_unlike"})
	{
		$labelWords{0} = "unlike";
	}
	elsif (defined $governors{$id - 1}{"prep_as"} && exists $governors{$id - 1}{"prep_as"})
	{
		$labelWords{0} = "as";
	}
	 
	 my $i = 2; #skipping the first word on the path which is the Entity1
	 while ($i < @elements)
	 {
		@items = split /-/, $elements[$i];
		$id = $items[@items - 1]; # e.g for intensified-11, the $id will be 11
		my $tword = $tokenWord{$id - 1};

		#print "current word is $tword located at $id with the POS $tokenPOS{$id - 1}\n";
		##print "the current word from the path is $elements[$i]\n\n";
		#if ($elements[$i] =~ /$tword/) # matching the current word on the path with the corresponding word from the output of the CoreNLP Parser
		#{
			if ($tokenPOS{$id - 1} =~ /NN/) # replace the nouns from the path with their extended version (after merging the head word with all its modifiers)
			{
				if ($i == @elements - 1) # if the second entity is already added to the label, skip it.
				{
					;
				}
				#if the noun is connected to a previous noun by -nn- relation, it's likely that it's already added to the previous noun. So just pass this noun.
				if ($i < @elements - 1 && ($elements[$i - 1] !~ /nn/) && ($elements[$i - 1] !~ /amod/) && (defined $tokenWord{$id - 1} && exists $tokenWord{$id - 1}))
				{
					$elements[$i] = $tokenWord{$id - 1} . "-" . $id;
				}
				else
				{
					;#print "We don't need to touch the path for $elements[$i]\n\n";
				}
				if ($i < @elements - 1 && (!defined $labelWords{$id} || !exists $labelWords{$id}))
				{
					$labelWords{$id} = substr $elements[$i], 0, rindex($elements[$i], '-');
					print "OOOOOO $elements[$i] is added to labelWords at $id\n\n";
					#if ($elements[$i - 1] =~ /nn/)
					#{
					#	
					#}
				}
				if (defined $dependents{$id - 1}{"mark"} && exists $dependents{$id - 1}{"mark"})
				{
					my $mark_id = $dependents{$id - 1}{"mark"};
					my $mark_word = $tokenWord{$mark_id};
					print "$mark_word -- $mark_id -- $tokenWord{7}\n\n";
					
					$labelWords{$mark_id + 1} = $tokenWord{$mark_id};
				}
				if (defined $dependents{$id - 1}{"cop"} && exists $dependents{$id - 1}{"cop"})
				{
					my $copID = $dependents{$id - 1}{"cop"};
					my $copWord = $tokenWord{$copID};
					$labelWords{$copID + 1} = $copWord;
					
					print "copula $copWord is added to the label at $copID + 1\n";
					
					$labelWords{$id} =  $tokenWord{$id - 1};
				}
				if (defined $dependents{$id - 1}{"aux"} && exists $dependents{$id - 1}{"aux"})
				{
					my $auxID = $dependents{$id - 1}{"aux"};
					my $auxWord = $tokenWord{$auxID};
					print "Noun $tokenWord{$id - 1} has an aux\n";
					$labelWords{$auxID + 1} = $auxWord;
					
					print "Aux $auxWord is added to the label at $auxID + 1\n\n";
					
					$labelWords{$id} =  $tokenWord{$id - 1};
				}
				#if (defined $dependents{$id - 1}{"det"} && exists $dependents{$id - 1}{"det"}) # X is another/a/the term for Y
				#{
				#	my $detID = $dependents{$id - 1}{"det"};
				#	my $detWord = $tokenWord{$detID};
				#	$labelWords{$detID + 1} = $detWord;
				#	
				#	print "det $detWord is added to the label at $detID + 1\n";
				#	
				#	$labelWords{$id} =  $tokenWord{$id - 1};	
				#}
				# if the noun has prep_between, you should make sure both conj s are added to the label along with the prep 'between'.
				if ((defined $dependents{$id - 1}{"prep_between"} && exists $dependents{$id - 1}{"prep_between"}) || (defined $dependents{$id - 1}{"prep_between"} && exists $dependents{$id - 1}{"prep_between"}))
				{
					my @DepIDs = split /\|/, $dependents{$id - 1}{"prep_between"};
					my $first_word = $tokenWord{$DepIDs[0]};
					my $second_word = $tokenWord{$DepIDs[1]};
					my $conj_word = $dependencies{$DepIDs[0]}{$DepIDs[1]};
					$conj_word =~ s/conj_//;
					
					if (defined $tokenWord{$DepIDs[0]} && exists $tokenWord{$DepIDs[0]})
					{
						if (defined $tokenWord{$DepIDs[1]} && exists $tokenWord{$DepIDs[1]}) # both words exist and not merged
						{
							$labelWords{$DepIDs[0]} = "between " . $first_word;
							$labelWords{$DepIDs[1]} = $conj_word . " " . $second_word;
						}
						else # second word in merged with first word?
						{
							$labelWords{$DepIDs[0]} = "between " . $first_word;
						}
					}
				}
				#if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"}) # poss(diet, my)
				#{
				#	my $possID = $dependents{$id - 1}{"poss"};
				#	my $possWord = $tokenWord{$possID};
				#	
				#	# if the noun has a prep associated with it, it has to be added before poss
				#
				#	$labelWords{$possID + 1} = $possWord;
				#	$labelWords{$id} = $tokenWord{$id - 1};
				#	print "$possWord and $labelWords{$id} are added to the label at $possID + 1 and $id\n";
				#}
				if (defined $governors{$id - 1}{"conj_and"} && exists $governors{$id - 1}{"conj_and"})
				{
					# if the first conj is not added to the label, don't add 'and' for the second conj.
					# or just add in the first conj too.
					
					my ($conj, $first_conj, $second_conj, $conj_ID, $first_conj_ID);
					$first_conj_ID = $governors{$id - 1}{"conj_and"};
					$first_conj = $tokenWord{$first_conj_ID};
					
					#if ($tokenWord{$id - 1} eq /$conj/) # the 
					$second_conj = $tokenWord{$id - 1};
					
					if ($first_conj eq "") # no 'and' for the second_conj
					{
						print "and is NOT added to $labelWords{$id} at $id\n";
					}
					else
					{
						$labelWords{$first_conj_ID + 1} = $first_conj;
						print "first_conj $first_conj is also added to the label at $first_conj_ID + 1\n";
					
						$labelWords{$id} = "and " . $labelWords{$id};
						print "and is added to $labelWords{$id} at $id\n";
					}
				}
				elsif (defined $governors{$id - 1}{"conj_or"} && exists $governors{$id - 1}{"conj_or"})
				{
					# if the first conj is not added to the label, don't add 'or' for the second conj.
					# or just add in the first conj too.
					
					my ($first_conj, $second_conj, $first_conj_ID);
					$first_conj_ID = $governors{$id - 1}{"conj_or"};
					$first_conj = $tokenWord{$first_conj_ID};
					$second_conj = $tokenWord{$id - 1};
					
					if ($first_conj ne "" && !(defined $labelWords{$first_conj_ID + 1} && exists $labelWords{$first_conj_ID + 1}) || $labelWords{$first_conj_ID + 1} eq "")
					{
						$labelWords{$first_conj_ID + 1} = $first_conj;
						$labelWords{$id} = "or " . $labelWords{$id};
					}
					elsif (defined $labelWords{$first_conj_ID + 1} && exists $labelWords{$first_conj_ID + 1})
					{
						if ($labelWords{$id} !~ /or /)
						{
							$labelWords{$id} = "or " . $labelWords{$id};
						}
					}
				}
				
				if ((defined $governors{$id - 1}{"prep_by"} && exists $governors{$id - 1}{"prep_by"}) || (defined $governors{$id - 1}{"prepc_by"} && exists $governors{$id - 1}{"prepc_by"}))
				{
					if ($labelWords{$id} !~ /by /)
					{
						#my $gID = $governors{$id - 1}{"prep_from"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "by " . $possWord;
							print "by is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "by " . $labelWords{$id};
							print "by is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -by-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_to"} && exists $governors{$id - 1}{"prep_to"}) || (defined $governors{$id - 1}{"prepc_to"} && exists $governors{$id - 1}{"prepc_to"}))
				{
					if ($labelWords{$id} !~ /to /)
					{
						#my $gID = $governors{$id - 1}{"prep_to"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "to " . $possWord;
							print "to is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "to " . $labelWords{$id};
							print "to is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -from-. so it is NOT added at $id\n\n";
					}
					
					
				}
				elsif ((defined $governors{$id - 1}{"prep_into"} && exists $governors{$id - 1}{"prep_into"}) || (defined $governors{$id - 1}{"prepc_into"} && exists $governors{$id - 1}{"prepc_into"}))
				{
					if ($labelWords{$id} !~ /into /)
					{
						#my $gID = $governors{$id - 1}{"prep_into"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "into " . $possWord;
							print "into is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "into " . $labelWords{$id};
							print "into is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -into-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_from"} && exists $governors{$id - 1}{"prep_from"}) || (defined $governors{$id - 1}{"prepc_from"} && exists $governors{$id - 1}{"prepc_from"}))
				{
					if ($labelWords{$id} !~ /from /)
					{
						#my $gID = $governors{$id - 1}{"prep_from"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "from " . $possWord;
							print "from is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "from " . $labelWords{$id};
							print "from is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -from-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_out_of"} && exists $governors{$id - 1}{"prep_out_of"}) || (defined $governors{$id - 1}{"prepc_out_of"} && exists $governors{$id - 1}{"prepc_out_of"}))
				{
					if ($labelWords{$id} !~ /out_of /)
					{
						#my $gID = $governors{$id - 1}{"prep_out_of"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "out_of " . $possWord;
							print "out_of is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						elsif (defined $dependents{$id - 1}{"num"} && exists $dependents{$id - 1}{"num"})
						{
							my $numID = $dependents{$id - 1}{"num"};
							my $numWord = $tokenWord{$numID};
							
							$labelWords{$numID + 1} = "out_of " . $numWord;
							print "out_of is added to Num $numWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "out_of " . $labelWords{$id};
							print "out_of is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -out_of-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_in"} && exists $governors{$id - 1}{"prep_in"}) || (defined $governors{$id - 1}{"prepc_in"} && exists $governors{$id - 1}{"prepc_in"}))
				{
					#if ($labelWords{$id} =~ /and /)
					#{
					#	my $newLabel = $labelWords{$id};
					#	$newLabel =~ s/and/in/;
					#	$labelWords{$id} = "and " . $newLabel;
					#	
					#	print "there is both 'in' & 'and' --> the new label is $newLabel and final result is $labelWords{$id}\n;"
					#}
					if ($labelWords{$id} !~ /in /)
					{
						#my $gID = $governors{$id - 1}{"prep_in"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "in " . $possWord;
							print "in is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						elsif (defined $dependents{$id - 1}{"num"} && exists $dependents{$id - 1}{"num"})
						{
							my $numID = $dependents{$id - 1}{"num"};
							my $numWord = $tokenWord{$numID};
							
							$labelWords{$numID + 1} = "in " . $numWord;
							print "in is added to num $numWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "in " . $labelWords{$id};
							print "in is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -in-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_at"} && exists $governors{$id - 1}{"prep_at"}) || (defined $governors{$id - 1}{"prepc_at"} && exists $governors{$id - 1}{"prepc_at"}))
				{
					#if ($labelWords{$id} =~ /and /)
					#{
					#	my $newLabel = $labelWords{$id};
					#	$newLabel =~ s/and/at/;
					#	$labelWords{$id} = "and " . $newLabel;
					#	
					#	print "there is both 'at' & 'and' --> the new label is $newLabel and final result is $labelWords{$id}\n;"
					#}
					if ($labelWords{$id} !~ /at /)
					{
						#my $gID = $governors{$id - 1}{"prep_at"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "at " . $possWord;
							print "at is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "at " . $labelWords{$id};
							print "at is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -at-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_on"} && exists $governors{$id - 1}{"prep_on"}) || (defined $governors{$id - 1}{"prepc_on"} && exists $governors{$id - 1}{"prepc_on"}))
				{
					#if ($labelWords{$id} =~ /and /)
					#{
					#	my $newLabel = $labelWords{$id};
					#	$newLabel =~ s/and/on/;
					#	$labelWords{$id} = "and " . $newLabel;
					#	
					#	print "there is both 'on' & 'and' --> the new label is $newLabel and final result is $labelWords{$id}\n;"
					#}
					if ($labelWords{$id} !~ /on /)
					{
						#my $gID = $governors{$id - 1}{"prep_on"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "on " . $possWord;
							print "on is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "on " . $labelWords{$id};
							print "on is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -on-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_with"} && exists $governors{$id - 1}{"prep_with"}) || (defined $governors{$id - 1}{"prepc_with"} && exists $governors{$id - 1}{"prepc_with"}))
				{
					if ($labelWords{$id} =~ /and /)
					{
						my $newLabel = $labelWords{$id};
						#$newLabel =~ s/and/and with/;
						#$labelWords{$id} = "and " . $newLabel;
						$labelWords{$id} = $newLabel;
						print "there is both 'with' & 'and' --> the new label is $newLabel and final result is $labelWords{$id}\n;"
					}
					elsif ($labelWords{$id} =~ /or /)
					{
						my $newLabel = $labelWords{$id};
						#$newLabel =~ s/or/or with/;
						#$labelWords{$id} = "or " . $newLabel;
						$labelWords{$id} = $newLabel;
						print "there is both 'with' & 'or' --> the new label is $newLabel and final result is $labelWords{$id}\n;"
					}
					elsif ($labelWords{$id} !~ /with /)
					{
						$labelWords{$id} = "with " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_thanks_to"} && exists $governors{$id - 1}{"prep_thanks_to"}) || (defined $governors{$id - 1}{"prepc_thanks_to"} && exists $governors{$id - 1}{"prepc_thanks_to"}))
				{
					if ($labelWords{$id} !~ /thanks_to /)
					{
						#my $gID = $governors{$id - 1}{"prep_thanks_to"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "thanks_to " . $possWord;
							print "thanks_to is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "thanks_to " . $labelWords{$id};
							print "thanks_to is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -thanks_to-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_after"} && exists $governors{$id - 1}{"prep_after"}) || (defined $governors{$id - 1}{"prepc_after"} && exists $governors{$id - 1}{"prepc_after"}))
				{
					if ($labelWords{$id} !~ /after /)
					{
						#my $gID = $governors{$id - 1}{"prep_after"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "after " . $possWord;
							print "after is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "after " . $labelWords{$id};
							print "after is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -after-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_before"} && exists $governors{$id - 1}{"prep_before"}) || (defined $governors{$id - 1}{"prepc_before"} && exists $governors{$id - 1}{"prepc_before"}))
				{
					if ($labelWords{$id} !~ /before /)
					{
						#my $gID = $governors{$id - 1}{"prep_before"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "before " . $possWord;
							print "before is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						elsif (defined $dependents{$id - 1}{"num"} && exists $dependents{$id - 1}{"num"})
						{
							my $numID = $dependents{$id - 1}{"num"};
							my $numWord = $tokenWord{$numID};
							
							$labelWords{$numID + 1} = "before " . $numWord;
							print "before is added to num $numWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "before " . $labelWords{$id};
							print "before is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -before-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_above"} && exists $governors{$id - 1}{"prep_above"}) || (defined $governors{$id - 1}{"prepc_above"} && exists $governors{$id - 1}{"prepc_above"}))
				{
					if ($labelWords{$id} !~ /above /)
					{
						#my $gID = $governors{$id - 1}{"prep_above"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "above " . $possWord;
							print "above is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						elsif (defined $dependents{$id - 1}{"num"} && exists $dependents{$id - 1}{"num"})
						{
							my $numID = $dependents{$id - 1}{"num"};
							my $numWord = $tokenWord{$numID};
							
							$labelWords{$numID + 1} = "above " . $numWord;
							print "above is added to num $numWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "above " . $labelWords{$id};
							print "above is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -above-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_below"} && exists $governors{$id - 1}{"prep_below"}) || (defined $governors{$id - 1}{"prepc_below"} && exists $governors{$id - 1}{"prepc_below"}))
				{
					if ($labelWords{$id} !~ /below /)
					{
						#my $gID = $governors{$id - 1}{"prep_below"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "below " . $possWord;
							print "below is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						elsif (defined $dependents{$id - 1}{"num"} && exists $dependents{$id - 1}{"num"})
						{
							my $numID = $dependents{$id - 1}{"num"};
							my $numWord = $tokenWord{$numID};
							
							$labelWords{$numID + 1} = "below " . $numWord;
							print "below is added to num $numWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "below " . $labelWords{$id};
							print "below is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -below-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_through"} && exists $governors{$id - 1}{"prep_through"}) || (defined $governors{$id - 1}{"prepc_through"} && exists $governors{$id - 1}{"prepc_through"}))
				{
					if ($labelWords{$id} !~ /through /)
					{
						#my $gID = $governors{$id - 1}{"prep_through"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "through " . $possWord;
							print "through is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						elsif (defined $dependents{$id - 1}{"num"} && exists $dependents{$id - 1}{"num"})
						{
							my $numID = $dependents{$id - 1}{"num"};
							my $numWord = $tokenWord{$numID};
							
							$labelWords{$numID + 1} = "through " . $numWord;
							print "through is added to num $numWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "through " . $labelWords{$id};
							print "through is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -through-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_around"} && exists $governors{$id - 1}{"prep_around"}) || (defined $governors{$id - 1}{"prepc_around"} && exists $governors{$id - 1}{"prepc_around"}))
				{
					if ($labelWords{$id} !~ /around /)
					{
						#my $gID = $governors{$id - 1}{"prep_around"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "around " . $possWord;
							print "around is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						elsif (defined $dependents{$id - 1}{"num"} && exists $dependents{$id - 1}{"num"})
						{
							my $numID = $dependents{$id - 1}{"num"};
							my $numWord = $tokenWord{$numID};
							
							$labelWords{$numID + 1} = "around " . $numWord;
							print "around is added to num $numWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "around " . $labelWords{$id};
							print "around is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -around-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_since"} && exists $governors{$id - 1}{"prep_since"}) || (defined $governors{$id - 1}{"prepc_since"} && exists $governors{$id - 1}{"prepc_since"}))
				{
					if ($labelWords{$id} !~ /since /)
					{
						#my $gID = $governors{$id - 1}{"prep_since"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "since " . $possWord;
							print "since is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "since " . $labelWords{$id};
							print "since is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -since-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_for"} && exists $governors{$id - 1}{"prep_for"}) || (defined $governors{$id - 1}{"prepc_for"} && exists $governors{$id - 1}{"prepc_for"}))
				{
					#if ($labelWords{$id} =~ /and /)
					#{
					#	my $newLabel = $labelWords{$id};
					#	$newLabel =~ s/and/for/;
					#	$labelWords{$id} = "and " . $newLabel;
					#	
					#	print "there is both 'for' & 'and' --> the new label is $newLabel and final result is $labelWords{$id}\n;"
					#}
					if ($labelWords{$id} !~ /for /)
					{
						#my $gID = $governors{$id - 1}{"prep_for"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "for " . $possWord;
							print "for is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						if (defined $dependents{$id - 1}{"num"} && exists $dependents{$id - 1}{"num"})
						{
							my $numID = $dependents{$id - 1}{"num"};
							my $numWord = $tokenWord{$numID};
							
							$labelWords{$numID + 1} = "for " . $numWord;
							print "for is added to num $numWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "for " . $labelWords{$id};
							print "for is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -for-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_including"} && exists $governors{$id - 1}{"prep_including"}) || (defined $governors{$id - 1}{"prepc_including"} && exists $governors{$id - 1}{"prepc_including"}))
				{
					if ($labelWords{$id} !~ /including /)
					{
						#my $gID = $governors{$id - 1}{"prep_including"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "including " . $possWord;
							print "including is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "including " . $labelWords{$id};
							print "including is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -including-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_such_as"} && exists $governors{$id - 1}{"prep_such_as"}) || (defined $governors{$id - 1}{"prepc_such_as"} && exists $governors{$id - 1}{"prepc_such_as"}))
				{
					if ($labelWords{$id} =~ /and /)
					{
						my $newLabel = $labelWords{$id};
						$newLabel =~ s/and/such_as/;
						$labelWords{$id} = "and " . $newLabel;
						
						print "there is both 'such as' & 'and' --> the new label is $newLabel and final result is $labelWords{$id}\n;"
					}
					elsif ($labelWords{$id} !~ /such_as /)
					{
						#my $gID = $governors{$id - 1}{"prep_such_as"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "such_as " . $possWord;
							print "such_as is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else 
						{
							$labelWords{$id} = "such_as " . $labelWords{$id};
							print "such_as is added $tokenWord{$id - 1} at $id\n\n";
						}
					}
					else
					{
						print "$labelWords{$id} already has -such_as-. so it is NOT added at $id\n\n";
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_like"} && exists $governors{$id - 1}{"prep_like"}) || (defined $governors{$id - 1}{"prepc_like"} && exists $governors{$id - 1}{"prepc_like"}))
				{
					if ($labelWords{$id} !~ /like /)
					{
						$labelWords{$id} = "like " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_unlike"} && exists $governors{$id - 1}{"prep_unlike"}) || (defined $governors{$id - 1}{"prepc_unlike"} && exists $governors{$id - 1}{"prepc_unlike"}))
				{
					if ($labelWords{$id} !~ /unlike /)
					{
						$labelWords{$id} = "unlike " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_as"} && exists $governors{$id - 1}{"prep_as"}) || (defined $governors{$id - 1}{"prepc_as"} && exists $governors{$id - 1}{"prepc_as"}))
				{
					if ($labelWords{$id} !~ /as /)
					{
						$labelWords{$id} = "as " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_of"} && exists $governors{$id - 1}{"prep_of"}) || (defined $governors{$id - 1}{"prepc_of"} && exists $governors{$id - 1}{"prepc_of"}))
				{
					if ($labelWords{$id} !~ /of /)
					{
						#my $gID = $governors{$id - 1}{"prep_of"};
						if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"})
						{
							my $possID = $dependents{$id - 1}{"poss"};
							my $possWord = $tokenWord{$possID};
							
							$labelWords{$possID + 1} = "of ". $possWord;
							print "of is added to poss $possWord for $tokenWord{$id - 1}\n\n";
						}
						else
						{
							$labelWords{$id} = "of " . $labelWords{$id};
						}
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_due_to"} && exists $governors{$id - 1}{"prep_due_to"}) || (defined $governors{$id - 1}{"prepc_due_to"} && exists $governors{$id - 1}{"prepc_due_to"}))
				{
					if ($labelWords{$id} !~ /due_to / && $labelWords{$id} !~ /due to /)
					{
						$labelWords{$id} = "due_to " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_about"} && exists $governors{$id - 1}{"prep_about"}) || (defined $governors{$id - 1}{"prepc_about"} && exists $governors{$id - 1}{"prepc_about"}))
				{
					if ($labelWords{$id} !~ /about /)
					{
						$labelWords{$id} = "about " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_toward"} && exists $governors{$id - 1}{"prep_toward"}) || (defined $governors{$id - 1}{"prepc_toward"} && exists $governors{$id - 1}{"prepc_toward"}))
				{
					if ($labelWords{$id} !~ /toward /)
					{
						$labelWords{$id} = "toward " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_towards"} && exists $governors{$id - 1}{"prep_towards"}) || (defined $governors{$id - 1}{"prepc_towards"} && exists $governors{$id - 1}{"prepc_towards"}))
				{
					if ($labelWords{$id} !~ /towards /)
					{
						$labelWords{$id} = "towards " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_away_from"} && exists $governors{$id - 1}{"prep_away_from"}) || (defined $governors{$id - 1}{"prepc_away_from"} && exists $governors{$id - 1}{"prepc_away_from"}))
				{
					if ($labelWords{$id} !~ /away_from / || $labelWords{$id} !~ /away from /)
					{
						$labelWords{$id} = "away_from " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_instead_of"} && exists $governors{$id - 1}{"prep_instead_of"}) || (defined $governors{$id - 1}{"prepc_instead_of"} && exists $governors{$id - 1}{"prepc_instead_of"}))
				{
					if ($labelWords{$id} !~ /instead_of / || $labelWords{$id} !~ /instead of /)
					{
						$labelWords{$id} = "instead_of " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_rather_than"} && exists $governors{$id - 1}{"prep_rather_than"}) || (defined $governors{$id - 1}{"prepc_rather_than"} && exists $governors{$id - 1}{"prepc_rather_than"}))
				{
					if ($labelWords{$id} !~ /rather_than / || $labelWords{$id} !~ /rather than /)
					{
						$labelWords{$id} = "rather_than " . $labelWords{$id};
					}
				}
				elsif ((defined $governors{$id - 1}{"prep_within"} && exists $governors{$id - 1}{"prep_within"}) || (defined $governors{$id - 1}{"prepc_within"} && exists $governors{$id - 1}{"prepc_within"}))
				{
					if ($labelWords{$id} !~ /within /)
					{
						$labelWords{$id} = "within " . $labelWords{$id};
					}
				}
				
			}
			elsif ($i < @elements - 1 && $tokenPOS{$id - 1} =~ /VB/)
			{
				my ($dobjID, $iobjID, $missingObj) = "";
				my $has2obj = 0; # this value will be updated to 1 once the first object of the verb is seen and to 2 *if* the verb has 2 objects
				my $firstObj = "";
				my $firstObjType = ""; #either 'dobj' or 'iobj'
				
				if (!defined $labelWords{$id} && !exists $labelWords{$id})
				{
					$labelWords{$id} = $tokenWord{$id - 1};
					print "the verb $labelWords{$id} is added to the label at $id\n\n";
				}
				#if (defined $dependents{$id - 1}{"mark"} && exists $dependents{$id - 1}{"mark"})
				#{
				#	$labelWords{$dependents{$id - 1}{"mark"}} = $tokenWord{$dependents{$id - 1}{"mark"}};
				#}
				#print "		the verb $labelWords{$id} is added to the label at $id\n\n";
				#print "Depending words:\n\n";
				foreach my $depID ( keys %{ $dependencies{$id - 1} } )  #for each depending word
				{
					my $d = $depID + 1;
					#print "$depID\n";
					my $dep = $dependencies{$id - 1}{$depID};
					#print "$dep\n";
					my $hasXsubj = 0;
					
					my $existingToken = "";
					@items = split /-/, $elements[$i];
					my $existing_id = $items[@items - 1];
					for (my $k = 0; $k < @items - 1; $k++)
					{
						$existingToken = $existingToken . @items[$k];
						if ($k < @items - 2)
						{
							$existingToken = $existingToken . "-";
						}
					}
					
					my @items2;
					my $nextToken = "";
					my $existing_id2;
					if ($i + 2 < @elements)
					{
						@items2 = split /-/, $elements[$i + 2];
						$existing_id2 = $items2[@items2 - 1];
						#print ">>>>existing id2 is $existing_id2\n";
						
						for (my $k = 0; $k < @items2 - 1; $k++)
						{
							$nextToken = $nextToken . @items2[$k];
							if ($k < @items2 - 2)
							{
								$nextToken = $nextToken . "-";
							}
						}
					}
					
					my @items_2;
					my $existing_id_2;
					@items_2 = split /-/, $elements[$i - 2];
					$existing_id_2 = $items_2[@items2 - 1];
					#print ">>>>existing id_2 is $existing_id_2\n";

					# if there is 'neg' replace the verb with '-' . verb
					if ($dependencies{$id - 1}{$depID} =~ /neg/)
					{
						$elements[$i] = "(-)" . $elements[$i];
						print "verb $elements[$i] is negated!\n";
						
						print "		The label at $id is updated from $labelWords{$id} to ";
						#$labelWords{$id} = $tokenWord{$dependents{$id - 1}{"aux"}} . " " . $tokenWord{$dependents{$id - 1}{"neg"}} . " " . $labelWords{$id};
						# --- NEW ---
						my $auxID = $dependents{$id - 1}{"aux"};
						my $auxWord = $tokenWord{$auxID};
						$labelWords{$auxID + 1} = $auxWord;
						print "$auxWord is added to the label at $auxID + 1\n";
						
						my $negID = $dependents{$id - 1}{"neg"};
						my $negWord = $tokenWord{$negID};
						$labelWords{$negID + 1} = $negWord;
						print "$negWord is added to the label at $negID + 1\n";
						
						print "$labelWords{$id}\n\n";
					}
					# if there is a phrasal verb particle, it should be added to the verb. e.g., "working out"
					elsif ($dependencies{$id - 1}{$depID} =~ /prt/)
					{
						#my $particle = $tokenWord{$governors{$depID}{"prt"}};
						my $particle = $tokenWord{$depID};
						$elements[$i] = $existingToken . "_" . $particle . "-" . $existing_id;
						print "verb particle $particle is added to the verb: $elements[$i]\n";
						
						print "		The label at $id is updated from $labelWords{$id} to ";
						$labelWords{$id} = $existingToken . "_" . $particle;
						print "$labelWords{$id}\n\n";
					}
					# if the verb has a missing dobj or iobj add it to the next 2 cells in @elements
					elsif ($dependencies{$id - 1}{$depID} =~ /dobj/ || $dependencies{$id - 1}{$depID} =~ /iobj/)
					{					
						$has2obj++;
						if ($has2obj == 1) # this is the first obj of this verb
						{
							$firstObj = $tokenWord{$depID};
							$firstObjType = $dependencies{$id - 1}{$depID};
							
							#print "firstObj is set to $firstObj and it's a $firstObjType\n";
							#print "the next token on the path is $elements[$i + 2]\n";
							#print "with index removed: $nextToken\n\n";
						}
						#print "$dependencies{$id - 1}{$depID} is missing\n";
						
						
						#sometimes the dobj and iobj are swapped when using different parsers. So we need to check if the actual word (i.e., object) is not already on the path.
						# e.g., 'Kenya' can be the dobj on the path while iobj on the parse results. So we need to add in 'home' as the missing object.
											
						if ($has2obj == 2)
						{
							# is it possible that a verb has both objects and none of them is on the path ???
							print "has both dobj and iobj!\n";
							
							#my $secondObj = $tokenWord{$depID};
							if (defined $tokenWord{$depID} && exists $tokenWord{$depID} && $elements[$i + 2] !~ /$tokenWord{$depID}/ && lc $tokenWord{$depID} !~ /that/) # the second obj is not already on the path
							{
								if ($elements[$i + 2] !~ /\|/) # there is only one word at this position
								{
									if ($depID > $existing_id2 - 1) # the missing object should be added after the existing dependent
									{
										$elements[$i + 1] = $elements[$i + 1] . " | ->-" . $dependencies{$id - 1}{$depID} . "->-";
										$elements[$i + 2] = $elements[$i + 2] . " | " . $tokenWord{$depID} . "-$d";
									}
									else
									{
										$elements[$i + 1] = "->-" . $dependencies{$id - 1}{$depID} . "->- | " . $elements[$i + 1];
										$elements[$i + 2] = $tokenWord{$depID} . "-$d | " . $elements[$i + 2];
										
									}
								}
								print "		The label at ($depID + 1) is updated from $labelWords{$depID + 1} to ";
								$labelWords{$depID + 1} = $tokenWord{$depID};
								print " ---> $tokenWord{$depID} and depID is $depID\n\n";

								print "$elements[$i] - $elements[$i + 1] - $elements[$i + 2]\n\n";
							}
						}
						elsif ($firstObj eq /$nextToken/)# $has2obj == 1
						{
							print "first object [$firstObj] is already on the path. Nothing needs to be added!\n";
						}
						elsif ($firstObj ne "" && $firstObj !~ /$nextToken/ && lc $firstObj !~ /that/)
						{
							print "depID is $depID -- existing_id is $existing_id2\n";
							if ($depID > $existing_id2 - 1) # the missing object should be added after the existing dependent
							{
								$elements[$i + 1] = $elements[$i + 1] . " | ->-" . $dependencies{$id - 1}{$depID} . "->-";
								$elements[$i + 2] = $elements[$i + 2] . " | " . $tokenWord{$depID} . "-$d";
							}
							else
							{
								$elements[$i + 1] = "->-" . $dependencies{$id - 1}{$depID} . "->- | " . $elements[$i + 1];
								$elements[$i + 2] = $tokenWord{$depID} . "-$d | " . $elements[$i + 2];
								
							}
							print "		The label at ($depID + 1) is updated from $labelWords{$depID + 1} to ";
							$labelWords{$depID + 1} = $tokenWord{$depID};
							
							print "---> $tokenWord{$depID} and depID is $depID\n\n";
							print "$elements[$i] - $elements[$i + 1] - $elements[$i + 2]\n\n";
						}
						
						
					}
					# if the verb is a passive verb, it has a nsubjpass and an agent (the same as an obj for an active verb). agent might be missing.
					elsif ($dependencies{$id - 1}{$depID} =~ /agent/)
					{
						if ($elements[$i + 1] !~ /agent/) # agent is missing
						{
							#print "agent is missing!\ndepID is $depID -- existing_id is $existing_id2\n";
							if ($depID > $existing_id2 - 1) # the missing agent should be added after the existing dependent
							{
								$elements[$i + 1] = $elements[$i + 1] . " | ->-" . $dependencies{$id - 1}{$depID} . "->-";
								$elements[$i + 2] = $elements[$i + 2] . " | " . $tokenWord{$depID} . "-$d";
							}
							else
							{
								$elements[$i + 1] = "->-" . $dependencies{$id - 1}{$depID} . "->- | " . $elements[$i + 1];
								$elements[$i + 2] = $tokenWord{$depID} . "-$d | " . $elements[$i + 2];
								
							}
							#print "		The label at ($depID + 1) is updated from $labelWords{$depID + 1} to ";
							$labelWords{$depID + 1} = "by " . $tokenWord{$depID};
							#print "$elements[$i] - $elements[$i + 1] - $elements[$i + 2]\n\n";
							#print "$labelWords{$depID + 1}\n\n";
						}
						else
						{
							$labelWords{$id} = $tokenWord{$id - 1} . " by";
						}
					}
					# if the verb has xsubj, add it along with nsubj as that's the main verb
					elsif ($dependencies{$id - 1}{$depID} =~ /xsubj/ && $elements[$i - 1] =~ /xsubj/) 
					{
						#[EN PNU] and  [EN ODM] agreed in February  [EN 2008] to form a  [EN coalition_government] in a power-sharing arrangement that ended the political crisis erupting after disputed national elections in  [EN December_2007] 
						#PNU	coalition_government	PNU-1 -<-xsubj-<- form-9 ->-dobj->- coalition_government-11
						
						#aux(form-9, to-8)
						
						# the nsubj dependency should be added as a kind of a condition --> nsubj(agreed-4, PNU-1); for now it's added right before the current verb to show the 'action' didn't necessarily take place!
						
						# if there is an xsubj for a verb, then there will be an xcomp relating 2 verb together: xcomp(agreed-4, form-9)
						# You need to find the id (i.e., 4) for the other verb (i.e., agreed) --> can you assume that the last verb occured before $id ???
						
						my $xID = $governors{$depID}{"xcomp"};
						my $xVerb = $tokenWord{$xID};
						
						#print "		The label at $id is updated from $labelWords{$id} to ";
						$elements[$i] = $elements[$i] . " to " . $xVerb;
						#$labelWords{$id} = $tokenWord{$id - 1} . " to " . $xVerb;
						# --- NEW ---
						$labelWords{$xID + 1} = $xVerb;
						print "$xVerb is added to the label at $xID + 1\n";
						my $auxID = $dependents{$id - 1}{"aux"};  # this might be added again when goes to elsif ($dependencies{$id - 1}{$depID} =~ /aux/) branch
						my $auxWord = $tokenWord{$auxID};
						$labelWords{$auxID + 1} = $auxWord;
						print "$auxWord is added to the label at $auxID + 1\n";
						$labelWords{$id} = $tokenWord{$id - 1};
						print "$labelWords{$id} is added to the label at $id\n";
						#print "$labelWords{$id}\n\n";
					}
					# if the verb has xcomp (e.g., intensified cooperation to address all forms of insecurity --> xcomp (intensified, address) --> it will have xsubj
						# don't have to change anything on the path. just add the proper prep using aux(address, to) before the verb (which has xcomp after) when u generate labels
					elsif ($dependencies{$id - 1}{$depID} =~ /xcomp/)
					{
						print "there is xcomp between $tokenWord{$id - 1} and $tokenWord{$depID}\n";
						#print "the word at 12 is $tokenWord{12}\n";
						#print "the dependency between $depID and 12 is $dependencies{$depID}{12}\n";
						
						if ($dependents{$depID}{"aux"} =~ /\|/)
						{
							my @auxIDs = split ($dependents{$depID}{"aux"}, /\|/);
							foreach my $prep_id (@auxIDs)
							{				
								my $prep = $tokenWord{$prep_id};
								
								#print "the prep is $prep at $prep_id\n";
								
								if ($depID > $second_entity_ID)
								{
									print "xcomp at $depID is after the second entity at $second_entity_ID, so it won't be added!\n";
								}
								else
								{
									#$labelWords{$depID + 1} = "$prep " . $tokenWord{$depID};
									# --- NEW ---
									$labelWords{$prep_id + 1} = $prep;
									print "the $prep is added to the label at $prep_id + 1\n";
									$labelWords{$depID + 1} = $tokenWord{$depID};
									print "$labelWords{$depID + 1} is added to the label at $depID\n\n";
									
									if (defined $dependents{$depID}{"dobj"} && exists $dependents{$depID}{"dobj"})
									{
										my $obj_id = $dependents{$depID}{"dobj"};
										my $obj = $tokenWord{$obj_id};
										
										$labelWords{$obj_id + 1} = $obj;
										print "the object $obj is added to the label at $obj_id + 1\n\n";
									}
									#print "$dependencies{$id - 1}{$depID} -- the updated label: $labelWords{$depID + 1}\n\n";
								}
							}
						}
						else
						{
							my $prep_id = $dependents{$depID}{"aux"};
				
							my $prep = $tokenWord{$prep_id};
							
							print "the prep is $prep at $prep_id\n";
							
							if ($depID > $second_entity_ID)
							{
								print "xcomp at $depID is after the second entity at $second_entity_ID, so it won't be added!\n";
							}
							else
							{
								#$labelWords{$depID + 1} = "$prep " . $tokenWord{$depID};
								# --- NEW ---
								$labelWords{$prep_id + 1} = $prep;
								print "the $prep is added to the label at $prep_id + 1\n";
								$labelWords{$depID + 1} = $tokenWord{$depID};
								print "$labelWords{$depID + 1} is added to the label at $depID\n\n";
								
								if (defined $dependents{$depID}{"dobj"} && exists $dependents{$depID}{"dobj"})
								{
									my $obj_id = $dependents{$depID}{"dobj"};
									my $obj = $tokenWord{$obj_id};
									
									$labelWords{$obj_id + 1} = $obj;
									print "the object $obj is added to the label at $obj_id + 1\n\n";
								}
								#print "$dependencies{$id - 1}{$depID} -- the updated label: $labelWords{$depID + 1}\n\n";
							}
						}
					}
					# e.g., "I need to help my family." --> xcomp (need, help)
					elsif ($dependencies{$id - 1}{$depID} =~ /aux/)
					{
						print "there is aux between $tokenWord{$id - 1} and $tokenWord{$depID}\n";
						if (defined $governors{$id - 1}{"xcomp"} && exists $governors{$id - 1}{"xcomp"})
						{
							my $govID = $governors{$id - 1}{"xcomp"};
							print "there is xcomp between $tokenWord{$id - 1} and $tokenWord{$depID}\n";
							
							# there could be more than one aux for a verb:
							# aux (making-14, wo-11)
							# neg (making-14, n't-12)
							# aux (making-14, be-13)
							
							if ($dependents{$id - 1}{"aux"} =~ /\|/) # multiple aux
							{
								my @auxIDs = split /\|/ , $dependents{$id - 1}{"aux"};
								print "$tokenWord{$id - 1} has multiple aux es: @auxIDs\n";
								
								foreach my $auxID (@auxIDs)
								{
									my $auxWord = $tokenWord{$auxID};
									
									if (defined $dependents{$govID}{"auxpass"} && exists $dependents{$govID}{"auxpass"}) # auxpass(used, is) - "BN is used to unify all accounts."
									{
										my $axpssID = $dependents{$govID}{"auxpass"};
										#print "auxpass $tokenWord{$axpssID} is added!\n";
										#$labelWords{$id} = $tokenWord{$dependents{$govID}{"auxpass"}} . " " . $tokenWord{$governors{$id - 1}{"xcomp"}} . " $prep " . $labelWords{$id};
										
										# --- NEW ---
										$labelWords{$axpssID + 1} = $tokenWord{$axpssID};
										print "auxpass $tokenWord{$axpssID} is added to the label at $axpssID + 1\n";
										
										my $xcompID = $governors{$id - 1}{"xcomp"};
										my $xcompWord = $tokenWord{$xcompID};
										$labelWords{$xcompID + 1} = $xcompWord;
										print "xcomp $xcompWord is added to the label at $xcompID + 1\n";
										
										$labelWords{$auxID + 1} = $auxWord;
										print "aux $auxWord is added to the label at $auxID + 1\n\n";
										
										
									}
									else
									{
										# --- NEW ---
								
										my $xcompID = $governors{$id - 1}{"xcomp"};
										my $xcompWord = $tokenWord{$xcompID};
										$labelWords{$xcompID + 1} = $xcompWord;
										print "xcomp $xcompWord is added to the label at $xcompID + 1\n";
										
										if (defined $dependents{$xcompID}{"aux"} && exists $dependents{$xcompID}{"aux"}) # xcomp (going-2, do-4) ; aux (going-2, am-1)
										{
											my $xcompAuxID = $dependents{$xcompID}{"aux"};
											my $xcompAuxWord = $tokenWord{$xcompAuxID};
											$labelWords{$xcompAuxID + 1} = $xcompAuxWord;
											
											print "aux $xcompAuxWord for xcomp $xcompWord is added to the label at $xcompAuxID + 1\n";
										}
										if (defined $dependents{$xcompID}{"neg"} && exists $dependents{$xcompID}{"neg"}) 
										{
											# aux (seem-3, ca-1)
											# neg (seem-3, n't-2)
											# aux (get-5, to-4)
											# xcomp (seem-3, get-5)
		
											my $xcompNegID = $dependents{$xcompID}{"neg"};
											my $xcompNegWord = $tokenWord{$xcompNegID};
											$labelWords{$xcompNegID + 1} = $xcompNegWord;
											
											print "Negation $xcompNegWord for xcomp $xcompWord is added to the label at $xcompNegID + 1\n";
										}
										
										$labelWords{$auxID + 1} = $auxWord;
										print "aux $auxWord is added to the label at $auxID + 1\n\n";
									}
								}
							}
							else
							{
								my $prep_id = $dependents{$id - 1}{"aux"};
								my $prep = $tokenWord{$prep_id};
								
								print "the aux is $prep at $prep_id\n";
								
								if (defined $dependents{$govID}{"auxpass"} && exists $dependents{$govID}{"auxpass"}) # auxpass(used, is) - "BN is used to unify all accounts."
								{
									my $axpssID = $dependents{$govID}{"auxpass"};
									#print "auxpass $tokenWord{$axpssID} is added!\n";
									#$labelWords{$id} = $tokenWord{$dependents{$govID}{"auxpass"}} . " " . $tokenWord{$governors{$id - 1}{"xcomp"}} . " $prep " . $labelWords{$id};
									
									# --- NEW ---
									$labelWords{$axpssID + 1} = $tokenWord{$axpssID};
									print "auxpass $tokenWord{$axpssID} is added to the label at $axpssID + 1\n";
									
									my $xcompID = $governors{$id - 1}{"xcomp"};
									my $xcompWord = $tokenWord{$xcompID};
									$labelWords{$xcompID + 1} = $xcompWord;
									print "xcomp $xcompWord is added to the label at $xcompID + 1\n";
									
									$labelWords{$prep_id + 1} = $prep;
									print "aux $prep is added to the label at $prep_id + 1\n\n";
									
									
								}
								else
								{
									#$labelWords{$id} = $tokenWord{$governors{$id - 1}{"xcomp"}} . " $prep " . $labelWords{$id};
									# --- NEW ---
									
									my $xcompID = $governors{$id - 1}{"xcomp"};
									my $xcompWord = $tokenWord{$xcompID};
									$labelWords{$xcompID + 1} = $xcompWord;
									print "xcomp $xcompWord is added to the label at $xcompID + 1\n";
									
									if (defined $dependents{$xcompID}{"aux"} && exists $dependents{$xcompID}{"aux"}) # xcomp (going-2, do-4) ; aux (going-2, am-1)
									{
										my $xcompAuxID = $dependents{$xcompID}{"aux"};
										my $xcompAuxWord = $tokenWord{$xcompAuxID};
										$labelWords{$xcompAuxID + 1} = $xcompAuxWord;
										
										print "aux $xcompAuxWord for xcomp $xcompWord is added to the label at $xcompAuxID + 1\n";
									}
									if (defined $dependents{$xcompID}{"neg"} && exists $dependents{$xcompID}{"neg"}) 
									{
										# aux (seem-3, ca-1)
										# neg (seem-3, n't-2)
										# aux (get-5, to-4)
										# xcomp (seem-3, get-5)
	
										my $xcompNegID = $dependents{$xcompID}{"neg"};
										my $xcompNegWord = $tokenWord{$xcompNegID};
										$labelWords{$xcompNegID + 1} = $xcompNegWord;
										
										print "Negation $xcompNegWord for xcomp $xcompWord is added to the label at $xcompNegID + 1\n";
									}
									
									$labelWords{$prep_id + 1} = $prep;
									print "aux $prep is added to the label at $prep_id + 1\n\n";
									
								}
							}
						}
						if (defined $dependents{$id - 1}{"aux"} && exists $dependents{$id - 1}{"aux"})
						{
							if ($dependents{$id - 1}{"aux"} =~ /\|/)
							{
								my @auxIDs = split /\|/ , $dependents{$id - 1}{"aux"};
								print "there are multiple aux es: @auxIDs\n";
								foreach my $auxID (@auxIDs)
								{
									my $auxWord = $tokenWord{$auxID};
									$labelWords{$auxID + 1} = $auxWord;
									print "$auxWord is added to the label at $auxID\n";
								}
							}
							else
							{
								my $auxID = $dependents{$id - 1}{"aux"};
								my $auxWord = $tokenWord{$auxID};
								$labelWords{$auxID + 1} = $auxWord;
								print "$auxWord is added to the label at $auxID\n";
							}
						}
						
					}
					# if the nsubj is missing or the verb has both xsubj and nsubj
					elsif ($dependencies{$id - 1}{$depID} =~ /nsubj/) # we need to check if there is an xsubj for the depID - also if the verb has 2 nsubjs
					{
						# if there is neither - nor related to this nsubj, the current verb has to be negated.
						if (defined $dependents{$depID}{"preconj"} && exists $dependents{$depID}{"preconj"})
						{
							my $preconj_id = $dependents{$depID}{"preconj"};
							my $preconj_word = $tokenWord{$preconj_id};
							
							$preconj_word = lc $preconj_word;
							if ($preconj_word eq "neither")
							{
								$hasNeither = 1;
								print "There is Neither!\n\n";
								$elements[$i] = "NOT " . $elements[$i];
								$labelWords{$id} = "NOT " . $labelWords{$id};
							}
						}
						#if nsubj is missing
						if ($elements[$i - 1] !~ /nsubj/)
						{
							if (defined $dependents{$id - 1}{"nsubj"} && exists $dependents{$id - 1}{"nsubj"})
							{
								if ($dependents{$id - 1}{"nsubj"} =~ /\|/) # the verb has more than one nsubjs; so we get multiple depIDs
								{
									my @DepIDs = split /\|/, $dependents{$id - 1}{"nsubj"};
									
									foreach my $dID (@DepIDs)
									{
										if ($dID > $existing_id_2 - 1) # the missing object should be added after the existing dependent
										{
											$elements[$i - 1] = $elements[$i - 1] . " | -<-" . $dependencies{$id - 1}{$dID} . "-<-";
											$elements[$i - 2] = $elements[$i - 2] . " | " . $tokenWord{$dID} . "-$d";
										}
										else
										{
											$elements[$i - 1] = "-<-" . $dependencies{$id - 1}{$dID} . "-<- | " . $elements[$i - 1];
											$elements[$i - 2] = $tokenWord{$dID} . "-$d | " . $elements[$i - 2];	
										}
										
										if (defined $labelWords{$dID + 1} && exists $labelWords{$dID + 1})
										{
											$labelWords{$dID + 1} = $labelWords{$dID + 1} . "|" . $tokenWord{$dID};
										}
										else
										{
											$labelWords{$dID + 1} = $tokenWord{$dID};
										}
									}
								}
								else
								{
									#print "nsubj is missing!\n depID is $depID -- existing_id is $existing_id2\n";
									if ($depID > $existing_id_2 - 1) # the missing object should be added after the existing dependent
									{
										$elements[$i - 1] = $elements[$i - 1] . " | -<-" . $dependencies{$id - 1}{$depID} . "-<-";
										$elements[$i - 2] = $elements[$i - 2] . " | " . $tokenWord{$depID} . "-$d";
									}
									else
									{
										$elements[$i - 1] = "-<-" . $dependencies{$id - 1}{$depID} . "-<- | " . $elements[$i - 1];
										$elements[$i - 2] = $tokenWord{$depID} . "-$d | " . $elements[$i - 2];
										
									}
									#print "		The label at ($depID + 1) is updated from $labelWords{$depID + 1} to ";
									$labelWords{$depID + 1} = $tokenWord{$depID};
									#print "$labelWords{$depID + 1}\n\n";
									#print "$elements[$i - 2] - $elements[$i - 1] - $elements[$i]\n\n";
								}
							}
							
						}
						elsif (defined $dependents{$id - 1}{"nsubj"} && exists $dependents{$id - 1}{"nsubj"})
						{
							print "$dependents{$id - 1}{\"nsubj\"} is defined!\n\n";
							if ($dependents{$id - 1}{"nsubj"} =~ /\|/) # the verb has more than one nsubjs; so we get 2 depIDs
							{
								print "the verb $tokenWord{$id - 1} has more than one nsubjs!\n\n";
								my @DepIDs = split /\|/, $dependents{$id - 1}{"nsubj"};
								
								my $ii = 0;
								for ($ii = 0; $ii < @DepIDs; $ii++)
								{
									my $dID = $DepIDs[$ii];
									if ($elements[$i - 2] !~ /$tokenWord{$dID}/) # if it is not already on the path
									{
										if ($dID > $existing_id_2 - 1) # the missing object should be added after the existing dependent
										{
											$elements[$i - 1] = $elements[$i - 1] . " | -<-" . $dependencies{$id - 1}{$dID} . "-<-";
											$elements[$i - 2] = $elements[$i - 2] . " | " . $tokenWord{$dID} . "-$d";
										}
										else
										{
											$elements[$i - 1] = "-<-" . $dependencies{$id - 1}{$dID} . "-<- | " . $elements[$i - 1];
											$elements[$i - 2] = $tokenWord{$dID} . "-$d | " . $elements[$i - 2];	
										}
									}
									else
									{
										print "$tokenWord{$dID} is already on the path!\n\n";
									}
									
									
									if (defined $labelWords{$dID + 1} && exists $labelWords{$dID + 1})
									{
										if ($labelWords{$dID + 1} !~ /$tokenWord{$dID}/) # if it is not already added to the Label
										{
											$labelWords{$dID + 1} = $labelWords{$dID + 1} . "|" . $tokenWord{$dID};
											print "Label is updated with the nsubj: $labelWords{$dID + 1}\n\n";
										}
										else
										{
											print "$tokenWord{$dID} is already in the Label!\n\n";
										}
									}
									else
									{
										if ($labelWords{$DepIDs[0] + 1} !~ /$tokenWord{$dID}/) # if it is not already added to the Label
										{
											if (defined $dependents{$dID}{"preconj"} && exists $dependents{$dID}{"preconj"})
											{
												my $preconj_id = $dependents{$dID}{"preconj"};
												my $preconj_word = $tokenWord{$preconj_id};
												
												$preconj_word = lc $preconj_word;
												if ($preconj_word eq "neither")
												{
													$hasNeither = 1;
													print "There is Neither!\n\n";
												}
											}
											if ($ii == 0) # the very first conjunct
											{
												my $conj_word = $dependencies{$DepIDs[0]}{$DepIDs[1]};
												$conj_word =~ s/conj_//;
												print "conj_word is $conj_word\n";
												if (lc($conj_word) =~ /nor/ && $hasNeither == 1)
												{
													$conj_word = "and";
													print "conj_word is changed to $conj_word\n\n";
												}
												$labelWords{$dID + 1} = $tokenWord{$dID} . " " . $conj_word;
												print "the very First nsubj -$tokenWord{$dID}- is added to label: $labelWords{$dID + 1}\n\n";
											}
											else
											{
												my $conj_word = $dependencies{$DepIDs[0]}{$dID};
												$conj_word =~ s/conj_//;
												print "conj_word is $conj_word\n";
												if (lc($conj_word) =~ /nor/ && $hasNeither == 1)
												{
													$conj_word = "and";
													print "conj_word is changed to $conj_word\n\n";
												}
																						
												if ($labelWords{$DepIDs[0] + 1} !~ /$conj_word/) # if conjunct is not already added to the Label
												{
													$labelWords{$DepIDs[0] + 1} = $labelWords{$DepIDs[0] + 1} . " " . $conj_word . " " . $tokenWord{$dID};
													print "First nsubj -$tokenWord{$dID}- and conjuct -$conj_word- are added to label: $labelWords{$DepIDs[0] + 1}\n\n";
												}
												else
												{
													$labelWords{$DepIDs[0] + 1} = $labelWords{$DepIDs[0] + 1} . " " . $tokenWord{$dID};
													print "First nsubj -$tokenWord{$dID}- is added to label: $labelWords{$DepIDs[0] + 1}\n\n";
												}
											}
										}
									}
								}
							}
						}
						
						# if the verb has an xsubj but it's not on the path, it should be added to the nsubj already on the path
						if (defined $governors{$depID}{"xsubj"} && exists $governors{$depID}{"xsubj"})
						{
							my $verb = $tokenWord{$governors{$depID}{"xsubj"}};
							$elements[$i] = $verb . " to " . $elements[$i];
						}
					}
					elsif ($dependencies{$id - 1}{$depID} =~ /prep_/) # if the verb is related to a noun (which is not already on the path) through a prep
					{
						#e.g.: "Hubby entered into negotiations with the existing owner."
						# prep_into(entered-4, negotiations-6)
						# prep_with(entered-4, owner-10)
						# Hubby-3**-<-nsubj-<-**entered-4**->-prep_with->-**existing owner-10
						
						my $prep = $dependencies{$id - 1}{$depID};
						print "%%% initial prep is $prep\n\n";
						$prep =~ s/prep_//;
									
						print "%%% prep is $prep\n\n";
						if ($elements[$i + 2] !~ /$tokenWord{$depID}/ ) # it's not already on the path
						{
							if (defined $dependents{$depID}{"poss"} && exists $dependents{$depID}{"poss"}) # if the noun has a poss, prep should be added before poss
							{
								my $possID = $dependents{$depID}{"poss"};
								my $possWord = $tokenWord{$possID};
								
								$labelWords{$possID + 1} = $prep . " " . $possWord;
								$labelWords{$depID + 1} = $tokenWord{$depID};
								
								print "$tokenWord{$depID} has both poss $possWord and prep $prep. They are added to $labelWords{$possID + 1} at $possID + 1\n";
							}
							elsif (defined $dependents{$depID}{"num"} && exists $dependents{$depID}{"num"}) # if the noun has a num, prep should be added before the number
							{
								my $numID = $dependents{$depID}{"num"};
								my $numWord = $tokenWord{$numID};
								
								$labelWords{$numID + 1} = $prep . " " . $numWord;
								$labelWords{$depID + 1} = $tokenWord{$depID};
								
								print "$tokenWord{$depID} has both number $numWord and prep $prep. They are added to $labelWords{$numID + 1} at $numID + 1\n";
							}
							elsif (defined $tokenWord{$depID} && exists $tokenWord{$depID} && $tokenWord{$depID} ne "" && $labelWords{$depID + 1} !~ /$prep/)
							{
								$labelWords{$depID + 1} = $prep . "  " . $tokenWord{$depID};
								
								my $lw = $labelWords{$depID + 1};
								print "%% $lw is added to the Label at $depID + 1!\n\n";
							}
							else
							{
								$labelWords{$depID + 1} = $tokenWord{$depID};
								print "%%% $tokenWord{$depID} is added to the Label at $depID + 1!\n\n";
							}
						}
						
						
					}
					elsif ($dependencies{$id - 1}{$depID} =~ /prepc_/) # if the verb is related to a VP via a prep 
					{
						#e.g.: "getting what you want without raising one's voice."
						
						#nsubj(want-25, you-24)
						#ccomp(getting-22, want-25)
						#prepc_without(want-25, raising-27)
						#poss(voice-30, one-28)
						#dobj(raising-27, voice-30)
						
						my $prepc = $dependencies{$id - 1}{$depID};
						print "%%% initial prepc is $prepc\n\n";
						$prepc =~ s/prepc_//;
									
						print "%%% prepc is $prepc\n\n";
						if ($elements[$i + 2] !~ /$tokenWord{$depID}/ ) # it's not already on the path
						{
							if (defined $tokenWord{$depID} && exists $tokenWord{$depID} && $tokenWord{$depID} ne "" && $labelWords{$depID + 1} !~ /$prepc/)
							{
								$labelWords{$depID + 1} = $prepc . "  " . $tokenWord{$depID};
								my $lw = $labelWords{$depID + 1};
								print "%% $lw is added to the Label!\n\n";
							}
							else
							{
								$labelWords{$depID + 1} = $tokenWord{$depID};
								print "%%% $tokenWord{$depID} is added to the Label!\n\n";
							}
							
							# $tokenWord{$depID} is a verb, so it might have a dobj which needs to be added
							if (defined $dependents{$depID}{"dobj"} && exists $dependents{$depID}{"dobj"})
							{
								my $dobjID = $dependents{$depID}{"dobj"};
								my $dobjWord = $tokenWord{$dobjID};
								
								$labelWords{$dobjID + 1} = $dobjWord;
								print "%%% dobj $dobjWord is added to the Label at $dobjID!\n\n";
							}
						}
						else # it is on the path but the prep might never be added to it??
						{
							if (defined $tokenWord{$depID} && exists $tokenWord{$depID} && $tokenWord{$depID} ne "" && $labelWords{$depID + 1} !~ /$prepc/)
							{
								$labelWords{$depID + 1} = $prepc . "  " . $tokenWord{$depID};
								my $lw = $labelWords{$depID + 1};
								print "%% $lw is added to the Label!\n\n";
							}
							else
							{
								$labelWords{$depID + 1} = $tokenWord{$depID};
								print "%%% $tokenWord{$depID} is added to the Label!\n\n";
							}
						}
						
						
					}
					if ($dependencies{$id - 1}{$depID} =~ /advmod/) # advmod (do-3, well-4)
					{
						print "verb $tokenWord{$id - 1} has an advmod $tokenWord{$depID}!\n";
						
						# --- NEW ---
						my $advmodID = $dependents{$id - 1}{"advmod"};
						my $advmodWord = $tokenWord{$advmodID};
						$labelWords{$advmodID + 1} = $advmodWord;
						print "$advmodWord is added to the label at $advmodID + 1\n";
					}
					
				}
			}
			elsif ($tokenPOS{$id - 1} =~ /JJ/)
			{
				#nsubj(disciplined-14, walks-10)
				#cop(disciplined-14, were-11)
				#neg(disciplined-14, n't-12)
				
				if (defined $dependents{$id - 1}{"cop"} && exists $dependents{$id - 1}{"cop"})
				{
					if (defined $dependents{$id - 1}{"neg"} && exists $dependents{$id - 1}{"neg"})
					{
						print "Negated copula!\n";
						#$labelWords{$id} = $tokenWord{$dependents{$id - 1}{"cop"}} . " " . $tokenWord{$dependents{$id - 1}{"neg"}} . " " . $elements[$i];
						# --- NEW ---
						my $copID = $dependents{$id - 1}{"cop"};
						my $copWord = $tokenWord{$copID};
						$labelWords{$copID + 1} = $copWord;
						print "Copula $copWord is added to the label at $copID\n";
						
						my $negID = $dependents{$id - 1}{"neg"};
						my $negWord = $tokenWord{$negID};
						$labelWords{$negID + 1} = $negWord;
						print "Negator $negWord is added to the label at $negID\n";
						
						$labelWords{$id} = $tokenWord{$id - 1};
						print "$labelWords{$id} is added to the label at $id\n";
					}
					else
					{
						#print "		The label at $id is updated from $labelWords{$id} to ";
						#$labelWords{$id} = $tokenWord{$dependents{$id - 1}{"cop"}} . " " . $elements[$i];
						# --- NEW ---
						my $copID = $dependents{$id - 1}{"cop"};
						my $copWord = $tokenWord{$copID};
						$labelWords{$copID + 1} = $copWord;
						print "Copula $copWord is added to the label at $copID\n";
						
						$labelWords{$id} = $tokenWord{$id - 1};
						print "$labelWords{$id} is added to the label at $id\n";
					}
				}
				else
				{
					$labelWords{$id} = $tokenWord{$id - 1}; # just add the adj as it was on the path
					print "ADJ $labelWords{$id} is added to the label at $id\n";
				}
			}
			elsif ($tokenPOS{$id - 1} =~ /R/)
			{
				;
			}
			else # the word is merged with other words and the id does not exist anymore!
			{
				$tword = "";
			}
			$i += 2;
			$hasNeither = 0;
		#}
		#else
		#{
		#	print "Didn't go through !!!!!!!!!!!!!!\n\n";
		#	print "$i ~~ $elements[$i] ~~ $tword\n";
		#}
	 }
	 

	 my $augmentedPath = "";
	 foreach my $element (@elements)
	 {
		#print "$element ** ";
		$augmentedPath = $augmentedPath . $element . "**";
	 }
	 #print "\n\n";
	 my $label = "";
	 foreach my $id (keys %labelWords)
	 {
		if ($labelWords{$id} =~ /\|/)
		{
			my @tokens = split /\|/, $labelWords{$id};
			#print "labelWords: $labelWords{$id}\n";
			#delete $labelWords{$id};
			foreach my $token (@tokens)
			{
				#print "token: $token\n";
				@items = split /-/, $token;
				my $id2 = $items[@items - 1];
				$id2 =~ s/\s+//g;
				#print "labelWords at $id2 was $labelWords{$id2}\n\n";
				$labelWords{$id2} = $tokenWord{$id2 - 1};
				#print "labelWords at $id2 is updated to $tokenWord{$id2 - 1}\n\n";
				
				
				#if (defined $dependents{$id2 - 1}{"conj_and"} && exists $dependents{$id2 - 1}{"conj_and"})
				#{
				#	$labelWords{$dependents{$id2 - 1}{"conj_and"}} = "and " . $tokenWord{$dependents{$id2 - 1}{"conj_and"}};
				#}
				#elsif (defined $dependents{$id2 - 1}{"conj_or"} && exists $dependents{$id2 - 1}{"conj_or"})
				#{
				#	$labelWords{$dependents{$id2 - 1}{"conj_or"}} = "or " . $tokenWord{$dependents{$id2 - 1}{"conj_or"}};
				#}
				#print "OOOOO $labelWords{$id2} is updated! -- $id2\n\n";
			}
		}
		#else
		#{
		#	if (defined $dependents{$id - 1}{"conj_and"} && exists $dependents{$id - 1}{"conj_and"})
		#	{
		#		my $depId = $dependents{$id - 1}{"conj_and"};
		#		my $lw = $labelWords{$depId};
		#		print "labelWords at $depId is $lw\n";
		#		print "the dependent word is $tokenWord{$depId}\n\n";
		#		if ($labelWords{$depId} =~ /$tokenWord{$depId}/)
		#		{
		#			print "and added!\n\n";
		#			$labelWords{$depId} = "and " . $tokenWord{$depId};
		#		}
		#	}
		#	elsif (defined $dependents{$id - 1}{"conj_or"} && exists $dependents{$id - 1}{"conj_or"})
		#	{
		#		$labelWords{$dependents{$id - 1}{"conj_or"}} = "or " . $tokenWord{$dependents{$id - 1}{"conj_or"}};
		#	}
		#}
		
		if ($tokenPOS{$id - 1} =~ /NN/)
		{
			# for every noun in the Label, if there is a poss associated with it, add it in. e.g., poss (best-6, my-5)
			if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"}) 
			{
				my $possID = $dependents{$id - 1}{"poss"};
				my $possWord = $tokenWord{$possID};
				
				if (! (defined $labelWords{$possID + 1} && exists $labelWords{$possID + 1}) || $labelWords{$possID + 1} !~ /$possWord/)
				{
					$labelWords{$possID + 1} = $possWord;
					print "poss $possWord is added to the Label at $possID + 1\n\n";
				}
				else
				{
					print "poss $possWord is NOT added to the Label at $possID + 1\n\n"
				}
			}
			# for every noun in the Label, if there is a number associated with it, add it in. e.g., num (days-12, 21-11)
			if (defined $dependents{$id - 1}{"num"} && exists $dependents{$id - 1}{"num"}) 
			{
				my $numID = $dependents{$id - 1}{"num"};
				my $numWord = $tokenWord{$numID};
				
				if (! (defined $labelWords{$numID + 1} && exists $labelWords{$numID + 1}) || $labelWords{$numID + 1} !~ /$numWord/)
				{
					$labelWords{$numID + 1} = $numWord;
					print "Number $numWord is added to the Label at $numID + 1\n\n";
				}
				else
				{
					print "Number $numWord is NOT added to the Label at $numID + 1\n\n";
				}
			}
			# for every noun in the Label, if there is a infmod associated with it, add it in. e.g., infmod (site-7, load-9) in "get the site to load"
			if (defined $dependents{$id - 1}{"infmod"} && exists $dependents{$id - 1}{"infmod"})
			{
				# An infinitival modifier of an NP is an infinitive that serves to modify the meaning of the NP.
				# “Points to establish are . . . ” infmod(points, establish)
				#“I don’t have anything to say” infmod(anything, say)
				
				my $infmodID = $dependents{$id - 1}{"infmod"};
				my $infmodWord = $tokenWord{$infmodID};
				
				$labelWords{$infmodID + 1} = "to " . $infmodWord;
				print "Infinitival modifier 'to $infmodWord' is added to the Label at $infmodID + 1\n\n";
			
			}
			if (defined $dependents{$id - 1}{"cop"} && exists $dependents{$id - 1}{"cop"})
			{
				# "it is my book." --> cop (book, is)
				
				my $copID = $dependents{$id - 1}{"cop"};
				my $copWord = $tokenWord{$copID};
				
				$labelWords{$copID + 1} = $copWord;
				print "Copula 'to $copWord' is added to the Label at $copID + 1\n\n";
			
			}
		}
		elsif ($tokenPOS{$id - 1} =~ /JJ/)
		{
			if (defined $dependents{$id - 1}{"poss"} && exists $dependents{$id - 1}{"poss"}) 
			{
				my $possID = $dependents{$id - 1}{"poss"};
				my $possWord = $tokenWord{$possID};
				
				$labelWords{$possID + 1} = $possWord;
				print "poss $possWord is added to the Label at $possID + 1 for ADJ $tokenWord{$id - 1}\n\n";				
			}
			elsif (defined $dependents{$id - 1}{"cop"} && exists $dependents{$id - 1}{"cop"}) 
			{
				my $copID = $dependents{$id - 1}{"cop"};
				my $copWord = $tokenWord{$copID};
				
				$labelWords{$copID + 1} = $copWord;
				print "cop $copWord is added to the Label at $copID + 1 for ADJ $tokenWord{$id - 1}\n\n";				
			}
		}
		elsif ($tokenPOS{$id - 1} =~ /VB/)
		{
			if (defined $dependents{$id - 1}{"prt"} && exists $dependents{$id - 1}{"prt"}) # prt ( get-6 , up-7 )
			{
				my $prtID = $dependents{$id - 1}{"prt"};
				my $prtWord = $tokenWord{$prtID};
				
				$labelWords{$prtID + 1} = $prtWord;
				print "prt $prtWord is added to the Label at $prtID + 1 for Verb $tokenWord{$id - 1}\n\n";				
			}
		}
	 }
	 
	 #if the second entity was added twice, it would be added once at $second_entity_ID and the second time at the previous position in the label
	 if (defined $labelWords{$second_entity_ID} && exists $labelWords{$second_entity_ID})
	 {
		my $i = $second_entity_ID - 1;
		print "the second entity is $second_entity\n";
		while ($i > 0 && (!defined $labelWords{$i} || !exists $labelWords{$i} || $labelWords{$i} eq ""))
		{
			$i--;
		}
		print "the previous element at the label is $labelWords{$i} at $i\n";
		if ($labelWords{$i} eq $second_entity)
		{
			print "$labelWords{$i} is deleted from $i\n";
			delete ($labelWords{$i});
		}		
	 }
	 my $neatLabel = "";
	 foreach my $id (sort { $a <=> $b} keys %labelWords)
	 {
		if (defined $labelWords{$id} && exists $labelWords{$id})
		{
			$label = $label . " (" . $id . ") " . $labelWords{$id} . "*";
			$neatLabel = $neatLabel . " " . $labelWords{$id};
		}
	 }
	 
	 print "NEW LABEL AFTER DELETING SECOND ENTITY: $label\n\n";
	 my $isAdded = 0;
	 my @eles = split / /, $originalPath;
	 for (my $k = 0;  $k < @eles; $k += 2) # if there is a word on the original path, but not on the label, add it.
	 {
		my $element = @eles[$k];
		my $entid = substr $element, rindex($element, '-') + 1;
		my $ent = substr $element, 0, rindex($element, '-');
		my $missingPrep = 1;
		my $possID = -1;
		my $numID = -1;
		if ($label !~ /$ent/)
		{
			$isAdded = 1;
			
			print "Lable: $label does not contain $ent\n";
			
			$labelWords{$entid} = $ent;
			
			print "missing term $ent is added to the label at $entid\n\n";
		}
		if ($k > 1 && $eles[$k - 1] =~ /prep_/)
		{
			# compositions-2 -<-nsubj-<- shared-6 ->-prep_with->- energy-16
			# -<-prep_during-<-
			
			my $prep = $eles[$k - 1];
			$prep =~ s/->-prep_//;
			$prep =~ s/->-//;
			$prep =~ s/-<-prep_//;
			$prep =~ s/-<-//;
			
			print "there is a prep $prep on the path\n";
			if ($labelWords{$entid} =~ /$prep/)
			{
				$missingPrep = 0;
				print "$prep is already added to $labelWords{$entid} at $entid\n";
			}
			elsif (defined $dependents{$entid - 1}{"poss"} && exists $dependents{$entid - 1}{"poss"})
			{
				$possID = $dependents{$entid - 1}{"poss"};
				if ($labelWords{$possID + 1} =~ /$prep/)
				{
					$missingPrep = 0;
					print "$prep is already added to $labelWords{$possID + 1} at $possID + 1\n";
				}
			}
			elsif (defined $dependents{$entid - 1}{"num"} && exists $dependents{$entid - 1}{"num"})
			{
				$numID = $dependents{$entid - 1}{"num"};
				if ($labelWords{$numID + 1} =~ /$prep/)
				{
					$missingPrep = 0;
					print "$prep is already added to $labelWords{$numID + 1} at $numID + 1\n";
				}
			}
			
			if ($missingPrep == 1)
			{
				print "$prep is missing from the label!\n";
				$isAdded = 1;
				if ($possID != -1) # noun has a poss
				{
					$labelWords{$possID} = $prep . " " . $labelWords{$possID};
					print "$prep is added to $labelWords{$possID + 1} at $possID + 1\n";
				}
				elsif ($numID != -1) # noun has a num
				{
					$labelWords{$numID} = $prep . " " . $labelWords{$numID};
					print "$prep is added to $labelWords{$numID + 1} at $numID + 1\n";
				}
				else
				{
					$labelWords{$entid} = $prep . " " . $labelWords{$entid};
					print "$prep is added to $labelWords{$entid} at $entid\n";
				}
			}
			
		}
	 }
	 if ($isAdded == 1)
	 {
		$label = "";
		$neatLabel = "";
		foreach my $id (sort { $a <=> $b} keys %labelWords)
		{
		       if (defined $labelWords{$id} && exists $labelWords{$id})
		       {
			       $label = $label . " (" . $id . ") " . $labelWords{$id} . "*";
			       $neatLabel = $neatLabel . " " . $labelWords{$id};
		       }
		}
	 }

	 #print "$labelWords{9} - $labelWords{10} - $labelWords{12} - $labelWords{16} - $labelWords{17}\n\n";
	 
	 #close (OUT);
	 #print OUT "$first_entity\t$second_entity\t$neatLabel\t$doc\n";
	 return ($augmentedPath, $label, $neatLabel);
}

sub fixEntities_1 # The first step to fixEntities: Generates the tokenized version of texts from TaggedEntities and stores the tokens and their indexes. 
{
	my $topic = $_[0];
	my $docfile = $_[1];
	my $dN = $_[2];
	
	#my $rm = `rm -rf windows/$topic/tokenizedSentences`;
	#my $mkdir = `mkdir windows/$topic/tokenizedSentences`;
	my $mkdir = `mkdir windows/$topic/$dN/tokenizedSentences`;
	
	# Create a new NLP pipeline (don't silence messages, do make corefs bidirectional)
	$pipeline = new Lingua::StanfordCoreNLP::Pipeline(0, 1);

	my @sentences = ();
	
#	opendir (THISDIR, "windows/$topic/taggedEntities") or die "$!";
#        my @docfiles = grep !/^\./, readdir THISDIR;
#        closedir THISDIR;
	
	#my $dcount = @docfiles;
	#print "$dcount\n";
		
	#foreach my $docfile (@docfiles)
	#{
		print "$docfile\n";
	
		
		#open (OUT, ">windows/$topic/tokenizedSentences/$docfile") or die "$!";
		#open (IN, "windows/$topic/taggedEntities/$docfile") or die "$!";
		open (OUT, ">windows/$topic/$dN/tokenizedSentences/$docfile") or die "$!";
		open (IN, "windows/$topic/$dN/taggedEntities/$docfile") or die "$!";
		while (my $in = <IN>){
		      chomp $in;
		      #print "$in\n";
		      push @sentences, $in;
		}
		#print "@sentences\n";
		close IN;
		
		my $sentNum = 0;
		foreach my $sntnce (@sentences)
		{
			my %Words = ();	# assigns IDs to every word (including punctuations)
			my %Entities = (); # stores the entities in that sentence and their corresponding IDs
			#my %Extensions = (); # Stores the governID for the depIDs which got merged with the head
			#my %EntitiesperSent = (); # Stores the IDs for entities in every subsentence
			#my %WordsperSent = ();
			
		
	#		print "-- $sentence\n";
			$sentNum++;
			$sntnce =~ s/\s+/ /g;
			$sntnce =~ s/"//g;
			$sntnce =~ s/\[EN /\[EN_/g;
			
			print "SENTENCE: $sntnce\n";
						
			my $sent = $sntnce;
			$sent =~ s/\[EN_//g;
			$sent =~ s/\]//g;
			chomp $sent;
			if ($sent !~ /.$/)
			{
				$sent = $sent . " .";
			}
			#print "The sentence is $sent\n";
			
	# --------------------  Start the LINGUA Phase --------------------------------------
	
			print "SENT: $sent\n\n";
			
			my $l = length($sent);
			if ($sent =~ /XXXX/)
			{
				print OUT "\n$sent\n";
			}
			elsif ($l < 1100)
			{
				$sntnce =~ s/[\/]/ - /g;
				my $fakeresult = $pipeline->process($sntnce);
							 
				# Print results
				my $sentID = 0;
				my $sID = 0;
				my $sentCount = @{$fakeresult->toArray};
				my $subsentence;
				my $l = 0;
				
				print "THERE ARE $sentCount SUB-SENTENCES\n\n";
	
				$sentID = 0;
				for my $sentence (@{$fakeresult->toArray}) # assign ID to words here as one sentence can be split to multiple sentences again ..
				{
					
					my %FakeWords = ();	# assigns IDs to every word (including punctuations)
					my %FakeEntities = (); # stores the entities in that sentence and their corresponding IDs
					
					print "there are $sentCount sentences\n $sentence \n";
					
					#print "\n[Sentence ID: ", $sentence->getIDString, "]:\n";
					$subsentence = $sentence->getSentence;
					print "\n\nOriginal sentence:\n\t", $subsentence, "\n\n";
					
					my $fakeSentence = "";
					my $count = 0;
					my $c = 0;
					
					for my $token (@{$sentence->getTokens->toArray}) {
					     my @tokens = $token->getWord;
					     #my @POS = $token->getPOSTag;
					     #my @lemmas = $token->getLemma;
					
					     my $fw = $tokens[0];
					     if ($fw =~  /EN_/)
					     {
						$FakeWords{$c} = "[" . $fw . "]";
						$FakeEntities{$c} = $fw;
						$FakeEntities{$c} =~ s/EN_//;
						$c++;
					     }
					     elsif ($fw !~ /-LRB-/ && $fw !~ /-RRB-/)
					     {
						$FakeWords{$c} = $fw;
						$c++;
					     }		     
					     
					     #print "$count<>$tokens[0]<>$POS[0]<>$lemmas[0]<>\n";
					     $count++;
					}
					
					for my $fw (sort { $a <=> $b} keys %FakeWords)
					{
						if (defined $FakeWords{$fw} && exists $FakeWords{$fw} && $FakeWords{$fw} ne "")
						{
							$fakeSentence = $fakeSentence . " " . $FakeWords{$fw};
							print "$fw -- $FakeWords{$fw}\n";
						}
					}
					
					print "\n&&&&& FAKE: $fakeSentence\n\n";
					
					print OUT "# $fakeSentence\n";
					for my $fw (sort { $a <=> $b} keys %FakeWords)
					{
						if (defined $FakeWords{$fw} && exists $FakeWords{$fw} && $FakeWords{$fw} ne "")
						{
							print OUT "$fw\t$FakeWords{$fw}\n";
						}
					}
					print OUT "##\n";
				}
			}
			else
			{
				print "Sentence too long!\n\n";
			}
		}
		close (OUT);
	#}
	
	#print "$dcount\n";
}
sub fixEntities_2 # Second step to FixedEntities: Finds incomplete entities (modifiers tagged as an entity) and extend them with adding all following words until the head of the NP is added
{
	my $topic = $_[0];
	my $docfile = $_[1];
	my $dN = $_[2];
	$mergeType = 2;
	
	# Create a new NLP pipeline (don't silence messages, do make corefs bidirectional)
	$pipeline = new Lingua::StanfordCoreNLP::Pipeline(0, 1);
	
	my %hashterm = (); # Stores the frequency of each entity to calculate TF
	
	my %tokenPOS = ();
	my %tokenWord = ();
	my %tokenWordAndPOS = ();
	
	my %dependencies = ();
	my %governors = ();
	my %dependents = ();
	
	my @sentences = ();
	
	#my $rmdir = `rm -rf windows/$topic/taggedFixedEntities`;
	#my $rm = `rm -rf windows/$topic/allEntitiesBySent`;
	#my $rm = `rm -rf data/$topic`;
	
	#my $mkdir = `mkdir windows/$topic/taggedFixedEntities`;
	#my $mkdir = `mkdir windows/$topic/allEntitiesBySent`;
	#my $mkdir = `mkdir data/$topic`;
	
	my $mkdir = `mkdir windows/$topic/$dN/taggedFixedEntities`;
	my $mkdir = `mkdir windows/$topic/$dN/allEntitiesBySent`;
	my $mkdir = `mkdir data/$topic/$dN`;
	
#	opendir (THISDIR, "windows/$topic/taggedEntities") or die "$!";
#        my @docfiles = grep !/^\./, readdir THISDIR;
#        closedir THISDIR;
	
	#my $dcount = @docfiles;
	#print "$dcount\n";
		
	#foreach my $docfile (@docfiles)
	#{
		@sentences = ();
		print "$docfile\n";
		my $outFile = $docfile . "_allEntities";
		#open (TFIDF, ">data/$topic/TFIDF_all") or die "$!";
		#open (TF, "|sort -rn >data/$topic/TF_all") or die "$!";		
		#open (ENT, ">windows/$topic/allEntitiesBySent/$docfile") or die "$!";
		#open (ALLENT, ">windows/$topic/allEntitiesBySent/$outFile") or die "$!";
		#
		#open (OUT, ">windows/$topic/taggedFixedEntities/$docfile") or die "$!";
		#open (IN, "windows/$topic/taggedEntities/$docfile") or die "$!";
		
		open (TF, "|sort -rn >data/$topic/$dN/TF_all") or die "$!";		
		open (ENT, ">windows/$topic/$dN/allEntitiesBySent/$docfile") or die "$!";
		open (ALLENT, ">windows/$topic/$dN/allEntitiesBySent/$outFile") or die "$!";
		
		open (OUT, ">windows/$topic/$dN/taggedFixedEntities/$docfile") or die "$!";
		open (IN, "windows/$topic/$dN/taggedEntities/$docfile") or die "$!";
		while (my $in = <IN>){
		      chomp $in;
		      #print "$in\n";
		      push @sentences, $in;
		}
		#print "@sentences\n";
		close IN;
		
		#open (IN, "windows/$topic/tokenizedSentences/$docfile") or die "$!";
		open (IN, "windows/$topic/$dN/tokenizedSentences/$docfile") or die "$!";
		
		my $sentNum = 0;
	
		foreach my $sentence (@sentences)
		{
			#my %Words = ();	# assigns IDs to every word (including punctuations)
			#my %Entities = (); # stores the entities in that sentence and their corresponding IDs
			my %Extensions = (); # Stores the governID for the depIDs which got merged with the head
			my %EntitiesperSent = (); # Stores the IDs for entities in every subsentence
			my %WordsperSent = ();
		
	#		print "-- $sentence\n";
			$sentNum++;
			#$sentence =~ s/,/ ,/g;
			$sentence =~ s/\s+/ /g;
			$sentence =~ s/"//g;
			$sentence =~ s/\[EN /\[EN_/g;
			
			print "SENTENCE: $sentence\n";
						
			my $sent = $sentence;
			$sent =~ s/\[EN_//g;
			$sent =~ s/\]//g;
			chomp $sent;
			if ($sent !~ /.$/)
			{
				$sent = $sent . " .";
			}
			#print "The sentence is $sent\n";
			
	# --------------------  Start the LINGUA Phase --------------------------------------
	
			print "SENT: $sent\n\n";
			
			my $l = length($sent);
			
			if ($sent =~ /XXXX/)
			{
				print OUT "\n$sent\n";
			}
			elsif ($l < 1100)
			{
				my %FakeWords = ();	# assigns IDs to every word (including punctuations)
				my %FakeEntities = (); # stores the entities in that sentence and their corresponding IDs
				
				my $in = <IN>;
				my $cleanSentence = $in;
				$cleanSentence =~ s/# //g;
				$cleanSentence =~ s/\[EN_//g;
				$cleanSentence =~ s/\]//g;
				$cleanSentence =~ s/[\/]/\\/g;
				
				$in = <IN>;
				while ($in !~ /##/)
				{
					chomp $in;
					my ($index, $word) = split /\t/, $in;
					$FakeWords{$index} = $word;
					if ($word =~ /EN_/)
					{
						$word =~ s/\[EN_//g;
						$word =~ s/\]//g;
						$FakeEntities{$index} = $word;
					}
					$in = <IN>;
				}					 
				   
				my $result = $pipeline->process($cleanSentence);
				
				my $count = 0;
				
				for my $sntnc (@{$result->toArray})
				{
					#get tokens, POS and lemma
					%tokenPOS = ();
					%tokenWord = ();
					%tokenWordAndPOS = ();
					
					my $tokenizedSentence = $sntnc->getSentence;
					print "TokenizedSentence: $tokenizedSentence\n";
					
					if ($tokenizedSentence =~ /[a-zA-Z]/) # there are subsentences with punctuations only which should be skipped!
					{
						for my $token (@{$sntnc->getTokens->toArray}) {
						     my @tokens = $token->getWord;
						     my @POS = $token->getPOSTag;
						     my @lemmas = $token->getLemma;
						
						     my $addToken = 1;
						     if ($tokens[0] eq "'s"){
							     if ($POS[0] eq "POS"){
								     $addToken = 0;
							     }
						     }
						     if ($addToken == 1){
							     $tokenPOS{$count} = $POS[0];
							     $tokenWord{$count} = $tokens[0];
							     $tokenWordAndPOS{$count} = $tokens[0] . "_" . $POS[0];
						     }	     
						     
						     #print "$count<>$tokens[0]<>$POS[0]<>$lemmas[0]<>\n";
						     $count++;
						}
						
						# Any entity which is a verb or and adv has to be removed
						for my $fw (sort { $a <=> $b} keys %FakeWords)
						{
							# Note: multiword entities which are underlined and end in 'ed' can be mistagged as a VB by the POS tagger
							if (defined $FakeEntities{$fw} && exists $FakeEntities{$fw} && $FakeEntities{$fw} !~ /_/) # if the word is an entity
							{
								if ($FakeEntities{$fw} !~ /_/ && $tokenPOS{$fw} =~ /VB/ || $tokenPOS{$fw} =~ /RB/) # underlined words can end up with wrong POS tags
								{
									print "#### The Entity at $fw -- $FakeWords{$fw} is a $tokenPOS{$fw}. --> will be removed from the list of entities\n";
									delete ($FakeEntities{$fw});
									$FakeWords{$fw} =~ s/\[EN_//g;
									$FakeWords{$fw} =~ s/\]//g;
									print "$FakeWords{$fw} is now fixed!\n\n";
								}	
							}
							#if ($tokenPOS{$fw} =~ /PRP/ && (lc($tokenWord{$fw}) eq "i" || lc($tokenWord{$fw}) eq "we")) # Add 'we' and 'I' to the list of entities
							#{
							#	$FakeEntities{$fw} = $tokenWord{$fw};
							#	$FakeWords{$fw} = "[EN_" . $tokenWord{$fw} . "]";
							#}
						}

						#get dependencies
						for my $dep (@{$sntnc->getDependencies->toArray}) {
						     my @relations = $dep->getRelation;
						     my @governWord = $dep->getGovernor->getWord;
						     my @governIndex = $dep->getGovernorIndex;
						     my @depWord = $dep->getDependent->getWord;
						     my @depIndex = $dep->getDependentIndex;
						     print "$relations[0] ($governWord[0]-$governIndex[0], $depWord[0]-$depIndex[0])\n";
						     my $governId = $governIndex[0];
						     my $depID = $depIndex[0];
						     $dependencies{$governId}{$depID} = $relations[0];
						     $governors{$depID}{$relations[0]} = $governId;
						     
						     #if (($relations[0] =~ /amod/ || $relations[0] =~ /nn/) && defined $EntitiesperSent{$sentID}{$depID} && exists $EntitiesperSent{$sentID}{$depID}) # the tagged entity is participating in an amod or nn dependency
						     if (($relations[0] =~ /amod/ || $relations[0] =~ /nn/) && defined $FakeEntities{$depID} && exists $FakeEntities{$depID}) # the tagged entity is participating in an amod or nn dependency
						     {
							print "$FakeEntities{$depID} is participating in a $relations[0] dependency.\n The head is $tokenWord{$governId} - or - $FakeWords{$governId}\n";
							$Extensions{$depID} = $governId;
						     }
						}
					   
								######### STAGE 1: merge simple NPs (i.e. NPs in the form: JJ* NN+) ##########################
						##  Identify if there are any nouns that can be merged;
						##  merge them in a pairwise manner beginning from the head;
						##  iterate until there are no more merges.
						##############################################################################################
						#print "#################### STAGE 1 #########################\n";
						my $mergeMode = 1; #1 - Stage 1: merge contiguous "nn", "amod" and "poss" relations; 2 - Stage 2: merge contiguous prep_ and conj_and relations
						my $stopIteration = 0;
						my $iterationNumber = 0;
						until ($stopIteration == 1){
						 $iterationNumber++;
						 #print "##################### SENTENCE $sentID ;  ITERATION $iterationNumber ###################################\n";
						 my $mergeCount = 0;
						 foreach my $governID (keys %dependencies){ #for each governing word
						      if ($tokenPOS{$governID} =~ /NN/){ #if the governing word is a noun
							      foreach my $depID ( keys %{ $dependencies{$governID} } ) { #for each depending word
								      #print "\t$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
								      #check if the dependent word is immediately before the governing word (distance = 1)
								      my $distance = $governID - $depID;
								      my $contiguous = 0;
								      if ($distance == 1)
								      {
									      $contiguous = 1;
								      }
								      elsif ($distance > 1){
									      #check if there exist any in-between words
									      my $start = $depID + 1;
									      my $end = $governID;
									      my $inBetweenWordExists = 0;
									      for (my $a=$start; $a<$end; $a++){
											      #print "\t\t\t<$a><$tokenWord{$a}>\n";
										      if (exists($tokenWord{$a})){
											      $inBetweenWordExists = 1;
											      #print "\t\t\t\tEXISTS\n";
										      }
									      }
									      if ($inBetweenWordExists == 0){
										      $contiguous = 1;
									      }
								      }
								      #print "\t\t<CONTIGUOUS>$contiguous<>$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
								      if ($contiguous == 1){  #if the governing and dependent words are contiguous
									      #"checkType" subroutine checks if the type of dependency relation is correct and if they pass the MI and/or t-test
									      #list of arguments for checkType subroutine: (relation type; merge mode; POS of governing word; POS of depending word; governing word; depending word, dummy)
									      my $mergeStatus = checkType($dependencies{$governID}{$depID}, $mergeMode, $tokenPOS{$governID}, $tokenPOS{$depID}, $tokenWord{$governID}, $tokenWord{$depID}, "");
									      if ($mergeStatus == 1){
										#merge the governing and dependent words
										$tokenWord{$governID} = $tokenWord{$depID} . " " . $tokenWord{$governID};
										$tokenWordAndPOS{$governID} = $tokenWordAndPOS{$depID} . " " . $tokenWordAndPOS{$governID};
										if (defined $FakeEntities{$depID} && exists $FakeEntities{$depID}) # the tagged entity is a modifier
										{
											my $w1 = $FakeWords{$depID};
											my $w2 = $FakeWords{$governID};
											
											$w1 =~ s/\[EN_//g;
											$w1 =~ s/\]//g;
							 
											$w2 =~ s/\[EN_//g;
											$w2 =~ s/\]//g;
											#$WordsperSent{$sentID}{$governID} = $w1 . "_" . $w2;
											if ($dependencies{$governID}{$depID} =~ /poss/ && $FakeWords{$depID + 1} =~ /'s/) # my partner's help --> poss(partner-12, help-14)
											{
												$FakeWords{$governID} = "[EN_" . $w1 . "'s_" . $w2 . "]";
												print "\'s is added to $FakeWords{$governID}\n";
												$FakeEntities{$governID} = $w1 . "'s_" . $w2;
												print "Entity $FakeEntities{$governID} is updated\n\n";
											}
											else
											{
												$FakeWords{$governID} = "[EN_" . $w1 . "_" . $w2 . "]";
												$FakeEntities{$governID} = $w1 . "_" . $w2;
												print "Entity $FakeEntities{$governID} is updated\n\n";
											}
											print "OO $FakeWords{$depID} is deleted!\n";
											delete($FakeWords{$depID});
											print "the entity $FakeEntities{$depID} is a dependant. It got added to $FakeWords{$governID}\n";
											delete($FakeEntities{$depID});
										}
										elsif ($dependencies{$governID}{$depID} =~ /nn/ && defined $FakeEntities{$governID} && exists $FakeEntities{$governID}) # we merge the words which are in a nn relationship whether the head is an entity or the dependent
										{
											my $w1 = $FakeWords{$depID};
											my $w2 = $FakeWords{$governID};
											
											$w1 =~ s/\[EN_//g;
											$w1 =~ s/\]//g;
							 
											$w2 =~ s/\[EN_//g;
											$w2 =~ s/\]//g;
											#$WordsperSent{$sentID}{$governID} = $w1 . "_" . $w2;
											if ($dependencies{$governID}{$depID} =~ /poss/ && $FakeWords{$governID + 1} =~ /'s/) # my partner's help --> poss(partner-12, help-14)
											{
												$FakeWords{$governID} = "[EN_" . $w1 . "'s_" . $w2 . "]";
												print "'s is added to $FakeWords{$governID}{$depID}\n";
												$FakeEntities{$governID} = $w1 . "'s_" . $w2;
												print "Entity $FakeEntities{$governID} is updated\n\n";
											}
											else
											{
												$FakeWords{$governID} = "[EN_" . $w1 . "_" . $w2 . "]";
												$FakeEntities{$governID} = $w1 . "_" . $w2;
												print "Entity $FakeEntities{$governID} is updated\n\n";
											}
											print "OO $FakeWords{$depID} is deleted!\n";
											delete($FakeWords{$depID});
											print "the entity $FakeEntities{$governID} is an entity in a nn relation with $FakeWords{$depID}\n";											
											print "$FakeEntities{$governID} is now expanded!\n";
											delete($FakeWords{$depID});
										}
										delete($tokenWordAndPOS{$depID});
										delete($tokenWord{$depID});
										delete($dependencies{$governID}{$depID});
										delete($tokenPOS{$depID});
										$mergeCount++;
									      }
								      }
							      }
						      }
						      elsif ($tokenPOS{$governID} =~ /VB/) #if the governing word is a verb -- can't be an entity
						      {
							
						      }
						}
						if ($mergeCount == 0){
						      $stopIteration = 1;
						}
						}
						#### END OF STAGE 1 merge ####
						
						## Weight NPs output by stage 1
						my %weightedNPs = weightNPs(\%tokenWordAndPOS);
						##
						
						foreach my $NPid (keys %tokenWord){
							if ($tokenPOS{$NPid} =~ /NN/){
								print "<FINAL-NP>$tokenWord{$NPid}\n";
							}
						}
									
						if ($mergeType == 2){ #do Stage 2 merge
						#### STAGE 2: merge complex NPs (i.e. NPs with prepositions and conjunctions)
						############################################################################
							print "######################STAGE 2#########################\n";
							my $stopIteration = 0;
							my $iterationNumber = 0;
							my %numOfJointNPs = ();
							$mergeMode = 2;
							until ($stopIteration == 1){
							 $iterationNumber++;
							 my $mergeCount = 0;
							 my $article = "";
							 foreach my $governID (keys %dependencies){ #for each governing word
							      if ($tokenPOS{$governID} =~ /NN/){ #if the governing word is a noun
								      foreach my $depID ( keys %{ $dependencies{$governID} } ) { #for each depending word
									      #print "\t$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
							
							##
									      my $contiguous = 0;
									      my $rel = $dependencies{$governID}{$depID};
									      $rel =~ s/^\w+_(.+)$/$1/;
									      my $start = $governID + 1;
									      my $end = $depID;
									      my $numOfInBetweenWords = 0;
									      my $inBetweenWords = "";
									      for (my $a=$start; $a<$end; $a++){
										      if (exists($tokenWord{$a})){	
											      if ($tokenWord{$a} eq $rel){ #if the in-between word is the same as the name of the dep. relation, e.g. "and" in "conj_and"
												      #do not count
											      }elsif ($tokenPOS{$a} eq "DT"){
												      #do not count
											      }elsif ($tokenPOS{$a} eq ","){
												      #do not count
											      }else{
												      $numOfInBetweenWords++;
											      }
											      $inBetweenWords = $inBetweenWords . " " . $tokenWord{$a};
										      }
									      }
									      $inBetweenWords =~ s/\s+/ /g;
									      #print "\t\t\t\t<IN-BETWEEN-WORDS>$inBetweenWords<NUM>$numOfInBetweenWords<>\n";
							##
									      if ($numOfInBetweenWords == 0){
										      $contiguous = 1;
									      }
									      #print "\t\t<CONTIGUOUS>$contiguous<>$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
									      if ($contiguous == 1){  #if the governing and dependent words are separated by 1 word
										      #"checkType" subroutine checks if the type of dependency relation is correct and if they pass the MI and/or t-test
										      #list of arguments for checkType: (relation type; merge mode; POS of governing word; POS of depending word; governing word; depending word; article before the governing word /if any/)
										      my $mergeStatus = checkType_Limited($dependencies{$governID}{$depID}, $mergeMode, $tokenPOS{$governID}, $tokenPOS{$depID}, $tokenWord{$governID}, $tokenWord{$depID}, $inBetweenWords);
										      if ($mergeStatus == 1)
										      {
											      #merge the governing and dependent words
											      my $start = $governID + 1;
											      my $end = $depID + 1;
											      for (my $a=$start; $a<$end; $a++){
												      $tokenWord{$governID} = $tokenWord{$governID} . " "  . $tokenWord{$a};
												      print "STAGE2: $tokenWord{$a} is added to $tokenWord{$governID}\n";
												      #if (defined $Entities{$a} && exists $Entities{$a}) # the tagged entity is a modifier
												      if (defined $FakeEntities{$a} && exists $FakeEntities{$a}) # the tagged entity is a modifier
												      {
													if ($a - $governID == 1) # words are contiguous
													{
														my $w1 = $FakeWords{$governID};
														my $w2 = $FakeWords{$a};
														
														$w1 =~ s/\[EN_//g;
														$w1 =~ s/\]//g;
										 
														$w2 =~ s/\[EN_//g;
														$w2 =~ s/\]//g;
														
														$FakeWords{$governID} = "[EN_" . $w1 . "_" . $w2 . "]";
														$FakeEntities{$governID} = $w1 . "_" . $w2;
														print "OO $FakeWords{$depID} is deleted!\n";
														delete($FakeWords{$a});
														print "the entity $FakeEntities{$a} is a dependant. It got added to $FakeWords{$governID}\n";
														delete($FakeEntities{$a});
													}
													else # e.g., leap of [EN_faith] --> "leap of" is already merged. So we need to use w2 = $tokenWord{$governID}
													{
														# $tokenWord{$governID} already has "leap of faith"
														my $w = $tokenWord{$governID};
														
														$w =~ s/\[EN_//g;
														$w =~ s/\]//g;
														$w =~ s/ /_/g;
														
														$FakeWords{$governID} = "[EN_" . $w . "]";
														$FakeEntities{$governID} = $w;
														print "OO $FakeWords{$depID} is deleted!\n";
														delete($FakeWords{$a});
														print "the entity $FakeEntities{$a} is a dependant. It got added to $FakeWords{$governID}\n";
														delete($FakeEntities{$a});
													}
												      }
												      delete($tokenWord{$a});
												      delete($tokenPOS{$a});
											      }
											      delete($dependencies{$governID}{$depID});
											      
							
											      #my $rel = $dependencies{$governID}{$depID};
											      #$rel =~ s/^\w+_(.+)$/$1/;
											      #$tokenWord{$governID} = $tokenWord{$governID} . " " . $rel . " " . $article . " "  . $tokenWord{$depID};
											      #$tokenWord{$governID} =~ s/\s+/ /g;
											      #delete($tokenWord{$depID});
											      #delete($dependencies{$governID}{$depID});
											      #delete($tokenPOS{$depID});
							
											      $weightedNPs{$governID} = $weightedNPs{$governID} + $weightedNPs{$depID};
											      $numOfJointNPs{$governID} = $numOfJointNPs{$governID} + 1;
											      $mergeCount++;
										      }
									      }
								      }
							      }
							}
							if ($mergeCount == 0)
							{
							      $stopIteration = 1;
							}
						} #stop iteration
						
						
						foreach my $NPid (keys %tokenWord){
						      if ($tokenPOS{$NPid} =~ /NN/){
							      print "<FINAL-NP>$tokenWord{$NPid}\n";
							      ## calculate weight of the NPs output by Stage 2
							      my $NPweight = 0;
							      $numOfJointNPs{$NPid} = $numOfJointNPs{$NPid} + 1;
							      if ($numOfJointNPs{$NPid} > 1){
								      $NPweight = $weightedNPs{$NPid} / $numOfJointNPs{$NPid};
							      }else{
								      if (exists($weightedNPs{$NPid})){
									      $NPweight = $weightedNPs{$NPid};
								      }
							      }
							      if ($NPweight > 0){
								      my $lowerCaseNP = lc($tokenWord{$NPid});
								      $lowerCaseNP =~ s/\s+/ /g;
								      $lowerCaseNP =~ s/\s,\s/, /g;
								      print OUT "$NPweight\t$lowerCaseNP\n";
								      print "<FINAL-NP>$tokenWord{$NPid}<WEIGHT>$NPweight<>\n";
							      }
						      }
						}
						} #end of stage 2
						#### END OF STAGE 2 merge ####
						
						my $newsentence = "";
						my $entities_per_sentence = "";
						
						#foreach my $wid (sort { $a <=> $b} keys %Words)
						foreach my $wid (sort { $a <=> $b} keys %FakeWords)
						{
							print "-- $FakeWords{$wid}\n";
							if (defined $FakeEntities{$wid} && exists $FakeEntities{$wid})	# if the word is an entity,
							{
								my $entity = $FakeEntities{$wid};
								print "--- $entity\n";
								if ($entity =~ /(\#|,|;|\\|\/|\||\?|!|:|\$|\@|\*|\(|\)|\"|\+|\`)/) # make sure punctuations or "to" are not added to the end (with an '_')
								{
									print "$entity needs to be cleaned!\n";
									my @elements = split (/_/, $entity);
									my $punc = $elements[@elements - 1];
									print "the attached punctuation is $punc";
									$entity =~ s/(\#|,|;|\\|\/|\||\?|!|:|\$|\@|\*|\(|\)|\"|\+|\`|to)$//g;
									$entity =~ s/_$//g;
									$FakeWords{$wid} = "[EN " . $entity . "] " . $punc;
									$entity = $entity . " " . $punc;
									$FakeEntities{$wid} = $entity;
									print "After cleaning: $entity - $FakeWords{$wid}\n\n";
								}
								elsif ($entity !~ /_/) # if the entity is not underlined, check for the POS to make sure the entity is a noun
								{
									if ($tokenPOS{$wid} =~ /JJ/ || $tokenPOS{$wid} =~ /RB/ || $tokenPOS{$wid} =~ /VB/) # remove the entity
									{
										print "$FakeEntities{$wid} has the POS $tokenPOS{$wid} so needs to be removed!\n";
										delete ($FakeEntities{$wid});
										$FakeWords{$wid} =~ s/\[EN_//g;
										$FakeWords{$wid} =~ s/\]//g;
										print "$FakeWords{$wid} is not an entity anymore!\n\n";
									}
								}
							}
							elsif (defined $FakeEntities{$Extensions{$wid}} && exists $FakeEntities{$Extensions{$wid}})
							{
								my $entity = $FakeEntities{$Extensions{$wid}};
								print "---- $entity\n";
								if ($entity =~ /(\#|,|;|\\|\/|\||\?|!|:|\$|\@|\*|\(|\)|\"|\+|\`)/) # make sure punctuations or "to" are not added to the end (with an '_')
								{
									print "$entity needs to be cleaned!\n";
									my @elements = split (/_/, $entity);
									my $punc = $elements[@elements - 1];
									print "the attached punctuation is $punc";
									$entity =~ s/(\#|,|;|\\|\/|\||\?|!|:|\$|\@|\*|\(|\)|\"|\+|\`|to)$//g;
									$entity =~ s/_$//g;
									$FakeWords{$wid} = "[EN " . $entity . "] " . $punc;
									$entity = $entity . " " . $punc;
									$FakeEntities{$wid} = $entity;
									print "After cleaning: $entity - $FakeWords{$wid}\n\n";
								}
							}
							if (defined $FakeWords{$wid} && exists $FakeWords{$wid})
							{
								$newsentence = $newsentence . " " . $FakeWords{$wid};
							}
							if (defined $FakeEntities{$wid} && exists $FakeEntities{$wid})	# if the word is an entity
							{
								my $entity;
								print "$FakeEntities{$wid} is an entity!\n";
								if (defined $FakeWords{$wid} && exists $FakeWords{$wid})
								{
									$entity = $FakeWords{$wid};
								}
								elsif (defined $FakeWords{$Extensions{$wid}} && exists $FakeWords{$Extensions{$wid}})
								{
									$entity = $FakeWords{$Extensions{$wid}};
								}
								$entity =~ s/\[EN_//g;
								$entity =~ s/\]//g;
								$entity =~ s/ //g;					
								
								if (length($entity) > 0)
								{
									print "ENT - $entity\n";
									$entities_per_sentence = $entities_per_sentence . "\t" . $entity;
				
									if ($hashterm{lc($entity)}{freq} < 1) # the term is not already in the hash
									{
										$hashterm{lc($entity)}{freq} = 1;
										print "**** seeing the entity $entity for the first time !!!\n";
									}
									elsif ($hashterm{lc($entity)}{freq} >= 1) # update the TF for the term
									{
										$hashterm{lc($entity)}{freq}++;
										print "**** seeing the entity $entity for $hashterm{$entity}{freq} times !!!\n";
									}
									else
									{
										#print "\n**** HOW IS THAT POSSIBLE??? -- $entity **** \n";
									}
								}
							}
						}
						#print "Original: $sentence\n";
						print "Before: $tokenizedSentence\n";
						print "After: $newsentence\n\n";
						$newsentence =~ s/EN_/EN /g;
						print OUT "$newsentence\n";
						
						$entities_per_sentence =~ s/^\t//;
						my @elements = split /\t/, $entities_per_sentence;
						if (@elements > 1)
						{
							print ENT "$sentNum\t$entities_per_sentence\n";
						}
						print ALLENT "$sentNum\t$entities_per_sentence\n";
						$sentNum++;
					}
				}
			}
			else
			{
				print "Sentence is too long!!\n\n";
			}
			
		}
	#}
	
	foreach my $k (keys(%hashterm))
	{
	      print "$hashterm{$k}{freq}\t$k\n";
	      print TF "$hashterm{$k}{freq}\t$k\n";
	}
	
	close ENT;
	close OUT;
	close TF;	
}
sub fixEntities # Finds incomplete entities (modifiers tagged as an entity) and extend them with adding all following words until the head of the NP is added
{
	my $topic = $_[0];
	$mergeType = 2;
	
	# Create a new NLP pipeline (don't silence messages, do make corefs bidirectional)
	$pipeline = new Lingua::StanfordCoreNLP::Pipeline(0, 1);
	
	my %hashterm = (); # Stores the frequency of each entity to calculate TF
	
	my %tokenPOS = ();
	my %tokenWord = ();
	my %tokenWordAndPOS = ();
	
	my %dependencies = ();
	my %governors = ();
	my %dependents = ();
	
	my @sentences = ();
	
	my $rmdir = `rm -rf windows/$topic/taggedFixedEntities`;
	my $rm = `rm -rf windows/$topic/allEntitiesBySent`;
	my $rm = `rm -rf data/$topic`;
	
	my $mkdir = `mkdir windows/$topic/taggedFixedEntities`;
	my $mkdir = `mkdir windows/$topic/allEntitiesBySent`;
	my $mkdir = `mkdir data/$topic`;
	
	opendir (THISDIR, "windows/$topic/taggedEntities") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
	
	my $dcount = @docfiles;
	print "$dcount\n";
		
	foreach my $docfile (@docfiles)
	{
		print "$docfile\n";
	
		#open (TFIDF, ">data/$topic/TFIDF_all") or die "$!";
		open (TF, "|sort -rn >data/$topic/TF_all") or die "$!";		
		open (ENT, ">windows/$topic/allEntitiesBySent/$docfile") or die "$!";
		
		open (OUT, ">windows/$topic/taggedFixedEntities/$docfile") or die "$!";
		open (IN, "windows/$topic/taggedEntities/$docfile") or die "$!";
		
		while (my $in = <IN>){
		      chomp $in;
		      #print "$in\n";
		      push @sentences, $in;
		}
		#print "@sentences\n";
		close IN;
	}

	my $sentNum = 0;
	
	foreach my $sentence (@sentences)
	{
		my %Words = ();	# assigns IDs to every word (including punctuations)
		my %Entities = (); # stores the entities in that sentence and their corresponding IDs
		my %Extensions = (); # Stores the governID for the depIDs which got merged with the head
		my %EntitiesperSent = (); # Stores the IDs for entities in every subsentence
		my %WordsperSent = ();
		
		#my %FakeWords = ();	# assigns IDs to every word (including punctuations)
		#my %FakeEntities = (); # stores the entities in that sentence and their corresponding IDs
	
#		print "-- $sentence\n";
		$sentNum++;
		#$sentence =~ s/,/ ,/g;
		$sentence =~ s/\s+/ /g;
		$sentence =~ s/"//g;
		$sentence =~ s/\[EN /\[EN_/g;
		
		print "SENTENCE: $sentence\n";
				        
		my $sent = $sentence;
		$sent =~ s/\[EN_//g;
		$sent =~ s/\]//g;
		chomp $sent;
		if ($sent !~ /.$/)
		{
			$sent = $sent . " .";
		}
		#print "The sentence is $sent\n";
		
# --------------------  Start the LINGUA Phase --------------------------------------

		print "SENT: $sent\n\n";
		
		if ($sent =~ /XXXX/)
		{
			print OUT "\n$sent\n";
		}
		else
		{
			#my $raw_result = $pipeline->process($sentence);
			#my $result = $pipeline->process($sent);
			$sentence =~ s/[\/]/ - /g;
			my $fakeresult = $pipeline->process($sentence);
			
	
			 
			# Print results
			my $sentID = 0;
			my $sID = 0;
			my $sentCount = @{$fakeresult->toArray};
			my $subsentence;
			my $l = 0;
			
			print "THERE ARE $sentCount SUB-SENTENCES\n\n";

			$sentID = 0;
			for my $sentence (@{$fakeresult->toArray}) # assign ID to words here as one sentence can be split to multiple sentences again ..
			{
				
				my %FakeWords = ();	# assigns IDs to every word (including punctuations)
				my %FakeEntities = (); # stores the entities in that sentence and their corresponding IDs
				
				print "there are $sentCount sentences\n $sentence \n";
				
				#print "\n[Sentence ID: ", $sentence->getIDString, "]:\n";
				$subsentence = $sentence->getSentence;
				print "\n\nOriginal sentence:\n\t", $subsentence, "\n\n";
			
				
				##get tokens, POS and lemma
				#%tokenPOS = ();
				#%tokenWord = ();
				#%tokenWordAndPOS = ();
				
				my $fakeSentence = "";
				my $count = 0;
				my $c = 0;
				
				for my $token (@{$sentence->getTokens->toArray}) {
				     my @tokens = $token->getWord;
				     my @POS = $token->getPOSTag;
				     my @lemmas = $token->getLemma;
				
				#     my $addToken = 1;
				#     if ($tokens[0] eq "'s"){
				#	     if ($POS[0] eq "POS"){
				#		     $addToken = 0;
				#	     }
				#     }
				#     if ($addToken == 1){
				#	     $tokenPOS{$count} = $POS[0];
				#	     $tokenWord{$count} = $tokens[0];
				#	     $tokenWordAndPOS{$count} = $tokens[0] . "_" . $POS[0];
				#     }
				     my $fw = $tokens[0];
				     if ($fw =~  /EN_/)
				     {
					$FakeWords{$c} = "[" . $fw . "]";
					$FakeEntities{$c} = $fw;
					$FakeEntities{$c} =~ s/EN_//;
					$c++;
				     }
				     elsif ($fw !~ /-LRB-/ && $fw !~ /-RRB-/)
				     {
					$FakeWords{$c} = $fw;
					$c++;
				     }		     
				     
				     #print "$count<>$tokens[0]<>$POS[0]<>$lemmas[0]<>\n";
				     $count++;
				}
				
				for my $fw (sort { $a <=> $b} keys %FakeWords)
				{
					if (defined $FakeWords{$fw} && exists $FakeWords{$fw} && $FakeWords{$fw} ne "")
					{
						$fakeSentence = $fakeSentence . " " . $FakeWords{$fw};
						print "$fw -- $FakeWords{$fw} -- $tokenPOS{$fw}\n";
					}
				}
				
				print "\n&&&&& FAKE: $fakeSentence\n\n";
				my $cleanSentence = $fakeSentence;
				$cleanSentence =~ s/\[EN_//g;
				$cleanSentence =~ s/\]//g;
				$cleanSentence =~ s/[\/]/\\/g;
			   
			   
				my $result = $pipeline->process($cleanSentence);
				
				$count = 0;
				
				my $subSentCount = @{$result->toArray};
				print "-- there are $subSentCount subsentences\n";
				for my $sntnc (@{$result->toArray})
				{
					#get tokens, POS and lemma
					%tokenPOS = ();
					%tokenWord = ();
					%tokenWordAndPOS = ();
					
					my $tokenizedSentence = $sntnc->getSentence;
					print "TokenizedSentence: $tokenizedSentence\n";
					
					if ($tokenizedSentence =~ /[a-zA-Z]/) # there are subsentences with punctuations only which should be skipped!
					{
						for my $token (@{$sntnc->getTokens->toArray}) {
						     my @tokens = $token->getWord;
						     my @POS = $token->getPOSTag;
						     my @lemmas = $token->getLemma;
						
						     my $addToken = 1;
						     if ($tokens[0] eq "'s"){
							     if ($POS[0] eq "POS"){
								     $addToken = 0;
							     }
						     }
						     if ($addToken == 1){
							     $tokenPOS{$count} = $POS[0];
							     $tokenWord{$count} = $tokens[0];
							     $tokenWordAndPOS{$count} = $tokens[0] . "_" . $POS[0];
						     }	     
						     
						     #print "$count<>$tokens[0]<>$POS[0]<>$lemmas[0]<>\n";
						     $count++;
						}
						
						# Any entity which is a verb or and adv has to be removed
						for my $fw (sort { $a <=> $b} keys %FakeWords)
						{
							# Note: multiword entities which are underlined and end in 'ed' can be mistagged as a VB by the POS tagger
							if (defined $FakeEntities{$fw} && exists $FakeEntities{$fw} && $FakeEntities{$fw} !~ /_/) # if the word is an entity
							{
								if ($FakeEntities{$fw} !~ /_/ && $tokenPOS{$fw} =~ /VB/ || $tokenPOS{$fw} =~ /RB/) # underlined words can end up with wrong POS tags
								{
									print "#### The Entity at $fw -- $FakeWords{$fw} is a $tokenPOS{$fw}. --> will be removed from the list of entities\n";
									delete ($FakeEntities{$fw});
									$FakeWords{$fw} =~ s/\[EN_//g;
									$FakeWords{$fw} =~ s/\]//g;
									print "$FakeWords{$fw} is now fixed!\n\n";
								}	
							}
							#if ($tokenPOS{$fw} =~ /PRP/ && (lc($tokenWord{$fw}) eq "i" || lc($tokenWord{$fw}) eq "we")) # Add 'we' and 'I' to the list of entities
							#{
							#	$FakeEntities{$fw} = $tokenWord{$fw};
							#	$FakeWords{$fw} = "[EN_" . $tokenWord{$fw} . "]";
							#}
						}
						#print "TokenWords are:\n\n";
						#for my $tw (sort { $a <=> $b} keys %tokenWord)
						#{
						#	print "--- $tw - $tokenWord{$tw}\n";
						#}
						#get dependencies
						for my $dep (@{$sntnc->getDependencies->toArray}) {
						     my @relations = $dep->getRelation;
						     my @governWord = $dep->getGovernor->getWord;
						     my @governIndex = $dep->getGovernorIndex;
						     my @depWord = $dep->getDependent->getWord;
						     my @depIndex = $dep->getDependentIndex;
						     print "$relations[0] ($governWord[0]-$governIndex[0], $depWord[0]-$depIndex[0])\n";
						     my $governId = $governIndex[0];
						     my $depID = $depIndex[0];
						     $dependencies{$governId}{$depID} = $relations[0];
						     $governors{$depID}{$relations[0]} = $governId;
						     
						     #if (($relations[0] =~ /amod/ || $relations[0] =~ /nn/) && defined $EntitiesperSent{$sentID}{$depID} && exists $EntitiesperSent{$sentID}{$depID}) # the tagged entity is participating in an amod or nn dependency
						     if (($relations[0] =~ /amod/ || $relations[0] =~ /nn/) && defined $FakeEntities{$depID} && exists $FakeEntities{$depID}) # the tagged entity is participating in an amod or nn dependency
						     {
							print "$FakeEntities{$depID} is participating in a $relations[0] dependency.\n The head is $tokenWord{$governId} - or - $FakeWords{$governId}\n";
							$Extensions{$depID} = $governId;
						     }
						}
					   
								######### STAGE 1: merge simple NPs (i.e. NPs in the form: JJ* NN+) ##########################
						##  Identify if there are any nouns that can be merged;
						##  merge them in a pairwise manner beginning from the head;
						##  iterate until there are no more merges.
						##############################################################################################
						#print "#################### STAGE 1 #########################\n";
						my $mergeMode = 1; #1 - Stage 1: merge contiguous "nn", "amod" and "poss" relations; 2 - Stage 2: merge contiguous prep_ and conj_and relations
						my $stopIteration = 0;
						my $iterationNumber = 0;
						until ($stopIteration == 1){
						 $iterationNumber++;
						 #print "##################### SENTENCE $sentID ;  ITERATION $iterationNumber ###################################\n";
						 my $mergeCount = 0;
						 foreach my $governID (keys %dependencies){ #for each governing word
						      if ($tokenPOS{$governID} =~ /NN/){ #if the governing word is a noun
							      foreach my $depID ( keys %{ $dependencies{$governID} } ) { #for each depending word
								      #print "\t$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
								      #check if the dependent word is immediately before the governing word (distance = 1)
								      my $distance = $governID - $depID;
								      my $contiguous = 0;
								      if ($distance == 1)
								      {
									      $contiguous = 1;
								      }
								      elsif ($distance > 1){
									      #check if there exist any in-between words
									      my $start = $depID + 1;
									      my $end = $governID;
									      my $inBetweenWordExists = 0;
									      for (my $a=$start; $a<$end; $a++){
											      #print "\t\t\t<$a><$tokenWord{$a}>\n";
										      if (exists($tokenWord{$a})){
											      $inBetweenWordExists = 1;
											      #print "\t\t\t\tEXISTS\n";
										      }
									      }
									      if ($inBetweenWordExists == 0){
										      $contiguous = 1;
									      }
								      }
								      #print "\t\t<CONTIGUOUS>$contiguous<>$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
								      if ($contiguous == 1){  #if the governing and dependent words are contiguous
									      #"checkType" subroutine checks if the type of dependency relation is correct and if they pass the MI and/or t-test
									      #list of arguments for checkType subroutine: (relation type; merge mode; POS of governing word; POS of depending word; governing word; depending word, dummy)
									      my $mergeStatus = checkType($dependencies{$governID}{$depID}, $mergeMode, $tokenPOS{$governID}, $tokenPOS{$depID}, $tokenWord{$governID}, $tokenWord{$depID}, "");
									      if ($mergeStatus == 1){
										#merge the governing and dependent words
										$tokenWord{$governID} = $tokenWord{$depID} . " " . $tokenWord{$governID};
										$tokenWordAndPOS{$governID} = $tokenWordAndPOS{$depID} . " " . $tokenWordAndPOS{$governID};
										if (defined $FakeEntities{$depID} && exists $FakeEntities{$depID}) # the tagged entity is a modifier
										{
											my $w1 = $FakeWords{$depID};
											my $w2 = $FakeWords{$governID};
											
											$w1 =~ s/\[EN_//g;
											$w1 =~ s/\]//g;
							 
											$w2 =~ s/\[EN_//g;
											$w2 =~ s/\]//g;
											#$WordsperSent{$sentID}{$governID} = $w1 . "_" . $w2;
											if ($dependencies{$governID}{$depID} =~ /poss/ && $FakeWords{$depID + 1} =~ /'s/) # my partner's help --> poss(partner-12, help-14)
											{
												$FakeWords{$governID} = "[EN_" . $w1 . "'s_" . $w2 . "]";
												print "\'s is added to $FakeWords{$governID}\n";
												$FakeEntities{$governID} = $w1 . "'s_" . $w2;
												print "Entity $FakeEntities{$governID} is updated\n\n";
											}
											else
											{
												$FakeWords{$governID} = "[EN_" . $w1 . "_" . $w2 . "]";
												$FakeEntities{$governID} = $w1 . "_" . $w2;
												print "Entity $FakeEntities{$governID} is updated\n\n";
											}
											print "OO $FakeWords{$depID} is deleted!\n";
											delete($FakeWords{$depID});
											print "the entity $FakeEntities{$depID} is a dependant. It got added to $FakeWords{$governID}\n";
											delete($FakeEntities{$depID});
										}
										elsif ($dependencies{$governID}{$depID} =~ /nn/ && defined $FakeEntities{$governID} && exists $FakeEntities{$governID}) # we merge the words which are in a nn relationship whether the head is an entity or the dependent
										{
											my $w1 = $FakeWords{$depID};
											my $w2 = $FakeWords{$governID};
											
											$w1 =~ s/\[EN_//g;
											$w1 =~ s/\]//g;
							 
											$w2 =~ s/\[EN_//g;
											$w2 =~ s/\]//g;
											#$WordsperSent{$sentID}{$governID} = $w1 . "_" . $w2;
											if ($dependencies{$governID}{$depID} =~ /poss/ && $FakeWords{$governID + 1} =~ /'s/) # my partner's help --> poss(partner-12, help-14)
											{
												$FakeWords{$governID} = "[EN_" . $w1 . "'s_" . $w2 . "]";
												print "'s is added to $FakeWords{$governID}{$depID}\n";
												$FakeEntities{$governID} = $w1 . "'s_" . $w2;
												print "Entity $FakeEntities{$governID} is updated\n\n";
											}
											else
											{
												$FakeWords{$governID} = "[EN_" . $w1 . "_" . $w2 . "]";
												$FakeEntities{$governID} = $w1 . "_" . $w2;
												print "Entity $FakeEntities{$governID} is updated\n\n";
											}
											print "OO $FakeWords{$depID} is deleted!\n";
											delete($FakeWords{$depID});
											print "the entity $FakeEntities{$governID} is an entity in a nn relation with $FakeWords{$depID}\n";											
											print "$FakeEntities{$governID} is now expanded!\n";
											delete($FakeWords{$depID});
										}
										delete($tokenWordAndPOS{$depID});
										delete($tokenWord{$depID});
										delete($dependencies{$governID}{$depID});
										delete($tokenPOS{$depID});
										$mergeCount++;
									      }
								      }
							      }
						      }
						      elsif ($tokenPOS{$governID} =~ /VB/) #if the governing word is a verb -- can't be an entity
						      {
							
						      }
						}
						if ($mergeCount == 0){
						      $stopIteration = 1;
						}
						}
						#### END OF STAGE 1 merge ####
						
						## Weight NPs output by stage 1
						my %weightedNPs = weightNPs(\%tokenWordAndPOS);
						##
						
						foreach my $NPid (keys %tokenWord){
							if ($tokenPOS{$NPid} =~ /NN/){
								print "<FINAL-NP>$tokenWord{$NPid}\n";
							}
						}
									
						if ($mergeType == 2){ #do Stage 2 merge
						#### STAGE 2: merge complex NPs (i.e. NPs with prepositions and conjunctions)
						############################################################################
							print "######################STAGE 2#########################\n";
							my $stopIteration = 0;
							my $iterationNumber = 0;
							my %numOfJointNPs = ();
							$mergeMode = 2;
							until ($stopIteration == 1){
							 $iterationNumber++;
							 my $mergeCount = 0;
							 my $article = "";
							 foreach my $governID (keys %dependencies){ #for each governing word
							      if ($tokenPOS{$governID} =~ /NN/){ #if the governing word is a noun
								      foreach my $depID ( keys %{ $dependencies{$governID} } ) { #for each depending word
									      #print "\t$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
							
							##
									      my $contiguous = 0;
									      my $rel = $dependencies{$governID}{$depID};
									      $rel =~ s/^\w+_(.+)$/$1/;
									      my $start = $governID + 1;
									      my $end = $depID;
									      my $numOfInBetweenWords = 0;
									      my $inBetweenWords = "";
									      for (my $a=$start; $a<$end; $a++){
										      if (exists($tokenWord{$a})){	
											      if ($tokenWord{$a} eq $rel){ #if the in-between word is the same as the name of the dep. relation, e.g. "and" in "conj_and"
												      #do not count
											      }elsif ($tokenPOS{$a} eq "DT"){
												      #do not count
											      }elsif ($tokenPOS{$a} eq ","){
												      #do not count
											      }else{
												      $numOfInBetweenWords++;
											      }
											      $inBetweenWords = $inBetweenWords . " " . $tokenWord{$a};
										      }
									      }
									      $inBetweenWords =~ s/\s+/ /g;
									      #print "\t\t\t\t<IN-BETWEEN-WORDS>$inBetweenWords<NUM>$numOfInBetweenWords<>\n";
							##
									      if ($numOfInBetweenWords == 0){
										      $contiguous = 1;
									      }
									      #print "\t\t<CONTIGUOUS>$contiguous<>$depID<>$tokenWord{$depID}<>$governID<>$tokenWord{$governID}<>\n";
									      if ($contiguous == 1){  #if the governing and dependent words are separated by 1 word
										      #"checkType" subroutine checks if the type of dependency relation is correct and if they pass the MI and/or t-test
										      #list of arguments for checkType: (relation type; merge mode; POS of governing word; POS of depending word; governing word; depending word; article before the governing word /if any/)
										      my $mergeStatus = checkType_Limited($dependencies{$governID}{$depID}, $mergeMode, $tokenPOS{$governID}, $tokenPOS{$depID}, $tokenWord{$governID}, $tokenWord{$depID}, $inBetweenWords);
										      if ($mergeStatus == 1)
										      {
											      #merge the governing and dependent words
											      my $start = $governID + 1;
											      my $end = $depID + 1;
											      for (my $a=$start; $a<$end; $a++){
												      $tokenWord{$governID} = $tokenWord{$governID} . " "  . $tokenWord{$a};
												      print "STAGE2: $tokenWord{$a} is added to $tokenWord{$governID}\n";
												      #if (defined $Entities{$a} && exists $Entities{$a}) # the tagged entity is a modifier
												      if (defined $FakeEntities{$a} && exists $FakeEntities{$a}) # the tagged entity is a modifier
												      {
													if ($a - $governID == 1) # words are contiguous
													{
														my $w1 = $FakeWords{$governID};
														my $w2 = $FakeWords{$a};
														
														$w1 =~ s/\[EN_//g;
														$w1 =~ s/\]//g;
										 
														$w2 =~ s/\[EN_//g;
														$w2 =~ s/\]//g;
														
														$FakeWords{$governID} = "[EN_" . $w1 . "_" . $w2 . "]";
														$FakeEntities{$governID} = $w1 . "_" . $w2;
														print "OO $FakeWords{$depID} is deleted!\n";
														delete($FakeWords{$a});
														print "the entity $FakeEntities{$a} is a dependant. It got added to $FakeWords{$governID}\n";
														delete($FakeEntities{$a});
													}
													else # e.g., leap of [EN_faith] --> "leap of" is already merged. So we need to use w2 = $tokenWord{$governID}
													{
														# $tokenWord{$governID} already has "leap of faith"
														my $w = $tokenWord{$governID};
														
														$w =~ s/\[EN_//g;
														$w =~ s/\]//g;
														$w =~ s/ /_/g;
														
														$FakeWords{$governID} = "[EN_" . $w . "]";
														$FakeEntities{$governID} = $w;
														print "OO $FakeWords{$depID} is deleted!\n";
														delete($FakeWords{$a});
														print "the entity $FakeEntities{$a} is a dependant. It got added to $FakeWords{$governID}\n";
														delete($FakeEntities{$a});
													}
												      }
												      delete($tokenWord{$a});
												      delete($tokenPOS{$a});
											      }
											      delete($dependencies{$governID}{$depID});
											      
							
											      #my $rel = $dependencies{$governID}{$depID};
											      #$rel =~ s/^\w+_(.+)$/$1/;
											      #$tokenWord{$governID} = $tokenWord{$governID} . " " . $rel . " " . $article . " "  . $tokenWord{$depID};
											      #$tokenWord{$governID} =~ s/\s+/ /g;
											      #delete($tokenWord{$depID});
											      #delete($dependencies{$governID}{$depID});
											      #delete($tokenPOS{$depID});
							
											      $weightedNPs{$governID} = $weightedNPs{$governID} + $weightedNPs{$depID};
											      $numOfJointNPs{$governID} = $numOfJointNPs{$governID} + 1;
											      $mergeCount++;
										      }
									      }
								      }
							      }
							}
							if ($mergeCount == 0)
							{
							      $stopIteration = 1;
							}
						} #stop iteration
						
						
						foreach my $NPid (keys %tokenWord){
						      if ($tokenPOS{$NPid} =~ /NN/){
							      print "<FINAL-NP>$tokenWord{$NPid}\n";
							      ## calculate weight of the NPs output by Stage 2
							      my $NPweight = 0;
							      $numOfJointNPs{$NPid} = $numOfJointNPs{$NPid} + 1;
							      if ($numOfJointNPs{$NPid} > 1){
								      $NPweight = $weightedNPs{$NPid} / $numOfJointNPs{$NPid};
							      }else{
								      if (exists($weightedNPs{$NPid})){
									      $NPweight = $weightedNPs{$NPid};
								      }
							      }
							      if ($NPweight > 0){
								      my $lowerCaseNP = lc($tokenWord{$NPid});
								      $lowerCaseNP =~ s/\s+/ /g;
								      $lowerCaseNP =~ s/\s,\s/, /g;
								      print OUT "$NPweight\t$lowerCaseNP\n";
								      print "<FINAL-NP>$tokenWord{$NPid}<WEIGHT>$NPweight<>\n";
							      }
						      }
						}
						} #end of stage 2
						#### END OF STAGE 2 merge ####
						
						my $newsentence = "";
						my $entities_per_sentence = "";
						
						#foreach my $wid (sort { $a <=> $b} keys %Words)
						foreach my $wid (sort { $a <=> $b} keys %FakeWords)
						{
							print "-- $FakeWords{$wid}\n";
							if (defined $FakeEntities{$wid} && exists $FakeEntities{$wid})	# if the word is an entity,
							{
								my $entity = $FakeEntities{$wid};
								print "--- $entity\n";
								if ($entity =~ /(\#|,|;|\\|\/|\||\?|!|:|\$|\@|\*|\(|\)|\"|\+|\`)/) # make sure punctuations or "to" are not added to the end (with an '_')
								{
									print "$entity needs to be cleaned!\n";
									my @elements = split (/_/, $entity);
									my $punc = $elements[@elements - 1];
									print "the attached punctuation is $punc";
									$entity =~ s/(\#|,|;|\\|\/|\||\?|!|:|\$|\@|\*|\(|\)|\"|\+|\`|to)$//g;
									$entity =~ s/_$//g;
									$FakeWords{$wid} = "[EN " . $entity . "] " . $punc;
									$entity = $entity . " " . $punc;
									$FakeEntities{$wid} = $entity;
									print "After cleaning: $entity - $FakeWords{$wid}\n\n";
								}
								elsif ($entity !~ /_/) # if the entity is not underlined, check for the POS to make sure the entity is a noun
								{
									if ($tokenPOS{$wid} =~ /JJ/ || $tokenPOS{$wid} =~ /RB/ || $tokenPOS{$wid} =~ /VB/) # remove the entity
									{
										print "$FakeEntities{$wid} has the POS $tokenPOS{$wid} so needs to be removed!\n";
										delete ($FakeEntities{$wid});
										$FakeWords{$wid} =~ s/\[EN_//g;
										$FakeWords{$wid} =~ s/\]//g;
										print "$FakeWords{$wid} is not an entity anymore!\n\n";
									}
								}
							}
							elsif (defined $FakeEntities{$Extensions{$wid}} && exists $FakeEntities{$Extensions{$wid}})
							{
								my $entity = $FakeEntities{$Extensions{$wid}};
								print "---- $entity\n";
								if ($entity =~ /(\#|,|;|\\|\/|\||\?|!|:|\$|\@|\*|\(|\)|\"|\+|\`)/) # make sure punctuations or "to" are not added to the end (with an '_')
								{
									print "$entity needs to be cleaned!\n";
									my @elements = split (/_/, $entity);
									my $punc = $elements[@elements - 1];
									print "the attached punctuation is $punc";
									$entity =~ s/(\#|,|;|\\|\/|\||\?|!|:|\$|\@|\*|\(|\)|\"|\+|\`|to)$//g;
									$entity =~ s/_$//g;
									$FakeWords{$wid} = "[EN " . $entity . "] " . $punc;
									$entity = $entity . " " . $punc;
									$FakeEntities{$wid} = $entity;
									print "After cleaning: $entity - $FakeWords{$wid}\n\n";
								}
							}
							if (defined $FakeWords{$wid} && exists $FakeWords{$wid})
							{
								$newsentence = $newsentence . " " . $FakeWords{$wid};
							}
							if (defined $FakeEntities{$wid} && exists $FakeEntities{$wid})	# if the word is an entity
							{
								my $entity;
								print "$FakeEntities{$wid} is an entity!\n";
								if (defined $FakeWords{$wid} && exists $FakeWords{$wid})
								{
									$entity = $FakeWords{$wid};
								}
								elsif (defined $FakeWords{$Extensions{$wid}} && exists $FakeWords{$Extensions{$wid}})
								{
									$entity = $FakeWords{$Extensions{$wid}};
								}
								$entity =~ s/\[EN_//g;
								$entity =~ s/\]//g;
								$entity =~ s/ //g;					
								
								if (length($entity) > 0)
								{
									print "ENT - $entity\n";
									$entities_per_sentence = $entities_per_sentence . "\t" . $entity;
				
									if ($hashterm{lc($entity)}{freq} < 1) # the term is not already in the hash
									{
										$hashterm{lc($entity)}{freq} = 1;
										print "**** seeing the entity $entity for the first time !!!\n";
									}
									elsif ($hashterm{lc($entity)}{freq} >= 1) # update the TF for the term
									{
										$hashterm{lc($entity)}{freq}++;
										print "**** seeing the entity $entity for $hashterm{$entity}{freq} times !!!\n";
									}
									else
									{
										#print "\n**** HOW IS THAT POSSIBLE??? -- $entity **** \n";
									}
								}
							}
						}
						#print "Original: $sentence\n";
						print "Before: $tokenizedSentence\n";
						print "After: $newsentence\n\n";
						$newsentence =~ s/EN_/EN /g;
						print OUT "$newsentence\n";
						
						$entities_per_sentence =~ s/^\t//;
						my @elements = split /\t/, $entities_per_sentence;
						if (@elements > 1)
						{
							print ENT "$sentNum\t$entities_per_sentence\n";
						}
						
						$sentNum++;
					}
				}
			}
		}	
	}
	
	foreach my $k (keys(%hashterm))
	{
	      print "$hashterm{$k}{freq}\t$k\n";
	      print TF "$hashterm{$k}{freq}\t$k\n";
	}
	
	close ENT;
	close OUT;
	close TF;
	
	
}
sub selectByRankedEntities
{
	my $topic = $_[0];
	my $selectMode = $_[1]; # $selectMode is referring to the criterion used for ranking entities: 0: TFIDF for individual entities; 1: average TFIDF for entity pairs; 2: NPMI for entity pairs
	
	my %TFIDFentities = ();
	my %TFIDFentityPairs = ();
	my %NPMIentityPairs = ();
	
	my $mkdir = `mkdir windows/$topic/selectedPathsBetweenEntities`;
	opendir (THISDIR, "windows/$topic/pathsBetweenEntities") or die "$!";
        my @docfiles = grep !/^\./, readdir THISDIR;
        closedir THISDIR;
	if ($selectMode == 0) # entities are ranked by TFIDF
	{
		open (IN, "data/$topic/TFIDF_all") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($tfidf, $entity, $entityType) = split /\t/, $in;
			#print "$entity\n";
			#if ($count < 100){
			#if ($tfidf > 3 || lc($entity) eq "i" || lc($entity) eq "we")
			#{
				$entity =~ s/\s/_/g;
				$TFIDFentities{$entity} = $tfidf;
			#}
		}
		close (IN);
	}
	elsif ($selectMode == 1) # entity pairs are ranked by average TFIDF
	{
		open (IN, "data/$topic/TFIDF_pairs") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($tfidf, $entity1, $entity2) = split /\t/, $in;
			#print "$entity\n";
			#if ($count < 100){
			#if ($tfidf > 3 || lc($entity) eq "i" || lc($entity) eq "we")
			#{
				$entity1 =~ s/\s/_/g;
				$entity2 =~ s/\s/_/g;
				$TFIDFentityPairs{$entity1}{$entity2} = $tfidf;
			#}
		}
		close (IN);
	}
	elsif ($selectMode == 2) # entity pairs are ranked by NPMI
	{
		open (IN, "data/$topic/NPMI_pairs_bySent") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($npmi, $entity1, $entity2, $sentID) = split /\t/, $in;
			#print "$entity\n";
			#if ($count < 100){
			#if ($tfidf > 3 || lc($entity) eq "i" || lc($entity) eq "we")
			#{
				$entity1 =~ s/\s/_/g;
				$entity2 =~ s/\s/_/g;
				$NPMIentityPairs{$entity1}{$entity2}{$sentID} = $npmi;
			#}
		}
		close (IN);
	}
	
	foreach my $docfile (@docfiles)
	{
		print "$docfile\n";
		open (IN, "windows/$topic/pathsBetweenEntities/$docfile") or die "there is no such file! $!";
		open (OUT, ">windows/$topic/selectedPathsBetweenEntities/$docfile") or die "$!";
		
		# Sample input format:
		# ballets	The_Rite_of_Spring
		#
		# 8	 He first achieved [EN international_fame] with three [EN ballets] commissioned by the [EN impresario_Sergei_Diaghilev] and first performed in [EN Paris] by [EN Diaghilev] 's [EN Ballets_Russes] : [EN The_Firebird] [EN 1910] , [EN Petrushka] [EN 1911] and [EN The_Rite_of_Spring] of [EN 1913] .
		# ballets	The_Rite_of_Spring	ballets-7 ->-partmod->- commissioned-8 ->-agent->- first-13 ->-dep->- The_Rite_of_Spring-28

		
		my $block = "";
		my $approved = 0;
		while (my $in = <IN>)
		{
			chomp $in;
			my ($entity1, $entity2) = split /\t/, $in;
			
			$block = $in . "\n";
			$entity1 =~ s/_/ /g;
			$entity2 =~ s/_/ /g;
			$entity1 = lc($entity1);
			$entity2 = lc($entity2);
			
			$in = <IN>; # blank line
			$block = $block . "\n";
			
			$in = <IN>; #sentenceID	sentence
			$block = $block . $in . "\n";
			chomp $in;
			my ($sentID, $sentence) = split /\t/, $in;
			
			$in = <IN>; # path
			chomp $in;
			$block = $block . $in . "\n";
			
			if ($selectMode == 0) # entities are ranked by TFIDF
			{
				if ($TFIDFentities{$entity1} >= 3 && $TFIDFentities{$entity2} >= 3)
				{
					$approved = 1;
				}
			}
			elsif ($selectMode == 1) # entity pairs are ranked by average TFIDF
			{
				if ($TFIDFentityPairs{$entity1}{$entity2} >= 10)
				{
					$approved = 1;
				}
			}
			elsif ($selectMode == 2) # entity pairs are ranked by NPMI
			{
				if ($NPMIentityPairs{$entity1}{$entity2}{$sentID} > 0)
				{
					$approved = 1;
				}
			}
			
			if ($approved == 1) # the relation has to be included
			{
				
				print OUT "$block\n";
			}
			
			$block = "";
		}

	}
}
sub summarizeResults
{
	my $topic = $_[0];
	#my $measure = $_[1]; # 0 is average TF-IDF / 1 is NPMI
	
	my $mkdir = `mkdir windows/$topic/Summary`;
	open (SUMM, ">windows/$topic/Summary/ALL") or die $!;
	
	my %rankedRelations = ();
	my %relations = ();
	
	my %TFIDFentities = ();
	
	open (IN, "data/$topic/TFIDF_all") or die $!;
	
	while (my $in = <IN>)
	{
		chomp $in;
		my ($tfidf, $entity) = split /\t/, $in;
		#print "$entity\n";
		
		$entity =~ s/\s+/ /g;
		$entity =~ s/\s/_/g;
		$TFIDFentities{$entity} = $tfidf;
	}
	close (IN);
		
	#my $mkdir = `mkdir windows/$topic/rankedRelations`;
	
	opendir (THISDIR, "windows/$topic/rankedRelations/NPMI") or die "$!";
        my @docfiles = grep !/^\./ && !/_/, readdir THISDIR;
	closedir THISDIR;
	
	print "docs to process: @docfiles\n\n";
	foreach my $docfile (@docfiles)
	{
		open (IN, "windows/$topic/rankedRelations/NPMI/$docfile") or die $!;
		open (OUT, ">windows/$topic/Summary/$docfile") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($entity1, $entity2, $npmi) = split /\t/, $in;
			
			$entity1 = lc ($entity1);
			$entity2 = lc ($entity2);
			
			my $averageTFIDF = ($TFIDFentities{$entity1} + $TFIDFentities{$entity2}) / 2;
			
			$in = <IN>; #blank line
			$in = <IN>;
			chomp $in;
			my ($sentID, $sentence) = split /\t/, $in;
			
			
			$relations{$entity1}{$entity2}{$sentID}{line1} = $entity1 . "\t" . $entity2;
			$relations{$entity1}{$entity2}{$sentID}{line3} = $in;
			
			$in = <IN>;
			chomp $in;
			$relations{$entity1}{$entity2}{$sentID}{line4} = $in; # path
			
			$in = <IN>;
			chomp $in;
			$relations{$entity1}{$entity2}{$sentID}{line5} = $in; # augmented path
			
			$in = <IN>;
			chomp $in;
			$relations{$entity1}{$entity2}{$sentID}{line6} = $in; # label
			my $label = $in;
			$label =~ s/\(\d+\)//g;
			$label =~ s/\s+/ /g;
			$label =~ s/\*//g;
			
			$in = <IN>; #blank line
			
			print OUT "$npmi\t$averageTFIDF\t$entity1\t$entity2\t$label\t$sentence\n";
			print SUMM "$npmi\t$averageTFIDF\t$entity1\t$entity2\t$label\t$sentence\n";
		}
		close (IN);
		close (OUT);
	}
	close (SUMM);
	
}
sub rankRelations
{
	my $topic = $_[0];
	my $docNum = $_[1];
	my $measure = $_[2]; # 0 is average TF-IDF / 1 is NPMI
	
	my %rankedRelations = ();
	my %relations = ();
		
	my $mkdir = `mkdir windows/$topic/$docNum/rankedRelations`;
	#my $rmdir = `rm -rf windows/$topic/rankedRelations/NPMI`;
	my $mkdir = `mkdir windows/$topic/$docNum/rankedRelations/NPMI`;
	
	#my $rmdir = `rm -rf windows/$topic/rankedRelations/averageTFIDF`;
	my $mkdir = `mkdir windows/$topic/$docNum/rankedRelations/averageTFIDF`;
				
	opendir (THISDIR, "windows/$topic/$docNum/relationLabels") or die "$!";
        my @docfiles = grep !/^\./ && !/_/, readdir THISDIR;
	closedir THISDIR;
	
	print "docs to process: @docfiles\n\n";
	foreach my $docfile (@docfiles)
	{
		open (IN, "windows/$topic/$docNum/relationLabels/$docfile") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($entity1, $entity2) = split /\t/, $in;
			
			$entity1 = lc ($entity1);
			$entity2 = lc ($entity2);
			
			$in = <IN>; #blank line
			$in = <IN>;
			chomp $in;
			my ($sentID, $sentence) = split /\t/, $in;
			
			print "-- NOT Ranked: $sentID\t$entity1\t$entity2\t$sentence\n";
			
			$relations{$entity1}{$entity2}{$sentID}{line1} = $entity1 . "\t" . $entity2;
			$relations{$entity1}{$entity2}{$sentID}{line3} = $in;
			
			$in = <IN>;
			chomp $in;
			$relations{$entity1}{$entity2}{$sentID}{line4} = $in; # path
			
			$in = <IN>;
			chomp $in;
			$relations{$entity1}{$entity2}{$sentID}{line5} = $in; # augmented path
			
			$in = <IN>;
			chomp $in;
			$relations{$entity1}{$entity2}{$sentID}{line6} = $in; # label
			
			$in = <IN>; #blank line
		}
		close (IN);
			
		if ($measure == 0) # entity pairs are ranked by average TFIDF
		{				
			open (IN, "data/$topic/$docNum/TFIDF_pairs_bySent") or die $!;
			open (OUT, ">windows/$topic/$docNum/rankedRelations/averageTFIDF/$docfile") or die $!;
			open (NOR, ">windows/$topic/$docNum/rankedRelations/averageTFIDF/noRelation.txt") or die $!;
			while (my $in = <IN>){
				chomp $in;
				my ($tfidf, $entity1, $entity2, $sentID) = split /\t/, $in;
				
				$entity1 = lc ($entity1);
				$entity2 = lc ($entity2);
		
				$rankedRelations{$entity1}{$entity2}{$sentID} = $tfidf;
				
				print "-- Ranked: $sentID\t$entity1\t$entity2\t$tfidf\n";
				
				
				if (defined $relations{$entity1}{$entity2}{$sentID} && exists $relations{$entity1}{$entity2}{$sentID})
				{
					print "** Added: $sentID\t$entity1\t$entity2\t$tfidf\n";
					print OUT "$relations{$entity1}{$entity2}{$sentID}{line1}\t$tfidf\n\n";
					print OUT "$relations{$entity1}{$entity2}{$sentID}{line3}\n";
					print OUT "$relations{$entity1}{$entity2}{$sentID}{line4}\n";
					print OUT "$relations{$entity1}{$entity2}{$sentID}{line5}\n";
					print OUT "$relations{$entity1}{$entity2}{$sentID}{line6}\n";
				}
				elsif (defined $relations{$entity2}{$entity1}{$sentID} && exists $relations{$entity2}{$entity1}{$sentID})
				{
					print "* Added: $sentID\t$entity2\t$entity2\t$tfidf\n";
					print OUT "$relations{$entity2}{$entity1}{$sentID}{line1}\t$tfidf\n\n";
					print OUT "$relations{$entity2}{$entity1}{$sentID}{line3}\n";
					print OUT "$relations{$entity2}{$entity1}{$sentID}{line4}\n";
					print OUT "$relations{$entity2}{$entity1}{$sentID}{line5}\n";
					print OUT "$relations{$entity2}{$entity1}{$sentID}{line6}\n";
				}
				else
				{
					print NOR "$sentID\t$entity1\t$entity2\t$tfidf\n";
				}
			}
			close (IN);
			close (OUT);
			#close (NOR);
			
		}
		elsif ($measure == 1) # entity pairs are ranked by NPMI
		{			
			open (IN, "data/$topic/$docNum/NPMI_pairs_bySent") or die $!;
			open (OUT, ">windows/$topic/$docNum/rankedRelations/NPMI/$docfile") or die $!;
			open (NOR, ">>windows/$topic/$docNum/rankedRelations/NPMI/noRelation.txt") or die $!;
			while (my $in = <IN>){
				chomp $in;
				my ($npmi, $entity1, $entity2, $sentID, $jointF) = split /\t/, $in;
				print "NPMIbySent: $npmi - $entity1 - $entity2 - $sentID - $jointF\n";
				$entity1 = lc ($entity1);
				$entity2 = lc ($entity2);
				
				#if (! defined $rankedRelations{$entity1}{$entity2} && ! exists $rankedRelations{$entity1}{$entity2} )
				#{
					$rankedRelations{$entity1}{$entity2} = $npmi;
					
					print "-- Ranked: $sentID\t$entity1\t$entity2\t$npmi\n";
					
					
					if (defined $relations{$entity1}{$entity2}{$sentID} && exists $relations{$entity1}{$entity2}{$sentID})
					{
						print "*** Added: $sentID\t$entity1\t$entity2\t$npmi\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line1}\t$npmi\n\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line3}\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line4}\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line5}\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line6}\n";
					}
					elsif (defined $relations{$entity2}{$entity1}{$sentID} && exists $relations{$entity2}{$entity1}{$sentID})
					{
						print "**** Added: $sentID\t$entity2\t$entity2\t$npmi\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line1}\t$npmi\n\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line3}\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line4}\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line5}\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line6}\n";
					}
					else
					{
						print NOR "$sentID\t$entity1\t$entity2\t$npmi\n";
					}
				#}
				#else
				#{
				#	print "*** already there!\n";
				#}
			}
			close (IN);
			close (OUT);
			#close (NOR);
		}
		%relations = ();
	}
	close (NOR);
}
sub rankRelations_all # rank relations for one aggregated graph
{
	my $topic = $_[0];
	my $measure = $_[1]; # 0 is average TF-IDF / 1 is NPMI
	
	my %rankedRelations = ();
	my %relations = ();
		
	my $mkdir = `mkdir windows/$topic/rankedRelations`;
	#my $rmdir = `rm -rf windows/$topic/rankedRelations/NPMI`;
	my $mkdir = `mkdir windows/$topic/rankedRelations/NPMI`;
	
	#my $rmdir = `rm -rf windows/$topic/rankedRelations/averageTFIDF`;
	my $mkdir = `mkdir windows/$topic/rankedRelations/averageTFIDF`;
	
	
	#open (IN, "data/$topic/TFIDF_pairs") or die $!;
	open (OUT, ">windows/$topic/rankedRelations/averageTFIDF/rankedRelations") or die $!;
	open (NOR, ">windows/$topic/rankedRelations/averageTFIDF/noRelation.txt") or die $!;
	
	for (my $docNum = 1; $docNum <= 13; $docNum++)
	{
		#opendir (THISDIR, "windows/$topic/$docNum/relationLabels") or die "$!";
		#my @docfiles = grep !/^\./ && !/_/, readdir THISDIR;
		#closedir THISDIR;
		
		open (IN, "windows/$topic/$docNum/relationLabels/$docNum") or die $!;
#	Sample Input:
#	Napoleon	Tsar_Alexander_I_of_Russia

#	14	 6 [EN Napoleon] hoped to compel [EN Tsar_Alexander_I_of_Russia] of to cease trading with [EN British_merchants] through [EN proxies] in an [EN effort] to [EN pressure_the_United_Kingdom] to sue for peace .
#	Napoleon	Tsar_Alexander_I_of_Russia	Napoleon-2 -<-xsubj-<- compel-5 ->-dobj->- Tsar_Alexander_I_of_Russia-6
#	Napoleon-2**-<-xsubj-<-**compel-5**->-dobj->-**Tsar_Alexander_I_of_Russia-6**
#	(1) 6* (2) Napoleon* (3) hoped* (4) to* (5) compel* (6) Tsar_Alexander_I_of_Russia*
#

		while (my $in = <IN>){
			chomp $in;
			my ($entity1, $entity2) = split /\t/, $in;
			
			$entity1 = lc ($entity1);
			$entity2 = lc ($entity2);
			
			$in = <IN>; #blank line
			$in = <IN>;
			chomp $in;
			my ($sentID, $sentence) = split /\t/, $in;
			
			print "-- NOT Ranked: $sentID\t$entity1\t$entity2\t$sentence\n";
			
			$relations{$entity1}{$entity2}{$docNum}{$sentID}{line1} = $entity1 . "\t" . $entity2;
			$relations{$entity1}{$entity2}{$docNum}{$sentID}{line3} = $in;
			
			$in = <IN>;
			chomp $in;
			$relations{$entity1}{$entity2}{$docNum}{$sentID}{line4} = $in; # path
			
			$in = <IN>;
			chomp $in;
			$relations{$entity1}{$entity2}{$docNum}{$sentID}{line5} = $in; # augmented path
			
			$in = <IN>;
			chomp $in;
			$relations{$entity1}{$entity2}{$docNum}{$sentID}{line6} = $in; # label
			
			$in = <IN>; #blank line
		}
		close (IN);
			
		if ($measure == 0) # entity pairs are ranked by average TFIDF
		{
			
			open (IN, "data/$topic/TFIDF_pairs_bySentDoc") or die $!;
			#open (IN, "data/$topic/TFIDF_pairs") or die $!;

			while (my $in = <IN>){
#	Sample Input:
#	512.15687207326	grande_armee	napoleon
#	458.879764508853	1812	napoleon
				chomp $in;
				my ($tfidf, $entity1, $entity2, $docID, $sentID) = split /\t/, $in;
				#my ($tfidf, $entity1, $entity2) = split /\t/, $in;
				
				$entity1 = lc ($entity1);
				$entity2 = lc ($entity2);
		
				$rankedRelations{$entity1}{$entity2}{$docID}{$sentID} = $tfidf;
				#$rankedRelations{$entity1}{$entity2} = $tfidf;
				
				print "-- Ranked: $entity1\t$entity2\t$docID\t$sentID\t$tfidf\n";
				
				
				if (defined $relations{$entity1}{$entity2}{$docID}{$sentID} && exists $relations{$entity1}{$entity2}{$docID}{$sentID})
				#if (defined $relations{$entity1}{$entity2} && exists $relations{$entity1}{$entity2})
				{
					print "** Added: $entity1\t$entity2\t$tfidf\n";
					print OUT "$relations{$entity1}{$entity2}{$docID}{$sentID}{line1}\t$tfidf\n\n";
					print OUT "$relations{$entity1}{$entity2}{$docID}{$sentID}{line3}\n";
					print OUT "$relations{$entity1}{$entity2}{$docID}{$sentID}{line4}\n";
					print OUT "$relations{$entity1}{$entity2}{$docID}{$sentID}{line5}\n";
					print OUT "$relations{$entity1}{$entity2}{$docID}{$sentID}{line6}\n";
				}
				elsif (defined $relations{$entity2}{$entity1}{$docID}{$sentID} && exists $relations{$entity2}{$entity1}{$docID}{$sentID})
				{
					print "* Added: $entity2\t$entity2\t$tfidf\n";
					print OUT "$relations{$entity2}{$entity1}{$docID}{$sentID}{line1}\t$tfidf\n\n";
					print OUT "$relations{$entity2}{$entity1}{$docID}{$sentID}{line3}\n";
					print OUT "$relations{$entity2}{$entity1}{$docID}{$sentID}{line4}\n";
					print OUT "$relations{$entity2}{$entity1}{$docID}{$sentID}{line5}\n";
					print OUT "$relations{$entity2}{$entity1}{$docID}{$sentID}{line6}\n";
				}
				else
				{
					print NOR "$entity1\t$entity2\t$docID\t$sentID\t$tfidf\n";
				}
			}
			close (IN);
			close (OUT);
			#close (NOR);
			
		}
		elsif ($measure == 1) # entity pairs are ranked by NPMI
		{			
			open (IN, "data/$topic/NPMI_pairs_bySent") or die $!;
			open (OUT, ">windows/$topic/rankedRelations/NPMI/rankedRelations") or die $!;
			open (NOR, ">>windows/$topic/rankedRelations/NPMI/noRelation.txt") or die $!;
			while (my $in = <IN>){
				chomp $in;
				my ($npmi, $entity1, $entity2, $sentID, $jointF) = split /\t/, $in;
				print "NPMIbySent: $npmi - $entity1 - $entity2 - $sentID - $jointF\n";
				$entity1 = lc ($entity1);
				$entity2 = lc ($entity2);
				
				#if (! defined $rankedRelations{$entity1}{$entity2} && ! exists $rankedRelations{$entity1}{$entity2} )
				#{
					$rankedRelations{$entity1}{$entity2} = $npmi;
					
					print "-- Ranked: $sentID\t$entity1\t$entity2\t$npmi\n";
					
					
					if (defined $relations{$entity1}{$entity2}{$sentID} && exists $relations{$entity1}{$entity2}{$sentID})
					{
						print "*** Added: $sentID\t$entity1\t$entity2\t$npmi\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line1}\t$npmi\n\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line3}\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line4}\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line5}\n";
						print OUT "$relations{$entity1}{$entity2}{$sentID}{line6}\n";
					}
					elsif (defined $relations{$entity2}{$entity1}{$sentID} && exists $relations{$entity2}{$entity1}{$sentID})
					{
						print "**** Added: $sentID\t$entity2\t$entity2\t$npmi\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line1}\t$npmi\n\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line3}\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line4}\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line5}\n";
						print OUT "$relations{$entity2}{$entity1}{$sentID}{line6}\n";
					}
					else
					{
						print NOR "$sentID\t$entity1\t$entity2\t$npmi\n";
					}
				#}
				#else
				#{
				#	print "*** already there!\n";
				#}
			}
			close (IN);
			close (OUT);
			#close (NOR);
		}
		%relations = ();
	}
	close (NOR);
}
sub getTuples
{
	my $topic = $_[0];
	my $dN = $_[1];

		
	#my $mkdir = `mkdir windows/$topic/extractedTuples`;
	my $mkdir = `mkdir windows/$topic/$dN/extractedTuples`;
	
	#opendir (THISDIR, "windows/$topic/relationLabels") or die "$!";
	opendir (THISDIR, "windows/$topic/$dN/relationLabels") or die "$!";
        my @docfiles = grep !/^\./ && !/_/, readdir THISDIR;
	closedir THISDIR;
	
	#open (OUT, ">windows/$topic/extractedTuples/tuples");
	open (OUT, ">windows/$topic/$dN/extractedTuples/tuples");
	
	print "docs to process: @docfiles\n\n";
	foreach my $docfile (@docfiles)
	{
		#open (IN, "windows/$topic/relationLabels/$docfile") or die $!;
		open (IN, "windows/$topic/$dN/relationLabels/$docfile") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($entity1, $entity2) = split /\t/, $in;
			
			$entity1 = lc ($entity1);
			$entity2 = lc ($entity2);
			
			print OUT "$entity1\t$entity2\t";
			
			$in = <IN>; #blank line
			$in = <IN>;
			chomp $in;
			my ($sentID, $sentence) = split /\t/, $in;
			
			print "-- NOT Ranked: $sentID\t$entity1\t$entity2\t$sentence\n";
			
			$in = <IN>;
			chomp $in; #path
			
			$in = <IN>;
			chomp $in; # augmented path
			
			$in = <IN>;
			chomp $in; # label

			my $label = $in;
			$label =~ s/\(\d+\)//g;
			$label =~ s/\s+/ /g;
			$label =~ s/\*//g;
			
			print OUT "$label\t$sentence\n";
			
			$in = <IN>; #blank line
		}
		close (IN);
	}
	close (OUT);
}
sub getRankedTuples_all
{
	my $topic = $_[0];
	my $measure = $_[1]; # 0 is average TF-IDF / 1 is NPMI

	my $mkdir = `mkdir windows/$topic/RankedTuples`;
	if ($measure == 0) # entity pairs are ranked by average TFIDF
	{
		my $mkdir = `mkdir windows/$topic/RankedTuples/averageTFIDF`;
		
		#opendir (THISDIR, "windows/$topic/relationLabels") or die "$!";
		#opendir (THISDIR, "windows/$topic/$dN/rankedRelations/averageTFIDF") or die "$!";
		#my @docfiles = grep !/^\./ && !/_/, readdir THISDIR;
		#closedir THISDIR;
		
		#open (OUT, ">windows/$topic/extractedTuples/tuples");
		open (OUT, ">windows/$topic/RankedTuples/averageTFIDF/tuples");
		
#		for (my $dN = 1; $dN <= 5; $dN++)
#		{
		#Sample docfile
		#napoleon	tsar_alexander_i_of_russia	344.987789540937
		#
		#14	 6 [EN Napoleon] hoped to compel [EN Tsar_Alexander_I_of_Russia] of to cease trading with [EN British_merchants] through [EN proxies] in an [EN effort] to [EN pressure_the_United_Kingdom] to sue for peace .
		#Napoleon	Tsar_Alexander_I_of_Russia	Napoleon-2 -<-xsubj-<- compel-5 ->-dobj->- Tsar_Alexander_I_of_Russia-6
		#Napoleon-2**-<-xsubj-<-**compel-5**->-dobj->-**Tsar_Alexander_I_of_Russia-6**
		#(1) 6* (2) Napoleon* (3) hoped* (4) to* (5) compel* (6) Tsar_Alexander_I_of_Russia*


		#open (IN, "windows/$topic/relationLabels/$docfile") or die $!;
		#open (IN, "windows/$topic/$dN/rankedRelations/averageTFIDF/$docfile") or die $!;
		open (IN, "windows/$topic/rankedRelations/averageTFIDF/rankedRelations") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($entity1, $entity2, $avgTFIDF) = split /\t/, $in;
			
			$entity1 = lc ($entity1);
			$entity2 = lc ($entity2);
			
			print "ENTITIES: $entity1\t$entity2\n";
			print OUT "$entity1\t$entity2\t";
			
			$in = <IN>; #blank line
			$in = <IN>;
			chomp $in;
			my ($sentID, $sentence) = split /\t/, $in;
			
			print "-- Ranked: $sentID\t$entity1\t$entity2\t$sentence\n";
			
			$in = <IN>;
			chomp $in; #path
			
			$in = <IN>;
			chomp $in; # augmented path
			
			$in = <IN>;
			chomp $in; # label

			my $label = $in;
			$label =~ s/\(\d+\)//g;
			$label =~ s/\s+/ /g;
			$label =~ s/\*//g;
			
			print OUT "$label\t$sentence\n";
			
			#$in = <IN>; #blank line
		}
		close (IN);
		close (OUT);
	}
}
sub getTuples_all
{
	my $topic = $_[0];
		
	my $mkdir = `mkdir windows/$topic/extractedTuples`;
	
	#opendir (THISDIR, "windows/$topic/relationLabels") or die "$!";
#	opendir (THISDIR, "windows/$topic/$dN/relationLabels") or die "$!";
#        my @docfiles = grep !/^\./ && !/_/, readdir THISDIR;
#	closedir THISDIR;
	
	#open (OUT, ">windows/$topic/extractedTuples/tuples");
	open (OUT, ">windows/$topic/extractedTuples/tuples");
	
	for (my $dN = 1; $dN <= 5; $dN++)
	{
		#open (IN, "windows/$topic/relationLabels/$docfile") or die $!;
		open (IN, "windows/$topic/$dN/relationLabels/$dN") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($entity1, $entity2) = split /\t/, $in;
			
			$entity1 = lc ($entity1);
			$entity2 = lc ($entity2);
			
			print OUT "$entity1\t$entity2\t";
			
			$in = <IN>; #blank line
			$in = <IN>;
			chomp $in;
			my ($sentID, $sentence) = split /\t/, $in;
			
			print "-- NOT Ranked: $sentID\t$entity1\t$entity2\t$sentence\n";
			
			$in = <IN>;
			chomp $in; #path
			
			$in = <IN>;
			chomp $in; # augmented path
			
			$in = <IN>;
			chomp $in; # label

			my $label = $in;
			$label =~ s/\(\d+\)//g;
			$label =~ s/\s+/ /g;
			$label =~ s/\*//g;
			
			print OUT "$label\t$sentence\n";
			
			$in = <IN>; #blank line
		}
		close (IN);
	}
	close (OUT);
}
sub getNuggets
{
	my $topic = $_[0];
	my $queryID = $_[1];
	my $num_of_docs = $_[2];
	
	my $mkdir = `mkdir windows/$topic/retrievedNuggets`;
	
#	opendir (THISDIR, "windows/$topic/retrievedNuggets") or die "$!";
#        my @docfiles = grep !/^\./ && !/_/, readdir THISDIR;
#	closedir THISDIR;
	
	open (OUT, ">windows/$topic/retrievedNuggets/retNuggets");
	
	#foreach my $docfile (@docfiles)
	for (my $d = 1; $d <= $num_of_docs; $d++)
	{
		#open (IN, "windows/$topic/retrievedNuggets/$docfile") or die $!;
		open (IN, "windows/$topic/$d/extractedTuples/tuples") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($entity1, $entity2, $label, $sentence) = split /\t/, $in;
			
			#print OUT "$entity1\t$entity2\t";
			
			#$in = <IN>; #blank line
			#chomp $in;

			my $clean_sentence = $sentence;
			$clean_sentence =~ s/\[EN//g;
			$clean_sentence =~ s/]/ /g;
			$clean_sentence =~ s/_/ /g;
			$clean_sentence =~ s/^\s+//;
			
			print OUT "$queryID\t" . "BS1\t" . "$d\t$clean_sentence\n";
		}
		close (IN);
	}
	close (OUT);	
}
sub getAllEntities
{
	my $topic = $_[0];
	my $num_of_docs = $_[1];
	
	my $mkdir = `mkdir windows/$topic/allEntities`;
	
	open (OUT, ">windows/$topic/allEntities/allEnts");
	
	for (my $d = 1; $d <= $num_of_docs; $d++)
	{
		#open (IN, "windows/$topic/retrievedNuggets/$docfile") or die $!;
		open (IN, "data/$topic/$d/TFIDF_all") or die $!;
		while (my $in = <IN>){
			chomp $in;
			my ($tfidf, $entity) = split /\t/, $in;
			
			$entity =~ s/_/ /g;
			$entity =~ s/^\s+//;
			$entity = lc ($entity);
			
			#print OUT "$entity1\t$entity2\t";
					
			print OUT "$entity\n";
		}
		close (IN);
	}
	close (OUT);
	
}
sub parseCanvasData
{
	my $topic = $_[0];
	my $dN = $_[1];
	
	open (IN, "windows/$topic/$dN/canvasData/canvasIDs") or die $!;
	open (Entities_OUT, ">windows/$topic//$dN/canvasData/entities_annotations");
	open (Relations_OUT, ">windows/$topic//$dN/canvasData/relations_annotations");
	
	# Sample format:
	# canvas-54522ae6-f9ae-4c92-8a0e-7980aaae2a80
	# States:co-7b2ed132-645b-4bca-ac7d-e0ae8cbc1318	other states are considering legislations:co-5b0d413d-8652-4bb9-bb04-46b2ae4cd23d	legislation:co-7e4fcd86-800e-4198-8944-71b587fee358
	
	my $in = <IN>; # first line is the canvas ID
	chomp $in;
	while ($in = <IN>){
		chomp $in; #entity1:entity1_ID	label:label_ID	entity2:entity2_ID
		
		my ($ent1, $l, $ent2) = split /\t/, $in;
		my ($entity1, $entity1_ID) = split /:/, $ent1;
		my ($entity2, $entity2_ID) = split /:/, $ent2;
		my ($label, $label_ID) = split /:/, $l;
		
		$entity1_ID =~ s/ //g;
		$entity2_ID =~ s/ //g;
		$label_ID =~ s/ //g;
		
		# adding the default annotation for entities and relations:
		# <span class="entity co-cef96166-f99d-4d67-aced-bb4ce65cb423" onclick="SelectEntityInUnity('http://www.insightng.com/vocabulary/co-cef96166-f99d-4d67-aced-bb4ce65cb423')">California</span>
		# <span class="relation co-1d0ebbed-4909-461c-8460-bbc76eb7026a" onclick="SelectEntityInUnity('http://www.insightng.com/vocabulary/co-1d0ebbed-4909-461c-8460-bbc76eb7026a')">moves quickly toward setting up a $3-billion</span>
		
		my $entity1_annotation = "<span class=\"entity " . $entity1_ID . "\" onclick=\"SelectEntityInUnity(\'http://www.insightng.com/vocabulary/" . $entity1_ID . "\')\">" . $entity1 . "</span>";
		my $entity2_annotation = "<span class=\"entity " . $entity2_ID . "\" onclick=\"SelectEntityInUnity(\'http://www.insightng.com/vocabulary/" . $entity2_ID . "\')\">" . $entity2 . "</span>";
		my $label_annotation = "<span class=\"relation " . $label_ID . "\" onclick=\"SelectEntityInUnity(\'http://www.insightng.com/vocabulary/" . $label_ID . "\')\">" . $label . "</span>";
		
		print Entities_OUT "$entity1_annotation\n";
		print Entities_OUT "$entity2_annotation\n";
		
		print Relations_OUT "$label_annotation\n";
	}
	close (IN);
	close (Entities_OUT);
	close (Relations_OUT);
}
sub filterReverbExtractions 	# Takes the output of reverb and writes the extractions that have high ranked entities as theirs Args into an output file
{
	my $topic = $_[0];
		
	my %TFIDFentities = ();
	my %stopWords = ();
	my $count = 0;
    
        my $rm = `rm -rf /data/bsarrafzadeh/OpenIE/InsightNG/reverb-master/Out/filtered`;
	#load top TFIDF-ranked entities
	open (IN, "/data/bsarrafzadeh/OpenIE/InsightNG/all-sentences/data/$topic/TFIDF_all") or die $!;
	while (my $in = <IN>){
		chomp $in;
		my ($tfidf, $entity) = split /\t/, $in;
		#print "$entity\n";
		if ($count < 150){
			$entity =~ s/\s/_/g;
			$TFIDFentities{$entity} = $tfidf;
		}
		$count++;
	}
	close (IN);
	
	#load StopWords
	open (IN, "/data/bsarrafzadeh/OpenIE/InsightNG/all-sentences/data/StopWords") or die $!;
	while (my $in = <IN>)
	{
		chomp $in;
		$stopWords{$in} = 1;
	}
	close (IN);
	
	opendir (THISDIR, "/data/bsarrafzadeh/OpenIE/InsightNG/reverb-master/Out") or die "$!";
        my @docfiles = grep !/^\./ && !/_/, readdir THISDIR;
	closedir THISDIR;
        
        print "*** @docfiles\n\n";
        
        my $mkdir = `mkdir /data/bsarrafzadeh/OpenIE/InsightNG/reverb-master/Out/filtered`;
	
	foreach my $docfile (@docfiles)
	{
		 my $mkdir = `mkdir /data/bsarrafzadeh/OpenIE/InsightNG/reverb-master/Out/filtered/$docfile`;
		 
		open (IN, "/data/bsarrafzadeh/OpenIE/InsightNG/reverb-master/Out/$docfile") or die $!;
		open (OUT, ">/data/bsarrafzadeh/OpenIE/InsightNG/reverb-master/Out/filtered/$docfile/$docfile") or die $!;
		open (SINGLE, ">/data/bsarrafzadeh/OpenIE/InsightNG/reverb-master/Out/filtered/$docfile/single") or die $!;
		open (NOENT, ">/data/bsarrafzadeh/OpenIE/InsightNG/reverb-master/Out/filtered/$docfile/noEntities") or die $!;
		#open (MAYBE, ">/data/bsarrafzadeh/OpenIE/InsightNG/reverb-master/Out/filtered/$docfile/PotentialEntities") or die $!;
		while (my $in = <IN>)
		{
			my $count = 0;
			
			chomp $in;
			my ($path, $sendID, $arg1, $rel, $arg2,
			    $arg1_start, $arg1_end, $rel_start, $rel_end, $arg2_start, $arg2_end,
			    $confidence,
			    $sentence, $POS_tags, $chunk_tags,
			    $arg1_normalized, $rel_normalized, $arg2_normalized) = split /\t/, $in;
			
			$arg1 =~ s/\s/_/g;
			$arg2 =~ s/\s/_/g;
			
			$arg1 = lc $arg1;
			$arg2 = lc $arg2;
			
			foreach my $entity (keys(%TFIDFentities))
			{
				my $LCentity = lc ($entity);
				if (! exists($stopWords{$LCentity}))
				{
					# check to see if these args *partially* match with high-ranked entities
					#if ($arg1 =~ /$entity/)
					if(index($arg1, $entity) != -1)
					{
						my $flag = 1;
						if($entity !~ /_/ && $arg1 !~ /_/ && length($entity) != length($arg1))
						{
							print "OO first argument $arg1 is NOT matched with $entity\n";
							$flag = 0;
						}
						elsif($entity !~ /_/ && $arg1 =~ /_/)
						{
							my @terms = split /_/, $arg1;
							foreach my $term (@terms)
							{
								if(index($term, $entity) != -1 && length($entity) != length($term)) # "man" shouldn't be matched with "the_Neiman"
								{
									print "OOO first argument $arg1 is NOT matched with $entity\n";
									$flag = 0;
								}
							}
						}
						if ($flag == 1)
						{
							print "## first argument $arg1 is matched with $entity";
							$count++;
							print " -- count is $count\n";
						}
					}
					#if ($arg2 =~ /$entity/)
					if(index($arg2, $entity) != -1)
					{
						my $flag = 1;
						if($entity !~ /_/ && $arg2 !~ /_/ && length($entity) != length($arg2))
						{
							print "OO second argument $arg2 is NOT matched with $entity\n";
							$flag = 0;
						}
						elsif($entity !~ /_/ && $arg2 =~ /_/)
						{
							my @terms = split /_/, $arg2;
							foreach my $term (@terms)
							{
								if(index($term, $entity) != -1 && length($entity) != length($term)) # "man" shouldn't be matched with "the_Neiman"
								{
									print "OOO second argument $arg2 is NOT matched with $entity\n";
									$flag = 0;
								}
							}
						}
						if ($flag == 1)
						{
							print "## second argument $arg2 is matched with $entity";
							$count++;
							print " -- count is $count\n";
						}
					}
					
					if ($count == 2)
					{
						print OUT "$confidence\t$arg1\t$rel\t$arg2\t$sentence\n";
						last;
					}
				}
			}
			
			if ($count == 1)
			{
				print SINLGE "$confidence\t$arg1\t$rel\t$arg2\t$sentence\n";
			}
			elsif ($count == 2)
			{
				;#print OUT "$confidence\t$arg1\t$rel\t$arg2\t$sentence\n";
			}
			else
			{
				print NOENT "$confidence\t$arg1\t$rel\t$arg2\t$sentence\n";
			}
		}
                close (OUT);
                close (SINGLE);
                close (NOENT);
	}	
}
sub checkType {
	my $relation = $_[0];
	my $mergeMode = $_[1];
	my $governPOS = $_[2];
	my $depPOS = $_[3];
	my $governWord = $_[4];
	my $depWord = $_[5];
	my $inBetweenWords = $_[6];

	my $mergeStatusStage1 = 0;
	my $mergeStatusStage2 = 0;

	if ($mergeMode == 1){ #i.e. if we are merging "nn", "amod" and "poss" relations
		#check if the type of the relation is correct
		if ($relation eq "nn"){
			$mergeStatusStage1 = 1;
		}elsif ($relation eq "amod"){
                        $mergeStatusStage1 = 1;
                }elsif ($relation eq "poss"){
			if ($depPOS =~ /NN/){
                        	$mergeStatusStage1 = 1;
			}
                }
		my $checkTtest = 1;
		if ($mergeStatusStage1 == 1){
			if ($depPOS =~ /NN/){
				if ($relation ne "poss"){
					$checkTtest = 0;
				}
			}
			if ($checkTtest == 1){
				#check t-test and/or MI
				my $rel = "";
				#my $MI = calcMI($governWord, $depWord, $rel, "");
				#print "\t<MI>$MI</MI>$governWord, $depWord, $rel\n";
				#if ($MI > 0){
				#	$mergeStatusStage2 = 1;
				#}
				#my $ttest = calcTtest($governWord, $depWord, $rel, "");
                        	#print "\t<T-TEST>$ttest</T-TEST>$governWord, $depWord, $rel\n";
                        	#if ($ttest >= 2.576){
				#if ($ttest > 0){
                        	       $mergeStatusStage2 = 1;
                        	#}
			}else{
				$mergeStatusStage2 = 1;
			}

		}
	}elsif ($mergeMode == 2){ # i.e. if we are merging prep_ and conj_and relations
		my $rel = "";
		if ($relation eq "prep_in"){
			$mergeStatusStage1 = 1;
		}elsif ($relation eq "prep_of"){
                        $mergeStatusStage1 = 1;
                }elsif ($relation eq "prep_on"){
                        $mergeStatusStage1 = 1;
                }elsif ($relation eq "prep_over"){
                        $mergeStatusStage1 = 1;
                }elsif ($relation eq "prep_under"){
                        $mergeStatusStage1 = 1;
                }elsif ($relation eq "prep_with"){
                        $mergeStatusStage1 = 1;
                }elsif ($relation eq "conj_and"){
                        $mergeStatusStage1 = 1;
                }
		my $checkTtest = 1;
                if ($mergeStatusStage1 == 1){
                        if ($depPOS =~ /NN/){
                                #check t-test and/or MI
                                #my $MI = calcMI($depWord, $governWord, $rel, $inBetweenWords);
				
                                #print "\t<MI>$MI</MI>$governWord<>$inBetweenWords<>$depWord\n";
                                #if ($MI > 0){
                                       $mergeStatusStage2 = 1;
                                #}
                                #my $ttest = calcTtest($depWord, $governWord, $rel, $article);
                                #print "\t<T-TEST>$ttest</T-TEST>$governWord, $depWord, $rel\n";
                                #if ($ttest >= 2.576){
                                #if ($ttest > 0){
                                #       $mergeStatusStage2 = 1;
                                #}
                        }

                }
	}
	return $mergeStatusStage2;
}
sub checkType_Limited {
	my $relation = $_[0];
	my $mergeMode = $_[1];
	my $governPOS = $_[2];
	my $depPOS = $_[3];
	my $governWord = $_[4];
	my $depWord = $_[5];
	my $inBetweenWords = $_[6];

	my $mergeStatusStage1 = 0;
	my $mergeStatusStage2 = 0;

	if ($mergeMode == 1){ #i.e. if we are merging "nn", "amod" and "poss" relations
		#check if the type of the relation is correct
		if ($relation eq "nn"){
			$mergeStatusStage1 = 1;
		}elsif ($relation eq "amod"){
                        $mergeStatusStage1 = 1;
                }elsif ($relation eq "poss"){
			if ($depPOS =~ /NN/){
                        	$mergeStatusStage1 = 1;
			}
                }
		my $checkTtest = 1;
		if ($mergeStatusStage1 == 1){
			if ($depPOS =~ /NN/){
				if ($relation ne "poss"){
					$checkTtest = 0;
				}
			}
			if ($checkTtest == 1){
				#check t-test and/or MI
				my $rel = "";
				#my $MI = calcMI($governWord, $depWord, $rel, "");
				#print "\t<MI>$MI</MI>$governWord, $depWord, $rel\n";
				#if ($MI > 0){
				#	$mergeStatusStage2 = 1;
				#}
				#my $ttest = calcTtest($governWord, $depWord, $rel, "");
                        	#print "\t<T-TEST>$ttest</T-TEST>$governWord, $depWord, $rel\n";
                        	#if ($ttest >= 2.576){
				#if ($ttest > 0){
                        	       $mergeStatusStage2 = 1;
                        	#}
			}else{
				$mergeStatusStage2 = 1;
			}

		}
	}
	elsif ($mergeMode == 2)
	{ # i.e. if we are merging prep_ and conj_and relations
		my $rel = "";
		if ($relation eq "prep_in")
		{
			$mergeStatusStage1 = 1;
		}
		elsif ($relation eq "prep_of")
		{
                        $mergeStatusStage1 = 1;
                }
		elsif ($relation eq "prep_on")
		{
                        $mergeStatusStage1 = 1;
                }
#		elsif ($relation eq "prep_over")
#		{
#                        $mergeStatusStage1 = 1;
#                }
#		elsif ($relation eq "prep_under")
#		{
#                        $mergeStatusStage1 = 1;
#                }
#		elsif ($relation eq "prep_with"){
#                        $mergeStatusStage1 = 1;
#                }
#		elsif ($relation eq "conj_and"){
#                        $mergeStatusStage1 = 1;
#                }
		my $checkTtest = 1;
                if ($mergeStatusStage1 == 1){
                        if ($depPOS =~ /NN/){
                                #check t-test and/or MI
                                my $MI = calcMI($depWord, $governWord, $rel, $inBetweenWords);
				
                                print "\t<MI>$MI</MI>$governWord<>$inBetweenWords<>$depWord\n";
                                if ($MI > 0){
                                       $mergeStatusStage2 = 1;
                                }
                                #my $ttest = calcTtest($depWord, $governWord, $rel, $article);
				my $ttest = calcTtest($depWord, $governWord, $rel, $inBetweenWords);
                                print "\t<T-TEST>$ttest</T-TEST>$governWord, $depWord, $rel\n";
                                if ($ttest >= 2.576){
                                if ($ttest > 0){
                                       $mergeStatusStage2 = 1;
                                }
				}
                        }

                }
	}
	return $mergeStatusStage2;
}

sub calcMI {
        my $NP1 = $_[0];
        my $NP2 = $_[1];
        my $rel = $_[2];
	my $inBetweenWords = $_[3];
        $NP1 =~ s/_/ /g;
        $NP2 =~ s/_/ /g;

        my $MI = 0;
        my $corpus = 13712600;
        #get frequency of the NP1 name
	my $NP1query = $NP1;
	$NP1query =~ s/\s+/ /g;
        my ($command ) = "\@count \"$NP1query\" \n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $NP1F = $response[0];
        #get frequency of the NP2
	my $NP2query = "$NP2 $inBetweenWords";
	$NP2query =~ s/\s+/ /g;
        my ($command ) = "\@count \"$NP2query\" \n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $NP2F = $response[0];
        #get joint frequency
	my $jointNP = "$NP2 $inBetweenWords $NP1";
	$jointNP =~ s/\s+/ /g;
	print "\t\t\t\t<MI-QUERIES><NP1>$NP1query<NP2>$NP2query<JOINT-NP>$jointNP<>\n";
        my ($command ) = "\@count \"$jointNP\" \n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $jointF = $response[0];

        #calculate MI
        my $probNP1 = $NP1F / $corpus;
        my $probNP2 = $NP2F / $corpus;
        my $jointProb = $jointF / $corpus;

        if ($jointProb > 0 && $probNP1 != 0 && $probNP2 != 0){
                $MI = log2($jointProb / ($probNP1 * $probNP2));
        }

        return $MI;
}
sub calcPMI {
        my $NP1 = $_[0];
        my $NP2 = $_[1];
        my $rel = $_[2];
	my $inBetweenWords = $_[3];
        $NP1 =~ s/_/ /g;
        $NP2 =~ s/_/ /g;

        my $PMI = 0;
        my $corpus = 13712600;
        #get frequency of the NP1 name
	my $NP1query = $NP1;
	$NP1query =~ s/\s+/ /g;
        my ($command ) = "\@count \"$NP1query\" \n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $NP1F = $response[0];
        #get frequency of the NP2
	my $NP2query = "$NP2 $inBetweenWords";
	$NP2query =~ s/\s+/ /g;
        my ($command ) = "\@count \"$NP2query\" \n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $NP2F = $response[0];
        #get joint frequency
	#my $jointNP = "$NP2 $inBetweenWords $NP1";
	my $jointNP = "$NP1^$NP2"; 
	$jointNP =~ s/\s+/ /g;
	print "\t\t\t\t<MI-QUERIES><NP1>$NP1query<NP2>$NP2query<JOINT-NP>$jointNP<>\n";
       # my ($command ) = "\@count \"$jointNP\" \n";
	my ($command ) = "\@count ((\"$NP1\"^\"$NP2\")<[10])<(\"<doc>\"..\"</doc>\")\n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $jointF = $response[0];

        #calculate MI
        my $probNP1 = $NP1F / $corpus;
        my $probNP2 = $NP2F / $corpus;
        my $jointProb = $jointF / (10 * $corpus);

	if ($jointProb > 0){
                if ($probNP1 > 0){
                        if ($probNP2 > 0){
                                $PMI = (log($jointProb / ($probNP1 * $probNP2)))/(-log($jointProb));
                        }
                }
        }
        return ($PMI, $jointF);
}
sub calcTtest {
        my $NP1 = $_[0];
        my $NP2 = $_[1];
        my $rel = $_[2];
	my $inBetweenWords = $_[3];
        $NP1 =~ s/_/ /g;
        $NP2 =~ s/_/ /g;

        my $ttest = 0;
        my $corpus = 13712600;
        #get frequency of the NP1 name
	my $NP1query = $NP1;
        $NP1query =~ s/\s+/ /g;
        my ($command ) = "\@count \"$NP1query\" \n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $NP1F = $response[0];
        #get frequency of the NP2
	my $NP2query = "$NP2 $inBetweenWords";
        $NP2query =~ s/\s+/ /g;
        my ($command ) = "\@count \"$NP2query\" \n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $NP2F = $response[0];
        #get joint frequency
	my $jointNP = "$NP2 $rel $inBetweenWords $NP1";
        $jointNP =~ s/\s+/ /g;
	print "\t\t\t\t<TTEST-QUERIES><NP1>$NP1query<NP2>$NP2query<JOINT-NP>$jointNP<>\n";
        my ($command ) = "\@count \"$jointNP\" \n";
        my (@response) = wumpusResponse($wumpus, $command);
        my $jointF = $response[0];

        #calculate t-test
        my $probNP1 = $NP1F / $corpus;
        my $probNP2 = $NP2F / $corpus;
        my $jointProb = $jointF / $corpus;

        if ($jointProb > 0 && $probNP1 != 0 && $probNP1 != 0){
                $ttest = ($jointProb - ($probNP1 * $probNP2) )/(sqrt($jointProb/$corpus));
        }else{
                #print "ERROR: $NP1\t$NP2\n";
        }
        return $ttest;
}

sub log2 {
        my $n = shift;
        return log($n)/log(2);
}
sub weightNPs {
	my %NPs = %{$_[0]};
	my %weightedNPs = ();
	foreach my $key (keys %NPs){
		my $NP = $NPs{$key};
		my $valid = 0; #validation whether the head of the NP is in the list of dish names
	        my $score = 0;
        	my $numWords = 0;
		my @elements = split / /, $NP;
		my $orderNum = 0;
        	my @newElements = ();
        	foreach my $tuple (@elements){
        	        if ($tuple ne ""){
        	                push @newElements, $tuple;
        	        }
        	}
        	my @reversedElements = reverse(@newElements);
        	for (my $a=0; $a<@reversedElements; $a++){
			my $tuple = $reversedElements[$a];
                  if ($tuple ne ""){
                        my $temp = $tuple;
                        $temp =~ s/^(\S+)_(.+)$/$1$2/;
                        my $word = $1;
                        my $role = $2;
                        my $wordLC = lc($word);
                        #print "<>$role<>$word<>\n";
                        if ($role =~ /NN/){
                                $numWords++;
                                #print "$word\n";
                                my $matched = 0;
                                my $matchingDish = "";
                                foreach my $dish (keys %dishes){
                                        if ($wordLC eq $dish){
                                                if ($matched == 0){
                                                        #print "\t$word\n";
                                                        #$score = $score + $dishes{$dish};
                                                        $matchingDish = $dish;
                                                        $matched = 1;
                                                        if ($a == 0){ #if head of the NP
                                                                #print "$a<>$tuple<>$NP<>\n";
                                                                $valid = 1;
                                                        }
                                                }
                                        }else{
                                                if ($matched == 0){
                                                        if ($role =~ /(NNS|NNPS)/){
                                                                my $singularWord = singularize($wordLC);
                                                                if ($singularWord eq $dish){
                                                                        #print "\t<PLURAL>$word<SINGULAR>$singularWord<>\n";
                                                                        #$score = $score + $dishes{$dish};
                                                                        $matchingDish = $dish;
                                                                        $matched = 1;
                                                                        if ($a == 0){ #if head of the NP
                                                                                #print "$a<>$tuple<>$NP<>\n";
                                                                                $valid = 1;
                                                                        }
                                                                }
                                                        }
                                                }
                                        }
                                }
                                $orderNum++;
                                my $discountScore = 0;
                                if (exists $dishes{$matchingDish}){
                                        $discountScore = $discounts{$orderNum} * $dishes{$matchingDish};
                                }
                                        ##print "$orderNum<>$word<>$NP<>$discountScore = $discounts{$orderNum} * $dishes{$matchingDish}\n";
                                $score = $score + $discountScore;
                                #$score = $score + $dishes{$matchingDish};
                                #$score = $score + $dishes{$matchingDish};

                        }else{
                                if ($role !~ /PRP|DT|CC|,|CD/){
                                        $numWords++;
                                }
                        }
                }
        }

        #get the final number of words in the NP
        #my @nounPhrase = split / /, $NP;
        #my $numWords = scalar(@nounPhrase);

        #calculate NP's score
        my $normScore = 0;
        if ($numWords > 0){
                $normScore = $score / $numWords;
        }
        if ($normScore > 0){
                if ($valid == 1){
                        $NP =~ s/_\w+//g;
                        #print OUT "$normScore\t$score\t$numWords\t$NPs{$NP}\t$sentID $wordID $NP\n";
                        my $roundedNormScore = sprintf("%.4f", $normScore);
                        #print "\t<WEIGHT>$roundedNormScore<>$NP<>\n";
			$weightedNPs{$key} = $roundedNormScore;
                }
        }
  }
  return %weightedNPs;
}
sub loadDiscounts{
        my %discounts = (

### no discount
#       '1' => '1',
#       '2' => '1',
#       '3' => '1',
#       '4' => '1',
#       '5' => '1',
#       '6' => '1',
#       '7' => '1',
#       '8' => '1',
#       '9' => '1',
#       '10' => '1',

### log-linear discount
#       '1' => '1',
#       '2' => '0.7',
#       '3' => '0.52',
#       '4' => '0.4',
#       '5' => '0.3',
#       '6' => '0.22',
#       '7' => '0.15',
#       '8' => '0.1',
#       '9' => '0.05',
#       '10' => '0',

### 0.5 discount
#       '1' => '1',
#       '2' => '0.5',
#       '3' => '0.5',
#       '4' => '0.5',
#       '5' => '0.5',
#       '6' => '0.5',
#       '7' => '0.5',
#       '8' => '0.5',
#       '9' => '0.5',
#       '10' => '0.5',

### linear discount
        '1' => '1',
        '2' => '0.9',
        '3' => '0.8',
        '4' => '0.7',
        '5' => '0.6',
        '6' => '0.5',
        '7' => '0.4',
        '8' => '0.3',
        '9' => '0.2',
        '10' => '0.1',

        );
        return %discounts;
}
sub loadTopicNums {
        my @topicNums = ();
        open (IN, "topic-numbers.txt") or die $!;
        while (my $in = <IN>){
                chomp $in;
                push @topicNums, $in;
        }
        close (IN);
        return @topicNums;
}