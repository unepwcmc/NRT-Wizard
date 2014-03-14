fs = require 'fs'

exports.all = ->
  JSON.parse(fs.readFileSync('../config/modules.json'))
