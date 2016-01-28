TextHandler = require '../../../src/handler/TextHandler'

describe 'TextHandler', ->

    beforeEach ->
        @subject = new TextHandler()

    it 'resolves to the data for files without an extension', ->
        path = "#{__dirname}/../../fixture/valid/no-extension"
        expected = ['no-extension', 'no extension']

        return @subject.handle path
        .then (actual) ->
            assert.deepEqual actual, expected

    it 'resolves to the data for text files', ->
        path = "#{__dirname}/../../fixture/valid/txt.txt"
        expected = ['txt', 'text']

        return @subject.handle path
        .then (actual) ->
            assert.deepEqual actual, expected

    it 'resolves to null for non-text files', ->
        path = "#{__dirname}/../../fixture/valid/other.other"

        return @subject.handle path
        .then (actual) ->
            assert.isNull actual

    it 'handles file system errors', ->
        path = "#{__dirname}/../../fixture/invalid/nonexistent"

        return @subject.handle path
        .catch (actual) ->
            assert.instanceOf actual, Error
