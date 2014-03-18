request = require 'request'
Promise = require 'bluebird'

module.exports = class GitHub
  constructor: (@username, @repo) ->

  releases: ->
    apiUrl = "https://api.github.com/repos/#{@username}/#{@repo}/tags"
    new Promise( (resolve, reject) ->
      request.get(
        url: apiUrl
      , (err, res) ->
        return reject(err) if err?

        body = JSON.parse(res.body)
        modules = body.map( (module) -> module.name )

        resolve(modules)
      )
    )
