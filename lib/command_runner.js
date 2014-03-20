var parse = require('shell-quote').parse;

printProcessMessages = function(theProcess) {
  theProcess.stdout.on('data', function (data) {
    console.log(data.toString());
  });

  theProcess.stderr.on('data', function (data) {
    console.log('ERROR: ' + data);
  });
};

usingWindows = function() {
  return new RegExp("^win").test(process.platform);
};

exports.spawn = function(command) {
  var parsedCommand = parse(command),
      processName = parsedCommand[0],
      args = parsedCommand.slice(1);

  var spawn = require('child_process').spawn;
  var childProcess;

  if (usingWindows()) {
    args = ["/c", processName].concat(args || []);
    processName = 'cmd';
  }

  childProcess = spawn(processName, args);
  printProcessMessages(childProcess);

  return childProcess;
};

