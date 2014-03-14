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
