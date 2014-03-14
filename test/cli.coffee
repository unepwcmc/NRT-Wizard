assert = require('chai').assert
sinon  = require('sinon')

pkg = require('../package.json')
cli = require('../cli')

fs = require('fs')

suite('NRT Wizard CLI')

test('.create creates a NRT instance directory', ->
  cli.create('projectName')

  try
    assert.isTrue fs.existsSync('./projectName'),
      "Expected the directory ./projectName to be created"
  finally
    fs.rmdirSync('./projectName')
)
