#!/usr/bin/perl -w
use WWW::Spider;

my $spider = new WWW::Spider;
$spider = new WWW::Spider({UASTRING=>"ChuiBot"});
 
print $spider->uastring . "\n";
$spider->uastring('New UserAgent String');
$spider->user_agent(new LWP::UserAgent);
 
#basic stuff
#print $spider->get_page_response('http://search.cpan.org/') -> content;
#print $spider->get_page_content('http://search.cpan.org/');
@urls = $spider->get_links_from('http://www.greenmediaagency.com/'); #get array of URLs
foreach(@urls){
	print $_ . "\n";
}