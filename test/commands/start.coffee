assert = require('chai').assert
sinon  = require 'sinon'

StartCommand = require '../../commands/start'

CommandRunner = require('../../lib/command_runner')
fs = require 'fs'

suite 'nrt start'

test('returns all the NRT repositories for this instance', ->
  expectedRespositories = ['Reporting', 'Indicatorator']

  sandbox = sinon.sandbox.create()

  chdirStub = sandbox.stub(process, 'chdir', ->)
  readdirStub = sandbox.stub(fs, 'readdirSync', -> expectedRespositories)
  spawnStub = sandbox.stub(CommandRunner, 'spawn', (command) ->
    #return {
      #on: (state, callback) -> callback()
    #}
  )

  try
    repositories = StartCommand.start()

    assert.isTrue readdirStub.calledWith(process.cwd()),
      "Expected readdir to be called with the current directory"

    assert.strictEqual spawnStub.callCount, 2,
      "Expected spawn to be called twice"

    assert.strictEqual chdirStub.callCount, 4,
      "Expected chdir to be called four times"

    assert.isTrue spawnStub.calledWith('npm start'),
      "Expected spawn to be called with `npm start`"

    assert.deepEqual repositories, expectedRespositories

  finally
    sandbox.restore()
)
