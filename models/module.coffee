fs = require 'fs'
path = require 'path'

module.exports = class Module
  constructor: (@attributes) ->

  @all: ->
    moduleConfigPath = path.join(__dirname, '..', 'config', 'modules.json')
    JSON.parse(fs.readFileSync(moduleConfigPath))
