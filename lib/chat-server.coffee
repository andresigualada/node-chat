module.exports = (server) ->
  chatServer = require('socket.io')(server)

  messages = []
  users = []

  storeUser = (name) ->
    users.push(name)

  storeMessage = (name, data) ->
    messages.push(
      name: name,
      data: data
    )
    if messages.length > 20 then messages.shift()

  removeChatter = (chatter) ->
    console.log "users before: " + users.toString()
    users = (user for user in users when user isnt chatter)
    console.log "users after: " + users.toString()

  chatServer.on('connection', (client) ->
    client.on('join', (name) ->
      console.log "#{name} has joined the chat"

      storeUser(name)

      client.name = name

      # Update userlist of other users
      client.broadcast.emit('joined',name)
      users.forEach((username) ->
        client.emit('joined', username)
      )

      # Update last messages of THIS user
      messages.forEach((message) ->
        client.emit('message', "#{message.name}: #{message.data}")
      )
    )

    client.on('message', (message) ->
      console.log "#{client.name}: #{message}"

      client.broadcast.emit('message',  "#{client.name}: #{message}")
      client.emit('message',  "#{client.name}: #{message}")

      storeMessage(client.name, message)
    )

    client.on('disconnect', () ->
      console.log "#{client.name} has left the chat"
      removeChatter(client.name)
      client.broadcast.emit('remove chatter', client.name)
    )
  )