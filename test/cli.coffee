assert  = require('chai').assert
sinon   = require('sinon')
Promise = require('bluebird')
git     = require('gift')

pkg = require('../package.json')
cli = require('../cli')
Component = require('../models/component')

fs = require('fs')
inquirer = require('inquirer')

suite('NRT Wizard CLI')

test('.create-instance creates a NRT instance directory, and asks the user which
 components to import', ->
  availableComponents = [{name: 'Reporting'}]

  sandbox = sinon.sandbox.create()

  promptSpy = sandbox.stub(inquirer, 'prompt', (option, callback) ->)
  promptOptions = [{
    type: 'checkbox'
    name: 'required_components'
    message: 'Select the components to import for this instance:'
    choices: availableComponents
  }]

  mkdirStub = sandbox.stub(fs, 'mkdirSync', ->)
  readFileStub = sandbox.stub(fs, 'readFileSync', -> JSON.stringify(availableComponents))

  cli['create-instance']('projectName')

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

