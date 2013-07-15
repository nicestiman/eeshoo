###
this is a class to make maps or globes for the hiwipi site
Version :0.01
Auther: Duncan Fedde
Dependancys: d3.js v3.2
             queue.js
             topojson.js
contact: duncan@fedde.us
This is under the CC licence share and share alkike
###


class window.Map
  #define all the global objects


  constructor: (options)->

    { @width, @height, @scale, @tag, @projection, @trackable} = options
    #if the mouse is moved or lettup call the respective function
    d3.select(window)
      .on("mousemove", @mousemove)
      .on("mouseup", @mouseup)

    #mouse origin
    @m0

    #rotation origin
    @o0
    # center origen
    @currentveiw = [0,0]
    
    if @trackable == undefined
      @trackable = false
    
    #the deafult projection
    if @projection == undefined
      @projection =
        d3.geo.orthographic()
          .scale(@scale)
          .translate([@width / 2, @height / 2])
          .clipAngle(90)

    #graticule to display the "grid" on the map
    @graticule =
      d3.geo.graticule()

    #the svg object that thw map will be added to
    @svg =
      d3.select(@tag).append("svg")
      .attr("width",      @width)
      .attr("height",     @height)
      .on("mousedown",  @mousedown)
    console.log(@projection)

    @path =
      d3.geo.path()
        .projection(@projection)
        .pointRadius(1.5)
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


  ###
    change the projection type
  ###
  changeProjection:(projection, trackable) =>
    @projection = projection
    @trackable = trackable
    @path =  d3.geo.path()
      .projection(@projection)
    @refresh()

  ###
    asyrinisly finds gets a map object and then calls the ready function witch renders the objects
  ###
  getmap: (options) =>

    if options != undefined
      {map, location} = options

    if location != undefined
      @location = location

    name = "maps/"

    unless map == undefined

      if typeof map == 'object'
        for thing in map
          name += thing
      else if typeof map == 'string'
        name += map
      else
        name +="world_small"
    else
      name +="world_small"

    name +=".json"
    console.log "tobe loaded", name, map
    queue()
      .defer(d3.json, name)
      .await(@ready)

  ready: (error, world) =>
    @features = null
    @refresh
    console.log "world", world
    @features = topojson.feature(world, world.objects.land).features
    console.log "features", @features
    self = @

    #append all the samller objects to the map
    @svg
      .selectAll("svg")
      .data(@features)
      .enter()
          .append("path")
          .attr("class", "land")
          .attr("id", (d) ->
            d.id
          )
          .attr("d", @path)


  mousedown: () =>
    @m0 = [d3.event.pageX, d3.event.pageY]
    @o0 = @projection.rotate()
    d3.event.preventDefault()

  mousemove: ()=>
    if @m0
      m1 = [d3.event.pageX, d3.event.pageY]
      o1 = [@o0[0] + (m1[0] - @m0[0]) / 6, @o0[1] + (@m0[1] - m1[1]) / 6]
      if o1[1] > 60
         o1[1] = 60
      else if o1[1] < -60
        o1[1] = -60
      @projection.rotate(o1)
      @refresh()

  mouseup: () =>
    if @m0
      @mousemove()
      @m0 = null


  refresh: () =>
    @svg
      .selectAll(".land")
      .attr(      "d", @path)
    @svg
      .selectAll(".countries path")
      .attr(       "d", @path)
    @svg
      .selectAll(".graticule")
      .attr(       "d", @path)
    @svg
      .selectAll(".point")
      .attr(       "d", @path)

  ###
  go (with no animation) to a geografic quardanet
  ###
  goto: (location) =>
    if !@trackable
      @projection.rotate(location)
      #console.log("rotate",location)
    else
      @projection.center(location)
    @refresh()

  ###
  go with animation to a gragrafic quardanet
  ###
  slideto: (location, time = 2000, ease = "cubic-in-out") =>
    @location = location
    d3.transition().duration(time).ease(ease).tween("rotate", @rotateTween )
    return

  ###
  animated go to and hover over a locatin by its id
  ###
  slideToLocation: (contrey, time = 2000, ease = "cubic-in-out")=>

    place = @getFeature(contrey)

    #get the conterys id
    p = d3.geo.centroid(place)

    #get its real quardanets
    @location = [p[0], p[1]]

    d3.transition().duration(time).ease(ease).tween("rotate", @rotateTween )

    return

  rotateTween: =>

    p = @location
    r = d3.interpolate(@projection.rotate(), [-p[0], -p[1]])
    console.log(r)
    return (t) =>
      console.log(r(t))
      @goto(r(t))

  centerTween: =>

    p = @location
    r = d3.interpolate(@currentveiw, [p[0], p[1]])

    return (t) =>
      #log the current location
      @currentveiw = (r(t))

      @projection.center(r(t))
      @refresh()
  
  scaleTween: =>
    r = d3.interpolate(0, 1500)

    return (t) =>
      @projection.scale(r(t))
      @refresh

  #make it pretty later
#  projectionTween: (projection0, projection1) =>
#    return (d) =>
#      t = 0
#      project = (λ , φ) ->
#        console.log("project is run")
#        λ *= 180 / Math.PI
#        φ *= 180 / Math.PI
#        p0 = projection0([λ, φ])
#        p1 = projection1([λ, φ])
#        console.log(" λ = "+λ+" φ = "+φ)
#        return [(1 - t) * p0[0] + t * p1[0], (1 - t) * -p0[1] + t * -p1[1]]
#
#      proj = d3.geo.projection(project)
#        .scale(1)
#        .translate([@width / 2, @height / 2])
#
#
#      path = d3.geo.path()
#          .projection(proj)
#
#      return (_) ->
#        t = _;
#        return path(d);

  ###
  get a feature from a 3 letttter code
  ###
  getFeature: (location) =>
    for feature in @features
      if feature.id == location
        return feature
        break

  ###
  zooms in on a location
  has the opitons time ease projection
  ###
  zoomInOn: (location, options) =>

    place = @getFeature(location)
    
       #make it so you dont have to insert a option if you dont want to
    if options    != undefined
                  {time, ease, projection, callback} =
                    options


    if time       == undefined
                  time =
                    2000

    if ease       == undefined
                  ease =
                    "cubic-in-out"

    if projection == undefined
                  projection =
                    d3.geo.mercator()
                      .scale(400)
                      .translate([@width / 2, @height / 2])

    @location =
      d3.geo.centroid(place)
    console.log(@trackable)
    if !@trackable
      d3.transition()
        .duration(time/2)
        .ease(ease)
        .tween("rotate", @rotateTween )
        .each("end", =>
          @svg.selectAll("path").remove()
          @getmap(map: location+"_topo")
          @svg.select(".stroke").remove()
          @svg.select(".fill").remove()
          @changeProjection projection, true

          @projection.center @location
          d3.transition()
            #.duration(time/2)
            #.ease(ease)
            .tween("zoom", @scaleTween)
            .each("end", =>
              @refresh
              if callback   != undefined
                  callback()
            )
        )
     else
      d3.transition()
        .duration(time/2)
        .ease(ease)
        .tween("rotate", @centerTween )
        .each("end", =>
          @svg.selectAll("path").remove()
          @getmap(map: location+"_topo")
          @svg.select(".stroke").remove()
          d3.select("")
          @projection = projection
          @path =  d3.geo.path()
            .projection(@projection)

          @projection.center @location
          d3.transition()
            #.duration(time/2)
            #.ease(ease)
            .tween("zoom", @scaleTween)
            .each("end", =>
              @refresh
            )
        )
       
###
testing function
###
#$(document).ready( () ->
#  window.globe = new Map width: 500, height: 500, scale: 220, tag:"body"
#
#  console.log globe
#
#  globe.getmap("world")
#
#  $("body").append("<button onclick='globe.slideToLocation(\"VEN\")'> click me I'm pretty </button>")
#)
