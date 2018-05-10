#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use DBI;
use LWP::Simple;
use LWP::UserAgent;
use HTML::TreeBuilder::XPath;

# Globals
# Global Affairs request
my $myurl = "http://10.209.102.135:9080/vac-rules/api/adjudication/execute";
my $filename = "content.txt";

# Start the work
print "Starting search...\n";

# Call to get HTML
my $response = getURLResponse($myurl);
if($response ne 'ERROR') {
	
	print "Here's the content: \n\n\n";
	print $response . "\n";
	#Save to a file  
		#saveToFile($response);
} else {
	print "Error happended";
}

# End the work
print "Complete...\n";
print "Complete...\n";
print "Complete...\n";

# Subroutines
sub getURLResponse {
	my $url = shift;
	my $ua = LWP::UserAgent->new;
	
	my @ns_headers = (
				'User-Agent' 		=> 'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko',
				'Accept' 			=> 'text/html, application/xhtml+xml, */*',
				'Accept-Charset' 	=> 'iso-8859-1,*,utf-8', 'Accept-Language' => 'en-US',
	);

  
	
	# set the header fields
	my $response = $ua->post( $url, { 
						'todaysDate' => '2017-09-15', 
						'clientFirstContactDate' => '2009-10-01', 
						'clientDateOfIntent' => '2009-09-01', 
						'language' => '1', 
						'sessionClientOracleId' => '400319034100',
						'sessionVeteranOracleId' => '400319034100',
						'clientRole' => '0',
						'benefitTypeCode' => '1',
						'veteranInTheirOwnRightRate' => 'false',
						'lastAdjudicationEpisodeId' => '0',
						'firstEventDate' => '2034-12-31'},
						@ns_headers				);
						
						
	my $chunked = $response->header( 'Client-Transfer-Encoding' );
				
	if($chunked eq 'chunked') {
		print "Chunking going on here \n";
	}
	
	print $response->headers_as_string;
	
	

	return $response->decoded_content();	
	

}


sub saveToFile {

	unlink($filename);

	my $html = shift;
	open(HANDLE, ">$filename");
	
	print HANDLE $html;
	close HANDLE;
}


