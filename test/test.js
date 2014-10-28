(function() {
  var assert, corvid, expect;

  assert = require('assert');

  expect = require('chai').expect;

  corvid = require('../lib/corvid');

  suite('corvid', function() {
    return suite('process', function() {
      return test('should throw an error when empty options', function() {
        return assert.throws((function() {
          return corvid.browse();
        }), Error);
      });
    });
  });

}).call(this);
