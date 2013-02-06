#!/perl/bin/perl
use campConfig;
use apiConfig;
use DateFunctions;
use Logger;

my $cc = new campConfig;
my $ac = new apiConfig;
my $df = new DateFunctions;
my $logger = new Logger;

my ($date, 
	$cHour, 
	$yesterday, 
	$rDate, 
	$hour, 
	$iDate, 
	$rHour, 
	$oHour, 
	$dow, 
	$ydow, 
	$odow, 
	$oDate, 
	$lastDate, 
	$lHour, 
	$mDate, 
	$mHour) = $df->getGMTDateHour(0, 0);

my $logFile = $ac->getCommonParam('importLogFile').$oDate."_".$oHour.".txt";
my $log = $logger->openFile($ac->getCommonParam('importLogDir'), $logFile);
	
$logger->write($log, "
+ AOL API Downstream Import
+-----------------------------------------+
+-----------------------------------------+
+ Date/Hour Used (GMT)
+ ====================
+ Date: $iDate
+ Hour: $hour
+ Day of Week: $dow
+-----------------------------------------+
+-----------------------------------------+
");

## Run Downstream Process
$logger->write($log, "\n\n".$df->currentTime().": Importing Campaign Data...");
$logger->write($log, "\n+----------------------------------------------+");

	$cc->downstreamImport($dow, $hour, $log);

$logger->write($log, "\n\n+----------------------------------------------+");
$logger->write($log, "\n".$df->currentTime().": Done!");

exit;
