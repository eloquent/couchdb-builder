CommonJsHandler = require '../../../src/handler/CommonJsHandler'

describe 'CommonJsHandler', ->

    beforeEach ->
        @subject = new CommonJsHandler()

    it 'resolves to a module wrapper for JavaScript files', ->
        path = "#{__dirname}/../../fixture/handler/js.js"
        expected = [
            'js'
            '''
                function () {
                var module = {};
                (function () {

                var test = 'It works.';
                module.exports = function () { return [test, arguments] };

                }).call(this);
                return module.exports.apply(this, arguments);
                }
            '''
        ]

        return @subject.handle path
        .then (actual) ->
            assert.deepEqual actual, expected

    it 'resolves to null for non-JavaScript files', ->
        path = "#{__dirname}/../../fixture/handler/other.other"

        return @subject.handle path
        .then (actual) ->
            assert.isNull actual

    it 'handles file system errors', ->
        path = "#{__dirname}/../../fixture/invalid/nonexistent.js"

        return @subject.handle path
        .catch (actual) ->
            assert.instanceOf actual, Error
