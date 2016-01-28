CouchBuilder = require '../../src/CouchBuilder'

describe 'CouchBuilder', ->

    beforeEach ->
        @subject = new CouchBuilder()

    describe 'build', ->

        it 'does stuff', ->
            path = "#{__dirname}/../fixture/file-listing"
            expected =
                'directory-a/directory-a-a/file-a-a-a': 'directory-a/directory-a-a/file-a-a-a'
                'directory-a/directory-a-a/file-a-a-b': 'directory-a/directory-a-a/file-a-a-b'
                'directory-a/directory-a-b/file-a-b-a': 'directory-a/directory-a-b/file-a-b-a'
                'directory-a/directory-a-b/file-a-b-b': 'directory-a/directory-a-b/file-a-b-b'
                'directory-a/file-a-a': 'directory-a/file-a-a'
                'directory-a/file-a-b': 'directory-a/file-a-b'
                'directory-b/file-b-a': 'directory-b/file-b-a'
                'directory-b/file-b-b': 'directory-b/file-b-b'
                'file-a': 'file-a'
                'file-b': 'file-b'

            return @subject.build path
            .then (actual) ->
                assert.deepEqual actual, expected
