HandlerError = require '../../../src/handler/error/HandlerError'
JsonHandler = require '../../../src/handler/JsonHandler'

describe 'JsonHandler', ->

    beforeEach ->
        @subject = new JsonHandler()

    it 'resolves to the parsed JSON data for JSON files', ->
        path = "#{__dirname}/../../fixture/handler/json.json"
        expected = ['json', {a: 1, b: 2}]

        return @subject.handleFile path
        .then (actual) ->
            assert.deepEqual actual, expected

    it 'resolves to null for non-JSON files', ->
        path = "#{__dirname}/../../fixture/handler/other.other"

        return @subject.handleFile path
        .then (actual) ->
            assert.isNull actual

    it 'handles invalid JSON data', ->
        path = "#{__dirname}/../../fixture/invalid/json.json"

        return @subject.handleFile path
        .catch (actual) ->
            assert.instanceOf actual, HandlerError

    it 'handles file system errors', ->
        path = "#{__dirname}/../../fixture/invalid/nonexistent.json"

        return @subject.handleFile path
        .catch (actual) ->
            assert.instanceOf actual, HandlerError
