crypto = require('crypto')
Redis = require('redis')

events = require('events')

MessageServer = class MessageServer
  constructor: ->
    events.EventEmitter.call(@)

    @serverId = MessageServer.generateId()
    @subscribe()

  @generateId: ->
    crypto.randomBytes(20).toString('hex')

  subscribe: ->
    queue = Redis.createClient()
    queue.subscribe(@serverId)

    queue.on('message', (channel, message) =>
      messageJSON = JSON.parse(message)
      if messageJSON.type is 'question'
        @emit('question', messageJSON)
    )

MessageServer::__proto__ = events.EventEmitter.prototype

module.exports = MessageServer
