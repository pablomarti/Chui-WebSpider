#!/usr/bin/perl -w
use strict;
use warnings;
use WWW::Spider;

sub main{
	my $website = "http://en.wikipedia.org/wiki/Artificial_intelligence";
	my $spider = new WWW::Spider;

	$spider = new WWW::Spider({UASTRING => "30Bbot"});
	 
	print $spider->uastring . "\n";
	$spider->uastring('New UserAgent String');
	$spider->user_agent(new LWP::UserAgent);
	 
	my $content = $spider->get_page_content($website);
	open (CONTENT_FILE, '>>artificial_intelligence.txt');
 	print CONTENT_FILE $content;
 	close (CONTENT_FILE); 
	
	my @urls = $spider->get_links_from($website);
	open (URL_FILE, '>>artificial_intelligence_links.txt');
	foreach my $url (@urls){
 		print URL_FILE "$url\n";
	}
 	close (URL_FILE); 

 	print "Bye...\n";
}

main(@ARGV);