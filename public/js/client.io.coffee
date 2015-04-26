$ ->
  $form = $('#form-new-message')
  $input = $("#input-new-message")
  $btn = $('#send-message')

  $ul_clients = $('#client-list>ul')

  inputUserName = ->
    username = prompt 'What\'s your name?'

  newChatter = (username) ->
    $li = $("<li data-user='#{username}'>#{username}</li>")
    $ul_clients.append($li)

  removeChatter = (username) ->
    $ul_clients.find("li[data-user='#{username}']").remove()

  sendMessage = (e) ->
    e.preventDefault()
    message = $input.val()
    console.log(message)
    if message isnt ''
      server.emit('message', message)
      $input.val('')

  renderMessage = (message) ->
    $ul = $('#chat-window>ul')
    $li = $("<li>#{message}</li>")
    $ul.append($li)

  ## Connect with serverInsertMe
  server = io.connect 'http://localhost:8080'

  ## On connect, prompt username and emit to the server
  server.on('connect', (client) ->
    server.emit('join', inputUserName())
  )

  $form.on 'submit', sendMessage


  server.on('joined', (username) ->
    newChatter(username)
  )

  server.on('message', (message) ->
    renderMessage(message)
  )

  server.on('remove chatter', (username) ->
    removeChatter(username)
  )