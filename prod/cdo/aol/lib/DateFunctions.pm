package DateFunctions;

use POSIX qw(strftime);
use Time::Local;
use apiConfig;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}


## GET M, D, Y for Get Recommendations
sub mdy {
    my ($self, $datein) = @_;

    @mdy = split(/-/, $datein);

    my $month = $mdy[1];
    my $day = $mdy[2];
    my $year = $mdy[0];

    return ($month, $day, $year);
}

## GET Current Date
sub currentDate {
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); # Get Time NOW
    my @month = qw(01 02 03 04 05 06 07 08 09 10 11 12); # Array of 2 digit Month Values
    my @monthName = qw(January February March April May June July August September October November December); # Array of Month Names
    my $thisYear = $year += 1900; # Current 4 digit year
    my $thisMonth = $month[$mon]; # get 2 digit month
    my $Current_Date = $thisYear."-".$thisMonth."-".$mday; # concat to form date var

    return $Current_Date;
}

## GET Current DOW
sub currentDOW {
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time); # Get Time NOW
    my @dowDays = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);
    my @dow = (1, 2, 3, 4, 5, 6, 7);
    my $current_dow = $dow[$wday];
    my $current_dow_days = $dowDays[$wday];

    return $current_dow;
}

## GET Tomorrow DOW
sub nextDOW {
    my $epochNextDay = time + 24 * 60 * 60;  # subtract secs in day from current epoch time
    my ($wday) = (localtime($epochNextDay))[6];

    my @dowDays = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);
    my @dow = (1, 2, 3, 4, 5, 6, 7);
    my $next_dow = $dow[$wday];
    my $next_dow_days = $dowDays[$wday];

    return $next_dow;
}

## GET TIMESTAMP
sub currentTime {
    my $ts = strftime "%H:%M:%S", gmtime;
    
    return $ts;
}

sub getYesterday {
    my @month = qw(01 02 03 04 05 06 07 08 09 10 11 12);
    my $epochYesterday = time - 24 * 60 * 60;  # subtract secs in day from current epoch time
    my ($year, $mon, $day) = (localtime($epochYesterday))[5,4,3];

    # Perl years begin at 1900
    $year += 1900;

    # GET 2 digit month
    $month = $month[$mon];

    return "$year-$month-$day";
}

sub getTwoDaysAgo {
    my @month = qw(01 02 03 04 05 06 07 08 09 10 11 12);
    my $epochTwoDaysAgo = time - 48 * 60 * 60;  # subtract secs in day from current epoch time
    my ($year, $mon, $day) = (localtime($epochTwoDaysAgo))[5,4,3];

    # Perl years begin at 1900
    $year += 1900;

    # GET 2 digit month
    $month = $month[$mon];

    return "$year-$month-$day";
}

sub getNextDay {
    my $epochNextDay = time + 24 * 60 * 60;  # add secs in day from current epoch time
    my ($year, $month, $day) = (localtime($epochNextDay))[5,4,3];

    # Perl years begin at 1900
    $year += 1900;

    # Perl months begin at 0
    $month++;

    return "$year-$month-$day";
}

sub getHour {
	my ($self, $delay) = @_;
	my $epochTime = time - (3600 * $delay);
	my ($hour) = (localtime($epochTime))[2];
	
	return $hour;
}

sub getGMTDateHour 
{
    my ($self, $dateDelay, $hourDelay) = @_; ## input hour delay
    my $epoch = time - ($hourDelay* 3600); # epoch today
    my $epochLast = $epoch - 3600;
    my $epochYest = $epoch - (24 * 3600); # epoch Yesterday
    my ($mday,$mon,$year, $wday, $gmtHour) = (gmtime($epoch))[3,4,5,6,2]; # Get Time NOW
    my ($yDay,$yMon,$yYear,$yWDay) = (gmtime($epochYest))[3,4,5,6]; # Get Time Yesterday

    my @month = qw(01 02 03 04 05 06 07 08 09 10 11 12); # Array of 2 digit Month Values
    my @day = qw(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31); #Array of 2 digit Days
    
    #Construct Today GMT
    my $thisYear = $year += 1900; # Current 4 digit year
    my $thisMonth = $month[$mon]; # get 2 digit month
    my $thisDay = $day[$mday];
    my $apiDate = $thisYear."-".$thisMonth."-".$thisDay; # concat to form date var
    
    #Construct Last Day/Hour GMT
    my ($lHour,$lDay,$lMon,$lYear) = (gmtime($epochLast))[2,3,4,5];
    my $lastYear = $lYear += 1900; # Current 4 digit year
    my $lMonth = $month[$lMon]; # get 2 digit month
    my $lDay = $day[$mday];
    my $lastDate = $lYear."-".$lMonth."-".$lDay; # concat to form date var
        
    #Construct Yesterday GMT
    my $yesterYear = $yYear += 1900; # Current 4 digit year
    my $yesterMonth = $month[$yMon]; # get 2 digit month
    my $yesterDay = $day[$yDay];
    my $apiYDate = $yesterYear."-".$yesterMonth."-".$yesterDay; # concat to form date var
    
    #DOW
    $wday++;
    $yWDay++;
    
    my $ac = new apiConfig;
    my $iFactor = $ac->getCommonParam('importDelay');
    my $rFactor = $ac->getCommonParam('reimportDelay');
    my $oFactor = $ac->getCommonParam('cdoFactor');
    my $mFactor = $ac->getCommonParam('mdImportDelay');
    
    # GET Import GMT Date/Hour
    my $epochTime = $epoch - (3600 * $iFactor);
    my ($iHour,$iDay,$iMon,$iYear) = (gmtime($epochTime))[2,3,4,5];
    my $impYear = $iYear += 1900; # Current 4 digit year
    my $impMonth = $month[$iMon]; # get 2 digit month
    my $impDay = $day[$iDay];
    my $apiIDate = $impYear."-".$impMonth."-".$impDay; # concat to form date var
    
    
    # GET Re-Import GMT Date/Time
    my $rEpochTime = $epochTime - (3600 * $rFactor);
    my ($rHour,$rDay,$rMon,$rYear) = (gmtime($rEpochTime))[2,3,4,5];
    my $reimpYear = $rYear += 1900; # Current 4 digit year
    my $reimpMonth = $month[$rMon]; # get 2 digit month
    my $reimpDay = $day[$rDay];
    my $apiRDate = $reimpYear."-".$reimpMonth."-".$reimpDay; # concat to form date var
    
    # GET MD GMT Date/Hour
    my $mEpochTime = $epochTime - (3600 * $mFactor);
    my ($mHour,$mDay,$mMon,$mYear) = (gmtime($mEpochTime))[2,3,4,5];
    my $mdimpYear = $mYear += 1900; # Current 4 digit year
    my $mdimpMonth = $month[$mMon]; # get 2 digit month
    my $mdimpDay = $day[$mDay];
    my $apiMDate = $mdimpYear."-".$mdimpMonth."-".$mdimpDay; # concat to form date var
    
    # GET Optimization GMT DOW/Hour
    my $epochNextHour = $epoch + ($oFactor * 3600);
    my ($oHour, $oDay, $oMon, $oYear, $oDOW) = (gmtime($epochNextHour))[2,3,4,5,6];
    my $cdoYear = $oYear += 1900; # Current 4 digit year
    my $cdoMonth = $month[$oMon]; # get 2 digit month
    my $cdoDay = $day[$oDay];
    my $apiCDODate = $cdoYear."-".$cdoMonth."-".$cdoDay; # concat to form date var
    $oDOW++;
    
    return ($apiDate, $gmtHour, $apiYDate, $apiRDate, $iHour, $apiIDate, $rHour, $oHour, $wday, $yWDay, $oDOW, $apiCDODate, $lastDate, $lHour, $apiMDate, $mHour);
}

sub twoDelayDates
{
    my ($self, $seedDate, $hourDelay1, $hourDelay2) = @_;
    my @month = qw(01 02 03 04 05 06 07 08 09 10 11 12); # Array of 2 digit Month Values
    my @day = qw(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31); #Array of 2 digit Days
    
    ##Epoch Dates
    my $delayEpoch1;
    my $delayEpoch2;
    if($seedDate==1)
    {
        my $epoch = time; # epoch NOW (incl delay)
           $delayEpoch1 = $epoch - ($hourDelay1 * 3600); # First Date
           $delayEpoch2 = $delayEpoch1 - ($hourDelay2 * 3600); # Second Date
    }
    else
    {
        my ($yyyy, $mm, $dd) = split(/-/, $seedDate);
        $mm--;
        my $epoch = timelocal(0,0,0,$dd,$mm,$yyyy); # seed date converted to epoch
           $delayEpoch1 = $epoch; # First Date
           $delayEpoch2 = $delayEpoch1 - ($hourDelay2 * 3600); # Second Date
    }

    ##Build Dates
    my ($h1, $d1, $m1, $y1, $dw1) = (gmtime($delayEpoch1))[2,3,4,5,6];
    my ($h2, $d2, $m2, $y2, $dw2) = (gmtime($delayEpoch2))[2,3,4,5,6];
    
    ##Config Dates
    $dw1++;
    $dw2++;
    my $month1 = $month[$m1];
    my $month2 = $month[$m2];
    my $day1 = $day[$d1];
    my $day2 = $day[$d2];
    $y1 += 1900;
    $y2 += 1900;
    
    my $delayDate1 = "$y1-$month1-$day1";
    my $delayDate2 = "$y2-$month2-$day2";
    
    return($delayDate1, $h1, $delayDate2, $h2);
}

sub getPVDate
{
    my ($self, $dateDelay, $hourDelay) = @_; ## input hour delay
    my @month = qw(01 02 03 04 05 06 07 08 09 10 11 12); # Array of 2 digit Month Values
    my @day = qw(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31); #Array of 2 digit Days
    
    # CURRENT DATE/DOW
    my $epoch = time - ($hourDelay* 3600); # epoch today
    my ($mday,$mon,$year, $wday, $gmtHour) = (gmtime($epoch))[3,4,5,6,2]; # Get Time NOW
    $wday++; #DOW
    $year += 1900;
    my $date = $year."-".$month[$mon]."-".$day[$mday];

    # LAST TWO DATES/DOWS
    ## If Monday, previous is Thursday then last Monday
    my $offset;
    if ($wday == 2)
    {
        $offset = 4 * 24;
    }
    else
    {
        $offset = 3 * 24;
    }

    my $epoch_1 = $epoch - ($offset * 3600);
    my $epoch_2 = $epoch - ((7 * 24) * 3600);
    
    my ($mday1, $mon1, $year1, $wday1, $gmtHour1) = (gmtime($epoch_1))[3,4,5,6,2]; # Get Time
    my ($mday2, $mon2, $year2, $wday2, $gmtHour2) = (gmtime($epoch_2))[3,4,5,6,2]; # Get Time
    $wday1++;
    $wday2++;
    $year1 += 1900;
    $year2 += 1900;

    my $date_1 = $year1."-".$month[$mon1]."-".$day[$mday1];
    my $date_2 = $year2."-".$month[$mon2]."-".$day[$mday2];

    return($date, $wday, $date_1, $wday1, $date_2, $wday2);    
}

sub getApiCurrentDate {
	my ($self, $delay) = @_;
	my $epochTime = time - ($delay * 24 * 60 * 60);
	my ($mday,$mon,$year) = (localtime($epochTime))[3,4,5];
    my @month = qw(01 02 03 04 05 06 07 08 09 10 11 12); # Array of 2 digit Month Values
    my @day = qw(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31);
    my $thisYear = $year += 1900; # Current 4 digit year
    my $thisMonth = $month[$mon]; # get 2 digit month
    my $thisDay = $day[$mday];
    my $apiDate = $thisYear."-".$thisMonth."-".$mday; # concat to form date var

    return $apiDate;
	
}

sub aol2mssqlDate {
	my ($self, $datein) = @_;
	my ($m, $d, $y) = split(/\//, $datein);
	
	return("$y-$m-$d");
}

sub aol2mysqlDate {
	my ($self, $datein) = @_;
	my ($m, $d, $y) = split(/\//, $datein);
	
	return("$y$m$d");
}

1;
