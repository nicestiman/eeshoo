$(document).ready ->
  

  country_list=[]
  $.get('/country_codes/hasc_codes_country_list.csv', (data)->
    console.log data

    all_text_lines=data.split(/\r\n|\n/)
    for line in all_text_lines
      line=line.split(',')
      country_list.push line


  )
  console.log country_list
