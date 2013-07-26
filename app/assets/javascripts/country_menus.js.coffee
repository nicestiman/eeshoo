$(document).ready ->
  
  menu_name = 'countrymenu'
  second_menu = 'statemenu'

  $.get('/country_codes/hasc_codes_country_list.csv', (data)->

    country_list = parse_csv(data)

    $('#new_group').prepend(build_dropdown_menu(country_list, menu_id: menu_name ))

    $("##{menu_name}").change(->

      $("##{second_menu}").remove()

      $('#new_group').append("<input type=\"hidden\" name=\"group[location]\" id=\"location\" value=\"#{find_input_code()}\"/>")

      $.get('/country_codes/hasc_codes.csv', (data)->

        country_code = $("##{menu_name} option:selected").attr 'value'
        state_list = parse_csv(data, country_code: country_code)

        $('#new_group').prepend(build_dropdown_menu(state_list, display_col: 2, menu_id: second_menu))

        $("##{second_menu}").change(->
          
          $('#new_group').append("<input type=\"hidden\" name=\"group[location]\" id=\"location\" value=\"#{find_input_code()}\"/>")
        )
      
      )#end state ajax block
    )#end change block for country

  )#end ajax for country list

  parse_csv = (data, options) ->
    
    if options  != undefined
                {country_code} = options

    list = []

    all_lines = data.split(/\r\n|\n/)
    for line in all_lines
      line = line.split(',')

      if country_code == undefined
        list.push line
      else if country_code == line[0][0..1]
        list.push line


    return list

  build_dropdown_menu = (list, options) ->
    if options    != undefined
                  {menu_id, index_col, display_col} = options

    if menu_id == undefined
      menu_id = "drop_down_box"

    if index_col == undefined
      index_col = 0

    if display_col == undefined
      display_col = 1
      #it needs a name attr the name valule is the key in in prams 
      #this is not real code just wanted to show that it works now 
    menu_html = "<select id=\"#{menu_id}\">"

    if list.length > 0

      menu_html += "<option value=\"Please make a selection\">Please make a selection</option>"

      for entry in list

        menu_html += "<option value=#{entry[index_col]}>#{entry[display_col]}</option>"
      menu_html += '</select>'
      return menu_html
    else

      return null

  find_input_code = ->

    $("#location").remove()

    
    if $("##{second_menu}").length > 0
      
      return $("##{second_menu} option:selected").attr 'value'
    else

      return $("##{menu_name} option:selected").attr 'value'
  

