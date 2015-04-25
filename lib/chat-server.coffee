express = require 'express'
app = express()
server = app.listen(8080)
io = require('socket.io')


chatServer = io.Server(server,
  path: '/socketest.io'
)

module.export = chatServer