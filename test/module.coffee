assert = require('chai').assert
sinon  = require('sinon')

fs = require('fs')

Module = require('../models/module')

suite('Module model')

test('#all returns all modules available', ->
  expectedModules = [{name: "Reporting"}]

  readFileStub = sinon.stub(fs, 'readFileSync', -> JSON.stringify(expectedModules))

  try
    assert.deepEqual Module.all(), expectedModules
  finally
    readFileStub.restore()
)

test('new Module() creates a new Module instance with the given attributes', ->
  attributes =
    name: 'Reporting'
    repository_url: 'http://github.com/the_codes'

  module = new Module(attributes)

  assert.strictEqual module.constructor.name, "Module",
    "Expected a Module class instance to be created"

  assert.property module.attributes, 'name',
    "Expected module instance to have property name"

    assert.strictEqual module.attributes.name, attributes.name,
      "Expected module instance to have name property
      '#{attributes.name}', but was '#{module.name}'"
)
