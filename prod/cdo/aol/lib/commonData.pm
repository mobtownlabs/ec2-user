package commonData;

use dbiConfig;
use apiConfig;

###
sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub getCampaigns
{
	my ($self, $outFormat) = @_;
	my $dbi = dbiConfig->dbiConnect('');
	
	my $sql = qq| SELECT san, cid, totalbudget, timeStatus
					FROM Campaign
					WHERE isapi = 1 |;
	
	my $sth = $dbi->prepare($sql);
	$sth->execute();
	
	if ($outFormat eq 'array')
		{
			$campRef = $sth->fetchall_arrayref;
		}
	else 
		{
			$campRef = $sth->fetchall_hashref(san);
		}
	
	$sth->finish;
	$dbi->disconnect;
	
	
	return $campRef;
}

sub getNewCampaigns
{
	my ($self, $outFormat) = @_;
	my $dbi = dbiConfig->dbiConnect('');
	
	my $sql = qq| SELECT san, cid, totalbudget, timeStatus
					FROM Campaign
					WHERE isapi = 1
						AND timestatus < 3 |;
	
	my $sth = $dbi->prepare($sql);
	$sth->execute();
	
	if ($outFormat eq 'array')
		{
			$campRef = $sth->fetchall_arrayref;
		}
	else 
		{
			$campRef = $sth->fetchall_hashref(san);
		}
	
	$sth->finish;
	$dbi->disconnect;
	
	
	return $campRef;
}

sub getMedia
{
	my ($self, $outFormat) = @_;
	my $dbi = dbiConfig->dbiConnect('');
	
	my $sql = qq| SELECT m.adid
					FROM Media m
				|;
	
	my $sth = $dbi->prepare($sql);
	$sth->execute();
	
	if ($outFormat eq 'array')
		{
			$mediaRef = $sth->fetchall_arrayref;
		}
	else 
		{
			$mediaRef = $sth->fetchall_hashref(adid);
		}
	
	$sth->finish;
	$dbi->disconnect;
	
	
	return $mediaRef;
	
}

sub getCdoCells
{
	
	# DBI
	my $dbi = dbiConfig->dbiConnect('');
	
    my $sql = qq|
			SELECT id
			FROM cdoDataAol
         		|;


    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $Cell = $sth->fetchall_hashref(id);
    $sth->finish();
    
    $dbi->disconnect;
    
    return($Cell);
}

sub getCdoTestCells
{
	
    my ($self, $san) = @_;
	# DBI
	my $dbi = dbiConfig->dbiConnect('');
	
    my $sql = qq|
			SELECT id
			FROM cdoDataAolTemp
         		|;


    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $Cell = $sth->fetchall_hashref(id);
    $sth->finish();
    
    $dbi->disconnect;
    
    return($Cell);
}

sub getCampaignImpsData
{
	my($self, $type, $san) = @_;
	my $campData = {};
	
	# DBI
	my $dbi = dbiConfig->dbiConnect('');
	
	# Objects Needed
	my $ac = new apiConfig;
	
	# Config Params Needed
	my $hourlyImpsThreshold = $ac->getCommonParam('hourlyImpsThreshold');
	my $dowHourlyImpsThreshold = $ac->getCommonParam('dowHourlyImpsThreshold');
	
	if ($type eq "hour")
	{
		my $sql = qq|
			SELECT san,hour,sum(impressions) as impressions
				FROM DisplayLogsHourly
				WHERE san='$san'
			GROUP BY san,hour
			HAVING sum(impressions) > $hourlyImpsThreshold
			ORDER BY hour
			|;
		
		my $sth = $dbi->prepare($sql);
		$sth->execute();
		$campData = $sth->fetchall_hashref(hour);
		$sth->finish();
	}
	elsif ($type eq "dowHour")
	{
#		my $sql = qq|
#			SELECT san,cast(datepart(weekday, date) as varchar)+'_'+cast(hour as varchar) as ind,hour,sum(impressions) as impressions
#				FROM DisplayLogsHourly
#				WHERE san='$san'
#			GROUP BY san,cast(datepart(weekday, date) as varchar)+'_'+cast(hour as varchar),datepart(weekday, date),hour
#			HAVING sum(impressions) > $dowHourlyImpsThreshold
#			ORDER BY datepart(weekday, date), hour
#			|;

		my $sql = qq|
			SELECT san,concat(dayofweek(date),'_',hour) as ind,hour,sum(impressions) as impressions
				FROM DisplayLogsHourly
				WHERE san='$san'
			GROUP BY san,concat(dayofweek(date),'_',hour),,hour
			HAVING sum(impressions) > $dowHourlyImpsThreshold
			ORDER BY dayofweek(date), hour
			|;
		
		my $sth = $dbi->prepare($sql);
		$sth->execute();
		$campData = $sth->fetchall_hashref(ind);
		$sth->finish();	
	}
	
	$dbi->disconnect();
	
	return($campData);
}

1;
