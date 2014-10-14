assert = require("assert")
corvid = require("../lib/corvid")
suite "corvid", ->
  suite "browse", ->
    test "should throw an error when empty options", ->
      assert.throws (->
        corvid.browse()
      ), Error
