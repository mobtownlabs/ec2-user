package campConfig;

use mediaOps;
use campOps;
use cellOps;
use commonData;
use apiOps;
use apiConfig;
use DateFunctions;
use Logger;
use populateCDO;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub downstreamImport
{	
	my ($self, $dow, $hour, $log) = @_;
	
	my $co = new campOps;
	my $mo = new mediaOps;
	my $ceo = new cellOps;
	my $cd = new commonData;
	my $ao = new apiOps;
	my $ac = new apiConfig;
	my $logger = new Logger;
        my $popCDO = new populateCDO;
	
	# Update Current Campaign Status
		#$co->updateCampaignStatus($log);
	
	# New Campaign Check
		my ($cI, $newCamp) = $co->checkNewCamps($dow, $hour, $log);
		
	# New Media Check
		$mo->checkNewMedia($cI, $log);
	
	# New Cell Check/Cell Cleanup
	my $import = &checkCellImportHour($hour);
	if($import == 1) ### Only do cell import for certain hours (see apiConfig)
	{
	
		foreach my $c (@$cI)
			{
                            my $san = $c->{'deliveryInformation'}{'systemAccountName'}; $san =~ s/\s//g;
                            my $cid = $c->{'id'};

                            #$popCDO->getNewCells($cid, $san, $log);
                            #$popCDO->markOldCells($cid, $san, $log);
			}
 
                #$popCDO->groupNewCells($log);
                #$popCDO->removeOldCells($log);
                #$popCDO->updateNetwork($log);
	}
}


###LOCAL SUBS
sub checkCellImportHour
{
	my ($hour) = @_;
	my $ac = new apiConfig;
	my $dsHours = $ac->getCommonParam('hourToImportCells');
	my @dsHours = split(/-/, $dsHours);
	my $import = 0;
	
	foreach my $ds (@dsHours)
	{
		if($ds == $hour)
		{
			$import = 1;
		}
	}
	
	return $import;
}

1;
