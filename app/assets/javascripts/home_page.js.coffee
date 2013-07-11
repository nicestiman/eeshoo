$(document).ready ->
  globe_width=$("#globe").width()
  globe_height=window.innerHeight-100
  
  if(globe_width>globe_height)
    scale = globe_height
  else
    scale = globe_width
  
  globe = new Map width: globe_width,height: globe_height,scale:(scale-5)/2,tag: "#globe"
  
  console.log(scale)
  
  globe.getmap()

  get_random_color =  ->
    letters = '0123456789ABCDEF'.split('')
    color = '#'
    for  i in [1..6]
      color += letters[Math.round(Math.random() * 15)]
    return color

  
  $.getJSON('posts', (data) ->
    console.log(data)
    for post in data
      console.log(post.content)
      $("#story")
        .append("
        <div location='#{post.location}'>
        <h3>#{post.title}</h3>
        <p>#{post.content}</p>
        </div>
        ")
    colorize()
    set_hover_effect()
  )
  
  colorize = ->
    $("#story div").each ( ->
      console.log($(this))
      color = get_random_color()

      $(this).css("background-color", color)
    )
  
  set_hover_effect = ->
    $("#story div").hover(->#on mouse in

      code = $(this)
        .attr("location")
      if code ==  undefined
        return

      d3.select("#"+code).attr("class", "land selected")
      
      globe.slideToLocation(code)

    ->#on mouse out
      code = $(this).
        attr("location")
      if code == undefined
        return
      console.log(code)
      d3.select("#"+code).attr("class", "land")
    )
