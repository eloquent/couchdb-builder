fs = require 'fs'
path = require 'path'

CouchBuilder = require '../../src/CouchBuilder'

describe 'CouchBuilder', ->

    beforeEach ->
        @handlers = [
            (filePath) -> new Promise (resolve, reject) ->
                fs.readFile filePath, (error, data) ->
                    return reject error if error

                    resolve [path.basename(filePath), data]
        ]
        @subject = new CouchBuilder @handlers

    describe 'build', ->

        it 'does stuff', ->
            filePath = "#{__dirname}/../fixture/valid"
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
                'file': ''
                'json.json': '{"a":1,"b":2}\n'
                'js.js': "var test = 'It works.';\nmodule.exports = function () { return [test, arguments] };\n"

            return @subject.build filePath
            .then (actual) ->
                assert.deepEqual actual, expected
