assert  = require('chai').assert
sinon   = require('sinon')
Promise = require('bluebird')
git     = require('gift')

pkg = require('../package.json')
cli = require('../cli')
Module = require('../models/module')

fs = require('fs')
inquirer = require('inquirer')

suite('NRT Wizard CLI')

test('.create creates a NRT instance directory, and asks the user which
 modules to import', ->
  availableModules = [{name: 'Reporting'}]

  sandbox = sinon.sandbox.create()

  promptSpy = sandbox.stub(inquirer, 'prompt', (option, callback) ->)
  promptOptions = [{
    type: 'checkbox'
    name: 'required_modules'
    message: 'Select the modules to import for this instance:'
    choices: availableModules
  }]

  mkdirStub = sandbox.stub(fs, 'mkdirSync', ->)
  readFileStub = sandbox.stub(fs, 'readFileSync', -> JSON.stringify(availableModules))

  cli.create('projectName')

  try
    assert.isTrue mkdirStub.calledWith('projectName'),
      "Expected the directory ./projectName to be created"

    assert.isTrue promptSpy.calledOnce,
      "Expected inquirer.prompt to be called"

    promptArgs = promptSpy.getCall(0).args[0]
    assert.deepEqual promptArgs, promptOptions,
      "Expected prompt to be called with #{promptOptions}, but was called with #{promptArgs}"
  finally
    sandbox.restore()
)

test('.create instantiates Modules and starts a git clone', ->
  module = new Module(name: 'Reporting')

  sandbox = sinon.sandbox.create()

  sandbox.stub(Module, 'all', -> [module])
  sandbox.stub(Module, 'findByName', -> module)

  moduleCloneSpy = sinon.spy(module, 'clone')

  sandbox.stub(git, 'clone', ->)
  sandbox.stub(inquirer, 'prompt', (options, callback) ->
    callback(required_modules: ['Reporting'])
  )
  sandbox.stub(fs, 'mkdirSync', ->)

  cli.create('projectName')

  try
    assert.isTrue moduleCloneSpy.calledOnce,
      "Expected module.clone to be called"
  finally
    sandbox.restore()
)
