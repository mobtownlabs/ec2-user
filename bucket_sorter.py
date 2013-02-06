#!/usr/bin/env python
# encoding: utf-8
"""
bucket_sorter.py

Created by Brian Tomasette on 2011-11-02.
Copyright (c) 2011 __DoublePositive__. All rights reserved.
"""

import re
from boto.s3.connection import S3Connection
from boto.s3.key import Key
from boto.ses import SESConnection
conn = S3Connection('AKIAIUCLB3MA3PL2XYNA', 'IbCFVJiiFxgPO6btlz32I67vZc9xoO+qsGpCVLhM')
conns = SESConnection('AKIAIUCLB3MA3PL2XYNA', 'IbCFVJiiFxgPO6btlz32I67vZc9xoO+qsGpCVLhM')


def send(source, subject, body, to):
	conns.send_email(source, subject, body, to)
	

message = ''
success_message = ''

email_content = 'The following files failed to copy from \'mm_logs\' bucket to the appropriate place:\n\n\n'

bucket = conn.get_bucket('mm_logs')

kl = bucket.list()

for i in kl:
	x = i.name
	if re.match('capabilities', x):
		try:
			Key(bucket, i.name).copy('mmhandset', x)
			Key(bucket, i.name).delete()
			success_message = success_message+x+',\n'
		except:
			message = message+x+', \n'
	elif re.match('channel', x):
		try:
			Key(bucket, i.name).copy('mmchannels', x)
			Key(bucket, i.name).delete()
			success_message = success_message+x+',\n'
		except:
			message = message+x+', \n'
	elif re.match('views', x):
		try:
			Key(bucket, i.name).copy('mmlogs', x)
			Key(bucket, i.name).delete()
			success_message = success_message+x+'\n'
		except:
			message = message+x+', \n'
			
if message != '':
	email = email_content+message
	send('btomasette@doublepositive.com', 'AWS mm_logs Bucket Copy Failure', email, ['mpatton@doublepositive.com', 'btomasette@doublepositive.com'])
else:
	email = 'The following files were successfully copied from mm_logs to the appropriate S3 bucket:\n\n\n'+success_message
	send('btomasette@doublepositive.com', 'AWS mm_logs Bucket Copy Success', email, 'btomasette@doublepositive.com')



