CouchBuilder = require '../../src/CouchBuilder'

describe 'CouchBuilder', ->

    beforeEach ->
        @subject = new CouchBuilder()

    describe 'build', ->

        it 'does stuff', ->
            path = "#{__dirname}/../fixture/file-listing"
            expected =
                'directory-a':
                    'directory-a-a':
                        'file-a-a-a': 'a-a-a'
                        'file-a-a-b': 'a-a-b'
                    'directory-a-b':
                        'file-a-b-a': 'a-b-a'
                        'file-a-b-b': 'a-b-b'
                    'file-a-a': 'a-a'
                    'file-a-b': 'a-b'
                'directory-b':
                    'file-b-a': 'b-a'
                    'file-b-b': 'b-b'
                'file-a': 'a'
                'file-b': 'b'

            return @subject.build path
            .then (actual) ->
                assert.deepEqual actual, expected
