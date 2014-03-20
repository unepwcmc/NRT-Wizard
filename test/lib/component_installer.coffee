assert  = require('chai').assert
sinon   = require('sinon')
Promise = require('bluebird')

fs = require('fs')

CommandRunner = require('../../lib/command_runner')
ComponentInstaller = require('../../lib/component_installer')
Component = require('../../models/component.coffee')

suite('ComponentInstaller')

test('#install, given a Component instance, reads the component
 package.json and runs the "setup" command', (done) ->
  component = new Component(
    directory: '/over/here'
    name: 'here'
  )

  originalPlatform = process.platform
  process.platform = 'osx'

  componentConfig = {
    setup:
      'osx': 'an command'
  }

  sandbox = sinon.sandbox.create()

  readFileStub = sandbox.stub(fs, 'readFileAsync', ->
    new Promise( (resolve, reject) ->
      resolve(JSON.stringify(componentConfig))
    )
  )
  existsStub = sandbox.stub(fs, 'existsSync', -> true)

  console.log 'making spawn stub'
  spawnStub = sandbox.stub(CommandRunner, 'spawn', (command) ->
    return {
      on: (state, callback) -> callback()
    }
  )

  try
    ComponentInstaller.install(component).then( ->
      assert.strictEqual readFileStub.callCount, 1,
        "Expected readFileSync to be called once"

      readFileArgs = readFileStub.getCall(0).args
      assert.strictEqual readFileArgs[0], "/over/here/package.json",
        "Expected readFileSync to be called with the path to the package.json"

      assert.strictEqual spawnStub.callCount, 1,
        "Expected CommandRunner.spawn to be called once"

      spawnArgs = spawnStub.getCall(0).args
      assert.strictEqual spawnArgs[0], 'an command',
        "Expected CommandRunner.spawn to be called with 'an command'"

      done()
    ).catch( (err) ->
      sandbox.restore()
      process.platform = originalPlatform
      done(err)
    )
  catch err
    done(err)
  finally
    sandbox.restore()
    process.platform = originalPlatform
)

test('#install throws an error if the component package.json does not exist', (done) ->
  component = new Component(
    directory: '/over/here'
    name: 'here'
  )

  existsStub = sinon.stub(fs, 'existsSync', -> false)

  try
    ComponentInstaller.install(component).then( ->
      existsStub.restore()
      done(new Error("Expected #install to throw an error"))
    ).catch( (err) ->
      assert.strictEqual existsStub.callCount, 1,
        "Expected existsSync to be called once"

      assert.strictEqual(
        err.message,
        "here does not have a package.json in its root directory"
      )

      return done()
    )
  catch err
    done(err)
  finally
    existsStub.restore()
)

test('#install throws an error if the component package.json does not
 specify a setup command for this operating system', (done) ->
  component = new Component(
    directory: '/over/here'
    name: 'here'
  )

  sandbox = sinon.sandbox.create()

  readFileStub = sandbox.stub(fs, 'readFileAsync', ->
    new Promise( (resolve, reject) ->
      resolve(JSON.stringify({}))
    )
  )
  existsStub = sandbox.stub(fs, 'existsSync', -> true)

  ComponentInstaller.install(component).then( ->
    existsStub.restore()
    sandbox.restore()
    return done(new Error("Expected #install to throw an error"))
  ).catch( (err) ->

    assert.strictEqual(
      err,
      "here does not define a 'setup' command in the package.json"
    )

    return done()
  )
)

