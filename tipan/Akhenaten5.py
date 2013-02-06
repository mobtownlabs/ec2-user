import glob
import csv
import datetime
import gzip
import sys
import math
import string
import MySQLdb
import cPickle as pickle
import numpy

mydbparams=["localhost","root","doublep123","cdo"]

def RunQuery(dbparams, QRY):
	db = MySQLdb.connect(dbparams[0],dbparams[1],dbparams[2],dbparams[3])
	cursor = db.cursor()
	print "Connected to run----> ",QRY
	cursor.execute(QRY)
	data = cursor.fetchall()
	db.close()
	print "DONE, disconnected."
	return data

def GetPlacementsData(dbparams):
	placement_QRY = "select d.siteid,m.size,d.segmentid, sum(d.impressions), sum(d.spend), 1 + max(date) - min(date) from DisplayLogsHourly d, Media m where m.adid=d.adid group by d.siteid,m.size,d.segmentid order by sum(d.spend) desc;"
	placement_DTA = RunQuery(dbparams,placement_QRY)
	placements = []
	for row in placement_DTA:
		site,adformat,segment,volume,spend,rundays = int(row[0]), row[1], int(row[2]), float(row[3]), float(row[4]), int(row[5])
		name = "W"+str(site)+"_AF"+str(adformat)+"_S"+str(segment)+"_Z"
		adv = volume / rundays
		adc = spend / rundays
		placements.append({'PlacementId':name, 'Site':site, 'AdFormat':adformat, 'Segment':segment, 'AverageDailyVolume':adv, 'AverageDailyCost':adc})
	return placements


def GetCampaignsData(dbparams):
	campaign_QRY = "select d.san, c.totalbudget, sum(d.impressions), sum(d.spend), count(distinct date) from DisplayLogsHourly d, Campaign c where c.san=d.san group by d.san,c.totalbudget;"
	campaign_DTA = RunQuery(dbparams,campaign_QRY)
	campaigns = []
	for row in campaign_DTA:
		san, totalbudget, impressions, spend, rundays = row[0], float(row[1]), int(row[2]), float(row[3]), int(row[4])
		adv = float(impressions) / rundays
		adc = spend / rundays
		campaigns.append({'systemacctname':san,'budget':totalbudget,'AverageDailyVolume':adv, 'AverageDailyCost':adc})
	return campaigns	


def PivotDATA(attributes):
	depth = len(attributes)
	attrib_QRY = "select "
	for attribute in attributes:
		if attribute in ['monthname','dayname','dayofmonth']:
			attrib_QRY = attrib_QRY + attribute +"(date), "
		else:
			attrib_QRY = attrib_QRY + attribute + ", "
	attrib_QRY = attrib_QRY + "sum(impressions), sum(clicks), sum(actions), sum(spend), count(*) from DisplayLogsHourly group by "
	for k in range(depth):
		if k < (depth - 1):
			if attributes[k] in ['monthname','dayname','dayofmonth']:
				attrib_QRY = attrib_QRY + attributes[k] + "(date),"
			else:
				attrib_QRY = attrib_QRY + attributes[k] + ", "
		else:
			if attributes[k] in ['monthname','dayname','dayofmonth']:
				attrib_QRY = attrib_QRY + attributes[k] + "(date); "
			else:
				attrib_QRY = attrib_QRY + attributes[k] + "; "
	print attrib_QRY		
	DTA = RunQuery(mydbparams,attrib_QRY)
	for attribute in attributes:
		print attribute + ", ",
	print "n, k, a, spend, nobs, p, q, cpa, rel"
	for row in DTA:
		n, k, a, spend, nobs = row[depth], row[depth + 1], row[depth + 2], row[depth + 3], row[depth + 4]

		if n > 0:
			p, q = float(k) / float(n), float(a) / float(n)
			rel = float((n + 2) * (n + 2) * (n + 3)) / float((a+1) *(n - a + 1) * 1000000 * nobs)
		else:
			p, q = 0.0, 0.0
			rel = 0.0

		if a > 0:
			cpa = spend / float(a)
		else:
			cpa = spend
		for field in range(depth):
			print row[field], ",",
		print n,",",k,",",a,",",spend,",",nobs,",",p,",",q,",",cpa,",",rel

def CMDLINE():
	n = len(sys.argv)
	for arg in sys.argv:
		print arg
	if n > 1:
		print sys.argv[1:]
		PivotDATA(sys.argv[1:])
	else:
		pass
