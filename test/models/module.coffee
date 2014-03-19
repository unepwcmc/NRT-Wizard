assert = require('chai').assert
sinon  = require('sinon')
git    = require('gift')
path   = require('path')

fs = require('fs')
Promise = require('bluebird')

Component = require('../../models/component')
GitHub = require('../../lib/git_hub')

suite('Component model')

test('#all returns all components available', ->
  expectedComponents = [{name: "Reporting"}]
  expectedComponentInstances = [new Component(expectedComponents[0])]

  readFileStub = sinon.stub(fs, 'readFileSync', -> JSON.stringify(expectedComponents))

  try
    assert.deepEqual Component.all(), expectedComponentInstances
  finally
    readFileStub.restore()
)

test('new Component() creates a new Component instance with the given attributes', ->
  attributes =
    name: 'Reporting'
    repository_url: 'http://github.com/the_codes'

  component = new Component(attributes)

  assert.strictEqual component.constructor.name, "Component",
    "Expected a Component class instance to be created"

  assert.property component.attributes, 'name',
    "Expected component instance to have property name"

  assert.strictEqual component.attributes.name, attributes.name,
    "Expected component instance to have name property
    '#{attributes.name}', but was '#{component.name}'"
)

test('#findByName returns the first component matching the given name', ->
  availableComponents = [{
    name: 'Reporting'
  }, {
    name: 'Indicatorator'
  }]

  readFileStub = sinon.stub(fs, 'readFileSync', -> JSON.stringify(availableComponents))

  try
    component = Component.findByName('Reporting')

    assert.strictEqual component.constructor.name, "Component",
      "Expected a Component class instance to be created"

    assert.property component.attributes, 'name',
      "Expected component instance to have property name"

    assert.strictEqual component.attributes.name, availableComponents[0].name,
      "Expected component instance to have name property
      '#{availableComponents[0].name}', but was '#{component.name}'"
  finally
    readFileStub.restore()
)

test(".clone clones the component's repository and resolves the promise", (done) ->
  repositoryUrl = 'git.com/code'
  destinationDir = '/destination'

  component = new Component(
    name: 'Reporting'
    repository_url: repositoryUrl
  )

  gitCloneStub = sinon.stub(git, 'clone', (remote, dest, callback) ->
    callback()
  )

  component.clone(destinationDir).then( (repo) ->
    gitCloneArgs = gitCloneStub.getCall(0).args

    assert.strictEqual gitCloneArgs[0], repositoryUrl,
      "Expected git.clone to be called with the repository url"
    assert.strictEqual gitCloneArgs[1], path.join(destinationDir, component.attributes.name),
      "Expected git.clone to be called with the destination directory"

    assert.strictEqual component.attributes.directory, '/destination/Reporting'

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

  expectedTags = [
    'tags/0.1'
    'tags/0.2'
    'master'
  ]

  component =
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
    Component::getReleases.call(component).then( (releases) ->
      assert.lengthOf releases, 3,
        'Expected two releases to be returned'

      assert.deepEqual releases, expectedTags,
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
  component =
    repository:
      checkout: checkoutSpy

  Component::checkoutRelease.call(component, refname).then( ->
    assert.isTrue checkoutSpy.calledOnce,
      "Expected repository.checkout to be called once"

    checkoutArgs = checkoutSpy.getCall(0).args
    assert.deepEqual checkoutArgs[0], refname

    done()
  ).catch(done)
)

test('.setup calls clone with the destination directory and checks out
 the release', (done) ->
  releaseName = 'fancy-pineapple'
  component =
    attributes:
      release: releaseName
    clone: sinon.spy( ->
      new Promise( (resolve) -> resolve() )
    )
    checkoutRelease: sinon.spy( ->
      new Promise( (resolve) -> resolve() )
    )

  Component::setup.call(component, './aDirectory').then( ->
    assert.strictEqual component.clone.callCount, 1,
      "Expected component.clone to be called once"

    assert.strictEqual component.checkoutRelease.callCount, 1,
      "Expected component.checkoutRelease to be called once"

    releaseArgs = component.checkoutRelease.getCall(0).args
    assert.strictEqual releaseArgs[0], releaseName,
      "Expected checkoutRelease to be called with #{releaseName}, but was
      #{releaseArgs[0]}"

    done()
  ).catch(done)
)
