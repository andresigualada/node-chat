express = require 'express'
router = express.Router()

app = express()
server = require('http').createServer app
chatServer = require('socket.io').listen server

# GET home page.
router.get('/', (req, res, next) ->
  res.render(
    'index',
    title: 'Node-chat'
  )
)

chatServer.on('connection', (socket) ->
  console.log 'socket established'
  socket.emit 'news', { hello: 'world' }
)


module.exports = router
