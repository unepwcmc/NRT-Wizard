assert  = require('chai').assert
sinon   = require('sinon')
request = require('request')

GitHub = require('../../lib/git_hub.coffee')

suite('GitHub')

test('.releases returns the releases listed by the GitHub API', (done) ->
  nrtRepo = new GitHub('unepwcmc', 'NRT')

  releases = [{
    name: 'fancy-banana'
  },{
    name: 'posh-banana'
  }]

  expectedReleases = ['fancy-banana', 'posh-banana']

  expectedRequestArgs =
    url: "https://api.github.com/repos/unepwcmc/NRT/tags"
    headers:
      'User-Agent': 'NRT Wizard 2014 Home Premium Edition'

  requestStub = sinon.stub(request, 'get', (options, callback) ->
    callback(null, body: JSON.stringify(releases))
  )

  try
    nrtRepo.releases().then( (releases) ->
      assert.isTrue requestStub.calledOnce,
        "Expected request.get to be called"

      requestArgs = requestStub.getCall(0).args
      assert.deepEqual requestArgs[0], expectedRequestArgs

      assert.lengthOf releases, 2,
        "Expected 2 releases to be returned"

      assert.deepEqual releases, expectedReleases

      done()
    ).catch( (err) ->
      requestStub.restore()
      done(err)
    )
  catch err
    done(err)
    requestStub.restore()
)
