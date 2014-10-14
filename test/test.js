(function() {
  var assert, corvid;

  assert = require("assert");

  corvid = require("../lib/corvid");

  suite("corvid", function() {
    return suite("browse", function() {
      return test("should throw an error when empty options", function() {
        return assert.throws((function() {
          return corvid.browse();
        }), Error);
      });
    });
  });

}).call(this);
