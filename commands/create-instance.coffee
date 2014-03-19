fs       = require 'fs'
inquirer = require 'inquirer'
async    = require 'async'

Component = require('../models/component')

ChooseComponentQuestion  = require('../lib/questions/choose_components')
ChooseReleaseQuestion = require('../lib/questions/choose_releases')

exports['create-instance'] = (instanceName) ->
  fs.mkdirSync(instanceName)

  installComponent = (component, callback) ->
    console.log "Setting up #{component.attributes.name}..."
    component.setup(instanceName).then( ->
      console.log "Finished setting up #{component.attributes.name}"
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
        return console.log "ERROR: #{err}" if err?
        console.log 'Finished setting up components'
      )
    ).catch( (err) ->
      console.log "### ERRROR"
      console.log err
    )
