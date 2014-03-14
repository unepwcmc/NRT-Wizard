inquirer = require('inquirer')

inquirer.prompt([{
  type: 'checkbox'
  name: 'required_modules'
  message: 'Select the modules required for the instance:'
  choices: ['Reporting', 'Indicatorator']
}], (answers) ->
  console.log answers
)
