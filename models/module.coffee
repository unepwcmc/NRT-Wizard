_       = require 'underscore'
fs      = require 'fs'
git     = require 'gift'
path    = require 'path'
Promise = require 'bluebird'

module.exports = class Module
  constructor: (@attributes) ->

  clone: (destinationDir) ->
    return new Promise( (resolve, reject) =>
      repoUrl = @attributes.repository_url
      repoDirectory = path.join(destinationDir, @attributes.name)

      git.clone(repoUrl, repoDirectory, (err, repo) =>
        return reject(err) if err?

        @repository = repo
        resolve(repo)
      )
    )

  @moduleConfigPath: path.join(__dirname, '..', 'config', 'modules.json')

  @findByName: (name) ->
    availableModules = JSON.parse(fs.readFileSync(@moduleConfigPath))
    moduleDefinition = _.findWhere(availableModules, name: name)

    if moduleDefinition?
      return new Module(moduleDefinition)
    else
      return null

  @all: ->
    moduleConfigPath = path.join(__dirname, '..', 'config', 'modules.json')
    availableModules = JSON.parse(fs.readFileSync(moduleConfigPath))

    return availableModules.map( (module) -> new Module(module) )
