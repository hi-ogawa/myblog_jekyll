$('.content h1,h2,h3,h4,h5,h6').click ->
  data =
     id: $(this).attr('id')
     url: document.URL
  $.post 'http://localhost:4010', data, ((res) -> console.log res)  
