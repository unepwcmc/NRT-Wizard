assert  = require('chai').assert
sinon   = require('sinon')
Promise = require('bluebird')

pkg = require('../package.json')
cli = require('../cli')

fs = require('fs')
inquirer = require('inquirer')

suite('NRT Wizard CLI')

test('.create creates a NRT instance directory, and asks the user which
 modules to import', ->
  availableModules = [{name: 'Reporting'}]

  promptSpy = sinon.stub(inquirer, 'promptAsync', ->
    return new Promise( (resolve) -> resolve() )
  )
  promptOptions = [{
    type: 'checkbox'
    name: 'required_modules'
    message: 'Select the modules to import for this instance:'
    choices: availableModules
  }]

  mkdirStub = sinon.stub(fs, 'mkdirSync', ->)
  readFileStub = sinon.stub(fs, 'readFileSync', -> JSON.stringify(availableModules))

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
    readFileStub.restore()
)
