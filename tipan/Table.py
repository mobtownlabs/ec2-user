import glob
import datetime
import sys
import math
import string
import cPickle as pickle

TableTypes = {'string':type("Hello"), 'long':type(123456789), 'float':type(12345.6789), 'date':type(datetime.date(1979,01,12))}

def AssignType(s):
	if len(set(s) & set(string.ascii_letters)) > 0:
		return TableTypes['string']
	else:
		if '-' in s:
			return TableTypes['date']
		else:
			if '.' in s:
				return TableTypes['float']
			else:
				return TableTypes['long']

def SubsetOf(small,big):
	ans = True
	if type(small) == type(set([])) and type(big) == type(set([])):
		if len(small) <= len(big):
			for s in small:
				if s in big:
					pass
				else:
					ans = ans & False
			return ans		
		else:
			return False
	else:
		print "(SubsetOf) ERROR: parameters are not sets"
		return False


class Table:
	def __init__(self):
		self.name = "NoName Table"
		self.header = {} # dictionary
		self.rows = [] # list of dictionaries

	def __init__(self,txtfile):
		self.name = txtfile
		self.header = {}
		self.rows = []

		txtfilename = txtfile +".txt"
		f = open(txtfilename,'rb')
		h = f.readline().rstrip()
		hItems = h.split(' ')
		print len(hItems)
		firstline = f.readline().rstrip()
		for line in f:
			pass
		f.close()



	def PrintTable(self, fields=[]):
		if len(self.header.keys()) == 0:
			print "<Table (PrintTable)> ERROR: This is a NULL Table"
		else:
			print "<Table> ", self.name, ":"
			print "--------"
			if fields == []:
				fields = self.header.keys()
			else:
				pass
			if SubsetOf(set(fields),set(self.header.keys())):
				for k in range(len(fields)):
					print "|",fields[k],
				print ""	
				for i in range(len(self.rows)):
					for j in range(len(fields)):
						print "|", self.rows[i][fields[j]],
					print ""	
			else:
				print "<Table (PrintTable)> ERROR: Missing a requested column"
