fs = require 'fs'

CommonJsHandler = require '../../../src/handler/CommonJsHandler'
HandlerError = require '../../../src/handler/error/HandlerError'

describe 'CommonJsHandler', ->

    beforeEach ->
        @subject = new CommonJsHandler()

        @filePath = "#{__dirname}/../../fixture/handler/js.js"
        @tmpPath = "#{__dirname}/../../fixture/tmp.js"

    it 'resolves to a module wrapper for JavaScript files', ->
        expected = [
            'js'
            '''
                if (!module) { var module = {}; }

                var test = 'It works.';
                module.exports = function () { return [test, Array.prototype.slice.call(arguments)] };

                module.exports;
            '''
        ]

        return @subject.handleFile @filePath
        .then (actual) ->
            assert.deepEqual actual, expected

    it 'produces code that will work as a CouchDB view function', ->
        return @subject.handleFile @filePath
        .then (actual) ->
            actual = eval actual[1]

            assert.isFunction actual
            assert.deepEqual actual('a', 'b'), ['It works.', ['a', 'b']]

    it 'produces code that will work as a CommonJS module', ->
        return @subject.handleFile @filePath
        .then (actual) =>
            fs.writeFileSync @tmpPath, actual[1]
            actual = require @tmpPath

            assert.isFunction actual
            assert.deepEqual actual('a', 'b'), ['It works.', ['a', 'b']]

    it 'resolves to null for non-JavaScript files', ->
        path = "#{__dirname}/../../fixture/handler/other.other"

        return @subject.handleFile path
        .then (actual) ->
            assert.isNull actual

    it 'handles file system errors', ->
        path = "#{__dirname}/../../fixture/invalid/nonexistent.js"

        return @subject.handleFile path
        .catch (actual) ->
            assert.instanceOf actual, HandlerError
