fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'

CouchBuilder = require '../../src/CouchBuilder'

describe 'CouchBuilder', ->

    beforeEach ->
        @handlerA = handleFile: (filePath) -> new Promise (resolve, reject) ->
            return resolve null unless path.basename(filePath).match /^file-a/

            fs.readFile filePath, (error, data) ->
                return reject error if error

                resolve [path.basename(filePath), "(handler a) #{data.toString()}"]

        @handlerB = handleFile: (filePath) -> new Promise (resolve, reject) ->
            return resolve null unless path.basename(filePath).match /^file-b/

            fs.readFile filePath, (error, data) ->
                return reject error if error

                resolve [path.basename(filePath), "(handler b) #{data.toString()}"]

        @filePath = "#{__dirname}/../fixture/tree"

    describe 'under normal conditions', ->

        beforeEach ->
            @subject = new CouchBuilder [@handlerA, @handlerB]

        it 'builds a result using the correct handlers', ->
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

            return @subject.build @filePath
            .then (actual) ->
                assert.deepEqual actual, expected

    describe 'under handler error conditions', ->

        beforeEach ->
            @error = 'error'
            @handlerX = handleFile: (filePath) => new Promise (resolve, reject) =>
                return reject @error
            @subject = new CouchBuilder [@handlerA, @handlerX]

        it 'handles the handler error', ->
            return @subject.build @filePath
            .catch (actual) =>
                assert.deepEqual actual, @error

    describe 'under file tree traversal error conditions', ->

        beforeEach ->
            @streamHandlers = {}
            @stream =
                on: (event, handler) => @streamHandlers[event] = handler
                destroy: => @streamHandlers.close()
            @readdirp = sinon.stub()
            @readdirp.returns @stream

            @subject = new CouchBuilder [], @readdirp

        it 'handles warnings', ->
            expected = 'warning'
            promise = @subject.build 'filePath'
            .catch (actual) ->
                assert.strictEqual actual, expected

            @streamHandlers.warn expected

            return promise

        it 'handles errors', ->
            expected = 'error'
            promise = @subject.build 'filePath'
            .catch (actual) ->
                assert.strictEqual actual, expected

            @streamHandlers.error expected

            return promise
