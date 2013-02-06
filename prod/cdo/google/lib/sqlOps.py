import dbOps

def getCampaigns():
    db = dbOps.dbConnect("cdo")

    sql = """SELECT san,cid FROM Campaign WHERE isapi=1 AND usepoe=1"""
    db.query(sql)
    
    c = db.store_result()
    camps = c.fetch_row(maxrows=0, how=1)
    dbOps.dbDisconnect(db)
    
    return camps

def getCellData():
    db = dbOps.dbConnect("cdo")

    sql = """SELECT concat(dl.san,"_",dl.adid,"_",dl.siteid,"_",dl.segmentid,"_",m.size) as id, impressions as n, clicks as k, actions as a 
                   FROM DisplayLogsByDOWHour dl, Media m, Campaign c
                   WHERE dl.adid=m.adid 
                   AND m.san=c.san
                   AND dl.dow = 2
                   AND dl.hour = 18
                   AND c.usepoe=1 
                   AND m.active=1 
                   AND c.timestatus=3
LIMIT 20"""
    db.query(sql)
    
    c = db.store_result()
    cells = c.fetch_row(maxrows=0, how=1)
    dbOps.dbDisconnect(db)
    
    return cells
