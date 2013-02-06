import tornado.ioloop
import tornado.web
import json
import MySQLdb

class MainHandler(tornado.web.RequestHandler):
	def get(self):
			self.render("templates/mainhandler.html")


class clusterPlacementHandler(tornado.web.RequestHandler):
	def get(self):
			self.write(""" <!DOCTYPE html>
			<html>
			  <head>
			    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
			    <title>Mobile Placement Flare</title>
			    <script type="text/javascript" src="static/d3/d3.js"></script>
			    <script type="text/javascript" src="static/d3/d3.layout.js"></script>
			    <link type="text/css" rel="stylesheet" href="static/d3/examples/cluster/cluster.css"/>
			  </head>
			  <body>
			    <div id="chart"></div>
			    <script type="text/javascript" src="static/d3/examples/cluster/cluster.js"></script>
			  </body>
			</html> """)
			
class treemapPlacementHandler(tornado.web.RequestHandler):
	def get(self):
			self.write(""" <!DOCTYPE html>
			<html>
			  <head>
			    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
			    <title>Mobile Placement Treemap</title>
			    <script type="text/javascript" src="static/d3/d3.js"></script>
			    <script type="text/javascript" src="static/d3/d3.layout.js"></script>
			    <link type="text/css" rel="stylesheet" href="static/d3/examples/treemap/treemap.css"/>
			  </head>
			  <body>
			    <div id="chart">
			      <button id="size" class="first active">
			        Conversions by Placement
			      </button
			      ><button id="count" class="last">
			        Converting Placements (equal size)
			      </button><p>
			    </div>
			    <script type="text/javascript" src="static/d3/examples/treemap/treemap.js"></script>
			  </body>
			</html> """)

class clusterHandsetHandler(tornado.web.RequestHandler):
	def get(self):
			self.write(""" <!DOCTYPE html>
			<html>
			  <head>
			    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
			    <title>Mobile Handset Flare</title>
			    <script type="text/javascript" src="static/d3/d3.js"></script>
			    <script type="text/javascript" src="static/d3/d3.layout.js"></script>
			    <link type="text/css" rel="stylesheet" href="static/d3/examples/cluster/cluster.css"/>
			  </head>
			  <body>
			    <div id="chart"></div>
			    <script type="text/javascript" src="static/d3/examples/cluster/handset.js"></script>
			  </body>
			</html> """)

class treemapHandsetHandler(tornado.web.RequestHandler):
	def get(self):
			self.write(""" <!DOCTYPE html>
			<html>
			  <head>
			    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
			    <title>Mobile Handset Treemap</title>
			    <script type="text/javascript" src="static/d3/d3.js"></script>
			    <script type="text/javascript" src="static/d3/d3.layout.js"></script>
			    <link type="text/css" rel="stylesheet" href="static/d3/examples/treemap/treemap.css"/>
			  </head>
			  <body>
			    <div id="chart">
			      <button id="size" class="first active">
			        Conversions by Handset
			      </button
			      ><button id="count" class="last">
			        Converting Handsets (equal size)
			      </button><p>
			    </div>
			    <script type="text/javascript" src="static/d3/examples/treemap/handset.js"></script>
			  </body>
			</html> """)			

		
application = tornado.web.Application([
    (r"/", MainHandler),
	(r"/placement-cluster", clusterPlacementHandler),
	(r"/placement-treemap", treemapPlacementHandler),
	(r"/handset-cluster", clusterHandsetHandler),
	(r"/handset-treemap", treemapHandsetHandler),
    (r"/static/(.*)", tornado.web.StaticFileHandler, {"path": "/home/ec2-user/static/"})
])

if __name__ == "__main__":
	application.listen(8888)
	tornado.ioloop.IOLoop.instance().start()