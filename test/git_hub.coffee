assert  = require('chai').assert
sinon   = require('sinon')
request = require('request')

GitHub = require('../lib/git_hub.coffee')

suite('GitHub')

test('.releases returns the releases listed by the GitHub API', (done) ->
  nrtRepo = new GitHub('unepwcmc', 'NRT')

  releases = [{
    name: 'fancy-banana'
  },{
    name: 'posh-banana'
  }]

  expectedReleases = ['fancy-banana', 'posh-banana']

  requestStub = sinon.stub(request, 'get', (options, callback) ->
    callback(null, body: JSON.stringify(releases))
  )

  try
    nrtRepo.releases().then( (releases) ->
      assert.isTrue requestStub.calledOnce,
        "Expected request.get to be called"

      assert.lengthOf releases, 2,
        "Expected 2 releases to be returned"

      assert.deepEqual releases, expectedReleases

      done()
    )
  finally
    requestStub.restore()
)
