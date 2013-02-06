package qHatAggregations;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub cell
{
    my ($self, $dow, $hour, $log) = @_;
    use dbiConfig;
    use DateFunctions;
    use Logger;
    my $logger = new Logger;
    #my ($date) = (DateFunctions->getGMTDateHour(0,3600))[0];


    my $dbi = dbiConfig->dbiConnect('');

    ## Cell
    # DOW/Hourly (timeStatus=3)
#    my $sql = qq| SELECT concat(m.san,"_",dl.adid,"_",siteid,"_",segmentid,"_",m.size) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a
#                  FROM DisplayLogsHourly dl, Media m, Campaign c
#                  WHERE dl.adid=m.adid
#                  AND m.san=c.san
#                  AND dayofweek(date) = $dow AND hour=$hour
#                  AND c.usepoe=1
#                  AND m.active = 1
#                  AND c.timestatus=3
#                  AND date > '$date'
#                  GROUP BY concat(m.san,"_",dl.adid,"_",siteid,"_",segmentid,"_",m.size) |;
    
    my $sql = qq|  SELECT concat(dl.san,"_",dl.adid,"_",dl.siteid,"_",dl.segmentid,"_",m.size) as id, impressions as n, clicks as k, actions as a 
                   FROM DisplayLogsByDOWHour dl, Media m, Campaign c
                   WHERE dl.adid=m.adid 
                   AND m.san=c.san
                   AND dl.dow = $dow
                   AND dl.hour = $hour
                   AND c.usepoe=1 
                   AND m.active=1 
                   AND c.timestatus=3 |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $cellKna = $sth->fetchall_hashref(id);
    $sth->finish();
    $logger->write($log, "             >> ".DateFunctions->currentTime().": Level 3 Cells Loaded (DOW/hour)\n");

    # Hourly (timeStatus=2)
#    my $sql = qq| SELECT concat(m.san,"_",dl.adid,"_",siteid,"_",segmentid,"_",m.size) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a
#                  FROM DisplayLogsHourly dl, Media m, Campaign c
#                  WHERE dl.adid=m.adid
#                  AND m.san=c.san
#                  AND hour=$hour
#                  AND c.usepoe=1
#                  AND m.active = 1
#                  AND c.timestatus=2
#                  AND date > '$date'
#                  GROUP BY concat(m.san,"_",dl.adid,"_",siteid,"_",segmentid,"_",m.size) |;

    my $sql = qq|  SELECT concat(dl.san,"_",dl.adid,"_",dl.siteid,"_",dl.segmentid,"_",m.size) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a 
                   FROM DisplayLogsByDOWHour dl, Media m, Campaign c
                   WHERE dl.adid=m.adid 
                   AND m.san=c.san
                   AND dl.hour = $hour
                   AND c.usepoe=1 
                   AND m.active=1 
                   AND c.timestatus=2 
                   GROUP BY id |;
    

    my $sth=$dbi->prepare($sql);
    $sth->execute();

    while(my @temp = $sth->fetchrow_array)
    {
        $$cellKNA{$temp[0]}{'n'} = $temp[1];
        $$cellKNA{$temp[0]}{'k'} = $temp[2];
        $$cellKNA{$temp[0]}{'a'} = $temp[3];
    }

    $sth->finish();
    $logger->write($log, "             >> ".DateFunctions->currentTime().": Level 2 Cells Loaded (hour)\n");

    # Life of Campaign (timeStatus=1)
#    my $sql = qq| SELECT concat(m.san,"_",dl.adid,"_",siteid,"_",segmentid,"_",m.size) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a
#                  FROM DisplayLogsHourly dl, Media m, Campaign c
#                  WHERE dl.adid=m.adid
#                  AND m.san=c.san
#                  AND hour < 24
#                  AND c.usepoe=1
#                  AND m.active = 1
#                  AND c.timestatus=1
#                  AND date > '$date'
#                  GROUP BY concat(m.san,"_",dl.adid,"_",siteid,"_",segmentid,"_",m.size) |;

    my $sql = qq|  SELECT concat(dl.san,"_",dl.adid,"_",dl.siteid,"_",dl.segmentid,"_",m.size) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a 
                   FROM DisplayLogsByDOWHour dl, Media m, Campaign c
                   WHERE dl.adid=m.adid 
                   AND m.san=c.san
                   AND c.usepoe=1 
                   AND m.active=1 
                   AND c.timestatus=1 
                   GROUP BY id |;


    my $sth=$dbi->prepare($sql);
    $sth->execute();
 
    while(my @temp = $sth->fetchrow_array)
    {
        $$cellKNA{$temp[0]}{'n'} = $temp[1];
        $$cellKNA{$temp[0]}{'k'} = $temp[2];
        $$cellKNA{$temp[0]}{'a'} = $temp[3];
    }

    $sth->finish();
    $logger->write($log, "             >> ".DateFunctions->currentTime().": Level 1 Cells Loaded (LOC)\n");

    $dbi->disconnect();

    return($cellKna);
    
}

sub cps
{
    my ($self, $dow, $hour) = @_;
    use dbiConfig;
    my $dbi = dbiConfig->dbiConnect('');

    ## CPS->Site,Segment
    my $sql = qq| SELECT concat(cps.san,"_",size,"_",adgroup,"_",siteid,"_",segmentid) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a, sum(num_cells) as cells
                  FROM CPSSiteSegmentHour cps, Campaign c
                  WHERE cps.san=c.san
                  AND dayofweek(date) = $dow AND hour=$hour
                  AND c.usepoe=1
                  GROUP BY concat(cps.san,"_",size,"_",adgroup,"_",siteid,"_",segmentid) |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $cpsSiteSegment = $sth->fetchall_hashref(id);
    $sth->finish();

    ## CPS->Segment
    my $sql = qq| SELECT concat(cps.san,"_",size,"_",adgroup,"_",segmentid) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a, sum(num_cells) as cells
                  FROM CPSSegmentHour cps, Campaign c
                  WHERE cps.san=c.san
                  AND dayofweek(date) = $dow AND hour=$hour
                  AND c.usepoe=1
                  GROUP BY concat(cps.san,"_",size,"_",adgroup,"_",segmentid) |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $cpsSegment = $sth->fetchall_hashref(id);
    $sth->finish();

    ## CPS
    my $sql = qq| SELECT concat(cps.san,"_",size,"_",adgroup) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a, sum(num_cells) as cells
                  FROM CPSHour cps, Campaign c
                  WHERE cps.san=c.san
                  AND dayofweek(date) = $dow AND hour=$hour
                  AND c.usepoe=1
                  GROUP BY concat(cps.san,"_",size,"_",adgroup) |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $cps = $sth->fetchall_hashref(id);
    $sth->finish();

    $dbi->disconnect();

    return($cps, $cpsSegment, $cpsSiteSegment);

}

sub site
{
    my ($self, $dow, $hour) = @_;
    use dbiConfig;
    my $dbi = dbiConfig->dbiConnect('');

    ## Site->Size,Segment
    my $sql = qq| SELECT concat(siteid,"_",size,"_",segmentid) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a, sum(num_cells) as cells
                  FROM SiteSizeSegmentHour
                  WHERE dayofweek(date) = $dow AND hour=$hour
                  GROUP BY concat(siteid,"_",size,"_",segmentid) |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $siteSizeSegment = $sth->fetchall_hashref(id);
    $sth->finish();

    ## Site->Segment
    my $sql = qq| SELECT concat(siteid,"_",segmentid) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a, sum(num_cells) as cells
                  FROM SiteSegmentHour
                  WHERE dayofweek(date) = $dow AND hour=$hour
                  GROUP BY concat(siteid,"_",segmentid) |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $siteSegment = $sth->fetchall_hashref(id);
    $sth->finish();

    ## Site->Size
    my $sql = qq| SELECT concat(siteid,"_",size) as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a, sum(num_cells) as cells
                  FROM SiteSizeHour
                  WHERE dayofweek(date) = $dow AND hour=$hour
                  GROUP BY concat(siteid,"_",size) |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $siteSize = $sth->fetchall_hashref(id);
    $sth->finish();

    $dbi->disconnect();
    
    return($siteSize, $siteSegment, $siteSizeSegment);
    

}

sub segment
{
    my ($self, $dow, $hour) = @_;
    use dbiConfig;
    my $dbi = dbiConfig->dbiConnect('');

    ## Segment
    my $sql = qq| SELECT segmentid as id, sum(impressions) as n, sum(clicks) as k, sum(actions) as a, sum(num_cells) as cells
                  FROM SegmentHour
                  WHERE dayofweek(date) = $dow AND hour=$hour
                  GROUP BY segmentid |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $segment = $sth->fetchall_hashref(id);
    $sth->finish();

    $dbi->disconnect();
    
    return($segment);
    
}

sub size
{
    my ($self, $dow, $hour) = @_;
    use dbiConfig;
    my $dbi = dbiConfig->dbiConnect('');

    ## Size
    my $sql = qq| SELECT m.size as id, sum(mh.impressions) as n, sum(mh.clicks) as k, sum(mh.actions) as a, sum(mh.num_cells) as cells
                  FROM MediaHour mh, Media m
                  WHERE mh.adid=m.adid 
                  AND dayofweek(mh.date) = $dow AND mh.hour=$hour
                  GROUP BY m.size |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $size = $sth->fetchall_hashref(id);
    $sth->finish();

    $dbi->disconnect();
    
    return($size);

}

sub available
{
    use dbiConfig;
    my $dbi = dbiConfig->dbiConnect('');

    ## Available Imps
    my $sql = qq| SELECT concat(san,"_",siteid,"_",segmentid,"_",size) as id, volume as total_volume, capped_volume as capped_volume
                  FROM EVolumeTest |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $availImpressions = $sth->fetchall_hashref(id);
    $sth->finish();

    $dbi->disconnect();
    
    return($availImpressions);

}

sub availableAvg
{
    use dbiConfig;
    my $dbi = dbiConfig->dbiConnect('');

    ## Available Imps Avg.
    my $sql = qq| SELECT concat(siteid,"_",segmentid,"_",size) as id, volume as total_volume, capped_volume as capped_volume
                  FROM EVolumeAvg |;

    my $sth=$dbi->prepare($sql);
    $sth->execute();
    
    my $availImpressionsAvg = $sth->fetchall_hashref(id);
    $sth->finish();

    $dbi->disconnect();
    
    return($availImpressionsAvg);

}

1;
