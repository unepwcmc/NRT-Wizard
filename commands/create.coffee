fs = require('fs')
Promise = require('bluebird')
inquirer = Promise.promisifyAll(require('inquirer'))

Module = require('../models/module')

exports.create = (instanceName) ->
  fs.mkdirSync(instanceName)

  availableModules = Module.all()

  inquirer.promptAsync([{
    type: 'checkbox'
    name: 'required_modules'
    message: 'Select the modules to import for this instance:'
    choices: availableModules
  }]).then(->)
