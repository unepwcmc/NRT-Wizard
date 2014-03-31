fs       = require 'fs'
inquirer = require 'inquirer'
async    = require 'async'

Component = require('../models/component')
ComponentInstaller = require('../lib/component_installer')

ChooseComponentQuestion  = require('../lib/questions/choose_components')
ChooseReleaseQuestion = require('../lib/questions/choose_releases')

Cli = require('../cli')

exports['create-instance'] = (instanceName) ->
  fs.mkdirSync(instanceName)

  installComponent = (component, callback) ->
    console.log "Setting up #{component.attributes.name}..."
    component.setup(instanceName).then( ->
      console.log "Finished setting up #{component.attributes.name}"
      console.log "Going to run installer..."
      ComponentInstaller.install(component)
    ).then(->
      console.log "Install complete..."
      callback()
    ).catch( (err) ->
      console.log '### Error'
      console.log "Could not setup #{component.attributes.name}"
      callback(err)
    )

  availableComponents = Component.all()

  ChooseComponentQuestion
    .ask(availableComponents)
    .then(ChooseReleaseQuestion.ask)
    .then( (components) ->
      async.eachSeries(components, installComponent, (err) ->
        return console.log err if err?
        console.log 'Finished setting up components'

        console.log '########'
        console.log 'Booting servers'

        process.chdir(instanceName)
        Cli.start()
      )
    ).catch( (err) ->
      console.log "### ERRROR"
      console.log err
      console.log err.stack
    )
