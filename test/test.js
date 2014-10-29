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
      return test('getting data for user Tom', function() {
        var criteria, testRequestOptions;
        criteria = {
          username: 'tom'
        };
        testRequestOptions = corvidData.getRequestOptions(criteria);
        return expect(testRequestOptions.url).to.equal(urlBase + 'users/tom');
      });
    });
  });

}).call(this);
