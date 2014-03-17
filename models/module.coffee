fs = require 'fs'
path = require 'path'

module.exports = class Module
  constructor: (@attributes) ->

  @all: ->
    moduleConfigPath = path.join(__dirname, '..', 'config', 'modules.json')
    availableModules = JSON.parse(fs.readFileSync(moduleConfigPath))

    return availableModules.map( (module) -> new Module(module) )
