//$(document).ready (function(){
//  d3.select(window)
//  .on("mousemove", mousemove)
//  .on("mouseup", mouseup);
//
//var width = 960,
//height = 500;
//
//var projection = d3.geo.orthographic()
//  .scale(220)
//  .translate([width - 225, height / 2])
//  .clipAngle(90);
//
//
//var path = d3.geo.path().projection(projection).pointRadius(1.5);
//
//var graticule = d3.geo.graticule();
//
//var svg = d3.select("body").append("svg")
//  .attr("width", width)
//  .attr("height", height)
//  .on("mousedown", mousedown);
//
//queue()
//  .defer(d3.json, "sovereignty_110m_topo.json")
//  .await(ready);
//
//function ready(error, world, places) {
//  svg.append("defs").append("path")
//    .datum({type: "Sphere"})
//    .attr("id", "sphere")
//    .attr("d", path);
//
//  svg.append("use")
//    .attr("class", "stroke")
//    .attr("xlink:href", "#sphere");
//
//  svg.append("use")
//    .attr("class", "fill")
//    .attr("xlink:href", "#sphere");
//
//  svg.append("path")
//    .datum(graticule)
//    .attr("class", "graticule")
//    .attr("d", path);
//
//  svg.append("path")
//    .datum(topojson.feature(world, world.objects.sovereignty_110m))
//    .attr("class", "land")
//    .attr("d", path);
//
//  svg.selectAll(".land")
//    .data(topojson.feature(world, world.objects.sovereignty_110m).features)
//    .enter().append("path")
//    .attr("class", function(d) { return "land " + d.id; })
//    .attr("d", path)
//    .on("click", function(d) {
//      alert("I am " + d.properties.name);
//    });
//  //svg.append("path")
//    //.datum(topojson.feature(world, world.objects.countries))
//    //.attr("class", "land")
//    //.attr("d", path);
//
//
//
//  //svg.append("g").attr("class","points")
//    //.selectAll("text").data(places.features)
//    //.enter().append("path")
//    //.attr("class", "point")
//    //.attr("d", path);
//
//  //svg.append("g").attr("class","labels")
//    //.selectAll("text").data(places.features)
//    //.enter().append("text")
//    //.attr("class", "label")
//    //.text(function(d) { return d.properties.name })
//
//    //svg.append("g").attr("class","countries")
//    //.selectAll("path")
//
//    position_labels();
//}
//
//function position_labels() {
//  var centerPos = projection.invert([width/2,height/2]);
//
//  var arc = d3.geo.greatArc();
//
//  svg.selectAll(".label")
//    .attr("text-anchor",function(d) {
//      var x = projection(d.geometry.coordinates)[0];
//      return x < width/2-20 ? "end" :
//      x < width/2+20 ? "middle" :
//      "start"
//    })
//  .attr("transform", function(d) {
//    var loc = projection(d.geometry.coordinates),
//    x = loc[0],
//    y = loc[1];
//  var offset = x < width/2 ? -5 : 5;
//  return "translate(" + (x+offset) + "," + (y-2) + ")"
//  })
//  .style("display",function(d) {
//    var d = arc.distance({source: d.geometry.coordinates, target: centerPos});
//    return (d > 1.57) ? 'none' : 'inline';
//  })
//
//}
//
//var m0, o0;
//function mousedown() {
//  m0 = [d3.event.pageX, d3.event.pageY];
//  o0 = projection.rotate();
//  d3.event.preventDefault();
//}
//function mousemove() {
//  if (m0) {
//    var m1 = [d3.event.pageX, d3.event.pageY]
//      , o1 = [o0[0] + (m1[0] - m0[0]) / 6, o0[1] + (m0[1] - m1[1]) / 6];
//    o1[1] = o1[1] > 30  ? 30  :
//      o1[1] < -30 ? -30 :
//      o1[1];
//    projection.rotate(o1);
//    refresh();
//  }
//}
//function mouseup() {
//  if (m0) {
//    mousemove();
//    m0 = null;
//  }
//}
//
//function refresh() {
//  svg.selectAll(".land").attr("d", path);
//  svg.selectAll(".countries path").attr("d", path);
//  svg.selectAll(".graticule").attr("d", path);
//  svg.selectAll(".point").attr("d", path);
//  position_labels();
//}
//});
