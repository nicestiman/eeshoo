#this is a class to make maps or globes for the hiwipi site
class window.Map
  #define all the global objects


  constructor: (options)->
    { @width, @height, @scale, @tag } = options
    #if the mouse is moved or lettup call the respective function
    d3.select(window)
      .on("mousemove", @mousemove)
      .on("mouseup", @mouseup);

    #mouse origin
    @m0

    #rotation origin
    @o0

    @graticule =
      d3.geo.graticule()

    @svg =
      d3.select(@tag).append("svg")
      .attr("width",      @width)
      .attr("height",     @height)
      .on("mousedown",  @mousedown)

    @proj =
      d3.geo.orthographic()
        .scale(@scale)
        .translate([@width / 2, @height / 2])
        .clipAngle(90)

    @path =
      d3.geo.path()
        .projection(@proj)
        .pointRadius(1.5)

  getmap: (map) =>
    queue()
      .defer(d3.json, map)
      .await(@ready)

  ready: (error, world) =>
    @svg
      .append(  "defs")
      .append(  "path")
      .datum(   type: "Sphere")
      .attr(    "id", "sphere")
      .attr(    "d", @path)


    @svg
      .append( "use")
      .attr(   "class", "stroke")
      .attr(   "xlink:href", "#sphere")

    @svg
      .append(  "use")
      .attr(    "class", "fill")
      .attr(    "xlink:href", "#sphere")

    @svg
      .append("path")
      .datum(@graticule)
      .attr("class", "graticule")
      .attr("d", @path)

    @svg
      .append("path")
      .datum(topojson.feature(world, world.objects.sovereignty_110m))
      .attr("class", "land")
      .attr("d", @path)

    @svg
      .selectAll(".land")
      .data(topojson.feature(world, world.objects.sovereignty_110m).features)
      .enter()
          .append("path")
          .attr("class", (d) ->
              return "land " + d.id
            )
          .attr("d", @path)
          .on("click", (d) ->
              alert "I am " + d.properties.name
            )
    console.log(world)

  mousedown: () =>
    @m0 = [d3.event.pageX, d3.event.pageY]
    @o0 = @proj.rotate()
    d3.event.preventDefault()

  mousemove: ()=>
    if @m0
      m1 = [d3.event.pageX, d3.event.pageY]
      o1 = [@o0[0] + (m1[0] - @m0[0]) / 6, @o0[1] + (@m0[1] - m1[1]) / 6]
      if o1[1] > 60
         o1[1] = 60
      else if o1[1] < -60
        o1[1] = -60
      @proj.rotate(o1)
      @refresh()

  mouseup: () =>
    if @m0
      @mousemove()
      @m0 = null


  refresh: () =>
    @svg
      .selectAll(".land")
      .attr      "d", @path
    @svg
      .selectAll(".countries path")
      .attr       "d", @path
    @svg
      .selectAll(".graticule")
      .attr       "d", @path
    @svg
      .selectAll(".point")
      .attr       "d", @path

  goto: (location) =>
    @proj.rotate(location)
    @refresh()

  slideto: (location, time = 2000, ease = "cubic-in-out") =>
    @location = location
    console.log("in slide to")
    d3.transition().duration(time).ease(ease).tween("rotate", @rotateTween )
    console.log(d3.select("svg"))
    return

  rotateTween: =>
    console.log("in the rotate tween")
    p = @location
    r = d3.interpolate(@proj.rotate(), [p[0], p[1]])
    return (t) =>
      @proj.rotate(r(t))
      console.log(r(t))
      @refresh()

$(document).ready( () ->
  window.globe = new Map width: 500, height: 500, scale: 220, tag:"body"

  console.log globe
  globe.getmap("sovereignty_110m_topo.json")

  globe.slideto([360, 0], 3000)


  return
)