package CDO_Util;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub FileToVariable {
my($self, $dir, $file) = @_;
my $message;

	open(IN, "$dir/$file");
		while(<IN>)
			{
				$message = $message.$_;	
			}
	close IN;
	
	return $message;
	
}

1;