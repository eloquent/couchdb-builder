fs = require 'fs'

CommonJsHandler = require '../../../src/handler/CommonJsHandler'
HandlerError = require '../../../src/handler/error/HandlerError'

describe 'CommonJsHandler', ->

    beforeEach ->
        @subject = new CommonJsHandler()

        @filePath = "#{__dirname}/../../fixture/handler/js.js"
        @tmpPath = "#{__dirname}/../../fixture/tmp"

    it 'resolves to a module wrapper for JavaScript files', ->
        expected = [
            'js'
            '''
                function () {
                var module = {};
                (function () {

                var test = 'It works.';
                module.exports = function () { return [test, Array.prototype.slice.call(arguments)] };

                }).call(this);
                return module.exports.apply(this, arguments);
                }
            '''
        ]

        return @subject.handleFile @filePath
        .then (actual) ->
            assert.deepEqual actual, expected

    it 'produces code that will work with CouchDB', ->
        return @subject.handleFile @filePath
        .then (actual) =>
            fs.writeFileSync @tmpPath, "module.exports = #{actual[1]};"
            actual = (require @tmpPath) 'a', 'b'

            assert.deepEqual actual, ['It works.', ['a', 'b']]

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
