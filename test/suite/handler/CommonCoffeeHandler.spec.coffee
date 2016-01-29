fs = require 'fs'

CommonCoffeeHandler = require '../../../src/handler/CommonCoffeeHandler'
HandlerError = require '../../../src/handler/error/HandlerError'

describe 'CommonCoffeeHandler', ->

    beforeEach ->
        @subject = new CommonCoffeeHandler()

        @filePath = "#{__dirname}/../../fixture/handler/coffee.coffee"
        @tmpPath = "#{__dirname}/../../fixture/tmp.js"

    it 'resolves to a compiled module wrapper for CoffeeScript files', ->
        expected = [
            'coffee'
            '''
                if (!module) { var module = {}; }

                var test;

                test = 'It works.';

                module.exports = function() {
                  return [test, Array.prototype.slice.call(arguments)];
                };

                module.exports;
            '''
        ]

        return @subject.handleFile @filePath
        .then (actual) ->
            assert.deepEqual actual, expected

    it 'produces code that will work as a CouchDB view function', ->
        return @subject.handleFile @filePath
        .then (actual) =>
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

    it 'resolves to null for non-CoffeeScript files', ->
        path = "#{__dirname}/../../fixture/handler/other.other"

        return @subject.handleFile path
        .then (actual) ->
            assert.isNull actual

    it 'handles invalid CoffeeScript data', ->
        path = "#{__dirname}/../../fixture/invalid/coffee.coffee"

        return @subject.handleFile path
        .catch (actual) ->
            assert.instanceOf actual, HandlerError

    it 'handles file system errors', ->
        path = "#{__dirname}/../../fixture/invalid/nonexistent.coffee"

        return @subject.handleFile path
        .catch (actual) ->
            assert.instanceOf actual, HandlerError

