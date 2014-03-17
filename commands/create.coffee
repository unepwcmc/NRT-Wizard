fs       = require 'fs'
inquirer = require 'inquirer'

Module = require('../models/module')

exports.create = (instanceName) ->
  fs.mkdirSync(instanceName)

  availableModules = Module.all().map( (module) -> module.attributes )

  inquirer.prompt([{
    type: 'checkbox'
    name: 'required_modules'
    message: 'Select the modules to import for this instance:'
    choices: availableModules
  }], (answers)->
    modulesToClone = answers.required_modules

    modulesToClone.forEach( (moduleName) ->
      module = Module.findByName(moduleName)
      module.clone()
    )
  )
