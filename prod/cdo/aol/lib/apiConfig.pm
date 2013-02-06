package apiConfig;

use MIME::Base64;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub getConfigParam {
	my ($self, $param) = @_;
	
	my $machine = "PROD";  ### PRODUCTION="PROD", TESTING="BETA"
	
	#### API Config
	if ($machine eq 'PROD')
		{
			$config{'host'} = "api.adlearnop.advertising.com"; # EBI Host
			$config{'baseUrl'} = "https://api.adlearnop.advertising.com"; # EBI Main URL;
			$config{'pName'} = "doublePositive Marketing Group, Inc.";
			$config{'pid'} = "20102";
			$config{'uid'} = "hotleads";
			$config{'pwd'} = "d2PmPBtJr!";
			$config{'auth'} = $config{'uid'}.":".$config{'pwd'};
			$config{'auth64'} = "Basic ".encode_base64($config{'auth'}); # Base 64 Authenticator
                        $config{'defaultDB'} = "localMySQL";
		}
	else
		{
			$config{'host'} = "beta.api.adlearnop.advertising.com"; # EBI Host
			$config{'baseUrl'} = "https://beta.api.adlearnop.advertising.com"; # EBI Main URL;
			$config{'pName'} = "Double Positive";
			$config{'pid'} = "20001";
			$config{'uid'} = "DoublePositiveSB";
			$config{'pwd'} = "T3stInt3gration";
			$config{'auth'} = $config{'uid'}.":".$config{'pwd'};
			$config{'auth64'} = "Basic ".encode_base64($config{'auth'}); # Base 64 Authenticator
                        $config{'defaultDB'} = "localMySQL";
		}
		
		return $config{$param};
}

sub getService {
	my ($self, $param) = @_;
	
	#### Services
		$service{'campaignService'} = "/20110228/CampaignService";
		$service{'reportingService'} = "/20110228/ReportingService.svc";
		$service{'recommendationService'} = "/20110228/RecommendationService.svc";
		$service{'cellGroupService'} = "/20110228/CellGroupService";
		$service{'bidService'} = "/20110228/BidService";
	
		return $service{$param};
}

sub getCommonParam {
    my ($self, $param) = @_;
    my $rootWinDir = "/prod";
    my $rootPerlDir = "/prod";
    
    #### Common Params

    # Directories
    $common{'localImportDir'} = "$rootWinDir/cdo/aol/in";
    $common{'localImportPerlDir'} = "$rootPerlDir/cdo/aol/in";
    $common{'localExportDir'} = "$rootWinDir/cdo/aol/out";
    $common{'localExportPerlDir'} = "$rootPerlDir/cdo/aol/out";
    $common{'localCdoWINDir'} = "$rootWinDir/cdo/aol/out";
    $common{'localCdoDir'} = "$rootPerlDir/cdo/aol/out";
    $common{'importLogDir'} = "$rootPerlDir/cdo/aol/logs/AOLImport";
    $common{'cdoLogDir'} = "$rootPerlDir/cdo/aol/logs";

    # Files
    $common{'importLogFile'} = "aolImportLog\_";
    $common{'cdoLogFile'} = "cdoLog\_";
    $common{'optBidsFile'} = "$rootWinDir/cdo/aol/out/<DATE>/<HOUR>/bids/optBids.csv";
    $common{'defBidsFile'} = "$rootWinDir/cdo/aol/out/<DATE>/<HOUR>/bids/defBids.csv";
    $common{'updatedBidsFile'} = "$rootWinDir/cdo/aol/out/<DATE>/<HOUR>/bids/updatedBids.csv";
    $common{'updatedOptBidsFile'} = "$rootWinDir/cdo/aol/out/<DATE>/<HOUR>/bids/updatedOptBids.csv";
    $common{'updatedDefBidsFile'} = "$rootWinDir/cdo/aol/out/<DATE>/<HOUR>/bids/updatedDefBids.csv";
    $common{'changedOptBidsFile'} = "$rootWinDir/cdo/aol/out/<DATE>/<HOUR>/bids/changedOptBids.csv";
    $common{'changedDefBidsFile'} = "$rootWinDir/cdo/aol/out/<DATE>/<HOUR>/bids/changedDefBids.csv";

    # Variables
    $common{'hourToGetDaily'} = 11;
    $common{'hourToImportCells'} = "24"; ## hours (0-23) separated by hyphens
    $common{'hourToRefreshPrevDay'} = 10;
    $common{'pvDaysToRun'}="2:Mon;5:Thur";
    $common{'defaultBudget'} = 100;
    $common{'defaultAdvertiserId'} = 9;
    $common{'minBid'} = 0.00;
    $common{'bidMode'} = "ALL";
    $common{'newGroupName'} = "NEW";
    $common{'newCampaignGroupName'} = "UNGROUPED";
    $common{'signalPhase'} = 60;
    $common{'mdPhase'} = 20;
    $common{'cdoFactor'} = 1;
    $common{'importDelay'} = 2;
    $common{'reimportDelay'} = 5;
    $common{'mdImportDelay'} = 1;
    $common{'bidIncrement'} = 1000;
    $common{'curationPageSize'} = 2000;
    $common{'hourlyImpsThreshold'} = 10000;
    $common{'dowHourlyImpsThreshold'} = 7000;
    $common{'bidTypes'} = "OPT DEF";

    # URLs
    $common{'AOLHourlyFileURL'} = "https://api.adlearnop.advertising.com/WebsvcDir/<PARTNERID>/reports/<CAMPAIGNID>/<YYYY>/<MM>/<DD>_<HH>.csv";
    $common{'AOLDailyFileURL'} = "https://api.adlearnop.advertising.com/WebsvcDir/<PARTNERID>/reports/<CAMPAIGNID>/<YYYY>/<MM>/<DD>.csv";
    $common{'AOLPriceVolumeCellFileURL'} = "https://api.adlearnop.advertising.com/WebsvcDir/<PARTNERID>/recommendations/<CAMPAIGNID>_<YYYY>_<MM>_<DD>_cell.csv";
    
    return $common{$param};
}

1;
