#!/usr/bin/perl -w
use strict;
use warnings;
use WWW::Spider;
use Marpa::HTML qw(html);
use Data::Inspect;

sub main{
  	my $insp = Data::Inspect->new;
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

    my $old_title = '<title>Old Title</title>A little html text';
    my $new_title = html(
        \$old_title,
        {   'title' => sub { return '<title>New Title</title>' }
        }
    );
  	my $insp = Data::Inspect->new;
  	$insp->p($new_title);
    print $new_title,title;
=cut

   	#my $with_table = 'Text<table><tr><td>I am a cell</table> More Text';
   	#my @attributes = Marpa::HTML::attributes($with_table);
   	#$insp->p(@attributes);

   	my $with_table = 'Text<table><tr><td>I am a cell</table> More Text';
    my %handlers_to_keep_only_tables = (
        table  => sub { return Marpa::HTML::original() },
        ':TOP' => sub { return \( join q{}, @{ Marpa::HTML::values() } ) }
    );
    my $only_table = html( \$with_table, \%handlers_to_keep_only_tables );
    print $only_table.value;;
}

main(@ARGV);