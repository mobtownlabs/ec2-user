package bidUploader;

use DateFunctions;
use apiOps;
use apiConfig;
use dbiConfig;
use Logger;

my $logger = new Logger;

sub new
{
	my $self = {};
	bless $self;
	return $self;
}

sub pushBids {
	my ($self, $date, $hour, $lastDate, $lastHour, $log, $bidMode) = @_;
	$logger->write($log, "\n\n".DateFunctions->currentTime().": Pushing bids to AOL API\n");
	
	### DBI Setup
	my $dbi = dbiConfig->dbiConnect('');
	
	open(BIDS, ">/AOL_hourly/out/bidsTest.txt"); ####TEST
	
	my $xmlTop = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
	<SOAP-ENV:Envelope
	 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
	 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
	  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
	 <SOAP-ENV:Body>
	  <createBidListRequest
	    xmlns=\"http://adlearn.open.platform.advertising.com\">
	   <bidList xmlns="">\n|;
	   
	my $xmlBottom = qq|   </bidList>
	  </createBidListRequest>
	 </SOAP-ENV:Body>
	</SOAP-ENV:Envelope>
	|;
	
	$logger->write($log, "\n     -> Using Bid Mode: $bidMode\n");
	
	my $sql;
	if ($bidMode eq "CHANGED")
	{
		$sql = qq|
			SELECT this.cellid as cellid, this.bid as bid
			        FROM
			        (SELECT *
			                FROM
			                DisplayBidsQueueAol
			                WHERE date='$date'
			                        AND hour=$hour
			        ) this,
			        (SELECT *
			                FROM
			                DisplayBidsQueueAol
			                WHERE date='$lastDate'
			                        AND hour=$lastHour
			        ) last
			
			WHERE this.cellid=last.cellid
			        AND this.bid <> last.bid
			ORDER BY this.cellid
				|;
	}
	else
	{	
		$sql = qq|
			SELECT cellid as cellid, bid as bid
				FROM DisplayBidsQueueAol
				WHERE
					date='$date'
					AND hour=$hour
			ORDER BY cellid
		|;
	}			
		my $sth = $dbi->prepare($sql);
		$sth->execute;
		my $bidList = $sth->fetchall_hashref(cellid);
		$sth->finish();
		
		$logger->write($log, DateFunctions->currentTime().": ".keys(%{$bidList})." bids to be updated\n");
		
		###UPLOAD BIDS INCREMENTALLY
		my $ac = new apiConfig;
		my $xmlBody = '';
		my $blockCounter = 0;
		my $totalCounter = 0;
		foreach $cellid (sort keys %{$bidList})
			{
				$blockCounter++;
				$totalCounter++;
				
				my $bid = sprintf("%.2f", $$bidList{$cellid}{'bid'});
				$xmlBody=$xmlBody.qq|    <bid xmlns="">\n     <cellId xmlns="">$cellid</cellId><amount xmlns="">$bid</amount>\n    </bid>\n|;
				
				if ($blockCounter == $ac->getCommonParam('bidIncrement'))
					{
						my $xmlMessage = $xmlTop.$xmlBody.$xmlBottom;
						print BIDS $xmlMessage; ####TEST
					
						### Make the API Request
						my $ao = new apiOps;
						my ($request, $hashOut, $xmlOut) = $ao->apiAction("createBidList", $xmlMessage);
						my $bidStart = ($totalCounter - $blockCounter) + 1;
						$logger->write($log, "\n+------------------------------------------------------+");
						$logger->write($log, "\nBids $bidStart --> $totalCounter");
						$logger->write($log, "\n$xmlOut");
						$blockCounter=0;
						$xmlBody = '';
					}
				
			}
		
			my $xmlMessage = $xmlTop.$xmlBody.$xmlBottom;
			print BIDS $xmlMessage; ####TEST
		
			### Make the API Request
			my $ao = new apiOps;
			my ($request, $hashOut, $xmlOut) = $ao->apiAction("createBidList", $xmlMessage);
			my $bidStart = ($totalCounter - $blockCounter) + 1;
			$logger->write($log, "\n+------------------------------------------------------+");
			$logger->write($log, "\n\nBids $bidStart --> $totalCounter");
			$logger->write($log, "\n$xmlOut");
			
		$logger->write($log, DateFunctions->currentTime().": bids done being updated\n");
		
	### UPLOAD MANUAL BIDS
		print BIDS "\n\nMANUAL BIDS\n";
	
		my $sql = qq|
			SELECT cdo.id as id,m.adid,m.siteid,m.segmentid,m.bid
			FROM cdoDataAOL cdo, ManualBidsAOL m
				WHERE cdo.adid=m.adid
       			AND cdo.siteid=m.siteid
        		AND cdo.segmentid=m.segmentid
					|;
					
		my $sth = $dbi->prepare($sql);
		$sth->execute;
		my $manualBidList = $sth->fetchall_hashref(id);
		$sth->finish();
		$dbi->disconnect();
		
		$logger->write($log, DateFunctions->currentTime().": ".keys(%{$manualBidList})." MANUAL bids to be uploaded\n");
		
	if (keys(%{$manualBidList}) > 0)
	{
		my $xmlBody = '';
		my $blockCounter = 0;
		my $totalCounter = 0;
		foreach $cellid (sort keys %{$manualBidList})
			{
				$blockCounter++;
				$totalCounter++;
				
				my $bid = sprintf("%.2f", $$manualBidList{$cellid}{'bid'});
				$xmlBody=$xmlBody.qq|    <bid xmlns="">\n     <cellId xmlns="">$cellid</cellId><amount xmlns="">$bid</amount>\n    </bid>\n|;
				
				if ($blockCounter == $ac->getCommonParam('bidIncrement'))
					{
						my $xmlMessage = $xmlTop.$xmlBody.$xmlBottom;
						print BIDS $xmlMessage; ####TEST
					
						### Make the API Request
						my $ao = new apiOps;
						my ($request, $hashOut, $xmlOut) = $ao->apiAction("createBidList", $xmlMessage);
						my $bidStart = ($totalCounter - $blockCounter) + 1;
						$logger->write($log, "\n+------------------------------------------------------+");
						$logger->write($log, "\nBids $bidStart --> $totalCounter");
						$logger->write($log, "\n$xmlOut");
						$blockCounter=0;
						$xmlBody = '';
					}
				
			}
		
			my $xmlMessage = $xmlTop.$xmlBody.$xmlBottom;
			print BIDS $xmlMessage; ####TEST
		
			### Make the API Request
			my $ao = new apiOps;
			my ($request, $hashOut, $xmlOut) = $ao->apiAction("createBidList", $xmlMessage);
			my $bidStart = ($totalCounter - $blockCounter) + 1;
			$logger->write($log, "\n+------------------------------------------------------+");
			$logger->write($log, "\n\nBids $bidStart --> $totalCounter");
			$logger->write($log, "\n$xmlOut");
			
		$logger->write($log, DateFunctions->currentTime().": bids done being updated\n");
	}
	else 
	{
	    $logger->write($log, DateFunctions->currentTime().": NO MANUAL BIDS\n");	
	}
}

1;
		
		
