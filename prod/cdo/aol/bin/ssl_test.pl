use LWP;

$ENV{HTTPS_DEBUG} = 1;
#$ENV{HTTPS_CA_DIR} = '/etc/ssl/certs';
#$ENV{HTTPS_CA_FILE} =  '/etc/ssl/certs/perl_int.cer';

my $agent = LWP::UserAgent->new;
$agent->ssl_opts(verify_hostname => 0);
my $req = HTTP::Request->new(GET, "https://api.adlearnop.advertising.com");
my $res = $agent->request($req);
print $res->content;

exit;

foreach $key (keys %ENV)
{
    print "$key: $ENV{$key}\n";
}

exit;
