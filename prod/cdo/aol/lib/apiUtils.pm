package apiUtils;

use LWP;
use XML::Simple;
use MIME::Base64;
use apiConfig;

my $apiConfig = new apiConfig;

###
sub new
{
    my $self = {};
    bless $self;
    return $self;
}

### REPORTING SERVICE
##
######### getLatestReports
sub getLatestHourlyFileAttrib {
	my ($self, $xmlOut) = @_;
	my $xml = new XML::Simple (KeyAttr=>{});
	my $data = $xml->XMLin($xmlOut);
		my $date = $data->{'s:Body'}{'getLatestReportsResponse'}{'getLatestReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:hourlyFileList'}{'b:fileInfo'}{'b:date'};
		my $hour = $data->{'s:Body'}{'getLatestReportsResponse'}{'getLatestReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:hourlyFileList'}{'b:fileInfo'}{'b:fileNumber'};
		my $url = $data->{'s:Body'}{'getLatestReportsResponse'}{'getLatestReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:hourlyFileList'}{'b:fileInfo'}{'b:url'};
		
	return($date, $hour, $url);
}

###
sub getLatestHourlyFile {
	my ($self, $date, $hour, $url, $localDir) = @_;
	my $hour--;
	my $browser = new LWP::UserAgent;
	my $headers = HTTP::Headers->new( 'Authorization' => $apiConfig->getConfigParam('auth64') );
	$browser->default_headers($headers);
	my $res = $browser->mirror($url, "$localDir/hourly/hourly\_$date\_$hour.csv");
}

###
sub getLatestDailyFileAttrib {
	my ($self, $xmlOut) = @_;
	my $xml = new XML::Simple (KeyAttr=>{});
	my $data = $xml->XMLin($xmlOut);
		my $date = $data->{'s:Body'}{'getLatestReportsResponse'}{'getLatestReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:dailySummaryFileList'}{'b:fileInfo'}{'b:date'};
		my $url = $data->{'s:Body'}{'getLatestReportsResponse'}{'getLatestReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:dailySummaryFileList'}{'b:fileInfo'}{'b:url'};
		
	return($date, $url);
}

###
sub getLatestDailyFile {
	my ($self, $date, $url) = @_;

	my $browser = new LWP::UserAgent;
	my $headers = HTTP::Headers->new( 'Authorization' => $apiConfig->getConfigParam('auth64') );
	$browser->default_headers($headers);
	my $res = $browser->mirror($url, "/sandbox/AOL\_hourly/DataFlows/in/daily\_$date.csv");
}

###
sub getLatestMTDFileAttrib {
	my ($self, $xmlOut) = @_;
	my $xml = new XML::Simple (KeyAttr=>{});
	my $data = $xml->XMLin($xmlOut);
		my $date = $data->{'s:Body'}{'getLatestReportsResponse'}{'getLatestReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:monthToDateFileList'}{'b:fileInfo'}{'b:date'};
		my $url = $data->{'s:Body'}{'getLatestReportsResponse'}{'getLatestReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:monthToDateFileList'}{'b:fileInfo'}{'b:url'};
		
	return($date, $url);
}

###
sub getLatestMTDFile {
	my ($self, $date, $url) = @_;

	my $browser = new LWP::UserAgent;
	my $headers = HTTP::Headers->new( 'Authorization' => $apiConfig->getConfigParam('auth64') );
	$browser->default_headers($headers);
	my $res = $browser->mirror($url, "/sandbox/AOL\_hourly/DataFlows/in/mtd\_$date.csv");
}

######### getReports
sub getHourlyFileAttrib {
	my ($self, $xmlOut, $hour) = @_;
	$hour++;
	my $xml = new XML::Simple (KeyAttr => [], ForceArray => ['b:fileInfo']);
	my $data = $xml->XMLin($xmlOut);
		my $fileInfo = $data->{'s:Body'}->{'getReportsResponse'}->{'getReportsResult'}->{'a:reportingFiles'}->{'b:reportingFileInformation'}->{'b:hourlyFileList'}->{'b:fileInfo'};
		
		my $url;
		foreach my $fi (@$fileInfo)
			{
				if ($fi->{'b:fileNumber'} == $hour)
					{
						$url = $fi->{'b:url'};
						last;
					}
			}
		print "\n$url";
	return($url, $fileInfo);
}

###
sub getHourlyFile {
	my ($self, $date, $hour, $url, $localDir, $campId, $returnFile) = @_;
			my $browser = new LWP::UserAgent;
			my $headers = HTTP::Headers->new( 'Authorization' => $apiConfig->getConfigParam('auth64') );
			$browser->default_headers($headers);
                        $browser->ssl_opts(verify_hostname => 0);
			
			my $file = "$campId\_hourly\_$date\_$hour.csv";
			my $res = $browser->mirror($url, "$localDir/hourly/$file");

        if($returnFile==1)
        {
            if ($res->is_error)
            {
                return (0,$res->status_line);
            }
			
            else 
            {
		return ($file, $res->status_line);
            }
        }
}

###
sub getDailyFileAttrib {
	my ($self, $xmlOut) = @_;
	my $xml = new XML::Simple ( KeyAttr => {} );
	my $data = $xml->XMLin($xmlOut);
		my $date = $data->{'s:Body'}{'getReportsResponse'}{'getReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:dailySummaryFileList'}{'b:fileInfo'}{'b:date'};
		my $url = $data->{'s:Body'}{'getReportsResponse'}{'getReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:dailySummaryFileList'}{'b:fileInfo'}{'b:url'};
		
	return($date, $url);
}

###
sub getDailyFile {
	my ($self, $date, $url, $localDir, $campId, $returnFile) = @_;
	if (!$url || $url eq '')
		{
			print "ERROR: No file for that date\n";
		}
	else
		{
			my $browser = new LWP::UserAgent;
			my $headers = HTTP::Headers->new( 'Authorization' => $apiConfig->getConfigParam('auth64') );
			$browser->default_headers($headers);
			
			my $file = "$campId\_daily\_$date.csv";
			my $res = $browser->mirror($url, "$localDir/daily/$file");
			
			if ($returnFile==1)
				{
					return $file;
				}
		}
}

###
sub getMTDFileAttrib {
	my ($self, $xmlOut) = @_;
	my $xml = new XML::Simple (KeyAttr=>{});
	my $data = $xml->XMLin($xmlOut);
		my $date = $data->{'s:Body'}{'getReportsResponse'}{'getReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:monthToDateFileList'}{'b:fileInfo'}{'b:date'};
		my $url = $data->{'s:Body'}{'getReportsResponse'}{'getReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:monthToDateFileList'}{'b:fileInfo'}{'b:url'};
		
	return($date, $url);
}

###
sub getMTDFile {
	my ($self, $date, $url, $localDir, $campId) = @_;
	if (!$url || $url eq '')
		{
			print "ERROR: No file for that date\n";
		}
	else 
		{
			print "Getting $url\n";
			my $browser = new LWP::UserAgent;
			my $headers = HTTP::Headers->new( 'Authorization' => $apiConfig->getConfigParam('auth64') );
			$browser->default_headers($headers);
			my $res = $browser->mirror($url, "$localDir/mtd/$campId\_mtd\_$date.csv");
		}
}

#### CAMPAIGN SERVICE
###
###### readCampaignList
sub readCampaignInfo {
	my ($self, $xmlOut) = @_;
	my $xml = new XML::Simple (KeyAttr => [], ForceArray => ['campaign']);
	my $camps = $xml->XMLin($xmlOut);
		my $campaignInfo = $camps->{'soap:Body'}{'ns2:readCampaignListResponse'}{'campaignList'}{'campaign'};
		
	return($campaignInfo);
}

#### CELL GROUP SERVICE
###
###### readCompleteCellList
sub readCellInfo {
	my ($self, $xmlOut, $pageIndex) = @_;
	my $xml = new XML::Simple (KeyAttr => [], ForceArray => ['cell']);
	my $cells = $xml->XMLin($xmlOut);
		my $cellInfo = $cells->{'soap:Body'}{'ns2:readCompleteCellListResponse'}{'cellList'}{'cell'};
		
	return($cellInfo, $pageIndex);
}

sub readCellGroupInfo {
	my ($self, $xmlOut, $getSpec, $groupName) = @_;
	my $xml = new XML::Simple (KeyAttr => [], ForceArray => ['cellGroup']);
	my $cellGroups = $xml->XMLin($xmlOut);
		my $result = $cellGroups->{'soap:Body'}{'ns2:readCellGroupListResponse'}{'resultList'}{'result'};
		if ($result->{'type'} eq "FAILURE")
			{
				return("Paused", "N/A");
			}
		else 
			{
				my $cellGroupInfo = $cellGroups->{'soap:Body'}{'ns2:readCellGroupListResponse'}{'groupList'}{'cellGroup'};
				
				if($getSpec == 1)
					{
						foreach my $cgi (@$cellGroupInfo)
							{
								if ($cgi->{'groupType'} eq $groupName)
									{
										return($cgi->{'id'}, $cgi->{'groupType'});
										last;
									}
							}
					}
				
				else 
					{
						return($cellGroupInfo);	
					}
		}
}

#### BID SERVICE
###
###### readBidList
sub readBidInfo {
	my ($self, $xmlOut) = @_;
	my $xml = new XML::Simple (KeyAttr => [], ForceArray => ['bid']);
	my $bids = $xml->XMLin($xmlOut);
		my $bidArray = $bids->{'soap:Body'}{'ns2:readBidListResponse'}{'bidList'}{'bid'};
	
	my %bidInfo = ();
	my $bidInfo = \%bidInfo;
	
		foreach $bid (@$bidArray)
			{
				$bidInfo{$bid->{'cellId'}}{'bid'} = $bid->{'amount'};
				$bidInfo{$bid->{'cellId'}}{'bidId'} = $bid->{'id'};
			}

	return($bidInfo);
}

#### RECOMMENDATION SERVICE
###
###### getRecommendations
sub getPriceVolumeCellFile
{
	my ($self, $date, $url, $localDir, $campId, $returnFile) = @_;
		my $browser = new LWP::UserAgent;
		my $headers = HTTP::Headers->new( 'Authorization' => $apiConfig->getConfigParam('auth64') );
		$browser->default_headers($headers);
                $browser->ssl_opts(verify_hostname => 0);
		
		my $file = "$campId\_pv\_$date.csv";
		my $res = $browser->mirror($url, "$localDir/priceVolume/$file");
		#print "\n".$res->is_error;
		
	if ($returnFile==1)
	{
			return($file);
	}
}

1;
