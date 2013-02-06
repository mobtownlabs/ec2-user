#!/usr/bin/env python
# encoding: utf-8
"""
mm_hadooptomysql_migrator.py

Created by Brian Tomasette on 2011-11-02.
Copyright (c) 2011 DoublePositive. All rights reserved.
"""
import re
import os
import MySQLdb
import gzip
import csv
from boto.s3.connection import S3Connection
from boto.s3.key import Key
from boto.ses import SESConnection
conn = S3Connection('AKIAIUCLB3MA3PL2XYNA', 'IbCFVJiiFxgPO6btlz32I67vZc9xoO+qsGpCVLhM')
conns = SESConnection('AKIAIUCLB3MA3PL2XYNA', 'IbCFVJiiFxgPO6btlz32I67vZc9xoO+qsGpCVLhM')
db = MySQLdb.connect(host='localhost', user='root', passwd='doublep123', db='mm')


def send(source, subject, body, to):
	conns.send_email(source, subject, body, to)


bucket = conn.get_bucket('dphiveoutput')

key_list = []

kl = bucket.list()

for i in kl:
	key_list.append(i.name)

keyz = []
cur = db.cursor()	
cur.execute("select filename from hadoopfiles")
y = cur.fetchall()
for i in y:
	keyz.append(i[0])
	
for i in keyz:
	try:
		a = key_list.index(i)
		key_list.pop(a)
	except:
		pass

cur.close()


message = ''
message_success = ''	

for i in key_list:
	if re.search('placement', i):
		key = bucket.get_key(i)
		x = i.strip('mm/placement/')
		key.get_contents_to_filename('/store/hadoopfiles/%s'%x)
		z = "insert into hadoopfiles (filename) values ('%s')" %i
		try:
			cur = db.cursor()
			file_infile = "LOAD DATA INFILE '/store/hadoopfiles/%s' replace INTO TABLE placement FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (date_stamp, hour, creative_id, placement_id, impressions, clicks, conversions)"%x
			cur.execute(file_infile)
			db.commit()
			cur.execute(z)
			cur.close()
			os.remove('/store/hadoopfiles/%s'%x)
			Key(bucket, i).copy('dphiveoutputuploaded', i)
			Key(bucket, i).delete()
			message_success = message_success + '%s,\n'%x
		except:
			message = message + '%s,\n'%x
			db.rollback()
			cur.close()
	elif re.search('carrier', i):
		key = bucket.get_key(i)
		x = i.strip('mm/carrier/')
		key.get_contents_to_filename('/store/hadoopfiles/%s'%x)
		z = "insert into hadoopfiles (filename) values ('%s')" %i
		try:
			cur = db.cursor()
			file_infile = "LOAD DATA INFILE '/store/hadoopfiles/%s' replace INTO TABLE handset FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (date_stamp, hour, creative_id, carrier_id, impressions, clicks, conversions)"%x
			cur.execute(file_infile)
			db.commit()
			cur.execute(z)
			cur.close()
			os.remove('/store/hadoopfiles/%s'%x)
			Key(bucket, i).copy('dphiveoutputuploaded', i)
			Key(bucket, i).delete()
			message_success = message_success + '%s,\n'%x
		except:
			message = message + '%s,\n'%x
			db.rollback()
			cur.close()
	elif re.search('handset', i):
		key = bucket.get_key(i)
		x = i.strip('mm/handset/')
		key.get_contents_to_filename('/store/hadoopfiles/%s'%x)
		z = "insert into hadoopfiles (filename) values ('%s')" %i
		try:
			cur = db.cursor()
			file_infile = "LOAD DATA INFILE '/store/hadoopfiles/%s' replace INTO TABLE handset FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (date_stamp, hour, creative_id, handset_id, impressions, clicks, conversions)"%x
			cur.execute(file_infile)
			db.commit()
			cur.execute(z)
			cur.close()
			os.remove('/store/hadoopfiles/%s'%x)
			Key(bucket, i).copy('dphiveoutputuploaded', i)
			Key(bucket, i).delete()
			message_success = message_success + '%s,\n'%x
		except:
			message = message + '%s,\n'%x
			db.rollback()
			cur.close()
	elif re.search('dma', i):
		key = bucket.get_key(i)
		x = i.strip('mm/dma/')
		key.get_contents_to_filename('/store/hadoopfiles/%s'%x)
		z = "insert into hadoopfiles (filename) values ('%s')" %i
		try:
			cur = db.cursor()
			file_infile = "LOAD DATA INFILE '/store/hadoopfiles/%s' replace INTO TABLE dma FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (date_stamp, hour, creative_id, dma_id, impressions, clicks, conversions)"%x
			cur.execute(file_infile)
			db.commit()
			cur.execute(z)
			cur.close()
			os.remove('/store/hadoopfiles/%s'%x)
			Key(bucket, i).copy('dphiveoutputuploaded', i)
			Key(bucket, i).delete()
			message_success = message_success + '%s,\n'%x
		except:
			message = message + '%s,\n'%x
			db.rollback()
			cur.close()
	else:
		a = 'rejected-' + i
		Key(bucket, i).copy('dphiveoutputuploaded', a)
		Key(bucket, i).delete()
if message != '':
	send('btomasette@doublepositive.com', 'MM Hadoop Hive Table migration', 'The following files failed to be written to the appropriate table in the mm database: \r %s'%message, ['btomasette@doublepositive.com', 'mpatton@doublepositive.com'])

send('btomasette@doublepositive.com', 'MM hadoop to mysql Insert Success', 'The following files have been inserted into db "mm" table "placement": \r %s'%message_success, 'btomasette@doublepositive.com')

		
	
	
	







db.close()







