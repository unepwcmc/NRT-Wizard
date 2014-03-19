path = require('path')
Promise = require('bluebird')
fs = Promise.promisifyAll(require('fs'))

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

configSupportsOS = (config) ->
  setupKey = normalisedOS()
  return config.setup?[setupKey]?

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

      resolve()
    )
  )
