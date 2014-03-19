fs       = require 'fs'
inquirer = require 'inquirer'
async    = require 'async'

Module = require('../models/module')

ChooseModuleQuestion  = require('../lib/questions/choose_modules')
ChooseReleaseQuestion = require('../lib/questions/choose_releases')

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

  ChooseModuleQuestion
    .ask(availableModules)
    .then(ChooseReleaseQuestion.ask)
    .then( (modules) ->
      async.eachSeries(modules, installModule, (err) ->
        return console.log "ERROR: #{err}" if err?
        console.log 'Finished setting up modules'
      )
    ).catch( (err) ->
      console.log "### ERRROR"
      console.log err
    )
