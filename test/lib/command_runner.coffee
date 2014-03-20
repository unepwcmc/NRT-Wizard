assert = require('chai').assert
sinon  = require('sinon')

CommandRunner = require('../../lib/command_runner')
ChildProcess = require('child_process')

suite('CommandRunner')

test('#spawn takes a command, parses it in to an args array and calls
 ChildProcess#spawn with the results', ->
  command = 'coffee ./this/file.coffee "args here"'
  expectedCommand = 'coffee'
  expectedArgs    = ['./this/file.coffee', 'args here']

  spawnStub = sinon.stub(ChildProcess, 'spawn', (processName, args) ->
    return {
      stdout: on: ->
      stderr: on: ->
    }
  )

  CommandRunner.spawn(command)

  try
    spawnArgs = spawnStub.getCall(0).args
    assert.strictEqual spawnArgs[0], expectedCommand,
      "Expected '#{expectedCommand}' to be the process name, but was #{spawnArgs[0]}"

    assert.deepEqual spawnArgs[1], expectedArgs
  finally
    spawnStub.restore()
)

test('#spawn structures commands correctly for Windows', ->
  command = 'coffee ./this/file.coffee "args here"'
  expectedCommand = 'cmd'
  expectedArgs    = ['/c', 'coffee', './this/file.coffee', 'args here']

  sandbox = sinon.sandbox.create()
  spawnStub = sandbox.stub(ChildProcess, 'spawn', (processName, args) ->
    return {
      stdout: on: ->
      stderr: on: ->
    }
  )
  platformStub = sandbox.stub(process, 'platform', "win128")

  CommandRunner.spawn(command)

  try
    spawnArgs = spawnStub.getCall(0).args
    assert.strictEqual spawnArgs[0], expectedCommand,
      "Expected '#{expectedCommand}' to be the process name, but was #{spawnArgs[0]}"

    assert.deepEqual spawnArgs[1], expectedArgs
  finally
    sandbox.restore()
)

