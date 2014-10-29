assert = require('assert')
expect = require('chai').expect
corvid = require('../lib/corvid')
corvidData = require '../lib/data'
suite 'corvid', ->
  suite 'process', ->
    test 'should throw an error when empty options', ->
      assert.throws (->
        corvid.browse()
      ), Error
  suite 'url generation', ->
    urlBase = 'https://api.github.com/'
    test 'searching for users named Tom with over 1000 followers', ->
      criteria =
        username: 'tom'
        followers: '50'
      testRequestOptions = corvidData.getRequestOptions criteria
      expect(testRequestOptions.url).to.equal urlBase + 'search/users?&q=tom+followers:%3E50&per_page=100'
    test 'getting data for user Tom', ->
      criteria =
        username: 'tom'
      testRequestOptions = corvidData.getRequestOptions criteria
      expect(testRequestOptions.url).to.equal urlBase + 'users/tom'
