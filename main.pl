#!/usr/bin/perl -w
use strict;
use warnings;
use WWW::Spider;
use HTML::Parser;

sub main{
=begin
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

 	print "I've just get the content\n";
=cut

  	my $parser = HTML::Parser->new(api_version => 3);
  	$parser->handler( start => \&start_handler, "tagname,self");
  	$parser->parse_file(shift || die) || die $!;
  	print "\n";
}

sub start_handler{
    return if shift ne "title";
    my $self = shift;
    $self->handler(text => sub { print shift }, "artificial_intelligence.txt");
    $self->handler(end  => sub { shift->eof if shift eq "title"; }, "tagname,self");
}

main(@ARGV);