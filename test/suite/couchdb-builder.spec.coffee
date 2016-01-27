designer = require '../../src/couchdb-builder'

describe 'main', ->

    it 'exports hello', ->
        assert.strictEqual designer, 'hello'
