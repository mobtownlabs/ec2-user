#!/perl/bin/perl
use dbiConfig;
use DateFunctions;
use Time::Local;
use apiConfig;

my($date1, $date2) = (DateFunctions->twoDelayDates(1,24,2160))[0,2]; 
print "$date1 :: $date2\n"; exit;

exit;




&hello('',"Hello!");

sub hello
{
    my ($self, $text) = @_;
    print "$text\n";
}


exit;




&compressFiles("/prod/cdo/aol/out", "2012-01-25", 0);
exit;

sub compressFiles
{
    my($localCdoDir, $date, $oHour) = @_;
    my @subFolders = qw(data components bids);
    my $folder = "$localCdoDir/$date/$oHour";
    print "$folder\n";

    foreach $subFolder (@subFolders)
    {
	my $zipFolder = "$folder/$subFolder";
	
	my $cmd = "gzip $zipFolder/*.*";
	system($cmd);
    }

    
    
}





my($date1, $date2) = (DateFunctions->twoDelayDates("2012-01-23",24,2160))[0,2]; 
print "$date1 :: $date2"; exit;



my $date="2012-01-24";
my ($y, $m, $d) = split(/\-/, $date);
$m--;
my $epoch = timelocal(0,0,18,$d,$m,$y);
my $epoch1 = time;
my ($h1, $d1, $m1, $y1, $dw1) = (localtime($epoch))[2,3,4,5,6];
my ($h2, $d2, $m2, $y2, $dw2) = (localtime($epoch1))[2,3,4,5,6];
print "$epoch  $epoch1\n";
print "$h1, $d1, $m1, $y1, $dw1\n";
print "$h2, $d2, $m2, $y2, $dw2\n";

exit;

for ($h=0; $h<24; $h++)
{
    my $dbi = dbiConfig->dbiConnect('');

    print DateFunctions->currentTime()."\n";

    my $sql = qq| SELECT concat(san,"_",adid,"_",siteid,"_",segmentid,"_",hour) as id, dayofweek(date) as dow, hour, san, adid, siteid, segmentid, impressions as n, clicks as k, actions as a, conversions as conv, spend as spend
              FROM DisplayLogsHourly dlh
              WHERE date = '$date1' |;

    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $new = $sth->fetchall_hashref(id);
    $sth->finish();

    my $sql = qq| SELECT concat(san,"_",adid,"_",siteid,"_",segmentid,"_",hour) as id, dayofweek(date) as dow, hour, san, adid, siteid, segmentid, impressions as n, clicks as k, actions as a, conversions as conv, spend as spend
              FROM DisplayLogsHourly dlh
              WHERE date = '$date2' |;

    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $old = $sth->fetchall_hashref(id);
    $sth->finish();

    open(TEST, ">/home/ec2-user/prod/cdo/aol/out/updateTest.txt");

    foreach my $id (keys %{$new})
{

    my $sql = "INSERT INTO DisplayLogsByDOWHour VALUES (".$$new{$id}{'dow'}.", ".$$new{$id}{'hour'}.", '".$$new{$id}{'san'}."', ".$$new{$id}{'adid'}.", ".$$new{$id}{'siteid'}.", ".$$new{$id}{'segmentid'}.", ".$$new{$id}{'n'}.", ".$$new{$id}{'k'}.", ".$$new{$id}{'a'}.", ".$$new{$id}{'conv'}.", ".$$new{$id}{'spend'}.")
                  ON DUPLICATE KEY UPDATE impressions=impressions+".$$new{$id}{'n'}.", clicks=clicks+".$$new{$id}{'k'}.", actions=actions+".$$new{$id}{'a'}.", conversions=conversions+".$$new{$id}{'conv'}.", spend=spend+".$$new{$id}{'spend'};
    
    my $sth = $dbi->prepare($sql);
    $sth->execute();
    $sth->finish();
}

foreach my $id (keys %{$old})
{
    my $sql = "UPDATE DisplayLogsByDOWHour SET impressions=impressions-".$$old{$id}{'n'}.", clicks=clicks-".$$old{$id}{'k'}.", actions=actions-".$$old{$id}{'a'}.", conversions=conversions-".$$old{$id}{'conv'}.", spend=spend-".$$old{$id}{'spend'}.
        " WHERE adid=".$$old{$id}{'adid'}." AND siteid=".$$old{$id}{'siteid'}." AND segmentid=".$$old{$id}{'segmentid'}." AND dow=".$$old{$id}{'dow'}." AND hour=".$$old{$id}{'hour'};

    my $sth = $dbi->prepare($sql);
    $sth->execute();
    $sth->finish();
}

close TEST;

$dbi->disconnect;

print DateFunctions->currentTime()."\n";
}
sub noNull {
	my ($input, $output) = @_;

	if ($input >= 0)
		{
			return $input;	
		}
	else
		{
		        return $output;
		}
}

exit;















$file = "/home/ec2-user/prod/cdo/aol/in/197487/priceVolume/197487_pv_2012-01-09.csv";
open(FILE, $file);
my @count = <FILE>;
print @count."\n";
exit;




use DateFunctions;

my ($date) = (DateFunctions->getGMTDateHour(0,3600))[0];
print "$date\n";
exit;









use dbiConfig;
my $dbi = dbiConfig->dbiConnect('localMySQL');

my $sql = qq| SELECT san,cid,usepoe from Campaign WHERE usepoe=1|;
my $sth = $dbi->prepare($sql);
   $sth->execute();
my $hash = $sth->fetchall_hashref(san);
$sth->finish();

my $sql = qq| SELECT san,cid,usepoe from Campaign WHERE usepoe=0|;
my $sth = $dbi->prepare($sql);
   $sth->execute();
while (my @temp = $sth->fetchrow_array)
{
    $$hash{$temp[0]}{'cid'} = $temp[1];
    $$hash{$temp[0]}{'usepoe'} = $temp[2];
}

$sth->finish();


foreach $key (sort keys %{$hash})
{
    print "$key: $$hash{$key}{'cid'}, $$hash{$key}{'usepoe'}\n";
}

exit;












#my $localDir="/home/ec2-user/prod/cdo/aol/in/197487";

#my @subFolders = qw(hourly daily mtd priceVolume);

#if(!opendir(DIR, $localDir))
#{
#    print "$localDir HAHA\n";
    
#    my $cmd = "mkdir $localDir"; system($cmd);

#    foreach $subFolder (@subFolders)
#    {
#        my $folder = "$localDir/$subFolder";
#        opendir(DIR, $folder);
#        my @dir = readdir(DIR);
#        close(DIR);
    
#        if (!@dir)
#        {
#            my $cmd = "mkdir $folder"; system($cmd);
            
#        }
#    }
#}
#else { print "HAHA\n"; }
#exit;


my $file1="/home/ec2-user/prod/cdo/aol/out/2011-12-19/15/bids/optBids.csv";
my $file2="/home/ec2-user/prod/cdo/aol/out/2011-12-19/16/bids/optBids.csv";

my $bids1 = {};
    open(BIDS, "$file1");
    while(<BIDS>)
    {
        $_ =~ s/\n//g;
        my ($cellid, $san, $lp, $bid, $alpha, $vol, $cvol, $espend, $type) = split(/,/, $_);    
        $$bids1{$cellid} = $bid;
    }
close BIDS;

my $bids2 = {};
    open(BIDS, "$file2");
    while(<BIDS>)
    {
        $_ =~ s/\n//g;
        my ($cellid, $san, $lp, $bid, $alpha, $vol, $cvol, $espend, $type) = split(/,/, $_);    
        $$bids2{$cellid} = $bid;
    }
close BIDS;
    
print keys(%{$bids1})."\n";
print keys(%{$bids2})."\n";

my $updatedBids = {};

my $ind = 0;
foreach $cell (keys %{$bids2})
{
    my $last_bid = &ifExists($$bids1{$cell}, "NONE");
    my $current_bid = &noNull($$bids2{$cell}, 0);
    $ind++;

 #print "$cell: $last_bid -> $current_bid\n";

    if ($current_bid ne $last_bid)
    {
#        print "$cell: $last_bid -> $current_bid\n";
        $$updatedBids{$cell} = $current_bid;
    }
    
}

print keys (%{$updatedBids})."\n";



sub noNull {
	my ($input, $output) = @_;

	if ($input >= 0)
		{
			return $input;	
		}
	else
		{
		        return $output;
		}
}

sub ifExists {
	my ($input, $output) = @_;

	if ($input ne '')
		{
			return $input;	
		}
	else
		{
		        return $output;
		}
}

   
exit;





my $url = "https://api.adlearnop.advertising.com/WebsvcDir/20102/reports/168114/2011/06/06_122.csv";
my $file = "hourlyTest.csv";

my $browser = new LWP::UserAgent;
my $headers = HTTP::Headers->new( 'Authorization' => apiConfig->getConfigParam('auth64') );
$browser->default_headers($headers);
$browser->ssl_opts(verify_hostname => 0);

#my $file = "$campId\_hourly\_$date\_$hour.csv";
my $res = $browser->mirror($url, "$file");

if ($res->is_error)
{
    print $res->status_line;
} 
