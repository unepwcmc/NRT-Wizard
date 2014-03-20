path = require('path')
Promise = require('bluebird')
fs = Promise.promisifyAll(require('fs'))
CommandRunner = require('./command_runner')

usingWindows = ->
  return new RegExp("^win").test(process.platform)

usingOSX = ->
  return new RegExp('darwin').test(process.platform)

normalisedOS = ->
  if usingWindows()
    return 'win'
  else if usingOSX()
    return 'osx'
  else
    return 'unix'

getSetupFromConfig = (config) ->
  setupKey = normalisedOS()
  return config.setup?[setupKey]

configSupportsOS = (config) ->
  return getSetupFromConfig(config)?

exports.install = (component) ->
  new Promise( (resolve, reject) ->
    pkgPath = path.join(component.attributes.directory, 'package.json')

    unless fs.existsSync(pkgPath)
      return reject(new Error(
        "#{component.attributes.name} does not have a package.json in its root directory"
      ))

    fs.readFileAsync(pkgPath).then( (body) ->
      pkg = JSON.parse(body)

      unless configSupportsOS(pkg)
        return reject(
          "#{component.attributes.name} does not define a 'setup' command in the package.json"
        )

      currentDir = process.cwd()
      process.chdir(component.attributes.directory)

      setupCommand = getSetupFromConfig(pkg)
      setupProcess = CommandRunner.spawn(setupCommand)

      setupProcess.on('close', (code) ->
        if code > 0
          return reject(new Error(
            "Installing #{component.attributes.name} failed with error code #{code}"
          ))

        process.chdir(currentDir)
        resolve()
      )
    )
  )
