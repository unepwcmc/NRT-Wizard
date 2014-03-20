_       = require 'underscore'
fs      = require 'fs'
git     = require 'gift'
path    = require 'path'
Promise = require 'bluebird'

GitHub = require '../lib/git_hub'

module.exports = class Component
  constructor: (@attributes) ->

  setup: (destinationDir) ->
    new Promise( (resolve, reject) =>
      @clone(destinationDir).then( =>
        @checkoutRelease(@attributes.release)
      ).then(resolve).catch(reject)
    )

  clone: (destinationDir) ->
    return new Promise( (resolve, reject) =>
      repoUrl = @attributes.repository_url
      repoDirectory = path.join(destinationDir, @attributes.name)
      @attributes.directory = repoDirectory

      git.clone(repoUrl, repoDirectory, (err, repo) =>
        return reject(err) if err?

        @repository = repo
        resolve(repo)
      )
    )

  checkoutRelease: (refname) ->
    new Promise( (resolve, reject) =>
      @repository.checkout(refname, (err) ->
        return reject(err) if err?
        resolve()
      )
    )

  getReleases: ->
    return new Promise( (resolve, reject) =>
      repo = new GitHub(
        @attributes.github.username,
        @attributes.github.repository_name
      )

      repo.releases().then( (releases) ->
        nonDeployTags = _.reject(releases, (release) ->
          /(.*)-[0-9a-f]{10}$/.test(release)
        )
        tags = nonDeployTags.map (tag) -> "tags/#{tag}"
        tags.push 'master'

        resolve(tags)
      ).catch(reject)
    )

  @componentConfigPath: path.join(__dirname, '..', 'config', 'components.json')

  @findByName: (name) ->
    availableComponents = JSON.parse(fs.readFileSync(@componentConfigPath))
    componentDefinition = _.findWhere(availableComponents, name: name)

    if componentDefinition?
      return new Component(componentDefinition)
    else
      return null

  @all: ->
    componentConfigPath = path.join(__dirname, '..', 'config', 'components.json')
    availableComponents = JSON.parse(fs.readFileSync(componentConfigPath))

    return availableComponents.map( (component) -> new Component(component) )
