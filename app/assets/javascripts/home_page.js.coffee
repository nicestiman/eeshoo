$(document).ready ->
  globe = new Map width: 500, height: 500, scale: 225, tag: "#globe"
  globe.getmap()

  window.get_random_color =  ->
    letters = '0123456789ABCDEF'.split('');
    color = '#';
    for  i in [1..6]
      color += letters[Math.round(Math.random() * 15)]
    return color

  console.log($("#story div"))

  $("#story div").each ( ->
#    console.log($(this))
    color = get_random_color()
    console.log(color)

    $(this).css("background-color", color)
  )

  $("#story div").hover(->#on mouse in

    code = $(this)
      .attr("location");

    $("."+code).addClass("selected")

    console.log(code)
    globe.slideToLocation(code)
  ->#on mouse out
    $("."+code).removeClass("selected")
  )

