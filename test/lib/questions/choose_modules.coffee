assert = require('chai').assert
inquirer = require('inquirer')
sinon    = require('sinon')

ChooseModuleQuestion  = require('../../../lib/questions/choose_modules')
Module = require('../../../models/module')

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
    ChooseModuleQuestion.ask(modules).then( (returnedModules) ->
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
