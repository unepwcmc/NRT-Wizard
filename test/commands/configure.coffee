assert = require('chai').assert
sinon  = require 'sinon'

MessageServer = require('../../lib/message_server')
fs = require('fs')
child_process = require('child_process')
Promise = require('bluebird')

cli = require('../../cli')

suite 'nrt configure'

test('.configure throws an error if the current directory is not an NRT
 component', ->
  readFileSyncStub = sinon.stub(fs, 'readFileSync', ->
    JSON.stringify({})
  )

  try
    assert.throws( (->
      cli['configure']()
    ), /package\.json has no `configure` script/)
  finally
    readFileSyncStub.restore()
)

#test('.configure starts a redis-server, subscribes to a MessageServer
 #and runs configure in the given component', ->
  #sandbox = sinon.sandbox.create()

  #readFileSyncStub = sandbox.stub(fs, 'readFileSync', ->
    #JSON.stringify({
      #scripts:
        #configure: ''
    #})
  #)

  #execStub = sandbox.stub(child_process, 'execAsync', (cmd) ->
    #new Promise( (resolve, reject) -> resolve())
  #)

  #onQuestionStub = sandbox.stub(MessageServer::, 'on', ->)

  #try
    #cli['configure']()

    #assert.strictEqual execStub.callCount, 1,
      #"Expected exec to be called once"
    #assert.isTrue execStub.calledWith("redis-server &"),
      #"Expected exec to be called with `redis-server &`"

    #assert.strictEqual onQuestionStub.callCount, 1,
      #"Expected MessageServer::on to be called once"
    #assert.isTrue onQuestionStub.calledWith('question'),
      #"Expected MessageServer::on to be called with 'question'"
  #finally
    #sandbox.restore()
#)
