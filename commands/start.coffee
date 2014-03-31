fs = require 'fs'
CommandRunner = require('../lib/command_runner')

exports.start = ->
  instanceDir = process.cwd()
  componentDirs = fs.readdirSync(instanceDir)

  componentDirs.forEach( (directory) ->
    process.chdir(directory)
    CommandRunner.spawn('npm start')
    process.chdir(instanceDir)
  )

  componentDirs
