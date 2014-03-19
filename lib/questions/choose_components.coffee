inquirer = require 'inquirer'
Promise  = require 'bluebird'
_        = require 'underscore'

Component = require '../../models/component'

exports.ask = (components) ->
  choices = components.map( (component) -> component.attributes )
  new Promise( (resolve, reject) ->
    inquirer.prompt([{
      type: 'checkbox'
      name: 'required_components'
      message: 'Select the components to import for this instance:'
      choices: choices
    }], (answers)->
      selectedComponents = answers.required_components

      resolve _.filter(components, (component) ->
        component.attributes.name in selectedComponents
      )
    )
  )
