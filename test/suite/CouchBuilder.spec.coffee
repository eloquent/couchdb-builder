CouchBuilder = require '../../src/CouchBuilder'

describe 'CouchBuilder', ->

    beforeEach ->
        @subject = new CouchBuilder()

    describe 'build', ->

        it 'does stuff', (done) ->
            path = "#{__dirname}/../fixture/file-listing"
            expected = [
                'directory-a/directory-a-a/file-a-a-a'
                'directory-a/directory-a-a/file-a-a-b'
                'directory-a/directory-a-b/file-a-b-a'
                'directory-a/directory-a-b/file-a-b-b'
                'directory-a/file-a-a'
                'directory-a/file-a-b'
                'directory-b/file-b-a'
                'directory-b/file-b-b'
                'file-a'
                'file-b'
            ]

            @subject.build path, (error, actual) ->
                assert.isNull error
                assert.deepEqual actual, expected
                done()
