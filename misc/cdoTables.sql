-- MySQL dump 10.13  Distrib 5.1.52, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: cdo
-- ------------------------------------------------------
-- Server version	5.1.52

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Advertiser`
--

DROP TABLE IF EXISTS `Advertiser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Advertiser` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `clientid` int(2) DEFAULT NULL,
  `totalbudget` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CPSHour`
--

DROP TABLE IF EXISTS `CPSHour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CPSHour` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `san` varchar(20) NOT NULL DEFAULT '',
  `size` varchar(10) NOT NULL DEFAULT '',
  `adgroup` int(4) NOT NULL DEFAULT '0',
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  `conversions` int(10) DEFAULT NULL,
  `spend` decimal(10,2) DEFAULT NULL,
  `num_cells` int(10) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`san`,`size`,`adgroup`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CPSSegmentHour`
--

DROP TABLE IF EXISTS `CPSSegmentHour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CPSSegmentHour` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `san` varchar(20) NOT NULL DEFAULT '',
  `size` varchar(10) NOT NULL DEFAULT '',
  `adgroup` int(4) NOT NULL DEFAULT '0',
  `segmentid` int(4) NOT NULL DEFAULT '0',
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  `conversions` int(10) DEFAULT NULL,
  `spend` decimal(10,2) DEFAULT NULL,
  `num_cells` int(10) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`san`,`size`,`adgroup`,`segmentid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CPSSiteSegmentHour`
--

DROP TABLE IF EXISTS `CPSSiteSegmentHour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CPSSiteSegmentHour` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `san` varchar(20) NOT NULL DEFAULT '',
  `size` varchar(10) NOT NULL DEFAULT '',
  `adgroup` int(4) NOT NULL DEFAULT '0',
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(4) NOT NULL DEFAULT '0',
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  `conversions` int(10) DEFAULT NULL,
  `spend` decimal(10,2) DEFAULT NULL,
  `num_cells` int(10) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`san`,`size`,`adgroup`,`siteid`,`segmentid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Campaign`
--

DROP TABLE IF EXISTS `Campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Campaign` (
  `san` varchar(20) NOT NULL DEFAULT '',
  `advertiser` int(2) DEFAULT NULL,
  `totalbudget` int(10) DEFAULT NULL,
  `cpu` decimal(6,2) DEFAULT NULL,
  `paytype` varchar(1) DEFAULT NULL,
  `targetcpa` decimal(6,2) DEFAULT NULL,
  `startdate` date DEFAULT NULL,
  `enddate` date DEFAULT NULL,
  `network` int(2) DEFAULT NULL,
  `cid` int(10) NOT NULL DEFAULT '0',
  `usepoe` tinyint(4) DEFAULT '0',
  `isnew` tinyint(4) DEFAULT '1',
  `isapi` tinyint(4) DEFAULT '0',
  `timestatus` int(2) DEFAULT NULL,
  PRIMARY KEY (`san`,`cid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CampaignAllocation`
--

DROP TABLE IF EXISTS `CampaignAllocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CampaignAllocation` (
  `san` varchar(50) NOT NULL DEFAULT '',
  `allocation` decimal(3,2) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `lastupdated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`san`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CampaignHour`
--

DROP TABLE IF EXISTS `CampaignHour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CampaignHour` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `san` varchar(20) NOT NULL DEFAULT '',
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(8) DEFAULT NULL,
  `conversions` int(8) DEFAULT NULL,
  `spend` decimal(8,2) DEFAULT NULL,
  `num_cells` int(5) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`san`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CdoDataAol`
--

DROP TABLE IF EXISTS `CdoDataAol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CdoDataAol` (
  `id` int(20) NOT NULL DEFAULT '0',
  `dow` int(2) DEFAULT NULL,
  `hour` int(2) DEFAULT NULL,
  `san` varchar(20) DEFAULT NULL,
  `adid` int(10) DEFAULT NULL,
  `adgroup` int(4) DEFAULT NULL,
  `size` varchar(10) DEFAULT NULL,
  `siteid` int(10) DEFAULT NULL,
  `segmentid` int(10) DEFAULT NULL,
  `impressions` int(15) DEFAULT '0',
  `actions` int(10) DEFAULT '0',
  `avail_impressions` int(15) DEFAULT '0',
  `avail_capped_impressions` int(15) DEFAULT '0',
  `sssd_impressions` int(15) DEFAULT '0',
  `sssd_actions` int(10) DEFAULT '0',
  `sssd_cells` int(10) DEFAULT '0',
  `szd_impressions` int(15) DEFAULT '0',
  `szd_actions` int(10) DEFAULT '0',
  `szd_cells` int(10) DEFAULT '0',
  `ssd_impressions` int(15) DEFAULT '0',
  `ssd_actions` int(10) DEFAULT '0',
  `ssd_cells` int(10) DEFAULT '0',
  `sd_impressions` int(15) DEFAULT '0',
  `sd_actions` int(10) DEFAULT '0',
  `sd_cells` int(10) DEFAULT '0',
  `zd_impressions` int(15) DEFAULT '0',
  `zd_actions` int(10) DEFAULT '0',
  `zd_cells` int(10) DEFAULT '0',
  `cps_impressions` int(15) DEFAULT '0',
  `cps_actions` int(10) DEFAULT '0',
  `cps_cells` int(10) DEFAULT '0',
  `cpssd_impressions` int(15) DEFAULT '0',
  `cpssd_actions` int(10) DEFAULT '0',
  `cpssd_cells` int(10) DEFAULT '0',
  `cpsssd_impressions` int(15) DEFAULT '0',
  `cpsssd_actions` int(10) DEFAULT '0',
  `cpsssd_cells` int(10) DEFAULT '0',
  `data_status` varchar(50) DEFAULT NULL,
  `spend` decimal(10,2) DEFAULT NULL,
  `time_status` varchar(10) DEFAULT '1',
  `dateCreated` datetime DEFAULT NULL,
  `dateUpdated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CellAllocation`
--

DROP TABLE IF EXISTS `CellAllocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CellAllocation` (
  `san` varchar(20) NOT NULL DEFAULT '',
  `adid` int(10) NOT NULL DEFAULT '0',
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `size` varchar(10) NOT NULL DEFAULT '',
  `allocation` decimal(3,2) DEFAULT NULL,
  `dateCreated` datetime DEFAULT NULL,
  `lastUpdated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`san`,`adid`,`siteid`,`segmentid`,`size`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Client`
--

DROP TABLE IF EXISTS `Client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Client` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DisplayBidsQueueAol`
--

DROP TABLE IF EXISTS `DisplayBidsQueueAol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DisplayBidsQueueAol` (
  `cellid` int(20) NOT NULL DEFAULT '0',
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `san` varchar(20) DEFAULT NULL,
  `adid` int(10) DEFAULT NULL,
  `siteid` int(10) DEFAULT NULL,
  `segmentid` int(10) DEFAULT NULL,
  `bid` decimal(4,2) DEFAULT NULL,
  `eimpressions` int(15) DEFAULT '0',
  `bidtype` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`cellid`,`date`,`hour`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DisplayLogsHourly`
--

DROP TABLE IF EXISTS `DisplayLogsHourly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DisplayLogsHourly` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(4) NOT NULL DEFAULT '0',
  `san` varchar(15) DEFAULT NULL,
  `adid` int(10) NOT NULL DEFAULT '0',
  `mediatext` varchar(30) DEFAULT NULL,
  `placement` varchar(30) DEFAULT NULL,
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `bid` double(4,2) DEFAULT NULL,
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  `conversions` int(10) DEFAULT NULL,
  `spend` double(10,2) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`adid`,`siteid`,`segmentid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DisplayMisdelivery`
--

DROP TABLE IF EXISTS `DisplayMisdelivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DisplayMisdelivery` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `adid` int(10) NOT NULL DEFAULT '0',
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `eimpressions` int(15) DEFAULT NULL,
  `impressions` int(15) DEFAULT NULL,
  `bid` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`adid`,`siteid`,`segmentid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `DisplaySeedHourly`
--

DROP TABLE IF EXISTS `DisplaySeedHourly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DisplaySeedHourly` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `adid` int(10) NOT NULL DEFAULT '0',
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`adid`,`siteid`,`segmentid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EVolume`
--

DROP TABLE IF EXISTS `EVolume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EVolume` (
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `size` varchar(10) NOT NULL DEFAULT '',
  `volume` int(15) DEFAULT NULL,
  `capped_volume` int(15) DEFAULT NULL,
  PRIMARY KEY (`siteid`,`segmentid`,`size`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ManualBidsAol`
--

DROP TABLE IF EXISTS `ManualBidsAol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ManualBidsAol` (
  `san` varchar(20) DEFAULT NULL,
  `adid` int(10) NOT NULL DEFAULT '0',
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `bid` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`adid`,`siteid`,`segmentid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Media`
--

DROP TABLE IF EXISTS `Media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Media` (
  `adid` int(10) NOT NULL DEFAULT '0',
  `size` varchar(20) DEFAULT NULL,
  `mediatext` varchar(250) DEFAULT NULL,
  `san` varchar(50) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `isnew` tinyint(1) DEFAULT '1',
  `adgroup` int(10) DEFAULT '1',
  PRIMARY KEY (`adid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `MediaHour`
--

DROP TABLE IF EXISTS `MediaHour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MediaHour` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `adid` int(10) NOT NULL DEFAULT '0',
  `mediatext` varchar(250) DEFAULT NULL,
  `san` varchar(20) DEFAULT NULL,
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  `conversions` int(10) DEFAULT NULL,
  `spend` decimal(10,2) DEFAULT NULL,
  `num_cells` int(10) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`adid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Network`
--

DROP TABLE IF EXISTS `Network`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Network` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PriceVolume`
--

DROP TABLE IF EXISTS `PriceVolume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PriceVolume` (
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `size` varchar(10) NOT NULL DEFAULT '',
  `bid` decimal(4,2) DEFAULT NULL,
  `allocation` decimal(3,2) NOT NULL DEFAULT '0.00',
  `volume` int(15) DEFAULT NULL,
  `capped_volume` int(15) DEFAULT NULL,
  PRIMARY KEY (`siteid`,`segmentid`,`size`,`allocation`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PriceVolumeTest`
--

DROP TABLE IF EXISTS `PriceVolumeTest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PriceVolumeTest` (
  `san` varchar(20) NOT NULL DEFAULT '',
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `size` varchar(10) NOT NULL DEFAULT '',
  `bid` decimal(4,2) DEFAULT NULL,
  `allocation` decimal(3,2) NOT NULL DEFAULT '0.00',
  `volume` int(15) DEFAULT NULL,
  `capped_volume` int(15) DEFAULT NULL,
  PRIMARY KEY (`san`,`siteid`,`segmentid`,`size`,`allocation`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SegmentHour`
--

DROP TABLE IF EXISTS `SegmentHour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SegmentHour` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  `conversions` int(10) DEFAULT NULL,
  `spend` decimal(10,2) DEFAULT NULL,
  `num_cells` int(10) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`segmentid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Site`
--

DROP TABLE IF EXISTS `Site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Site` (
  `siteid` int(10) NOT NULL DEFAULT '0',
  `placement` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`siteid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SiteSegmentHour`
--

DROP TABLE IF EXISTS `SiteSegmentHour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SiteSegmentHour` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  `conversions` int(10) DEFAULT NULL,
  `spend` decimal(10,2) DEFAULT NULL,
  `num_cells` int(10) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`siteid`,`segmentid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SiteSizeHour`
--

DROP TABLE IF EXISTS `SiteSizeHour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SiteSizeHour` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `siteid` int(10) NOT NULL DEFAULT '0',
  `size` varchar(10) NOT NULL DEFAULT '',
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  `conversions` int(10) DEFAULT NULL,
  `spend` decimal(10,2) DEFAULT NULL,
  `num_cells` int(10) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`siteid`,`size`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SiteSizeSegmentHour`
--

DROP TABLE IF EXISTS `SiteSizeSegmentHour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SiteSizeSegmentHour` (
  `date` date NOT NULL DEFAULT '0000-00-00',
  `hour` int(2) NOT NULL DEFAULT '0',
  `siteid` int(10) NOT NULL DEFAULT '0',
  `segmentid` int(10) NOT NULL DEFAULT '0',
  `size` varchar(10) NOT NULL DEFAULT '',
  `impressions` int(15) DEFAULT NULL,
  `clicks` int(10) DEFAULT NULL,
  `actions` int(10) DEFAULT NULL,
  `conversions` int(10) DEFAULT NULL,
  `spend` decimal(10,2) DEFAULT NULL,
  `num_cells` int(10) DEFAULT NULL,
  PRIMARY KEY (`date`,`hour`,`siteid`,`segmentid`,`size`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-11-11 19:25:50
