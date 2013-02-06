var w = 960,
    h = 10200;

var cluster = d3.layout.cluster()
    .size([h, w - 250 ]);

var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

var vis = d3.select("#chart").append("svg")
    .attr("width", w)
    .attr("height", h)
  .append("g")
    .attr("transform", "translate(40, 0)");

d3.json("static/flare.json", function(json) {
  var nodes = cluster.nodes(json);

  var link = vis.selectAll("path.link")
      .data(cluster.links(nodes))
    .enter().append("path")
      .attr("class", "link")
      .attr("d", diagonal);

  var node = vis.selectAll("g.node")
      .data(nodes)
    .enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })

  node.append("circle")
      .attr("r", 4.5);

  node.append("text")
      .attr("dx", function(d) { return d.children ? -8 : 8; })
      .attr("dy", 3)
      .attr("text-anchor", function(d) { return d.children ? "end" : "start"; })
      .text(function(d) { if (d.conversions) {if (d.placement_id) {return "placement: " + d.name + " conversions: " + d.conversions + "  ";} else {return d.name + " conversions: " + d.conversions + "  ";}} else {return d.name;} });
});
