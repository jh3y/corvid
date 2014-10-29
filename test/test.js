(function() {
  var assert, corvid, corvidData, expect;

  assert = require('assert');

  expect = require('chai').expect;

  corvid = require('../lib/corvid');

  corvidData = require('../lib/data');

  suite('corvid', function() {
    suite('process', function() {
      return test('should throw an error when empty options', function() {
        return assert.throws((function() {
          return corvid.browse();
        }), Error);
      });
    });
    return suite('url generation', function() {
      var urlBase;
      urlBase = 'https://api.github.com/';
      test('searching for users named Tom with over 1000 followers', function() {
        var criteria, testRequestOptions;
        criteria = {
          username: 'tom',
          followers: '50'
        };
        testRequestOptions = corvidData.getRequestOptions(criteria);
        return expect(testRequestOptions.url).to.equal(urlBase + 'search/users?&q=tom+followers:%3E50&per_page=100');
      });
      test('getting data for user Tom', function() {
        var criteria, testRequestOptions;
        criteria = {
          username: 'tom'
        };
        testRequestOptions = corvidData.getRequestOptions(criteria);
        return expect(testRequestOptions.url).to.equal(urlBase + 'users/tom');
      });
      test('finding users that live in "Milton Keynes" and write "CSS"', function() {
        var criteria, testRequestOptions;
        criteria = {
          username: true,
          location: 'Milton Keynes',
          language: 'CSS'
        };
        testRequestOptions = corvidData.getRequestOptions(criteria);
        return expect(testRequestOptions.url).to.equal(urlBase + 'search/users?&q=location:Milton%2BKeynes+language:CSS&per_page=100');
      });
      test('finding users in the UK and limit to 5 users', function() {
        var criteria, testRequestOptions;
        criteria = {
          username: true,
          location: 'UK',
          limit: '5'
        };
        testRequestOptions = corvidData.getRequestOptions(criteria);
        return expect(testRequestOptions.url).to.equal(urlBase + 'search/users?&q=location:UK&per_page=5');
      });
      test('finding repos for user twbs(twitter bootstrap)', function() {
        var criteria, testRequestOptions;
        criteria = {
          username: 'twbs',
          repos: true,
          limit: '5',
          sort: 'stars'
        };
        testRequestOptions = corvidData.getRequestOptions(criteria);
        return expect(testRequestOptions.url).to.equal(urlBase + 'search/repositories?&q=user:twbs&sort=stars&per_page=5');
      });
      return test('return repo "corvid" for "jh3y"', function() {
        var criteria, testRequestOptions;
        criteria = {
          username: 'jh3y',
          repos: 'corvid'
        };
        testRequestOptions = corvidData.getRequestOptions(criteria);
        return expect(testRequestOptions.url).to.equal(urlBase + 'search/repositories?&q=corvid+user:jh3y&per_page=100');
      });
    });
  });

}).call(this);
