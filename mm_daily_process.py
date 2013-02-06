import subprocess
import time

subprocess.call(['python', 'bucket_sorter.py'])
time.sleep(10)
subprocess.call(['python', 'mm_events_importer.py'])
time.sleep(10)
subprocess.call(['python', 'hadoop_job_runner.py'])
time.sleep(10)
subprocess.call(['python', 'mm_hadoop_to_mysql_migrator.py'])
