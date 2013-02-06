#!/perl/bin/perl

use LWP;
use MIME::Base64;
use Switch;
use XML::Simple;
use XML::Parser;
use Data::Dumper;

### Command Line Input
my $mode = shift;
my $machine = shift;
my $c_id = shift;

### Global Variables (API Config)
if ($machine eq 'prod'){
	$host = "api.adlearnop.advertising.com";
	$baseUrl = "https://api.adlearnop.advertising.com";
	$soap_action = "";
	
	$p_name = "doublePositive Marketing Group, Inc.";
	$p_id = "20102";
	$uid = "hotleads";
	$pwd = "d2PmPBtJr!";
	$auth = $uid.":".$pwd;
	$auth64 = "Basic ".encode_base64($auth);
}
else {
	$host = "beta.api.adlearnop.advertising.com";
	$baseUrl = "https://beta.api.adlearnop.advertising.com";
	$soap_action = "";
	
	$p_name = "Double Positive";
	$p_id = "20001";
	$uid = "DoublePositiveSB";
	$pwd = "T3stInt3gration";
	$auth = $uid.":".$pwd;
	$auth64 = "Basic ".encode_base64($auth);
}

###############################
#MAIN
switch($mode) 
	{
		## Campaign Service
		case "readCampaignList" { &readCampaignList("/20110228/CampaignService") }
		case "updatePausedStatus" { &updatePausedStatus("/20110228/CampaignService","false") }
		case "updateDefaultBidStatus" { &updateDefaultBidStatus("/20110228/CampaignService","true") }
		case "readMediaList" { &readMediaList("/20110228/CampaignService") }
		case "pauseMediaList" { &pauseMediaList("/20110228/CampaignService", "1") }
		case "playMediaList" { &playMediaList("/20110228/CampaignService", "1") }
		
		## Reporting Service
		case "getLatestReports" { &getLatestReports("/20110228/ReportingService.svc", "getLatestReports") }
		case "getAvailableReports" { &getAvailableReports("/20110228/ReportingService.svc", "getAvailableReports") }
		case "getReports" { &getReports("/20110228/ReportingService.svc", "getReports", "2012-01-10") }
		
		## Recommendation Service
		case "getLatestRecommendations" { &getLatestRecommendations("/20110228/RecommendationService.svc","getLatestRecommendations") }
		case "getAvailableRecommendations" { &getAvailableRecommendations("/20110228/RecommendationService.svc","getAvailableRecommendations") }
		case "getRecommendations" { &getRecommendations("/20110228/RecommendationService.svc","getRecommendations","2011-04-08") }
		
		## Cell Group Service
		case "readCellGroupList" { &readCellGroupList("/20110228/CellGroupService") }
		case "readCellGroup" { $cellId = shift; &readCellGroup("/20110228/CellGroupService","$cellId") }
		case "readCompleteCellList" { $cellGroupId = shift; &readCompleteCellList("/20110228/CellGroupService", "118", "1", "1000") }
		case "createCellGroup" { &createCellGroup("/20110228/CellGroupService") }
		case "updateCellGroup" { $cellId = shift; &updateCellGroup("/20110228/CellGroupService","$cellId") }
		case "deleteCellGroup" { $cellId = shift; &deleteCellGroup("/20110228/CellGroupService","$cellId") }
		case "distributeCellList" { &distributeCellList("/20110228/CellGroupService") }
		case "acknowledgeRemovedCellList" { &acknowledgeRemovedCellList("/20110228/CellGroupService", "979550") }
		
		## Bid Service
		case "readBidList" { &readBidList("/20110228/BidService", "5000", "0") }
		case "createBidList" { &createBidList("/20110228/BidService") }
	}


###############################
#### Campaign Service

sub readCampaignList {
	my ($endUrl) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <readCampaignListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   <partnerId xmlns="">$p_id</partnerId>
  </readCampaignListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
	print $data->{'soap:Body'}{'campaignList'}{'deliveryInformation'};
}

sub updatePausedStatus {
	my ($endUrl, $status) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <updatePausedStatusRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   <campaignId xmlns=\"\">$c_id</campaignId>
   <paused xmlns=\"\">$status</paused>
  </updatePausedStatusRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub updateDefaultBidStatus {
	my ($endUrl, $status) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <updateDefaultBidStatusRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   <campaignId xmlns=\"\">$c_id</campaignId>
   <defaultBidStatus xmlns=\"\">$status</defaultBidStatus>
  </updateDefaultBidStatusRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub readMediaList {
	my ($endUrl) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
GroupLi  <readMediaListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   <campaignId xmlns="">$c_id</campaignId>
  </readMediaListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	my($mediaList) = &apiRequest($xmlMessage, $endUrl);
		
	my @lines = split('\n', $mediaList);
				foreach $line (@lines)
					{
						if ($line =~ m/<media id/)
							{
								#print "$line\n";
								$line =~ s/<media id="/<id>/;
								$line =~ s/">/<\/id>/;
								$list = $list."$line\n";
							}
					}
	print $list;
}

sub pauseMediaList {
	my ($endUrl, $mediaList) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <pauseMediaListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   <mediaIdList xmlns="">
   	<id>1092787</id>
   	<id>1092786</id>
        <id>1104388</id>
   </mediaIdList>
  </pauseMediaListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub playMediaList {
	my ($endUrl, $mediaList) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <playMediaListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   <mediaIdList xmlns="">
        <id>959837</id>
        <id>959838</id>
        <id>959839</id>
        <id>959840</id>
        <id>971164</id>
        <id>971166</id>
        <id>971167</id>
        <id>971168</id>
        <id>971170</id>
        <id>971177</id>
        <id>971179</id>
        <id>971180</id>
        <id>971181</id>
        <id>971388</id>
        <id>976031</id>
        <id>976032</id>
        <id>976033</id>
        <id>976034</id>
        <id>976035</id>
        <id>976036</id>
        <id>976071</id>
        <id>976916</id>
        <id>1007675</id>
        <id>1007676</id>
        <id>1007677</id>
        <id>1007678</id>
        <id>1007679</id>
        <id>1007680</id>
        <id>1007681</id>
        <id>1007682</id>
        <id>1007683</id>
        <id>1007684</id>
        <id>1007685</id>
        <id>1007686</id>
        <id>1007687</id>
        <id>1007688</id>
        <id>1007689</id>
        <id>1007690</id>
        <id>1007691</id>
        <id>1007692</id>
        <id>1047883</id>
        <id>1047884</id>
        <id>1047885</id>
        <id>1047886</id>
        <id>1047887</id>
   </mediaIdList>
  </playMediaListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}
###

#### Reporting Service
sub getLatestReports {
	my ($endUrl, $soapAction) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <getLatestReports
    xmlns=\"http://adlearn.open.platform.advertising.com\">
    <request>
   	  <campaignId xmlns="">$c_id</campaignId>
   	</request>
  </getLatestReports>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

sub getAvailableReports {
	my ($endUrl, $soapAction) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <getAvailableReports
    xmlns=\"http://adlearn.open.platform.advertising.com\">
    <request>
   	 <campaignId xmlns="">$c_id</campaignId>
   	</request>
  </getAvailableReports>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

sub getReports {
	my ($endUrl, $soapAction, $date) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <getReports xmlns=\"http://adlearn.open.platform.advertising.com\">
    <request>
   	 <campaignId xmlns="">$c_id</campaignId>
   	 <ns2:date xmlns:ns2="http://adlearn.open.platform.advertising.com/reports/messages">$date</ns2:date>
   	</request>
  </getReports>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

#### Recommendation Service
sub getLatestRecommendations {
	my ($endUrl, $soapAction) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <getLatestRecommendations
    xmlns=\"http://adlearn.open.platform.advertising.com\">
    <request>
   	<campaignId xmlns="">$c_id</campaignId>
    </request>
  </getLatestRecommendations>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

sub getAvailableRecommendations {
	my ($endUrl, $soapAction) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <getAvailableRecommendations
    xmlns=\"http://adlearn.open.platform.advertising.com\">
    <request>
   	 <campaignId xmlns="">$c_id</campaignId>
   	</request>
  </getAvailableRecommendations>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

sub getRecommendations {
	my ($endUrl, $soapAction, $date) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <getRecommendations
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   	 <campaignId xmlns="">$c_id</campaignId>
   	 <ns2:date xmlns:ns2="http://adlearn.open.platform.advertising.com/reports/messages">$date</ns2:date>
  </getRecommendations>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl, $soapAction);
}

#### Cell Group Service
sub readCellGroupList {
	my ($endUrl) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <readCellGroupListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   	 <campaignId xmlns="">$c_id</campaignId>
  </readCellGroupListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub readCompleteCellList {
	my ($endUrl, $cellGroupId, $pageIndex, $totalRecords) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <readCompleteCellListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
    <paging xmlns="" nil="false">
    	<pageSize>$totalRecords</pageSize>
    	<pageNumber>$pageIndex</pageNumber>
    </paging>
   	<campaignId xmlns="">$c_id</campaignId>
   	<cellGroupId xmlns="">$cellGroupId</cellGroupId>
  </readCompleteCellListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub createCellGroup {
	my ($endUrl) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <createCellGroupRequest xmlns=\"http://adlearn.open.platform.advertising.com\">
  	 <cellGroup xmlns="">
  	 	<id xmlns="">13</id>
   	 	<campaignId xmlns="">$c_id</campaignId>
   	 	<groupType xmlns="">USER</groupType>
   	 	<basicInformation>
   	 		<name xmlns="">TEST GROUP LIST</name>
   	 		<description xmlns="">Just a test group</description>
   	 	</basicInformation>
   	 	<definition>
   	 		<mediaIdList>
   	 			<id>950161</id> 
   	 			<id>950162</id>
   	 		</mediaIdList>
   	 		<siteIdList>
   	 		</siteIdList>
   	 	</definition>	
   	 	
   	 </cellGroup>
  </createCellGroupRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub readCellGroup {
	my ($endUrl, $cellId) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <readCellGroupRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   	 <cellGroupId xmlns="">$cellId</cellGroupId>
  </readCellGroupRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub updateCellGroup {
	my ($endUrl, $cellGroupId) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <updateCellGroupRequest xmlns=\"http://adlearn.open.platform.advertising.com\">
  	 <cellGroup xmlns="">
  	 	<id xmlns="">$cellGroupId</id>
   	 	<campaignId xmlns="">$c_id</campaignId>
   	 	<basicInformation>
   	 		<name xmlns="">TEST Update of a GROUP LIST</name>
   	 		<description xmlns="">Just a test group updated</description>
   	 	</basicInformation>
   	 	<definition>
   	 		<mediaIdList>
   	 			<id>950160</id>
   	 		</mediaIdList>
   	 		<siteIdList>
   	 		</siteIdList>
   	 	</definition>	
   	 	
   	 </cellGroup>
  </updateCellGroupRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub deleteCellGroup {
	my ($endUrl, $cellId) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <deleteCellGroupRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   	 <cellGroupId xmlns="">$cellId</cellGroupId>
  </deleteCellGroupRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub distributeCellList {
	my ($endUrl) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <distributeCellListRequest xmlns=\"http://adlearn.open.platform.advertising.com\">
   	 <cellIdList xmlns="">
        <id>962058</id>
        <id>962059</id>
        <id>962061</id>
        <id>962062</id>
        <id>962064</id>
        <id>962065</id>
        <id>962066</id>
        <id>962067</id>
        <id>962070</id>
        <id>962071</id>
        <id>962073</id>
        <id>962074</id>
        <id>962075</id>
        <id>962076</id>
        <id>962077</id>
        <id>962079</id>
        <id>962080</id>
        <id>962082</id>
        <id>962083</id>
        <id>962085</id>
        <id>962086</id>
        <id>962089</id>
        <id>962090</id>
        <id>962091</id>
        <id>962093</id>
        <id>962095</id>
        <id>962096</id>
        <id>962097</id>
        <id>962098</id>
        <id>962100</id>
        <id>962101</id>
        <id>962102</id>
        <id>962103</id>
        <id>962107</id>
        <id>962109</id>
        <id>962110</id>
        <id>962113</id>
        <id>962117</id>
        <id>962118</id>
        <id>962120</id>
        <id>962121</id>
        <id>962122</id>
        <id>962124</id>
        <id>962125</id>
        <id>962126</id>
        <id>962127</id>
        <id>962129</id>
        <id>962130</id>
        <id>962134</id>
        <id>962136</id>
        <id>962137</id>
        <id>962141</id>
        <id>962142</id>
        <id>962145</id>
        <id>962147</id>
        <id>962148</id>
        <id>962149</id>
        <id>962150</id>
        <id>962151</id>
        <id>962152</id>
        <id>962154</id>
        <id>962155</id>
        <id>962163</id>
        <id>962164</id>
        <id>962167</id>
        <id>962170</id>
        <id>962173</id>
        <id>962174</id>
        <id>962175</id>
        <id>962177</id>
        <id>962178</id>
        <id>962179</id>
        <id>962180</id>
        <id>962181</id>
        <id>962182</id>
        <id>962183</id>
        <id>962185</id>
        <id>962186</id>
        <id>962187</id>
        <id>962188</id>
        <id>962189</id>
        <id>962192</id>
        <id>962193</id>
        <id>962196</id>
        <id>962198</id>
        <id>962202</id>
        <id>962204</id>
        <id>962205</id>
        <id>962206</id>
        <id>962207</id>
        <id>962208</id>
        <id>962209</id>
        <id>962212</id>
        <id>962213</id>
        <id>962214</id>
        <id>962215</id>
        <id>962218</id>
        <id>962222</id>
        <id>962223</id>
        <id>962224</id>
        <id>962227</id>
   	 </cellIdList>
  </distributeCellListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub acknowledgeRemovedCellList {
	my ($endUrl, $cellId) = @_;
	my $cellList = '';
	
	my @list = split(/\,/, $cellId);
	
	foreach $list (@list)
	{
		$cellList=$cellList."\n<id>$list</id>";
	}
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <acknowledgeRemovedCellListRequest xmlns=\"http://adlearn.open.platform.advertising.com\">
   <cellIdList xmlns="">$cellList
    <id>1563368</id>
   </cellIdList>
  </acknowledgeRemovedCellListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

#### Bid Service
sub readBidList {
	my ($endUrl, $totalRecords, $pageIndex) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <readBidListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
    <paging xmlns="" nil="false">
    	<pageSize>$totalRecords</pageSize>
    	<pageNumber>$pageIndex</pageNumber>
    </paging>
   <campaignId xmlns="">$c_id</campaignId>
  </readBidListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

sub createBidList {
	my ($endUrl) = @_;
	
my $xmlMessage = qq|<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<SOAP-ENV:Envelope
 xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"
 xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">
 <SOAP-ENV:Body>
  <createBidListRequest
    xmlns=\"http://adlearn.open.platform.advertising.com\">
   <bidList xmlns="">
    <bid xmlns="">
     <cellId xmlns="">858464</cellId><amount xmlns="">0.01</amount>
    </bid>
   </bidList>
  </createBidListRequest>
 </SOAP-ENV:Body>
</SOAP-ENV:Envelope>|;
		
	&apiRequest($xmlMessage, $endUrl);
}

#### MAKE API REQUEST
sub apiRequest {
		my ($message, $endUrl, $soap_action) = @_;
	
		my $url = $baseUrl.$endUrl;
		my $length = length($message);  ## GET REQUEST LENGTH
		my $browser = new LWP::UserAgent;  ## NEW LWP Client
                $browser->ssl_opts(verify_hostname => 0);

		## HTTP HEADERS
		my $headers = HTTP::Headers->new(
		         'Host' => $host,
		         'Content-Type' => 'text/xml; charset=UTF-8',
		         'Content-Length' => $length,
		         'SOAPAction' => $soap_action,
		         'Authorization' => $auth64
		         );
		
		
		## MAKE THE HTTP REQUEST
		my $req = HTTP::Request->new("POST", $url, $headers, $message);
		my $res = $browser->request($req);
		
		print "AUTH: $auth64\n\n";
		print "$message\n\n";
		
		my $xml = new XML::Simple (KeyAttr=>{});
		
		my $data = $xml->XMLin($res->content);
		#print $data;
		#print Dumper($data);
		print $xml->XMLout($data);
		return ($xml->XMLout($data));
		#print $data->{'s:Body'}{'getReportsResponse'}{'getReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:dailySummaryFileList'}{'b:fileInfo'}{'b:date'};
		#print $data->{'s:Body'}{'getReportsResponse'}{'getReportsResult'}{'a:reportingFiles'}{'b:reportingFileInformation'}{'b:dailySummaryFileList'}{'b:fileInfo'}{'b:date'};
		#$p1 = new XML::Parser(Style => '');
		#$p1->parse($res->content);
		
}		

exit;

