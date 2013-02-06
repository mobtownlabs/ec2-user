#!/usr/bin/perl

use DBI;
use apiConfig;
use dataLoader;
use dataImport;
use dbiConfig;
use DateFunctions;

my $dbi = dbiConfig->dbiConnect('localMySQL');
my ($yesterdayDate) = (DateFunctions->getGMTDateHour(0,0))[2];
my ($addDate, $removeDate) = (DateFunctions->twoDelayDates(1,24,2160))[0,2];

open($log, ">/home/ec2-user/prod/cdo/aol/bin/manual.txt");

&hourly($yesterdayDate, 0, $log);
&aggregate($yesterdayDate, $log);
&cdoAggregate($addDate,$removeDate,$log);

close $log;
$dbi->disconnect();
exit;

sub aggregate
{
    my ($date, $log) = @_;
    my $di = new dataImport;

    my $dir = "/home/ec2-user/prod/cdo/aol/logs/importAggregates";

        print "\nRunning Aggs for $date\n";
        $di->aggregate($date, $dir, $log);
}

sub cdoAggregate
{
    my ($addDate, $removeDate, $log) = @_;
    my $di = new dataImport;

    print "\nRunning cdoAggs for $addDate and $removeDate\n";
    $di->cdoAggregate($appDate, $removeDate, $log);
}

sub hourly
{
    my ($date, $hour, $log) = @_;
    my $di = new dataImport;

    my $sql = qq|SELECT cid,san FROM Campaign WHERE isapi=1|;
    my $sth = $dbi->prepare($sql);
    $sth->execute();

    while(my($cid, $san) = $sth->fetchrow_array)
    {
        system("mkdir /home/ec2-user/prod/cdo/aol/in/$cid");
        my $localDir = "/home/ec2-user/prod/cdo/aol/in/$cid";

            for ($h=0; $h<24; $h++)
            {
                $di->hourlyImport($date, $h, $cid, $san, $localDir, $localDir, $log);
            }
    }
    
    $sth->finish();
}
