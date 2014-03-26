fs = require 'fs'
path = require 'path'

MessageServer = require('../lib/message_server')

Promise = require('bluebird')
child_process = Promise.promisifyAll(require('child_process'))

getPackageJSONScript = (scriptName) ->
  packageJSONPath = path.join(process.cwd(), 'package.json')
  packageJSON = JSON.parse(fs.readFileSync(packageJSONPath))

  return packageJSON.scripts?[scriptName]

exports.configure = ->
  configureCommand = getPackageJSONScript('configure')
  unless configureCommand?
    throw new Error("package.json has no `configure` script")

  child_process.execAsync("redis-server &").then( (stdout, stderr) ->
    messageServer = new MessageServer()
    messageServer.on('question', (question) ->
      # pass question to adapter
      # adapter.ask('').then( publish answer )
    )
  )

exports.configure()
