assert = require('chai').assert
sinon  = require('sinon')
git    = require('gift')
path   = require('path')

fs = require('fs')
Promise = require('bluebird')

Module = require('../../models/module')
GitHub = require('../../lib/git_hub')

suite('Module model')

test('#all returns all modules available', ->
  expectedModules = [{name: "Reporting"}]
  expectedModuleInstances = [new Module(expectedModules[0])]

  readFileStub = sinon.stub(fs, 'readFileSync', -> JSON.stringify(expectedModules))

  try
    assert.deepEqual Module.all(), expectedModuleInstances
  finally
    readFileStub.restore()
)

test('new Module() creates a new Module instance with the given attributes', ->
  attributes =
    name: 'Reporting'
    repository_url: 'http://github.com/the_codes'

  module = new Module(attributes)

  assert.strictEqual module.constructor.name, "Module",
    "Expected a Module class instance to be created"

  assert.property module.attributes, 'name',
    "Expected module instance to have property name"

  assert.strictEqual module.attributes.name, attributes.name,
    "Expected module instance to have name property
    '#{attributes.name}', but was '#{module.name}'"
)

test('#findByName returns the first module matching the given name', ->
  availableModules = [{
    name: 'Reporting'
  }, {
    name: 'Indicatorator'
  }]

  readFileStub = sinon.stub(fs, 'readFileSync', -> JSON.stringify(availableModules))

  try
    module = Module.findByName('Reporting')

    assert.strictEqual module.constructor.name, "Module",
      "Expected a Module class instance to be created"

    assert.property module.attributes, 'name',
      "Expected module instance to have property name"

    assert.strictEqual module.attributes.name, availableModules[0].name,
      "Expected module instance to have name property
      '#{availableModules[0].name}', but was '#{module.name}'"
  finally
    readFileStub.restore()
)

test(".clone clones the module's repository and resolves the promise", (done) ->
  repositoryUrl = 'git.com/code'
  destinationDir = '/destination'

  module = new Module(
    name: 'Reporting'
    repository_url: repositoryUrl
  )

  gitCloneStub = sinon.stub(git, 'clone', (remote, dest, callback) ->
    console.log '#### Calling git clone'
    callback()
  )

  module.clone(destinationDir).then( (repo) ->
    gitCloneArgs = gitCloneStub.getCall(0).args

    assert.strictEqual gitCloneArgs[0], repositoryUrl,
      "Expected git.clone to be called with the repository url"
    assert.strictEqual gitCloneArgs[1], path.join(destinationDir, module.attributes.name),
      "Expected git.clone to be called with the destination directory"

    done()
  ).catch( (err) ->
    gitCloneStub.restore()
    done(err)
  )
)

test('.getReleases returns a list of non-deploy releases available', (done) ->
  tags = [
    '0.1'
    '0.2'
    'fancy-banana-actual-change-97d374758b'
  ]

  module =
    attributes:
      github:
        username: 'itsme'
        repository_name: 'nrt'

  gitHubStub = sinon.stub(GitHub::, 'releases', ->
    new Promise( (resolve, reject) ->
      resolve(tags)
    )
  )

  try
    Module::getReleases.call(module).then( (releases) ->
      assert.lengthOf releases, 2,
        'Expected two releases to be returned'

      assert.deepEqual releases, tags[0..1],
        "Expected only non-deploy releases to be returned"

      done()
    ).catch( (err) ->
      gitHubStub.restore()
      done(err)
    )
  catch err
    gitHubStub.restore()
    done(err)
)

test('.checkoutRelease checks out the given git refname', (done) ->
  refname = 'tags/a-release'

  checkoutSpy = sinon.spy( (tagName, callback) -> callback())
  module =
    repository:
      checkout: checkoutSpy

  Module::checkoutRelease.call(module, refname).then( ->
    assert.isTrue checkoutSpy.calledOnce,
      "Expected repository.checkout to be called once"

    checkoutArgs = checkoutSpy.getCall(0).args
    assert.deepEqual checkoutArgs[0], refname

    done()
  ).catch(done)
)
