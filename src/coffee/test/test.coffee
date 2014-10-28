assert = require('assert')
expect = require('chai').expect
corvid = require('../lib/corvid')
suite 'corvid', ->
  suite 'process', ->
    test 'should throw an error when empty options', ->
      assert.throws (->
        corvid.browse()
      ), Error
