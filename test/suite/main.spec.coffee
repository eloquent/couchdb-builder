designer = require '../../src/main'

describe 'main', ->

    it 'exports hello', ->
        assert.strictEqual designer, 'hello'
