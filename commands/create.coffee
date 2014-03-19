fs       = require 'fs'
inquirer = require 'inquirer'
async    = require 'async'

Module = require('../models/module')

ModuleQuestioner  = require('../lib/modules_questioner')
ReleaseQuestioner = require('../lib/releases_questioner')

exports.create = (instanceName) ->
  fs.mkdirSync(instanceName)

  installModule = (module, callback) ->
    console.log "Setting up #{module.attributes.name}..."
    module.setup(instanceName).then( ->
      console.log "Finished setting up #{module.attributes.name}"
      callback()
    ).catch( (err) ->
      console.log '### Error'
      console.log "Could not setup #{module.attributes.name}"
      callback(err)
    )

  availableModules = Module.all()

  ModuleQuestioner
    .ask(availableModules)
    .then(ReleaseQuestioner.ask)
    .then( (modules) ->
      async.eachSeries(modules, installModule, (err) ->
        return console.log "ERROR: #{err}" if err?
        console.log 'Finished setting up modules'
      )
    ).catch( (err) ->
      console.log "### ERRROR"
      console.log err
    )
