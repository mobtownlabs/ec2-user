use Net::Twitter;

my $tweet = Net::Twitter->new(
    traits   => [qw/OAuth API::REST/],
    consumer_key        => 'Y1vCjTEIcz4x9qiBfs8Zw',
    consumer_secret     => 'Ea1UvVCgkkeRLLwEwfk3flNCcNhtpFU1NaSTI7lg',
    access_token        => '239128992-tj0LZqS5I40kINNvrW4PpkXxYGln7gcfzpcwl1UT',
    access_token_secret => 'SCOK8n7sdub4VlhFEVni6nc9NrvviiIL341mWx6dKs'
    );

my $friends = $tweet->lookup_friendships('@);


foreach $f (@$friends)
{
#    print "$key: $$info{$key}\n";
    print "$f\n";
}

#my $result = $tweet->update({ status => 'My first tweet generated from the Perl API connection!' });
