package apiOps;

use LWP;
use MIME::Base64;
use Switch;
use XML::Simple;
use XML::Parser;
use Data::Dumper;
use apiConfig;
use Logger;

my $apiConfig = new apiConfig;

###
sub new
{
    my $self = {};
    bless $self;
    return $self;
}

#### Main Action Dispatcher
sub apiAction {
	my ($self, $action, $input) = @_;
	
			switch($action) 
				{
					## Campaign Service
					case "readCampaignList"
						{
							my ($request, $hashOut, $xmlOut) = &readCampaignList($apiConfig->getService('campaignService'), "", $apiConfig->getConfigParam('pid'));
							return ($request, $hashOut, $xmlOut)
						}
					case "updatePausedStatus" { &updatePausedStatus($apiConfig->getService('campaignService'), $input) }
					case "updateDefaultBidStatus" { &updateDefaultBidStatus($apiConfig->getService('campaignService'), $input) }
					case "readMediaList" { &readMediaList($apiConfig->getService('campaignService')) }
					case "pauseMediaList" { &pauseMediaList($apiConfig->getService('campaignService'), $input) }
					case "playMediaList" { &playMediaList($apiConfig->getService('campaignService'), $input) }
					
					## Reporting Service
					case "getLatestReports" 
						{ 
							my ($request, $hashOut, $xmlOut) = &getLatestReports($apiConfig->getService('reportingService'), "getLatestReports", $input);
							return ($request, $hashOut, $xmlOut) 
						}
					case "getAvailableReports" 
						{ 
							my ($request, $hashOut, $xmlOut) = &getAvailableReports($apiConfig->getService('reportingService'), "getAvailableReports", $input);
							return ($request, $hashOut, $xmlOut) 
						}
					case "getReports" 
						{ 
							my ($request, $hashOut, $xmlOut) = &getReports($apiConfig->getService('reportingService'), "getReports", $input);
							return ($request, $hashOut, $xmlOut)
						}
					
					## Recommendation Service
					case "getLatestRecommendations" { &getLatestRecommendations($apiConfig->getService('recommendationService'),"getLatestRecommendations") }
					case "getAvailableRecommendations" { &getAvailableRecommendations($apiConfig->getService('recommendationService'),"getAvailableRecommendations") }
					case "getRecommendations" { &getRecommendations($apiConfig->getService('recommendationService'),"getRecommendations", $input) }
					
					## Cell Group Service
					case "readCellGroupList" 
						{ 
							my ($request, $hashOut, $xmlOut) = &readCellGroupList($apiConfig->getService('cellGroupService'), "", $input);
							return ($request, $hashOut, $xmlOut)
						}
					case "readCellGroup" { &readCellGroup($apiConfig->getService('cellGroupService'), $input) }
					case "readCompleteCellList" 
						{ 
							my ($request, $hashOut, $xmlOut) = &readCompleteCellList($apiConfig->getService('cellGroupService'), "", $input);
							return ($request, $hashOut, $xmlOut)
						}
					case "createCellGroup" { &createCellGroup($apiConfig->getService('cellGroupService')) }
					case "updateCellGroup" { &updateCellGroup($apiConfig->getService('cellGroupService'), $input) }
					case "deleteCellGroup" { &deleteCellGroup($apiConfig->getService('cellGroupService'), $input) }
					case "distributeCellList" 
						{ 
							#my ($request, $hashOut, $xmlOut) = 
                                                        &distributeCellList($apiConfig->getService('cellGroupService'), "", $input)
							#return ($request, $hashOut, $xmlOut)
						}
					case "acknowledgeRemovedCellList" 
						{ 
							#my ($request, $hashOut, $xmlOut) = 
							&acknowledgeRemovedCellList($apiConfig->getService('cellGroupService'), "", $input)
							#return ($request, $hashOut, $xmlOut)
						}
					
					## Bid Service
					case "readBidList"
						{ 
							my ($request, $hashOut, $xmlOut) = &readBidList($apiConfig->getService('bidService'), "", $input);
							return ($request, $hashOut, $xmlOut) 
						}
					case "createBidList" 
						{ 
							my ($request, $hashOut, $xmlOut) = &createBidList($apiConfig->getService('bidService'), "", $input);
							return ($request, $hashOut, $xmlOut)
						
						}
				}
}

#### Reporting Service
sub getLatestReports {
	my ($endUrl, $soapAction, $c_id) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <getLatestReports xmlns=\"http://adlearn.open.platform.advertising.com\">
    <request>
	<ns2:campaignId xmlns:ns2="http://adlearn.open.platform.advertising.com/reports/messages">$c_id</ns2:campaignId>
   </request>
  </getLatestReports>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

sub getAvailableReports {
	my ($endUrl, $soapAction, $c_id) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <getAvailableReports xmlns=\"http://adlearn.open.platform.advertising.com\">
    <request>
   	<ns2:campaignId xmlns:ns2="http://adlearn.open.platform.advertising.com/reports/messages">$c_id</ns2:campaignId>
   </request>
  </getAvailableReports>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

sub getReports {
	my ($endUrl, $soapAction, $input) = @_;
	my ($c_id, $date) = split(/,/, $input); # decode input string
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <getReports xmlns=\"http://adlearn.open.platform.advertising.com\">
   <request>
   	<ns2:campaignId xmlns:ns2="http://adlearn.open.platform.advertising.com/reports/messages">$c_id</ns2:campaignId>
   	<ns2:date xmlns:ns2="http://adlearn.open.platform.advertising.com/reports/messages">$date</ns2:date>
   </request>
  </getReports>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

#### Campaign Services
sub readCampaignList {
	my ($endUrl, $soapAction, $p_id) = @_;

my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <readCampaignListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   <partnerId xmlns="">$p_id</partnerId>
  </readCampaignListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;

	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

#### Bid Services
sub readBidList {
	my ($endUrl, $soapAction, $campId) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <readBidListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   <campaignId xmlns="">$campId</campaignId>
  </readBidListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

sub createBidList {
	my ($endUrl, $soapAction, $xmlMessage) = @_;
	
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

#### Cell Group Services
sub readCompleteCellList {
	my ($endUrl, $soapAction, $input) = @_;
	my ($campId, $cellGroupId, $pageIndex, $pageSize) = split(/-/, $input);
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <readCompleteCellListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
    <paging xmlns="" nil="false">
    	<pageSize>$pageSize</pageSize>
    	<pageNumber>$pageIndex</pageNumber>
    </paging>
   	<campaignId xmlns="">$campId</campaignId>
   	<cellGroupId xmlns="">$cellGroupId</cellGroupId>
  </readCompleteCellListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

sub distributeCellList {
	my ($endUrl, $soapAction, $cellData) = @_;
        my ($cellIdList) = $$cellData[0];
        my $log = $$cellData[1];
        my $pageSize = 200;
        my $logger = Logger->new();
	
	my $xmlCellIdList = '';
	my $counter = 0;
	my $block = 0;
	foreach $cellId (keys %{$cellIdList})
		{
			$counter++;
			$block++;
			
			$xmlCellIdList = $xmlCellIdList."        <id>$cellId</id>\n";
			
			if($block==$pageSize)
			{
				my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
				<SOAP-ENV:Envelope
				 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
				 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
				  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
				 <SOAP-ENV:Body>
				  <distributeCellListRequest xmlns=\"http://adlearn.open.platform.advertising.com\">
				   	 <cellIdList xmlns="">
				   	 	$xmlCellIdList
				   	 </cellIdList>
				  </distributeCellListRequest>
				 </SOAP-ENV:Body>
				</SOAP-ENV:Envelope>|;
						
					my ($request, $hashOut, $xmlOut) = &apiRequest($xmlMessage, $endUrl, $soapAction);
					$logger->write($log, "\n$xmlOut");
					
					$block = 0;
					$xmlCellIdList = '';
			}
	}
				
		my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
		<SOAP-ENV:Envelope
		 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
		 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
		  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
		 <SOAP-ENV:Body>
		  <distributeCellListRequest xmlns=\"http://adlearn.open.platform.advertising.com\">
		   	 <cellIdList xmlns="">
		   	 	$xmlCellIdList
		   	 </cellIdList>
		  </distributeCellListRequest>
		 </SOAP-ENV:Body>
		</SOAP-ENV:Envelope>|;
				
			my ($request, $hashOut, $xmlOut) = &apiRequest($xmlMessage, $endUrl, $soapAction);
			$logger->write($log, "\n$xmlOut");
}

sub readCellGroupList {
	my ($endUrl, $soapAction, $campId) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <readCellGroupListRequest xmlns=\"http://adlearn.open.platform.advertising.com\">
   	 <campaignId xmlns="">$campId</campaignId>
  </readCellGroupListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

sub acknowledgeRemovedCellList {
	my ($endUrl, $soapAction, $cellData) = @_;
        my ($cellIdList, $log) = $$cellData[0,1];
        my $pageSize = 1000;
        my $logger = Logger->new();

	
	my $xmlCellIdList = '';
	my $counter = 0;
	my $block = 0;
	foreach $rCellId (@$removedCellIdList)
		{
			$counter++;
			$block++;
			
			$xmlCellIdList = $xmlCellIdList."        <id>$rCellId->{'id'}</id>\n";
			
			if ($block==$pageSize)
			{
				my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
				<SOAP-ENV:Envelope
				 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
				 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
				  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
				 <SOAP-ENV:Body>
				  <acknowledgeRemovedCellListRequest
				    xmlns=\"http://adlearn.open.platform.advertising.com\">
				   	 <cellIdList xmlns="">
				   	 	$xmlCellIdList
				   	 </cellIdList>
				  </acknowledgeRemovedCellListRequest>
				 </SOAP-ENV:Body>
				</SOAP-ENV:Envelope>|;
						
					my ($request, $hashOut, $xmlOut) = &apiRequest($xmlMessage, $endUrl, $soapAction);
                                        $logger->write($log, "\n$xmlOut");					
					
					$block = 0;
					$xmlCellIdList = '';
			}
		}
			my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
			<SOAP-ENV:Envelope
			 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
			 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
			  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
			 <SOAP-ENV:Body>
			  <acknowledgeRemovedCellListRequest
			    xmlns=\"http://adlearn.open.platform.advertising.com\">
			   	 <cellIdList xmlns="">
			   	 	$xmlCellIdList
			   	 </cellIdList>
			  </acknowledgeRemovedCellListRequest>
			 </SOAP-ENV:Body>
			</SOAP-ENV:Envelope>|;
					
				my ($request, $hashOut, $xmlOut) = &apiRequest($xmlMessage, $endUrl, $soapAction);
                                $logger->write($log, "\n$xmlOut");
}

#### MAKE API REQUEST
sub apiRequest {
		my ($message, $endUrl, $soap_action) = @_;
	
		my $url = $apiConfig->getConfigParam('baseUrl').$endUrl; ## Build Request URL (base + service)
		my $length = length($message);  ## GET REQUEST LENGTH
		my $browser = new LWP::UserAgent;  ## NEW LWP Client
                $browser->ssl_opts(verify_hostname => 0);
		## HTTP HEADERS
		my $headers = HTTP::Headers->new(
		         'Host' => $apiConfig->getConfigParam('host'),
		         'Content-Type' => 'text/xml; charset=UTF-8',
		         'Content-Length' => $length,
		         'SOAPAction' => $soap_action,
		         'Authorization' => $apiConfig->getConfigParam('auth64')
		         );
		
		## MAKE THE HTTP REQUEST
		my $req = HTTP::Request->new("POST", $url, $headers, $message);
		my $res = $browser->request($req);
		
		if ($res->is_success)
			{
				my $xml = new XML::Simple (KeyAttr => {});
				my $data = $xml->XMLin($res->content);
				my $hashOut = Dumper($data);
				my $xmlOut = $xml->XMLout($data);
				return ($message, $hashOut, $xmlOut);
			}
		else
			{
				print "\n".$res->status_line;
				return ("1","1","Error: No API Data Available for request:\n\n$message\n");
			}
}		

1;
