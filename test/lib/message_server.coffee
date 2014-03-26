assert = require('chai').assert
sinon  = require 'sinon'

MessageServer = require('../../lib/message_server')

Redis = require('redis')

suite 'MessageServer'

test('.on waits for a question and fires an event')

test('new MessageServer generates an ID for the queue, and subscribes to it', ->
  serverId = 'abcd'

  sandbox = sinon.sandbox.create()

  generateStub = sandbox.stub(MessageServer, 'generateId', -> serverId)
  subscribeSpy = sandbox.spy(MessageServer::, 'subscribe')

  redisClient =
    subscribe: sinon.spy()
    on: sinon.spy()
  createClientStub = sandbox.stub(Redis, 'createClient', -> redisClient)

  try
    messageServer = new MessageServer()

    assert.strictEqual generateStub.callCount, 1,
      "Expected MessageServer#generateId to be called once"

    assert.property messageServer, 'serverId'
    assert.strictEqual messageServer.serverId, serverId

    assert.strictEqual subscribeSpy.callCount, 1,
      "Expected MessageServer::subscribe to be called once"

    assert.strictEqual redisClient.subscribe.callCount, 1,
      "Expected redis.subscribe to be called once"
    assert.isTrue redisClient.subscribe.calledWith(serverId),
      "Expected redis.subscribe to be called with #{serverId}"

    assert.strictEqual redisClient.on.callCount, 1,
      "Expected redis.on to be called once"
    assert.isTrue redisClient.on.calledWith('message'),
      "Expected redis.on to be called with 'message'"
  finally
    sandbox.restore()
)

test('MessageServer is an EventEmitter', (done) ->
  sandbox = sinon.sandbox.create()
  subscribeStub = sandbox.stub(MessageServer::, 'subscribe', ->)

  try
    messageServer = new MessageServer()

    assert.property messageServer, 'on',
      "Expected MessageServer to have an 'on' method"

    messageServer.on('anEvent', ->
      done()
    )

    messageServer.emit('anEvent')
  finally
    sandbox.restore()
)
