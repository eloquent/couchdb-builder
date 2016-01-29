CommonCoffeeHandler = require '../../../src/handler/CommonCoffeeHandler'
HandlerError = require '../../../src/handler/error/HandlerError'

describe 'CommonCoffeeHandler', ->

    beforeEach ->
        @subject = new CommonCoffeeHandler()

        @filePath = "#{__dirname}/../../fixture/handler/coffee.coffee"
        @tmpPath = "#{__dirname}/../../fixture/tmp"

    it 'resolves to a compiled module wrapper for CoffeeScript files', ->
        expected = [
            'coffee'
            '''
                (function () {

                var test;

                test = 'It works.';

                module.exports = function() {
                  return [test, Array.prototype.slice.call(arguments)];
                };

                return module.exports;
                }).call(this);
            '''
        ]

        return @subject.handleFile @filePath
        .then (actual) ->
            assert.deepEqual actual, expected

    it 'produces code that will work with CouchDB', ->
        return @subject.handleFile @filePath
        .then (actual) =>
            actual = (eval actual[1])('a', 'b');

            assert.deepEqual actual, ['It works.', ['a', 'b']]

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

