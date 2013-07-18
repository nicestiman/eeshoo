$(document).ready ->
  

  $.get('/country_codes/hasc_codes_country_list.csv', (data)->
    console.log data

    country_list=[]
    all_text_lines=data.split(/\r\n|\n/)
    for line in all_text_lines
      line=line.split(',')
      country_list.push line


    console.log country_list
    select_html = '<select name="countrymenu">'

    for option in country_list

      select_html += "<option value=#{option[0]}>#{option[1]}</option>"

    select_html += '</select>'
    $('#new_group').append(select_html)
  )
