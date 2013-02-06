#!/usr/bin/perl

use DBI;
use apiConfig;
use dataLoader;
use dataImport;
use dataAggregation;
use dbiConfig;
use Logger;
use DateFunctions;
use apiConfig;

my $dbi = dbiConfig->dbiConnect('localMySQL');
my $ac = new apiConfig;

my $mode=shift;


if ($mode eq 'agg')
{
my $di = new dataImport;

my $month = "2012-01-";
my $dir = "/home/ec2-user/prod/cdo/aol";


my $logger = new Logger;
my $logFolder = $ac->getCommonParam('cdoLogDir')."/importAggregates";
my $aggLog = $logger->openFile($logFolder, "hourlyRollUpsLog\_$date.txt");

for ($d=23; $d<24; $d++)
{
  my $day;
  if($d<10){$day = "0".$d;}
  else {$day=$d;}
  my $date = $month.$day;

  my $aggLog = $logger->openFile($logFolder, "hourlyRollUpsLog\_$date.txt");
  print "Running for $date\n";
  $di->aggregate($date, $dir);

  $logger->closeFile($aggLog);
}

$dbi->disconnect();

exit;
}

if ($mode eq 'cdoAgg')
{
my $di = new dataImport;

my $month = "2012-01-";
my $dir = "/home/ec2-user/prod/cdo/aol";

my $logger = new Logger;
my $logFolder = $ac->getCommonParam('cdoLogDir')."/importAggregates";

for ($d=23; $d<24; $d++)
{
  my $day;
  if($d<10){$day = "0".$d;}
  else {$day=$d;}
  my $date = $month.$day;

  my($addDate, $removeDate) = (DateFunctions->twoDelayDates($date,24,2160))[0,2]; 

  my $aggLog = $logger->openFile($logFolder, "cdoAggregateLog\_$date.txt");
  print "Running for $date\n";
  $di->cdoAggregate($addDate, $removeDate, $aggLog);

  $logger->closeFile($aggLog);
}

$dbi->disconnect();

exit;
}


elsif($mode eq 'hourly')
{
my $di = new dataImport;

my $month = "2012-01-";
my $dir = "/home/ec2-user/prod/cdo/aol";

open($log, ">/home/ec2-user/sandbox/cdo/aol/bin/manual.txt");

my $sql = qq|SELECT cid,san FROM Campaign WHERE isapi=1|;
my $sth = $dbi->prepare($sql);
$sth->execute();

while(my($cid, $san) = $sth->fetchrow_array)
{
    system("mkdir /home/ec2-user/prod/cdo/aol/in/$cid");
    my $localDir = "/home/ec2-user/prod/cdo/aol/in/$cid";
    for ($d=23; $d<24; $d++)
    {
	my $day;
	if($d<10){$day = "0".$d;}
	else {$day=$d;}
	my $date = $month.$day;

	for ($h=0; $h<24; $h++)
	{
	    $di->hourlyImport($date, $h, $cid, $san, $localDir, $localDir, $log);
	}

    }

}

$sth->finish();


$dbi->disconnect();
close $log;

exit;
}
