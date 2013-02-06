package dataImport;

use apiConfig;
use apiOps;
use apiUtils;
use fileUtils;
use fileToDb;
use dataAggregation;
use Logger;

my $logger = new Logger;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub hourlyImport
{
	my ($self, $date, $hour, $campId, $san, $localDir, $localPerlDir, $log) = @_;
	
	my $au = new apiUtils;
	my $fu = new fileUtils;
	my $fdb = new fileToDb;
	
		# Create new directories (if need to)
		$fu->newImportDir($localDir);
	
	my $url = &buildURL('Hourly', $campId, $date, $hour);
        print "$url\n\n";
		my ($file, $status) = $au->getHourlyFile($date, $hour, $url, $localDir, $campId, 1);
		
        $logger->write($log, "\n---->Getting IMPORT file from: $url");

		if($file==0)
                        {
				$logger->write($log, "\n----->CID $campId ($san): no file for hour $hour (error: $status)");
			}
                else 
			{
                                $logger->write($log, "\n----->SUCCESS: $status");
				$fdb->hourly($localPerlDir, $file, $san, $date, $hour, 0, $log);
			}
}

sub hourlyReImport
{
	my ($self, $date, $hour, $campId, $san, $localDir, $localPerlDir, $log) = @_;
	
	my $au = new apiUtils;
	my $fdb = new fileToDb;
	my $ac = new apiConfig;
		
	my $url = &buildURL('Hourly', $campId, $date, $hour);
		
		my $file = $au->getHourlyFile($date, $hour, $url, $localDir, $campId, 1);
		if($file)
			{
				$logger->write($log, "\n---->Getting RE-IMPORT file from: $url");
				$fdb->hourly($localPerlDir, $file, $san, $date, $hour, 1, $log);
			}
			else
			{
				$logger->write($log, "\n---->CID $campId: no RE-IMPORT file for hour $hour");
			}			
}

sub dailyImport
{
	my ($self, $date, $campId, $san, $localDir, $localPerlDir, $log) = @_;

	my $au = new apiUtils;
	my $fdb = new fileToDb;
	
	my $url = &buildURL('Daily', $campId, $date, 24);
	my $file = $au->getDailyFile($date, $url, $localDir, $campId, 1);
			
		if($file)
			{
				$logger->write($log, "\n\n---->Getting DAILY IMPORT file from: $url");
				$fdb->daily($localPerlDir, $file, $san, $log);
			}
		else
			{
				$logger->write($log, "\n---->CID $campId: no DAILY file for $date");
			}
}

sub aggregate
{
    my ($self, $date, $log) = @_;
    my $da = new dataAggregation;

    $da->byHour($date, $date, 1, $log);
}

sub cdoAggregate
{
    my ($self, $addDate, $removeDate, $log) = @_;
    my $da = new dataAggregation;

    $da->cdoAggregate($addDate, $removeDate, $log);
}

sub priceVolume
{
	my ($self, $date, $date_1, $date_2, $campId, $san, $localDir, $localPerlDir, $log) = @_;
	use DateFunctions;
	
	my $au = new apiUtils;
	my $fdb = new fileToDb;
	my $df = new DateFunctions;
	
	$logger->write($log, "\n\n-----------------------------------------");
	$logger->write($log, "\n".$df->currentTime().": $san ($campId)");
	$logger->write($log, "\n-----------------------------------------");
	
	my $url = &buildURL('PriceVolume', $campId, $date, 24);
		$logger->write($log, "\n     -> URL: $url");
	my $file = $au->getPriceVolumeCellFile($date, $url, $localDir, $campId, 1);
        my $localFile = $localDir."/priceVolume/".$file;

	if((open(FILE, $localFile)))
	{
            open(FILE, $localFile);
            my @lines = <FILE>;
            
            if (@lines > 1)
            {
		$logger->write($log, "\n     -> File: $file");
		$fdb->priceVolume($localDir, $file, $san, $log);
            }
            else
            {
                $logger->write($log, "\n     -> File: $file exists but has NO DATA");
            }
	}
	else
	{
            $logger->write($log, "\n     -> NO PV FILE, trying another date ($date_1)");
            my $url = &buildURL('PriceVolume', $campId, $date_1, 24);
	    $logger->write($log, "\n        -> URL: $url");

            my $file = $au->getPriceVolumeCellFile($date_1, $url, $localDir, $campId, 1);
            my $localFile = $localDir."/priceVolume/".$file;

            if ((open(FILE, $localFile)))
            {
                open(FILE, $localFile);
                my @lines = <FILE>;
                
                if (@lines > 1)
                {
                    $logger->write($log, "\n     -> File: $file");
                    $fdb->priceVolume($localDir, $file, $san, $log);
                }
                else
                {
                    $logger->write($log, "\n     -> File: $file exists but has NO DATA");
                }
            }
            else
            {
                $logger->write($log, "\n     -> NO PV FILE, trying another date ($date_2)");
                my $url = &buildURL('PriceVolume', $campId, $date_2, 24);
                $logger->write($log, "\n        -> URL: $url");

                my $file = $au->getPriceVolumeCellFile($date_2, $url, $localDir, $campId, 1);
                my $localFile = $localDir."/priceVolume/".$file;

                if ((open(FILE, $localFile)))
                {
                    open(FILE, $localFile);
                    my @lines = <FILE>;
                    
                    if (@line > 1)
                    {
                        $logger->write($log, "\n     -> File: $file");
                        $fdb->priceVolume($localDir, $file, $san, $log);
                    }
                    else
                    {
                        $logger->write($log, "\n     -> File: $file exists but has NO DATA");
                    }   

                }
                else
                {
                    $logger->write($log, "\n     -> FUCKED!");
                }
            }
            
		
	}
		
	
}

##LOCAL SUBS
sub buildURL
{
	my $ac = new apiConfig;
	
	my($type, $c, $d, $h) = @_;
	my $url;
	
	my ($y, $m, $d) = split(/-/, $d);
	my $p = $ac->getConfigParam('pid');
	
	if ($type eq 'Hourly')
	{
		$url = $ac->getCommonParam('AOLHourlyFileURL');
	}
	elsif ($type eq 'Daily')
	{
		$url = $ac->getCommonParam('AOLDailyFileURL');
	}
	elsif ($type eq 'PriceVolume')
	{
		$url = $ac->getCommonParam('AOLPriceVolumeCellFileURL');
	}
	
		$url =~ s/<PARTNERID>/$p/g;
		$url =~ s/<CAMPAIGNID>/$c/g;
		$url =~ s/<YYYY>/$y/g;
		$url =~ s/<MM>/$m/g;
		$url =~ s/<DD>/$d/g;
		$url =~ s/<HH>/$h/g;
	
	return $url;
}

1;
