assert = require('chai').assert
inquirer = require('inquirer')
sinon    = require('sinon')

ChooseComponentQuestion  = require('../../../lib/questions/choose_components')
Component = require('../../../models/component')

suite('ChooseComponentQuestion')

test('.ask returns an array of component instances selected by the user', (done) ->
  components = [
    new Component(name: 'hats')
    new Component(name: 'boats')
  ]

  promptStub = sinon.stub(inquirer, 'prompt', (options, callback) ->
    callback(required_components: ['hats'])
  )

  try
    ChooseComponentQuestion.ask(components).then( (returnedComponents) ->
      assert.lengthOf returnedComponents, 1,
        'Expected only one component to be selected'

      assert.deepEqual returnedComponents[0], components[0]

      done()
    ).catch( (err) ->
      promptStub.restore()
      done(err)
    )
  finally
    promptStub.restore()
)
