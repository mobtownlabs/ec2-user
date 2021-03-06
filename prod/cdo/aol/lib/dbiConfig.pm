package dbiConfig;
# Module that maintains ONE db connection string
# This way I don't have to keep changing a million DB strings
#  when they change
use DBI;
use apiConfig;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub dbiConnect
{
	my($self, $source) = @_;
	my $dbi;

        ### DEFAULT (FROM apiConfig)
        if ($source eq '')
        {
            $source = apiConfig->getConfigParam('defaultDB');
        }
	
        ### Specific
	if($source eq 'cdo')
	{
		my $u = 'CDOadmin';
		my $p = 'rdd@S2#5';
		$dbi = DBI->connect('dbi:ODBC:CDO', $u, $p);
	}
	elsif($source eq 'DisplaySearch')
	{
		my $u = 'search';
		my $p = 'doublep123';
		$dbi = DBI->connect('dbi:ODBC:driver={SQL Server}; Server=p-sqlsub01; database=DisplaySearch', $u, $p);
	}
        elsif($source eq 'localMySQL')
        {
                my $u = 'root';
                my $p = 'doublep123';
                $dbi = DBI->connect('dbi:mysql:cdo:localhost:3306', $u, $p);
        }
	
	return($dbi);
}


1;
