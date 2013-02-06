#!/usr/bin/env python
# encoding: utf-8
"""
mm_events_importer.py

Created by Brian Tomasette on 2011-11-02.
Copyright (c) 2011 DoublePositive. All rights reserved.
"""

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


bucket = conn.get_bucket('mmlogs')

key_list = []

kl = bucket.list()

for i in kl:
	key_list.append(i.name)

keyz = []
cur = db.cursor()	
cur.execute("select filename from keyfiles")
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
	key = bucket.get_key(i)
	key.get_contents_to_filename('/store/mmfiles/%s'%i)
	f = gzip.open('/store/mmfiles/%s'%i, 'r')
	content = f.read()
	x = i.strip('.gz')
	fc = open('/store/mmfiles/%s'%x, 'w')
	fc.write(content)
	fc.close()
	f.close()
	os.remove('/store/mmfiles/%s'%i)
	z = "insert into keyfiles (filename) values ('%s')" %i
	try:
		cur = db.cursor()
		file_infile = "LOAD DATA INFILE '/store/mmfiles/%s' replace INTO TABLE events FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (time_stamp, creative_id, placement_id, handset_id, dma_id, carrier_id, text, count)"%x
		cur.execute(file_infile)
		db.commit()
		cur.execute(z)
		cur.close()
		os.remove('/store/mmfiles/%s'%x)
		message_success = message_success + ', ' + '%s'%i
	except:
		message = message + ', %s '%i
		db.rollback()
		cur.close()
if message != '':
	send('btomasette@doublepositive.com', 'MM Logfile failed insert to the keyfile table', 'The following files failed to be written to the keyfile table in the mm database: \r %s'%message, ['btomasette@doublepositive.com', 'mpatton@doublepositive.com'])

send('btomasette@doublepositive.com', 'MM Events Insert Success', 'The following files have been inserted into db "mm" table "events": \r %s'%message_success, 'btomasette@doublepositive.com')

		
	
	
	







db.close()







