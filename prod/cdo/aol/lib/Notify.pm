package Notify;

use Mail::Sender;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub send_email {
	my($self, $to, $from, $subject, $message, $attach, $file) = @_;
	
	my $sender = new Mail::Sender {smtp=>'mail.doublepositive.com',
								   from=>$from, 
								   replyto=>'mpatton@doublepositive.com'} or die "ERROR creating object: $Mail::Sender::Error\n";
	
	if ($attach == 1){
		$sender->MailFile({to=>$to,
						   subject => $subject, 
						   msg=> $message, 
						   file=>$file}) or die "Failed to Send Message $sender->{'error_msg'}\n" ;
	}
	else {
		$sender->MailMsg({to=>$to,
						   subject => $subject, 
						   msg=> $message}) or die "Failed to Send Message $sender->{'error_msg'}\n" ;
	}	
}

1;