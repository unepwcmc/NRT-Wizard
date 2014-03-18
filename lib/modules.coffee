inquirer = require 'inquirer'
Promise  = require 'bluebird'
_        = require 'underscore'

Module = require '../models/module'

exports.ask = (modules) ->
  choices = modules.map( (module) -> module.attributes )
  new Promise( (resolve, reject) ->
    inquirer.prompt([{
      type: 'checkbox'
      name: 'required_modules'
      message: 'Select the modules to import for this instance:'
      choices: choices
    }], (answers)->
      selectedModules = answers.required_modules

      resolve _.filter(modules, (module) ->
        module.attributes.name in selectedModules
      )
    )
  )
