#!/usr/bin/env coffee

commands = require('../cli')

# shift off node and script name
args = process.argv[2..]

command = args.shift()

# Default to help command if unrecognised
unless commands[command]?
  console.log('unrecognised command: ' + command)
  process.exit(1)

# Node args aren't a proper array, so...
argsArray = []
for index, arg of args
  argsArray.push arg

commands[command].apply(this, argsArray)
