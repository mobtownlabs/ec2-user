#!/perl/bin/perl
use dataImport;
use apiConfig;
use commonData;
use DateFunctions;
use Logger;
use cdoPopulate;

my $di = new dataImport;
my $ac = new apiConfig;
my $cc = new commonData;
my $df = new DateFunctions;
my $logger = new Logger;
my $cdo = new cdoPopulate;

my ($date, $dow,
    $date_1, $dow1,
    $date_2, $dow2) = $df->getPVDate(0, 168);
	
my %days = split(/[;:]/, $ac->getCommonParam('pvDaysToRun'));

	if ($days{$dow})
	{
		my $logFile = $ac->getCommonParam('pvLogFile').$date.".txt";
		my $log = $logger->openFile($ac->getCommonParam('pvLogDir'), $logFile);
			
	$logger->write($log, "
	+ AOL Price Volume Import
	+-----------------------------------------+
	+-----------------------------------------+
	+ Date/Hour Used (GMT)
	+ ====================
	+ Date: $date
	+ Day of Week: $dow
        +
	+ Date/Hour Previous (GMT)
	+ ====================
	+ Date: $date_1
	+ Day of Week: $dow1
        +
	+ Date/Hour Week Ago (GMT)
	+ ====================
	+ Date: $date_2
	+ Day of Week: $dow2
	+-----------------------------------------+
	+-----------------------------------------+
	");
		
		my $campaigns = $cc->getCampaigns('array');
		
		## Price Volume Table
		$logger->write($log, "\n\n+----------------------------------------------+");
		$logger->write($log, "\n".$df->currentTime().": Importing Price Volume Data...");
		$logger->write($log, "\n+----------------------------------------------+");
		
		## Create temp table
		$cdo->createPriceVolumeTable($log);
		
			foreach $c (@$campaigns)
			{
				my $localImportDir = $ac->getCommonParam('localImportDir')."/".$$c[1];
				my $localImportPerlDir = $ac->getCommonParam('localImportPerlDir')."/".$$c[1];
				
				$di->priceVolume($date, $date_1, $date_2, $$c[1], $$c[0], $localImportDir, $localImportPerlDir, $log);
			}
		
		## Update tables
		$logger->write($log, "\n\n+----------------------------------------------+");
		$logger->write($log, "\n".$df->currentTime().": Updating Price Volume Tables");
		$logger->write($log, "\n+----------------------------------------------+");
		$cdo->updatePriceVolumeTables(1, $log);
		
		## EVolume Table
		$logger->write($log, "\n\n+----------------------------------------------+");
		$logger->write($log, "\n".$df->currentTime().": Populating EVolume Data...");
		$logger->write($log, "\n+----------------------------------------------+");
			
		$cdo->populateEVolume(1, $log);

                ## AVG Tables
		$logger->write($log, "\n\n+----------------------------------------------+");
		$logger->write($log, "\n".$df->currentTime().": Populating AVG Data...");
		$logger->write($log, "\n+----------------------------------------------+");

                $cdo->populatePVAvg(1, $log);
			
		$logger->write($log, "\n\n".$df->currentTime().": Done!\n\n");
		
	}
	else
	{
		print "\nDay is $dow: PV only runs on days ".$ac->getCommonParam('pvDaysToRun');
	}

exit;
