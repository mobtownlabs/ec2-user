package dataLoader;

use commonData;
use dataImport;
use apiConfig;
use campConfig;
use cdoPopulate;
use DateFunctions;
use Logger;

my $logger = new Logger;

sub new
{
	my $self = {};
	bless $self;
	return $self;
}


sub getAllApiData {
	
	my($self, $date, $yesterday, $rDate, $dow, $hour, $rHour, $log) = @_;
	
	my $common = new commonData;
	my $di = new dataImport;
	my $ac = new apiConfig;
	my $cc = new campConfig;	
	
	## Get Campaigns in array form
	my $campaigns = $common->getCampaigns('array');
	
	## START
	$logger->write($log, "\n\n".DateFunctions->currentTime().": Starting AOL API Import...");
	
	## DO IMPORTS for each Campaign
	foreach $c (@{$campaigns})
		{
			## SET Camapign Directories
			my $localImportDir = $ac->getCommonParam('localImportDir')."/".$$c[1];
			my $localImportPerlDir = $ac->getCommonParam('localImportPerlDir')."/".$$c[1];
			
			## Get HOURLY Reporting Data from API --> INSERT into DB
			$logger->write($log, "\n\n++++++++++++++++++++++++++++++++++++++++++++");
			$logger->write($log, "\n".DateFunctions->currentTime().": $$c[0]");
			$logger->write($log, "\n++++++++++++++++++++++++++++++++++++++++++++");
			
			$logger->write($log, "\n-->Hourly...");
			$logger->write($log, "\n+------------+");
			$di->hourlyImport($date, $hour, $$c[1], $$c[0], $localImportDir, $localImportPerlDir, $log);
			
			$logger->write($log, "\n-->RE-IMPORT: Hourly...");
			$logger->write($log, "\n+----------------------+");
			$di->hourlyReImport($rDate, $rHour, $$c[1], $$c[0], $localImportDir, $localImportPerlDir, $log);
			
			## IF proper hour, get DAILY Reporting Data (NO DB INSERT)
			if ($hour == $ac->getCommonParam('hourToGetDaily'))
				{
					$logger->write($log, "\n-->Daily...");
					$logger->write($log, "\n+----------+");
					$di->dailyImport($yesterday, $$c[1], $$c[0], $localImportDir, $localImportPerlDir, $log);
				}
		}
	
	## IF proper hour, get Aggregate Data (By Hour and Day)
	if ($hour == $ac->getCommonParam('hourToGetDaily'))
		{
                    my $logFolder = $ac->getCommonParam('cdoLogDir')."/importAggregates";
                    my $aggLog = $logger->openFile($logFolder, "hourlyRollUpsLog\_$date.txt");
                    my ($addDate, $removeDate) = (DateFunctions->delayDates(24,1260))[0,2];
                    
                    $logger->write($aggLog, "\n\n-->Aggregates Running...");
                    $logger->write($aggLog, "\n+----------------------+");
                    $di->aggregate($yesterday, $aggLog);
                    $di->cdoAggregate($addDate, $removeDate, $aggLog);
                    
                    $logger->closeFile($aggLog);
		}
	## IF proper hour, refresh the entire previous day
	if ($hour == $ac->getCommonParam('hourToRefreshPrevDay'))
		{
			$logger->write($log, "\n\n-->REFRESHING PREVIOUS DAY'S HOURLY DATA...");
			$logger->write($log, "\n-----------------------------------------------+");
		
			foreach $c (@{$campaigns})
			{
				$logger->write($log, "\n\n++++++++++++++++++++++++++++++++++++++++++++");
				$logger->write($log, "\n".DateFunctions->currentTime().": $$c[0]");
				$logger->write($log, "\n++++++++++++++++++++++++++++++++++++++++++++");
				
				for (my $h=0; $h<24; $h++) # loop for all 24 hours
				{
					## Set Directories
					my $localImportDir = $ac->getCommonParam('localImportDir')."/".$$c[1];
					my $localImportPerlDir = $ac->getCommonParam('localImportPerlDir')."/".$$c[1];
					
					## Call the re-import method
					$di->hourlyReImport($yesterday, $h, $$c[1], $$c[0], $localImportDir, $localImportPerlDir, $log);
				}
			}
		}
	
	## Run Campaign Configuration Imports (new camps/media/cells)
		#print "\n\nImporting Campaign Data...";
		#print "\n+---------------------------+";
		#	$cc->downstreamImport($dow, $hour);
			
	## FINISH
	$logger->write($log, "\n".DateFunctions->currentTime().": AOL API Import Done.");
}

sub getCdoData {
	
	my($self, $dow, $hour, $log) = @_;
		
	my $cdo = new cdoPopulate;
	
	$logger->write($log, "\n".DateFunctions->currentTime().": Starting CDO Populate\n");
		
		$cdo->populateCdoKnaData($dow, $hour, $log);
		
	$logger->write($log, DateFunctions->currentTime().": CDO Populate Done.\n");
	
}

sub cleanCdoData {
	
	my($self, $bidQueueKeep, $date, $hour, $log) = @_;
	
	my $cdo = new cdoPopulate;
	
	$logger->write($log, "\n\n".DateFunctions->currentTime().": Cleaning Up CDO Data");
		$cdo->populateMD($bidQueueKeep, $date, $hour, $log);
	
}


1;
	
