package Logger;

use DateFunctions;
my $DateFunctions = new DateFunctions;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub openFile {
    my ($self, $directory, $filename) = @_;
    my $path = "$directory/$filename";
    open($log, ">$path");
    
    return $log;

}

sub writeFile {
    my ($self, $log, $logEntry) = @_;
    print $log $DateFunctions->currentTime().": ".$logEntry."\n";

}

sub write
{
	my ($self, $log, $logEntry) = @_;
	print $log $logEntry; # print to log
	print $logEntry; # print to <stdout>
}

sub closeFile {
	my($self, $log) = @_;
    close $log;
}






1;