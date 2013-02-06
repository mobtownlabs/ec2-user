package campOps;

use dbiConfig;
use commonData;
use apiOps;
use apiUtils;
use apiConfig;
use cellOps;
use Logger;
use DateFunctions;
use populateCDO;
use fileUtils;

my $logger = new Logger;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub checkNewCamps
{
	my($self, $dow, $hour, $log) = @_;
	
	#DBI
	my $dbi = dbiConfig->dbiConnect('');
	
	$logger->write($log, "\n\n".DateFunctions->currentTime().": Checking for new Campaigns...");
	
	# Objects Needed
	my $cd = new commonData;
	my $ao = new apiOps;
	my $au = new apiUtils;
	my $ac = new apiConfig;
	my $ceo = new cellOps;
        my $popCDO = new populateCDO;
        my $fu = new fileUtils;
	
	# Get current campaigns
	my $campRef = $cd->getCampaigns('hash');
	
	# Get campaign list from api
	my ($request, $hashOut, $xmlOut) = $ao->apiAction("readCampaignList");
	#print $xmlOut;
	my $cI = $au->readCampaignInfo($xmlOut);
	
	# New Campaign Hash
	my %newCamp = ();
	my $newCamp = \%newCamp;
	my $campCount = 0;
	
	foreach my $c (@$cI)
		{
		my $san = $c->{'deliveryInformation'}{'systemAccountName'}; $san =~ s/\s//g;
		if (!$campRef->{$san})
			{
                            $campCount++;

                            my $newDir = $ac->getCommonParam('localImportDir')."/".$c->{'id'};
                            $fu->newImportDir($newDir);
                            
                            my $sql = "INSERT INTO Campaign (san, advertiser, totalbudget, network, cid, isapi, timestatus) VALUES ('$san',".$ac->getCommonParam('defaultAdvertiserId').",".$ac->getCommonParam('defaultBudget').",1,".$c->{'id'}.",1,1)";
                            my $sth = $dbi->prepare($sql);
                            $sth->execute();
                            $logger->write($log, "\n$sql");

                            ## GET CELLS FOR NEW CAMPAIGNS
                            #$popCDO->getExistingCells($c->{'id'}, $san, $log);
                            #$popCDO->getNewCells($c->{'id'}, $san, $log);
                            
                            $newCamp{$c->{'id'}}{'san'} = $san;
                            
                            if (!$sth->err)
                            {
                                $logger->write($log, "\n$san added successfully!");
                                $sth->finish();
                            }
			}
		}
	
		if($campCount == 0)
		{
			$logger->write($log, "\n           -> No new campaigns.");
		}
		
	#disconnect from dbi
	$dbi->disconnect();
	
	return($cI, $newCamp);		
}

sub updateCampaignStatus
{
	my($self, $log) = @_;
	my $cd = new commonData;
	
	#DBI
	my $dbi = dbiConfig->dbiConnect('');
	
	$logger->write($log, "\n\n".DateFunctions->currentTime().": Checking Each Campaign Status...");
	
	my ($newCamps) = $cd->getNewCampaigns('hash');
	my $countNewCamps = keys(%{$newCamps});
	
	if($countNewCamps == 0)
	{
		$logger->write($log, "\n           -> ALL campaigns in highest data mode.");
	}
	else
	{
		foreach my $san (sort keys %{$newCamps})
		{
			if ($$newCamps{$san}{'timeStatus'} == 1)
			{
				my ($campData) = $cd->getCampaignImpsData("hour", $san);
				my $hours = keys(%{$campData});
				if ($hours == 24)
				{
					my $sql = qq|UPDATE Campaign SET timeStatus=2 WHERE san='$san'|;
					my $sth = $dbi->prepare($sql);
					$sth->execute();
					$sth->finish();
					
					$logger->write($log, "\n           -> $san now in HOURLY mode.");
				}
				else
				{
					$logger->write($log, "\n           -> $san only has $hours hours of valid data, remaining in LOC mode.");
				}
			}
			if ($$newCamps{$san}{'timeStatus'} == 2)
			{
				my ($campData) = $cd->getCampaignImpsData("dowHour", $san);
				my $hours = keys(%{$campData});
				if ($hours == 168)
				{
					my $sql = qq|UPDATE Campaign SET timeStatus=3 WHERE san='$san'|;
					my $sth = $dbi->prepare($sql);
					$sth->execute();
					$sth->finish();
					
					$logger->write($log, "\n           -> $san now in DOW-HOURLY mode.");
				}
				else
				{
					$logger->write($log, "\n           -> $san only has $hours dow-hours of valid data, remaining in HOURLY mode.");
				}
			}
		}
	}
	undef %{$newCamps};
	$dbi->disconnect();
}

1;
