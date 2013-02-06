package dataAggregation;

use dbiConfig;
use Logger;
use DateFunctions;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub byHour
{
	my ($self, $startDate, $endDate, $re_populate, $log) = @_;
	my $dbi = dbiConfig->dbiConnect('');
	
	my $df = new DateFunctions;
	my $Logger = new Logger;
	
	my $currentDate = $df->currentDate();

	### CampaignHour
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From CampaignHour FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM CampaignHour
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating CampaignHour...");
	$sql = "INSERT INTO CampaignHour (date, hour, san, impressions, clicks, actions, conversions, spend, num_cells)
	               SELECT date, hour, san, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogsHourly
	               WHERE date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, hour, san
	               ORDER BY date, hour, san";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with CampaignHour");
	
	### MediaHour
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From MediaHour FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM MediaHour
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating MediaHour...");
	$sql = "INSERT INTO MediaHour (date, hour, adid, mediatext, san, impressions, clicks, actions, conversions, spend, num_cells)
	               SELECT date, hour, adid, mediatext, san, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogsHourly
	               WHERE date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, hour, adid, mediatext, san
	               ORDER BY date, hour, adid, mediatext, san";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with MediaHour");
	
	### SiteSizeSegmentHour
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From SiteSizeSegmentHour FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM SiteSizeSegmentHour
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating SiteSizeSegmentHour...");
	$sql = "INSERT INTO SiteSizeSegmentHour (date, hour, siteid, segmentid, size, impressions, clicks, actions, conversions, spend, num_cells)
	               SELECT date, hour, siteid, segmentid, size, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogsHourly, Media
	               WHERE DisplayLogsHourly.adid = Media.adid
	               AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, hour, siteid, segmentid, size
	               ORDER BY date, hour, siteid, segmentid, size";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with SiteSizeSegmentHour");
	
	### SiteSizeHour
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From SiteSizeHour FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM SiteSizeHour
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating SiteSizeHour...");
	$sql = "INSERT INTO SiteSizeHour (date, hour, siteid, size, impressions, clicks, actions, conversions, spend, num_cells)
	               SELECT date, hour, siteid, size, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogsHourly, Media
	               WHERE DisplayLogsHourly.adid = Media.adid
	               AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, hour, siteid, size
	               ORDER BY date, hour, siteid, size";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with SiteSizeHour");
	
	### SiteSegmentHour
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From SiteSegmentHour FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM SiteSegmentHour
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating SiteSegmentHour...");
	$sql = "INSERT INTO SiteSegmentHour (date, hour, siteid, segmentid, impressions, clicks, actions, conversions, spend, num_cells)
	               SELECT date, hour, siteid, segmentid, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogsHourly
	               WHERE date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, hour, siteid, segmentid
	               ORDER BY date, hour, siteid, segmentid";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with SiteSegmentHour");
	
	### SegmentHour
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From SegmentHour FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM SegmentHour
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating SegmentHour...");
	$sql = "INSERT INTO SegmentHour (date, hour, segmentid, impressions, clicks, actions, conversions, spend, num_cells)
	               SELECT date, hour, segmentid, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogsHourly
	               WHERE date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, hour, segmentid
	               ORDER BY date, hour, segmentid";
	               
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with SegmentHour");
	
	### CPSHour
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From CPSHour FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM CPSHour
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating CPSHour...");
	$sql = "INSERT INTO CPSHour (date, hour, san, size, adgroup, impressions, clicks, actions, conversions, spend, num_cells)
	               SELECT date, hour, dl.san, m.size, m.adgroup, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogsHourly dl, Media m
	               WHERE dl.adid=m.adid
	               		AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, hour, dl.san, m.size, m.adgroup
	               ORDER BY date, hour, dl.san, m.size, m.adgroup";
	               
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with CPSHour");
	
	### CPSSegmentHour
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From CPSSegmentHour FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM CPSSegmentHour
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating CPSSegmentHour...");
	$sql = "INSERT INTO CPSSegmentHour (date, hour, san, size, adgroup, segmentid, impressions, clicks, actions, conversions, spend, num_cells)
	               SELECT date, hour, dl.san, m.size, m.adgroup, segmentid, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogsHourly dl, Media m
	               WHERE dl.adid=m.adid
	               		AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, hour, dl.san, m.size, m.adgroup, segmentid
	               ORDER BY date, hour, dl.san, m.size, m.adgroup, segmentid";
	               
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with CPSSegmentHour");
	
	### CPSSiteSegmentHour
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From CPSSiteSegmentHour FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM CPSSiteSegmentHour
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating CPSSiteSegmentHour...");
	$sql = "INSERT INTO CPSSiteSegmentHour (date, hour, san, size, adgroup, siteid, segmentid, impressions, clicks, actions, conversions, spend, num_cells)
	               SELECT date, hour, dl.san, m.size, m.adgroup, siteid, segmentid, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogsHourly dl, Media m
	               WHERE dl.adid=m.adid
	               		AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, hour, dl.san, m.size, m.adgroup, siteid, segmentid
	               ORDER BY date, hour, dl.san, m.size, m.adgroup, siteid, segmentid";
	               
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	     
	$Logger->writeFile($log, "DONE with CPSSiteSegmentHour");
	
	$sth->finish();
	$dbi->disconnect();

}

sub cdoAggregate
{
    my ($self, $addDate, $removeDate, $log) = @_;
    my $dbi = dbiConfig->dbiConnect('');

    my $Logger = new Logger;

    $Logger->writeFile($log, "Populating DisplayLogsByDOWHour");
    
    my $sql = qq| SELECT concat(san,"_",adid,"_",siteid,"_",segmentid,"_",hour) as id, dayofweek(date) as dow, hour, san, adid, siteid, segmentid, impressions as n, clicks as k, actions as a, conversions as conv, spend as spend
              FROM DisplayLogsHourly dlh
              WHERE date = '$addDate' |;

    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $new = $sth->fetchall_hashref(id);
    $sth->finish();

    $Logger->writeFile($log, "Executing:\n $sql");

    my $sql = qq| SELECT concat(san,"_",adid,"_",siteid,"_",segmentid,"_",hour) as id, dayofweek(date) as dow, hour, san, adid, siteid, segmentid, impressions as n, clicks as k, actions as a, conversions as conv, spend as spend
              FROM DisplayLogsHourly dlh
              WHERE date = '$removeDate' |;

    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $old = $sth->fetchall_hashref(id);
    $sth->finish();

    $Logger->writeFile($log, "Executing:\n $sql");

    $Logger->writeFile($log, "Inserting new data for $addDate");
    foreach my $id (keys %{$new})
    {

        my $sql = "INSERT INTO DisplayLogsByDOWHour VALUES (".$$new{$id}{'dow'}.", ".$$new{$id}{'hour'}.", '".$$new{$id}{'san'}."', ".$$new{$id}{'adid'}.", ".$$new{$id}{'siteid'}.", ".$$new{$id}{'segmentid'}.", ".$$new{$id}{'n'}.", ".$$new{$id}{'k'}.", ".$$new{$id}{'a'}.", ".$$new{$id}{'conv'}.", ".$$new{$id}{'spend'}.")
                  ON DUPLICATE KEY UPDATE impressions=impressions+".$$new{$id}{'n'}.", clicks=clicks+".$$new{$id}{'k'}.", actions=actions+".$$new{$id}{'a'}.", conversions=conversions+".$$new{$id}{'conv'}.", spend=spend+".$$new{$id}{'spend'};
        
        my $sth = $dbi->prepare($sql);
        $sth->execute();
        $sth->finish();
    }

    $Logger->writeFile($log, "Removing old data for $removeDate");
    foreach my $id (keys %{$old})
    {
        my $sql = "UPDATE DisplayLogsByDOWHour SET impressions=impressions-".$$old{$id}{'n'}.", clicks=clicks-".$$old{$id}{'k'}.", actions=actions-".$$old{$id}{'a'}.", conversions=conversions-".$$old{$id}{'conv'}.", spend=spend-".$$old{$id}{'spend'}.
        " WHERE adid=".$$old{$id}{'adid'}." AND siteid=".$$old{$id}{'siteid'}." AND segmentid=".$$old{$id}{'segmentid'}." AND dow=".$$old{$id}{'dow'}." AND hour=".$$old{$id}{'hour'};

        my $sth = $dbi->prepare($sql);
        $sth->execute();
        $sth->finish();
    }

    $dbi->disconnect;
    $Logger->writeFile($log, "Done.");
    $Logger->writeFile($log, "All Roll-ups Done!");
}

sub byDay
{
	my ($self, $startDate, $endDate, $localPerlDir) = @_;
	my $dbi = dbiConfig->dbiConnect('');
	
	my $df = new DateFunctions;
	my $Logger = new Logger;
	
	my $currentDate = $df->currentDate();
	#$Logger->openFile("$localPerlDir/out/DBRollUps", "dailyRollUpsLog_$currentDate.txt");

	### CampaignDay
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From CampaignDay FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM CampaignDay
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating CampaignDay...");
	$sql = "INSERT INTO CampaignDay
	               SELECT date, san, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM displaylogs
	               WHERE date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, san
	               ORDER BY date, san";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with CampaignDay");
	
	### MediaDay
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From MediaDay FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM MediaDay
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating MediaDay...");
	$sql = "INSERT INTO MediaDay
	               SELECT date, adid, mediatext, san, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM displaylogs
	               WHERE date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, adid, mediatext, san
	               ORDER BY date, adid, mediatext, san";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with MediaDay");
	
	### SiteSizeSegmentDay
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From SiteSizeSegmentDay FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM SiteSizeSegmentDay
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating SiteSizeSegmentDay...");
	$sql = "INSERT INTO SiteSizeSegmentDay
	               SELECT date, siteid, segmentid, size, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogs, Media
	               WHERE DisplayLogs.adid = Media.adid
	               AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, siteid, segmentid, size
	               ORDER BY date, siteid, segmentid, size";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with SiteSizeSegmentDay");
	
	### SiteSizeDay
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From SiteSizeDay FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM SiteSizeDay
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating SiteSizeDay...");
	$sql = "INSERT INTO SiteSizeDay
	               SELECT date, siteid, size, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM DisplayLogs, Media
	               WHERE DisplayLogs.adid = Media.adid
	               AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, siteid, size
	               ORDER BY date, siteid, size";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with SiteSizeDay");
	
	### SiteSegmentDay
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From SiteSegmentDay FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM SiteSegmentDay
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating SiteSegmentDay...");
	$sql = "INSERT INTO SiteSegmentDay
	               SELECT date, siteid, segmentid, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM displaylogs
	               WHERE date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, siteid, segmentid
	               ORDER BY date, siteid, segmentid";
	
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with SiteSegmentDay");
	
	### SegmentDay
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From SegmentDay FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM SegmentDay
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating SegmentDay...");
	$sql = "INSERT INTO SegmentDay
	               SELECT date, segmentid, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM displaylogs
	               WHERE date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, segmentid
	               ORDER BY date, segmentid";
	               
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with SegmentDay");
	
	### CPSDay
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From CPSDay FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM CPSDay
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating CPSDay...");
	$sql = "INSERT INTO CPSDay
	               SELECT date, dl.san, m.size, m.adgroup, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM displaylogs dl, Media m
	               WHERE dl.adid=m.adid
	               		AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, dl.san, m.size, m.adgroup
	               ORDER BY date, dl.san, m.size, m.adgroup";
	               
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with CPSDay");
	
	### CPSSegmentDay
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From CPSSegmentDay FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM CPSSegmentDay
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating CPSSegmentDay...");
	$sql = "INSERT INTO CPSSegmentDay
	               SELECT date, dl.san, m.size, m.adgroup, segmentid, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM displaylogs dl, Media m
	               WHERE dl.adid=m.adid
	               		AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, dl.san, m.size, m.adgroup, segmentid
	               ORDER BY date, dl.san, m.size, m.adgroup, segmentid";
	               
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with CPSSegmentDay");
	
	### CPSSiteSegmentDay
	if ($re_populate == 1) {
	  $Logger->writeFile($log, "Deleting Data From CPSSiteSegmentDay FROM $startDate TO $endDate...");
	
	   my $sql = "DELETE FROM CPSSiteSegmentDay
	              WHERE date BETWEEN '$startDate' AND '$endDate'
	              ";
	   $Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	}
	
	$Logger->writeFile($log, "Populating CPSSiteSegmentDay...");
	$sql = "INSERT INTO CPSSiteSegmentDay
	               SELECT date, dl.san, m.size, m.adgroup, siteid, segmentid, sum(impressions), sum(clicks), sum(actions), sum(conversions), sum(spend), count(*)
	               FROM displaylogs dl, Media m
	               WHERE dl.adid=m.adid
	               		AND date BETWEEN '$startDate' AND '$endDate'
	               GROUP BY date, dl.san, m.size, m.adgroup, siteid, segmentid
	               ORDER BY date, dl.san, m.size, m.adgroup, siteid, segmentid";
	               
	$Logger->writeFile($log, "Executing ($sql)");
	
	     $sth = $dbi->prepare($sql);
	     $sth->execute();
	
	$Logger->writeFile($log, "DONE with CPSSiteSegmentDay");
	
	$Logger->writeFile($log, "All Roll-ups Done!");
	$Logger->closeFile();
	
	$sth->finish();
	$dbi->disconnect();
	
}

1;
