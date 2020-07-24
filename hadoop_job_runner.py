#!/usr/bin/env python
# encoding: utf-8
"""
bucket_sorter.py

Created by Brian Tomasette on 2011-11-02.
Copyright (c) 2011 __DoublePositive__. All rights reserved.
"""

import re
import time
import datetime as dt
from boto.s3.connection import S3Connection
from boto.s3.key import Key
from boto.ses import SESConnection
from boto.emr.connection import EmrConnection
from boto.emr.step import JarStep
conn = S3Connection('AKIAIUCLB3MA3PL2XYNA', 'IbCFVJiiFxgPO6btlz32I67vZc9xoO+qsGpCVLhM')
conns = SESConnection('AKIAIUCLB3MA3PL2XYNA', 'IbCFVJiiFxgPO6btlz32I67vZc9xoO+qsGpCVLhM')
conne = EmrConnection('AKIAIUCLB3MA3PL2XYNA', 'IbCFVJiiFxgPO6btlz32I67vZc9xoO+qsGpCVLhM')


def send(subject, body, to):
	conns.send_email('btomasette@doublepositive.com', subject, body, to)



message = ''
success_message = ''

email_content = 'The following files have been archived and a successful Hadoop job was run:\n\n\n'


step1 = JarStep(name='Setup Hive',
               jar='s3://elasticmapreduce/libs/script-runner/script-runner.jar',
               step_args=['s3://elasticmapreduce/libs/hive/hive-script',
                          '--base-path',
                          's3://elasticmapreduce/libs/hive/',
                          '--install-hive'])
step2 = JarStep(name='Run Hive Script',
                jar='s3://elasticmapreduce/libs/script-runner/script-runner.jar',
                step_args=['s3://elasticmapreduce/libs/hive/hive-script',
                           '--run-hive-script',
                           '--args',
                           '-f',
                           's3://dphive/mmhadooprollup.hql', '-d',
                           'INPUT=s3://mmlogs', '-d',
                           'OUTPUT=s3://dphiveoutput'])

jobname = 'MM Logs Jobflow %s' %dt.datetime.now()

jobid = conne.run_jobflow(name=jobname,
                          log_uri='s3://dphive/debug/',
                          ec2_keyname='dpaws',
                          main_instance_type='c1.medium',
                          subordinate_instance_type='c1.medium',
                          num_instances=3,
                          steps=[step1, step2])



while True:
	status = conne.describe_jobflow(jobid)
	if status.state == 'STARTING':
		time.sleep(10)
	elif status.state == 'RUNNING':
		time.sleep(10)
	elif status.state == 'WAITING':
		time.sleep(10)
	elif status.state == 'TERMINATED':
		send('Hadoop Job Runner Update %s'%(dt.datetime.now()), 'The Hadoop Job: %s currently has the status: %s' %(jobid, status.state), 'btomasette@doublepositive.com')
		break
	elif status.state == 'FAILED':
		send('Hadoop Job Runner Update %s'%(dt.datetime.now()), 'The Hadoop Job: %s currently has the status: %s' %(jobid, status.state), ['btomasette@doublepositive.com', 'mpatton@doublepositive.com'])
		break
	elif status.state == 'SHUTTING_DOWN':
		time.sleep(10)
	elif status.state == 'COMPLETED':
		bucket = conn.get_bucket('mmlogs')
		kl = bucket.list()
		for i in kl:
			x = i.name
			try:
				Key(bucket, i.name).copy('mmlogsarchive', x)
				Key(bucket, i.name).delete()
				success_message = success_message+x+',\n'
			except:
				success_message = success_message+x+'-failed copy or delete, \n'
		send('Hadoop Job %s %s at %s'%(jobid, status.state, dt.datetime.now()), success_message, 'btomasette@doublepositive.com')
		break
		
		
	else:
		time.sleep(10)
		
