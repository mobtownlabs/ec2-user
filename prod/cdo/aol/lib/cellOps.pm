package cellOps;

use dbiConfig;
use apiOps;
use apiUtils;
use apiConfig;

sub new
{
	my $self = {};
	bless $self;
	return $self;
}

sub getNewCellGroupId
{
	my ($self, $campId) = @_;
	
	my $ao = new apiOps;
	my $au = new apiUtils;
	my $ac = new apiConfig;
	
	my ($request, $hashOut, $xmlOut) = $ao->apiAction("readCellGroupList", $campId);
	my ($newCellGroupId, $newCellGroupName) = $au->readCellGroupInfo($xmlOut, 1, $ac->getCommonParam('newGroupName'));
	
	return($newCellGroupId, $newCellGroupName);
}

sub getUngroupedCellGroupId
{
	my ($self, $campId) = @_;
	
	my $ao = new apiOps;
	my $au = new apiUtils;
	my $ac = new apiConfig;
	
	my ($request, $hashOut, $xmlOut) = $ao->apiAction("readCellGroupList", $campId);
	my ($ungroupedCellGroupId, $ungroupedCellGroupName) = $au->readCellGroupInfo($xmlOut, 1, $ac->getCommonParam('newCampaignGroupName'));
	
	return($ungroupedCellGroupId, $ungroupedCellGroupName);
}

sub getCells
{
	my ($self, $campId, $cellGroupId, $pageIndex, $pageSize) = @_;
	
	my $ao = new apiOps;
	my $au = new apiUtils;
	
	my ($request, $hashOut, $xmlOut) = $ao->apiAction("readCompleteCellList", "$campId\-$cellGroupId\-$pageIndex\-$pageSize");
	my ($cellInfo, $pageIndex) = $au->readCellInfo($xmlOut, $pageIndex);
	
	return ($cellInfo, $pageIndex);
}

sub getRemovedCellGroupId
{
	my ($self, $campId) = @_;
	
	my $ao = new apiOps;
	my $au = new apiUtils;
	
	my ($request, $hashOut, $xmlOut) = $ao->apiAction("readCellGroupList", $campId);
	my ($removedCellGroupId, $removedCellGroupName) = $au->readCellGroupInfo($xmlOut, 1, "REMOVED");
	
	return($removedCellGroupId, $removedCellGroupName);
}

sub getRemovedCells
{
	my ($self, $campId, $cellGroupId, $pageIndex, $pageSize) = @_;
	
	my $ao = new apiOps;
	my $au = new apiUtils;
	
	my ($request, $hashOut, $xmlOut) = $ao->apiAction("readCompleteCellList", "$campId\-$cellGroupId\-$pageIndex\-$pageSize");
	my ($cellInfo, $pageIndex) = $au->readCellInfo($xmlOut, $pageIndex);
	
	return ($cellInfo, $pageIndex);
	
}

sub getBids
{
	my ($self, $campId) = @_;
	
	my $ao = new apiOps;
	my $au = new apiUtils;
	
	my ($request, $hashOut, $xmlOut) = $ao->apiAction("readBidList", $campId);
	my ($bidInfo) = $au->readBidInfo($xmlOut);
	
	return ($bidInfo);
}

sub cellInsertTest
{
	my ($self, $cellInfo, $san, $isNew) = @_;
	my $counter = 0;
	my $block = 0;
	my $valuesString;
	my $SQL = '';
		
	my $sqlInsert = "INSERT INTO cdoCells (cellid,adid,siteid,segmentid,new) VALUES\n";
	foreach $cell (@$cellInfo)
		{
			#if(!$$currentCells{$cell->{'id'}}) # DO NOT Insert Dupe Cells
			#	{
					$counter++;
					if ($counter > 1)
						{
							$block++;
							
							$values = "("."$cell->{'id'},$cell->{'mediaId'},$cell->{'siteId'},$cell->{'segmentId'},$isNew".")";
							if ($block > 1) { $valuesString = $valuesString.",".$values; }
							else { $valuesString = $valuesString.$values; }
							
							#1000 value params at a time
							#if ($block == 1000)
							#	{
							#		my $sqlTemp = $sqlInsert.$valuesString.";\n";
							#		$SQL = $SQL.$sqlTemp;
							#		$block = 0;
							#		$valuesString = '';
							#	}
						}
			#	}
		}
	
	if ($valuesString ne '')
	{
		my $sqlTemp = $sqlInsert.$valuesString.";\n";
		$SQL = $SQL.$sqlTemp;	
	}
	
	## DBI
	my $dbi = dbiConfig->dbiConnect('');
	
	## Execute SQL
	my $sth = $dbi->prepare($SQL);
		$sth->execute();
		$sth->finish();
		$dbi->disconnect();
		
	### DEBUG TEST
	#open(SQL,">/sandbox/AOL_hourly/DataFlows/out/cell_sql.txt");
	#print SQL $SQL;
	#close SQL;
	###
	
	return($counter);
}

sub cellInsert
{
	my ($self, $currentCells, $cellInfo, $dow, $hour, $san) = @_;
	my $counter = 0;
	my $block = 0;
	my $valuesString;
	my $SQL = '';
		
	my $sqlInsert = "INSERT INTO cdoDataAolTemp (id,dow,hour,san,adid,siteid,segmentid) VALUES\n";
	foreach $cell (@$cellInfo)
		{
			if(!$$currentCells{$cell->{'id'}}) # DO NOT Insert Dupe Cells
				{
					$counter++;
					if ($counter > 1)
						{
							$block++;
							
							$values = "("."$cell->{'id'},$dow,$hour,'$san',$cell->{'mediaId'},$cell->{'siteId'},$cell->{'segmentId'}".")";
							if ($block > 1) { $valuesString = $valuesString.",".$values; }
							else { $valuesString = $valuesString.$values; }
							
							#1000 value params at a time
							if ($block == 1000)
								{
									my $sqlTemp = $sqlInsert.$valuesString.";\n";
									$SQL = $SQL.$sqlTemp;
									$block = 0;
									$valuesString = '';
								}
						}
				}
		}
	
	if ($valuesString ne '')
	{
		my $sqlTemp = $sqlInsert.$valuesString.";\n";
		$SQL = $SQL.$sqlTemp;	
	}
	
	## DBI
	my $dbi = dbiConfig->dbiConnect('');
	
	## Execute SQL
	my $sth = $dbi->prepare($SQL);
		$sth->execute();
		$sth->finish();
		$dbi->disconnect();
		
	### DEBUG TEST
	#open(SQL,">/sandbox/AOL_hourly/DataFlows/out/cell_sql.txt");
	#print SQL $SQL;
	#close SQL;
	###
	
	return($counter);
}


sub cellDelete
{
	my ($self, $removedCellInfo, $cell) = @_;
	my $SQL = '';
	my $rows = 0;
	
	foreach $rc (@$removedCellInfo)
		{
			if($$cell{$rc->{'id'}})
			{
				$rows++;
				$SQL = $SQL."DELETE FROM cdoDataAol WHERE id=$rc->{'id'};\n";
			}
		}
		
	## DBI
	my $dbi = dbiConfig->dbiConnect('');
	
	## Execute SQL
	my $sth = $dbi->prepare($SQL);
	$sth->execute();
	my $err = $sth->errstr();
	$sth->finish();
	$dbi->disconnect();
		
	### DEBUG TEST
	#open(SQL,">/sandbox/AOL_hourly/DataFlows/out/rcell_sql.txt");
	#print SQL $SQL;
	#close SQL;
	###
	
	return($err, $rows);
}

sub cellDeleteTest
{
	my ($self, $removedCellInfo) = @_;
	my $SQL = '';
	my $rows = 0;
        my $marked = 0;
	
	## DBI
	my $dbi = dbiConfig->dbiConnect('');

	foreach $rc (@$removedCellInfo)
		{
                    $rows++;
                    $SQL = qq|UPDATE cdoCells SET active=0 WHERE cellid=$rc->{'id'}|;
                    my $sth = $dbi->prepare($SQL);
                    $sth->execute();
                    my $err = $sth->errstr();
                    if (!$err) 
                    {
                        $marked = $marked + $sth->rows;
                    }
                    $sth->finish();
                    
		}
			
	## Execute SQL
	my $sth = $dbi->prepare($SQL);
	$sth->execute();
	my $err = $sth->errstr();
	$sth->finish();
	$dbi->disconnect();
		
	### DEBUG TEST
	#open(SQL,">./rcell_sql.txt");
	#print SQL $SQL;
	#close SQL;
	###
	
	return($err, $rows, $marked);
}

sub newCellQueue
{
    my $dbi = dbiConfig->dbiConnect('');
    
    my $sql = qq| TRUNCATE newCellsQueue |;
    my $sth = $dbi->prepare($sql);
    $sth->execute();
    $sth->finish();

    my $sql = qq| INSERT INTO newCellsQueue (cellid,adid,siteid,segmentid) SELECT cellid, adid, siteid, segmentid FROM cdoCells WHERE new=1 |;
    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $rows = $sth->rows;
    $sth->finish();

    $dbi->disconnect();

    return($rows);
}

sub distributeNewCells
{
    my ($self, $log) = @_;

    my $apiOps = apiOps->new();
    my $dbi = dbiConfig->dbiConnect('');

    my $sql = qq| SELECT cellid as id FROM cdoCells|;
#    my $sql = qq| SELECT cellid as id FROM newCellsQueue |;
    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $cellsToDistribute = $sth->fetchall_hashref(id);
    $sth->finish();

    my @cellData = ($cellsToDistribute, $log);

    $apiOps->apiAction("distributeCellList", \@cellData);

    $dbi->disconnect();
}

sub oldCellQueue
{
    my $dbi = dbiConfig->dbiConnect('');
    
    my $sql = qq| TRUNCATE oldCellsQueue |;
    my $sth = $dbi->prepare($sql);
    $sth->execute();
    $sth->finish();

    my $sql = qq| INSERT INTO oldCellsQueue (cellid,adid,siteid,segmentid) SELECT cellid, adid, siteid, segmentid FROM cdoCells WHERE active=0 |;
    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $rows = $sth->rows;
    $sth->finish();

    $dbi->disconnect();

    return($rows);
}

sub acknowledgeOldCells
{
    my ($self, $log) = @_;

    my $apiOps = apiOps->new();
    my $dbi = dbiConfig->dbiConnect('');

    my $sql = qq| SELECT cellid FROM oldCellsQueue |;
    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $cellsToAcknowledge = $sth->fetchall_hashref(cellid);
    $sth->finish();

    my @cellData = ($cellsToAcknowledge, $log);

    $apiOps->apiAction("acknowledgeCellList", \@cellData);

    $dbi->disconnect();
}

sub updateNetwork
{
    my $dbi = dbiConfig->dbiConnect('');

    my $sql = qq| CREATE TABLE cdoCellsTemp (cellid int primary key, adid int, siteid int, segmentid int, active tinyint default 1, new tinyint default 0, createdDateTime timestamp) |;
    my $sth = $dbi->prepare($sql);
    $sth->execute();
    $sth->finish();

    my $sql = qq| INSERT INTO cdoCellsTemp (cellid,adid,siteid,segmentid) SELECT cellid, adid, siteid, segmentid FROM cdoCells WHERE active=1 |;
    my $sth = $dbi->prepare($sql);
    $sth->execute();
    my $rows = $sth->rows;
    my $error = $sth->err;
    my $errorMsg = $sth->errstr();
    $sth->finish();

    if(!$error)
    {
        my $sql = qq| DROP TABLE cdoCells |;
        my $sth = $dbi->prepare($sql);
        $sth->execute();
        $sth->finish();

        my $sql = qq| RENAME TABLE cdoCellsTemp TO cdoCells |;
        my $sth = $dbi->prepare($sql);
        $sth->execute();
        $sth->finish();
        
        return($rows);
    }
    else
    {
        return($errorMsg);
    }

    $dbi->disconnect();
}

### LOCAL SUB
sub bidCheck
{
	my ($bidIn) = @_;
	my $ac = new apiConfig;
	
	if ($bidIn)
		{
			return $bidIn;
		}
	else
		{
			return $ac->getCommonParam('minBid');
		}
}

1;
