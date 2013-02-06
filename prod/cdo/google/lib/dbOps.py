import MySQLdb as mysql

def dbConnect(d):
    if d == "cdo":
        db = mysql.connect(host="localhost",db="cdo",read_default_file="~/.my.cnf")
        
    return db

def dbDisconnect(d):
    d.close()
