use DateFunctions;
use dataLoader;
use dataImport;
use apiConfig;
use bidUploader;
use fileUtils;
use CDO;
use Logger;

my $df = new DateFunctions;
my $dl = new dataLoader;
my $di = new dataImport;
my $ac = new apiConfig;
my $bu = new bidUploader;
my $fu = new fileUtils;
my $cdo = new CDO;
my $logger = new Logger;

my ($date, $cHour, $yesterday, $rDate, $hour, $iDate, $rHour, $oHour, $dow, $ydow, $odow, $oDate, $lastDate, $lHour, $mDate, $mHour) = $df->getGMTDateHour(0, 1);

my $logFile = $ac->getCommonParam('cdoLogFile').$oDate."_".$oHour.".txt";
my $log = $logger->openFile($ac->getCommonParam('cdoLogDir'), $logFile);
$logger->write($log, $df->currentTime.": CDO Logging BEGIN.\n\n");

$logger->write($log, "
+ Dates/Hours Used (ALL TIMES GMT)
+-----------------------------------------+
+-----------------------------------------+
+ CURRENT (GMT)
+ =============
+ Current Date: $date
+ Current Hour: $cHour
+ Current Day of Week: $dow
+
+ LAST (current - 1 hour)
+ =======================
+ Last Hour: $lHour
+ Last Date: $lastDate
+
+ YESTERDAY (current - 24 hrs)
+ ============================
+ Yesterday Date: $yesterday
+ 
+ IMPORT (current - parameter)
+ ============================
+ Import Date: $iDate
+ Import Hour: $hour
+
+ RE-IMPORT (import - paramter)
+ =============================
+ Re-Import Date: $rDate
+ Re-ImportHour: $rHour
+
+ MD IMPORT (import - paramter)
+ =============================
+ MD Import Date: $mDate
+ MD Hour: $mHour 
+
+ CDO (current + 1 hr)
+ ====================
+ CDO Date: $oDate
+ CDO Hour: $oHour\
+ CDO Day Of Week: $odow
+-----------------------------------------+
+-----------------------------------------+\n\n");
#exit;

## CDO
my $MAIN_DIR = $ac->getCommonParam('localCdoDir');
my $WIN_DIR = $ac->getCommonParam('localCdoWINDir');
my $bidMode = $ac->getCommonParam('bidMode');

$fu->newCdoFolder($MAIN_DIR, $oDate, $oHour);
my $LP_DIR = "$MAIN_DIR/$oDate/$oHour/components";
my $DATA_DIR = "$MAIN_DIR/$oDate/$oHour/data";
my $BIDS_DIR = "$MAIN_DIR/$oDate/$oHour/bids";

## Network Curation
my($campConfig, $cellMaxAlpha, $campaignMaxAlpha) = $cdo->Params($log);
my($cellMdFactors, $siteSegMdFactors) = $cdo->getMDFactors($DATA_DIR, $log);
my($siteSegSignal, $networkSignal, $campaignBudgetSignal, $networkBudgetSignal) = $cdo->GetSignals($odow, $log);
my($Cell) = $cdo->GetCellData($DATA_DIR, $odow, $oHour, $siteSegSignal, $networkSignal, $cellMdFactors, $siteSegMdFactors, $log);
my($cost, $costAvg) = $cdo->GetCostData($DATA_DIR, $log);

##LP OPS
$cdo->LP_Obj($LP_DIR, $DATA_DIR, $Cell, $cost, $costAvg, $oHour, $siteSegSignal, $networkSignal, $cellMaxAlpha, $campaignMaxAlpha, $cellMdFactors, $siteSegMdFactors, $log);
$cdo->LP_Constraint($LP_DIR, $oHour, $campConfig, $campaignBudgetSignal, $networkBudgetSignal, $log);
$cdo->LP_Build($LP_DIR, $log);
$cdo->LP_Solve($LP_DIR, $log);

##Bid Ops
my($bidList) = $cdo->BidCalc($LP_DIR, $BIDS_DIR, $Cell, $cost, $costAvg, $siteSegSignal, $networkSignal, $odow, $oHour, $cellMdFactors, $siteSegMdFactors, $log);
$cdo->processBids($bidList, $oDate, $date, $oHour, $cHour, $log);

## Compress CDO files
$fu->compressFiles($MAIN_DIR, $oDate, $oHour);

exit;


#$bu->pushBids($oDate, $oHour, $date, $cHour, $log, $bidMode);
#$dl->cleanCdoData($yesterday, $mDate, $mHour, $log);


## ALL API Imports
#$dl->getAllApiData($iDate, $yesterday, $rDate, $dow, $hour, $rHour, $log);
#undef %{$Cell};
#exit;

$logger->write($log, "\n\n".$df->currentTime.": CDO Logging END.\n\n");
exit;
