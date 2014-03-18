fs       = require 'fs'
inquirer = require 'inquirer'

Module = require('../models/module')

ModuleQuestioner  = require('../lib/modules')
ReleaseQuestioner = require('../lib/releases')

exports.create = (instanceName) ->
  fs.mkdirSync(instanceName)

  availableModules = Module.all()

  ModuleQuestioner
    .ask(availableModules)
    .then(ReleaseQuestioner.ask)
    .then( (modules) ->
      modules.forEach( (module) ->
        console.log module.attributes
      )
    ).catch( (err) ->
      console.log "### ERRROR"
      console.log err
    )
