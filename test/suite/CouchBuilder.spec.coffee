fs = require 'fs'
path = require 'path'

CouchBuilder = require '../../src/CouchBuilder'

describe 'CouchBuilder', ->

    beforeEach ->
        @handlers = [
            (filePath) -> new Promise (resolve, reject) ->
                return resolve null unless path.basename(filePath).match /^file-a/

                fs.readFile filePath, (error, data) ->
                    return reject error if error

                    resolve [path.basename(filePath), "(handler a) #{data.toString()}"]

            (filePath) -> new Promise (resolve, reject) ->
                return resolve null unless path.basename(filePath).match /^file-b/

                fs.readFile filePath, (error, data) ->
                    return reject error if error

                    resolve [path.basename(filePath), "(handler b) #{data.toString()}"]
        ]
        @subject = new CouchBuilder @handlers

    it 'builds a result using the correct handlers', ->
        filePath = "#{__dirname}/../fixture/tree"
        expected =
            'directory-a':
                'directory-a-a':
                    'file-a-a-a': '(handler a) a-a-a\n'
                    'file-a-a-b': '(handler a) a-a-b\n'
                'directory-a-b':
                    'file-a-b-a': '(handler a) a-b-a\n'
                    'file-a-b-b': '(handler a) a-b-b\n'
                'file-a-a': '(handler a) a-a\n'
                'file-a-b': '(handler a) a-b\n'
            'directory-b':
                'file-b-a': '(handler b) b-a\n'
                'file-b-b': '(handler b) b-b\n'
            'file-a': '(handler a) a\n'
            'file-b': '(handler b) b\n'

        return @subject.build filePath
        .then (actual) ->
            assert.deepEqual actual, expected
