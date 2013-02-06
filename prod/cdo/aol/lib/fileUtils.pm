package fileUtils;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub newImportDir
{
        my ($self, $localDir) = @_;
        my @subFolders = qw(hourly daily mtd priceVolume network);

        if(!opendir(DIR, $localDir))
        {
            my $cmd = "mkdir $localDir"; system($cmd);

            foreach $subFolder (@subFolders)
            {
                my $folder = "$localDir/$subFolder";
                opendir(DIR, $folder);
                my @dir = readdir(DIR);
                close(DIR);

                if (!@dir)
                {
                    my $cmd = "mkdir $folder"; system($cmd);

                }
            }
        }
}

sub newCdoFolder
{
	my($self, $localCdoDir, $date, $oHour) = @_;

	my $folder = "$localCdoDir/$date/$oHour";
	print "Creating folder: $folder\n";
	opendir(DIR, $folder);
	   my @dir = readdir(DIR);
	close(DIR);
			
	if(!@dir)
	{
	   my $cmd = "mkdir $localCdoDir/$date"; system($cmd);
	   my $cmd = "mkdir $localCdoDir/$date/$oHour"; system($cmd);
           my @subFolders = qw(data components bids);

          foreach $subFolder (@subFolders)
	  {
	       my $cdoFolder = $folder."/".$subFolder;
	       my $cmd = "mkdir $cdoFolder";
	       system($cmd);
	  }
	}
		
}

sub compressFiles
{
    my($self, $localCdoDir, $date, $oHour) = @_;
    my @subFolders = qw(data components);
    my $folder = "$localCdoDir/$date/$oHour";

    foreach $subFolder (@subFolders)
    {
	my $zipFolder = "$folder/$subFolder";
	
	my $cmd = "gzip $zipFolder/*.*";
	system($cmd);
    }
}

1;
