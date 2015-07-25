$ ->

  # for compatibility with toc-generator (to get emacs-to-chrome jump work)
  $('.content h1,h2').each ->
    # put a fake anchor at the top of each header
    $(this).before $('<span>').attr('id', $(this).attr('id'))

  $('.content-wrap h1,h2,h3,h4,h5,h6').click ->
    $jumpTag = $(this).next().children('p > span')
    data =
        sender: 'chrome'
        lineno: $jumpTag.attr('lineno')
        path:   $jumpTag.attr('path')
    $.post 'http://localhost:4010', data, ((res) -> console.log res)  
