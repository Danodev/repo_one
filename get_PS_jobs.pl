#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use DBI;
use LWP::Simple;
use LWP::UserAgent;
use HTML::TreeBuilder::XPath;
use CGI::Session;



# Globals
# Global Affairs request
my $global_affairs_url =  "https://emploisfp-psjobs.cfp-psc.gc.ca/psrs-srfp/applicant/page2440?classificationInfos=&locationsFilter=&selectionProcessNumber=&officialLanguage=&title=&tab=1&search=Search%20jobs&department=48&departments=&log=false";
my $global_affairs_url2 = "https://emploisfp-psjobs.cfp-psc.gc.ca/psrs-srfp/applicant/page2440?classificationInfos=&locationsFilter=&selectionProcessNumber=&officialLanguage=&title=&tab=1&search=Search%2520jobs&department=48&departments=&log=false&isSecondPartOfPage=1";
my $filename = "content.txt";

# Start the work
print "Starting search...\n";


my $session = new CGI::Session(undef, undef, {Directory=>'/tmp'});
print $session->id() . " here \n";

# Call to get HTML
my $response = getURLResponse($global_affairs_url);
if($response ne 'ERROR') {

	#Make 2nd caller
	print "2nd URL call...\n";
	$response = getURLResponse($global_affairs_url2);
	if($response ne 'ERROR') {	
		#Save to a file  
		saveToFile($response);
		print "Response saved to file.\n";
		
		# Now find the results
		print "Saved content to file. Now getting jobs...\n";
		my $tree = HTML::TreeBuilder::XPath->new_from_file($filename);
		
		my @jobs = $tree->findnodes('/span/ol/li[@class="searchResult"');
		
		#Print array size
		print scalar @jobs . "\n";
	}
}



# End the work
print "Complete...\n";



# Subroutines
sub getURLResponse {
	my $url = shift;
	my $ua = LWP::UserAgent->new;
	
	# set the header fields
	my $req = HTTP::Request->new(GET => $url);
		$req->header('Accept' => 'text/html, application/xhtml+xml, */*');	
		$req->header('Referer' => 'https://emploisfp-psjobs.cfp-psc.gc.ca/psrs-srfp/applicant/page2440?fromMenu=true&toggleLanguage=en');
		$req->header('Accept-Language' => 'en-CA,en-US;q=0.5');	
		$req->header('User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko');
		$req->header('Accept-Encoding' => 'gzip, deflate, peerdist');
		$req->header('Host' => 'emploisfp-psjobs.cfp-psc.gc.ca');
		$req->header('Connection' => 'Keep-Alive');	
		$req->header('Cookie' => 'JSESSIONID=oOKBzZDseuG_A_SMu8zeUg53v1_tsIgxBFS5F8XlOyHuuoRMK7cw!-1818495822; _ga=GA1.2.439562069.1509622935');	
		$req->header('X-P2P-PeerDist' => 'Version=1.0');
	
#JSESSIONID=wqA92SlYxw3SB8NKeFeKMMREj4s3ynBA9-6TIZ63ZRZPVmnwohle!-620073390; _ga=GA1.2.1924536897.1496857590
#JSESSIONID=y_hSadRpoRJugFXQd8Y0Wg_Xhlhe2hzdc3cl7kJpeW9sDwPR39Rp!-620073390; _ga=GA1.2.1924536897.1496857590
#JSESSIONID=oOKBzZDseuG_A_SMu8zeUg53v1_tsIgxBFS5F8XlOyHuuoRMK7cw!-1818495822; _ga=GA1.2.439562069.1509622935		
	
	my $resp = $ua->request($req);
	if ($resp->is_success) {
		#Print the response headers
		#print $resp->headers()->as_string;
		my $content = $resp->decoded_content;
		return $content;
	}
	else {
		print "HTTP GET error code: ", $resp->code, "\n";
		print "HTTP GET error message: ", $resp->message, "\n";
	}	
	return "ERROR";
}


sub saveToFile {

	unlink($filename);

	my $html = shift;
	open(HANDLE, ">$filename");
	
	print HANDLE $html;
	close HANDLE;
}


