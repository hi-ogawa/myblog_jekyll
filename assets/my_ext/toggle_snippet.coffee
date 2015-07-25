$ ->
    $('.toggle-snippet').click ->
      $(this).parent().next().toggle()
      if $(this).parent().next().css('display') is 'none'
        $(this).parent().css('margin-bottom', '15px')
      else      
        $(this).parent().css('margin-bottom', '0px')

    # initial state is `snippet off`
    $('.toggle-snippet').click()
