fs = require('fs')

exports.create = (instanceName) ->
  fs.mkdirSync(instanceName)
