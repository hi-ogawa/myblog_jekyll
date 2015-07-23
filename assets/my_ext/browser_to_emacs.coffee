$('.content h1,h2,h3,h4,h5,h6').click ->
  $jumpTag = $(this).next().children('p > span')
  data =
      sender: 'chrome'
      lineno: $jumpTag.attr('lineno')
      path:   $jumpTag.attr('path')
  $.post 'http://localhost:4010', data, ((res) -> console.log res)  
