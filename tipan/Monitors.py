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

cdodb=["localhost","root","doublep123","cdo"]

def RunQuery(dbparams,QRY):
	db = MySQLdb.connect(dbparams[0],dbparams[1],dbparams[2],dbparams[3])
	cursor = db.cursor()
	print "Connected to run----> ",QRY
	cursor.execute(QRY)
	data = cursor.fetchall()
	db.close()
	print "DONE, disconnected."
	return data

def CampaignsSummary():
	qry = "select san, sum(impressions) as n, sum(clicks) as k, sum(actions) a, sum(spend) as cost, max(date), min(date), datediff(max(date),min(date)) as days from DisplayLogsHourly group by san;"
	table = RunQuery(cdodb,qry)
	print "san n k a cost maxdate mindate days average_volume p q average_winning_bid TA"
	for row in table:
		san, n, k, a, cost, maxdate, mindate, days = row[0], int(row[1]), int(row[2]), int(row[3]), float(row[4]), row[5], row[6], int(row[7]) + 1 
		
		average_volume = float(n) / days
		
		if n > 0:
			p, q, average_winning_bid = float(k) / n, float(a) / n, 1000 * cost / n
		else:
			p, q, average_winning_bid = 0, 0, 0
		
		if a > 0:
			TA = cost / a
		else:
			TA = cost
		print san, n, k, a, cost, maxdate, mindate, days, average_volume, p, q, average_winning_bid, TA		


CampaignsSummary()	
