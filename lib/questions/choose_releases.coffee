inquirer = require 'inquirer'
Promise  = require 'bluebird'
async    = require 'async'

promptForRelease = (module, callback) ->
  module
    .getReleases()
    .then( (releases) ->
      inquirer.prompt([{
        type: 'list'
        name: 'release'
        message: "Select the release for #{module.attributes.name}:"
        choices: releases
      }], (answer)->
        selectedRelease = answer.release
        module.attributes.release = selectedRelease
        callback(null)
      )
    )

exports.ask = (modules) ->
  new Promise( (resolve, reject) ->
    async.eachSeries(modules, promptForRelease, (err) ->
      return reject(err) if err?

      resolve(modules)
    )
  )
