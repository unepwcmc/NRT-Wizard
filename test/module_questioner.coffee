assert = require('chai').assert
inquirer = require('inquirer')
sinon    = require('sinon')

ModuleQuestioner = require('../lib/modules')
Module = require('../models/module')

suite('ModuleQuestioner')

test('.ask returns an array of module instances selected by the user', (done) ->
  modules = [
    new Module(name: 'hats')
    new Module(name: 'boats')
  ]

  promptStub = sinon.stub(inquirer, 'prompt', (options, callback) ->
    callback(required_modules: ['hats'])
  )

  try
    ModuleQuestioner.ask(modules).then( (returnedModules) ->
      assert.lengthOf returnedModules, 1,
        'Expected only one module to be selected'

      assert.deepEqual returnedModules[0], modules[0]

      done()
    ).catch( (err) ->
      promptStub.restore()
      done(err)
    )
  finally
    promptStub.restore()
)
