CommonCoffeeHandler = require '../../../src/handler/CommonCoffeeHandler'

describe 'CommonCoffeeHandler', ->

    beforeEach ->
        @subject = new CommonCoffeeHandler()

    it 'resolves to a compiled module wrapper for CoffeeScript files', ->
        path = "#{__dirname}/../../fixture/valid/coffee.coffee"
        expected = [
            'coffee'
            '''
                function () {
                var module = {};

                (function() {
                  var test;

                  test = 'It works.';

                  module.exports = function() {
                    return [test, arguments];
                  };

                }).call(this);

                return module.exports.apply(this, arguments);
                }
            '''
        ]

        return @subject.handle path
        .then (actual) ->
            assert.deepEqual actual, expected

    it 'resolves to null for non-CoffeeScript files', ->
        path = "#{__dirname}/../../fixture/valid/other.other"

        return @subject.handle path
        .then (actual) ->
            assert.isNull actual

    it 'handles invalid CoffeeScript data', ->
        path = "#{__dirname}/../../fixture/invalid/coffee.coffee"

        return @subject.handle path
        .catch (actual) ->
            assert.instanceOf actual, SyntaxError

    it 'handles file system errors', ->
        path = "#{__dirname}/../../fixture/invalid/nonexistent.js"

        return @subject.handle path
        .catch (actual) ->
            assert.instanceOf actual, Error
