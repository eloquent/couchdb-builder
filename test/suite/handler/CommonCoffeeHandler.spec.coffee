CommonCoffeeHandler = require '../../../src/handler/CommonCoffeeHandler'

describe 'CommonCoffeeHandler', ->

    beforeEach ->
        @subject = new CommonCoffeeHandler()

    describe 'handle', ->

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
            path = "#{__dirname}/../../fixture/valid/file"

            return @subject.handle path
            .then (actual) ->
                assert.isNull actual

        it 'handles file system errors', ->
            path = "#{__dirname}/../../fixture/invalid/nonexistent.js"

            return @subject.handle path
            .catch (actual) ->
                assert.instanceOf actual, Error
