import json
import MySQLdb
import os


db = MySQLdb.connect(host='localhost', user='root', passwd='doublep123', db='mm')

cur = db.cursor()
cur.execute("select c.name, c.campaign_id, sum(h.conversions) from campaign as c, handset as h, media as m where c.campaign_id=m.campaign_id and m.creative_id=h.creative_id group by c.name having sum(h.conversions) > 0;")
query = cur.fetchall()

x = {"name": "Mobiel Network", "children" : []}

for row in query:
	x['children'].append({"name" : row[0], "campaign_id": int(row[1]), "conversions" : int(row[2]), "children" : []})
	
cur.close()

cur1 = db.cursor()
cur1.execute("select c.name as 'cname', c.campaign_id as 'campaign_id', m.creative_id as 'creative_id', m.name as 'mname', sum(h.conversions) from campaign as c, media as m, handset as h where c.campaign_id=m.campaign_id and m.creative_id=h.creative_id group by c.name, c.campaign_id, m.creative_id, m.name having sum(h.conversions) > 0; ")
query1 = cur1.fetchall()
for row in query1:
	for i in x['children']:
		if i['campaign_id'] == int(row[1]):
			y = x['children'].index(i)
			x['children'][y]['children'].append({"name" : row[3], "creative_id": int(row[2]), "conversions" : int(row[4]), "children" : []})
cur1.close()



cur2 = db.cursor()
cur2.execute("select c.name as 'cname', c.campaign_id as 'campaign_id', m.creative_id as 'creative_id', m.name as 'mname', h.handset_id, sum(h.conversions) from campaign as c, media as m, handset as h where c.campaign_id=m.campaign_id and m.creative_id=h.creative_id group by c.name, c.campaign_id, m.creative_id, m.name, h.handset_id having sum(h.conversions) > 0; ")
query2 = cur2.fetchall()
for row in query2:
	for i in x['children']:
		if i['campaign_id'] == int(row[1]):
			y = x['children'].index(i)
			for a in i['children']:
				if a['creative_id'] == int(row[2]):
					z = i['children'].index(a)
					x['children'][y]['children'][z]['children'].append({"name" : int(row[4]), "handset_id": int(row[4]), "conversions" : int(row[5])})
cur2.close()


db.close()

try:
	os.remove("static/handset.json")
except:
	pass
f = open("static/handset.json", 'w')
f.write(json.dumps(x))
f.close()