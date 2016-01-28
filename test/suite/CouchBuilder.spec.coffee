fs = require 'fs'

CouchBuilder = require '../../src/CouchBuilder'

describe 'CouchBuilder', ->

    beforeEach ->
        @handlers = [
            (path) -> new Promise (resolve, reject) ->
                fs.readFile path, (error, data) ->
                    return reject error if error

                    resolve data.toString()
        ]
        @subject = new CouchBuilder @handlers

    describe 'build', ->

        it 'does stuff', ->
            path = "#{__dirname}/../fixture/file-listing"
            expected =
                'directory-a':
                    'directory-a-a':
                        'file-a-a-a': "a-a-a\n"
                        'file-a-a-b': "a-a-b\n"
                    'directory-a-b':
                        'file-a-b-a': "a-b-a\n"
                        'file-a-b-b': "a-b-b\n"
                    'file-a-a': "a-a\n"
                    'file-a-b': "a-b\n"
                'directory-b':
                    'file-b-a': "b-a\n"
                    'file-b-b': "b-b\n"
                'file-a': "a\n"
                'file-b': "b\n"

            return @subject.build path
            .then (actual) ->
                assert.deepEqual actual, expected
