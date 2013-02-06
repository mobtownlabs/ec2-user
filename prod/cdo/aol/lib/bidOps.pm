package bidOps;

use DateFunctions;
use Logger;

my $DateFunctions = new DateFunctions;
my $logger = new Logger;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}


sub getBids
{
    my ($self, $type, $bidList, $date, $lastDate, $hour, $lastHour, $log) = @_;
    $logger->write($log, $DateFunctions->currentTime().":  >> Getting $type Bids\n");    

    my $lastBids = {};
    open(BIDS, &getBidFile(1, $type, $lastDate, $lastHour)); print " --- >> Last Bids: ".&getBidFile(1, $type, $lastDate, $lastHour)."\n";
    while(<BIDS>)
    {
        $_ =~ s/\n//g;
        my ($cellid, $san, $lp, $bid, $alpha, $vol, $cvol, $espend, $type) = split(/,/, $_);    
        $$lastBids{$cellid}{'bid'} = $bid;
        $$lastBids{$cellid}{'lp'} = $lp;
    }
    close BIDS;

    my $currentBids = {};
    open(BIDS, &getBidFile(1, $type, $date, $hour)); print " --- >> Current Bids: ".&getBidFile(1, $type, $date, $hour)."\n";
    while(<BIDS>)
    {
        $_ =~ s/\n//g;
        my ($cellid, $san, $lp, $bid, $alpha, $vol, $cvol, $espend, $type) = split(/,/, $_);    
        $$currentBids{$cellid}{'bid'} = $bid;
        $$currentBids{$cellid}{'lp'} = $lp;
    }
    close BIDS;

    my $updated = 0;
    my $u_type = "U\_$type";
    my $delta_type = "DELTA\_$type";

    open(UPDATEDBIDS, ">", &getBidFile(1, $u_type, $date, $hour));
    open(BIDCHANGES, ">", &getBidFile(1, $delta_type, $date, $hour));

    foreach $cell (keys %{$currentBids})
    {
        my $last_bid = &ifExists($$lastBids{$cell}{'bid'}, "NONE");
        my $current_bid = &noNull($$currentBids{$cell}{'bid'}, 0);

        if ($current_bid ne $last_bid)
        {
            $updated++;
            print UPDATEDBIDS "$cell,$current_bid\n";
            print BIDCHANGES "$cell,$$currentBids{$cell}{'lp'},$last_bid,$current_bid\n";
        }
        
    }
    close UPDATEDBIDS;
    close BIDCHANGES;

    $logger->write($log, $DateFunctions->currentTime().":  >> $updated $type bids set to be uploaded.\n");
}

sub getBidFile
{
    my ($self, $type, $date, $hour) = @_;
    my $bidFile;

    if ($type eq 'OPT')
    {
        my $file = apiConfig->getCommonParam('optBidsFile');
        $file =~ s/<DATE>/$date/;
        $file =~ s/<HOUR>/$hour/;
        $bidFile = $file;
    }
    elsif ($type eq 'DEF')
    {
        my $file = apiConfig->getCommonParam('defBidsFile');
        $file =~ s/<DATE>/$date/;
        $file =~ s/<HOUR>/$hour/;
        $bidFile = $file;
    }
    elsif ($type eq 'U_OPT')
    {
        my $file = apiConfig->getCommonParam('updatedOptBidsFile');
        $file =~ s/<DATE>/$date/;
        $file =~ s/<HOUR>/$hour/;
        $bidFile = $file;
    }
    elsif ($type eq 'U_DEF')
    {
        my $file = apiConfig->getCommonParam('updatedDefBidsFile');
        $file =~ s/<DATE>/$date/;
        $file =~ s/<HOUR>/$hour/;
        $bidFile = $file;
    }
    elsif ($type eq 'DELTA_OPT')
    {
        my $file = apiConfig->getCommonParam('changedOptBidsFile');
        $file =~ s/<DATE>/$date/;
        $file =~ s/<HOUR>/$hour/;
        $bidFile = $file;
    }
    elsif ($type eq 'DELTA_DEF')
    {
        my $file = apiConfig->getCommonParam('changedDefBidsFile');
        $file =~ s/<DATE>/$date/;
        $file =~ s/<HOUR>/$hour/;
        $bidFile = $file;
    }

    return($bidFile);

}

###LOCAL SUBS
sub noNull {
	my ($input, $output) = @_;

	if ($input > 0)
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

1;
