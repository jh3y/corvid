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
    test 'finding users that live in "Milton Keynes" and write "CSS"', ->
      criteria =
        username: true
        location: 'Milton Keynes'
        language: 'CSS'
      testRequestOptions = corvidData.getRequestOptions criteria
      expect(testRequestOptions.url).to.equal urlBase + 'search/users?&q=location:Milton%2BKeynes+language:CSS&per_page=100'
    test 'finding users in the UK and limit to 5 users', ->
      criteria =
        username: true
        location: 'UK'
        limit: '5'
      testRequestOptions = corvidData.getRequestOptions criteria
      expect(testRequestOptions.url).to.equal urlBase + 'search/users?&q=location:UK&per_page=5'
    test 'finding repos for user twbs(twitter bootstrap)', ->
      criteria =
        username: 'twbs'
        repos: true
        limit: '5'
        sort: 'stars'
      testRequestOptions = corvidData.getRequestOptions criteria
      expect(testRequestOptions.url).to.equal urlBase + 'search/repositories?&q=user:twbs&sort=stars&per_page=5'
    test 'return repo "corvid" for "jh3y"', ->
      criteria =
        username: 'jh3y'
        repos: 'corvid'
      testRequestOptions = corvidData.getRequestOptions criteria
      expect(testRequestOptions.url).to.equal urlBase + 'search/repositories?&q=corvid+user:jh3y&per_page=100'
