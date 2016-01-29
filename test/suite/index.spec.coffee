couchBuilder = require '../../src/index'

describe 'Module', ->

    beforeEach ->
        @filePath = "#{__dirname}/../fixture/handler"

    it 'builds a result using the correct handlers', ->
        expectedCoffee = '''
            (function () {
            if (!module) { module = {}; }

            var test;

            test = 'It works.';

            module.exports = function() {
              return [test, Array.prototype.slice.call(arguments)];
            };

            return module.exports;
            }).call(this);
        '''
        expectedJs = '''
            (function () {
            if (!module) { module = {}; }

            var test = 'It works.';
            module.exports = function () { return [test, Array.prototype.slice.call(arguments)] };

            return module.exports;
            }).call(this);
        '''
        expected =
            'coffee': expectedCoffee
            'js': expectedJs
            'json': a: 1, b: 2
            'nested':
                'coffee': expectedCoffee
                'js': expectedJs
                'json': a: 1, b: 2
                'no-extension': 'no extension'
                'txt': 'text'
            'no-extension': 'no extension'
            'txt': 'text'

        return couchBuilder.build @filePath
        .then (actual) ->
            assert.deepEqual actual, expected
