#!/usr/bin/perl

use populateCDO;
use DateFunctions;
use Logger;

#my @campaigns = qw(aioapi1amdec10:168114 chpcrbnamjan11:169135 aiolbckammay11:181418 auolbckammay11:181419 aigebi1amjul11:183960 aiglbckamsep11:190973 gameflyamnov11:194164 alarmdpamnov11:194677 adchmdpamdec11:197487 chronicamdec11:197909 alarmdcamjan12:199386 adchronamjan12:199707 chearonamjan12:200058 reply11amjan12:200095 reply22amjan12:200096 repllb1amjan12:200218 repllb2amjan12:200219 gameronamjan12:199706);
#my @campaigns = qw (gameronamjan12:199706);



my $log = Logger->openFile("./","test.txt");
my $popCDO = populateCDO->new();

foreach my $campaign (@campaigns)
{
    my ($san, $cid) = split(/:/, $campaign);

    #$popCDO->getExistingCells($cid, $san, $log);  ## THIS WILL GO WHEN CDO DETECTS NEW CAMPAIGN OUT OF API
    #$popCDO->getNewCells($cid, $san, $log);
    #$popCDO->markOldCells($cid, $san, $log);
}

##BATCH PROCESSES
$popCDO->groupNewCells($log);
#$popCDO->removeOldCells($log);
$popCDO->updateNetwork($log);

exit;



