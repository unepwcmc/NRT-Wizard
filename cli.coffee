fs = require('fs')
_ = require('underscore')

isNotCoffeeScriptFilename = (fileName) ->
  tokens = fileName.split('.')
  return tokens[tokens.length-1] != 'coffee'

stripCoffeeExtension = (fileName) ->
  tokens = fileName.split(".coffee")
  return tokens[0]

commandFiles = _.reject(fs.readdirSync("#{__dirname}/commands/"), isNotCoffeeScriptFilename)
commandFiles = commandFiles.map(stripCoffeeExtension)

for commandFile in commandFiles
  exports[commandFile] = require("#{__dirname}/commands/#{commandFile}.coffee")[commandFile]
