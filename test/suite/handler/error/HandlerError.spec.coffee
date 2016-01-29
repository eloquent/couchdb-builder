HandlerError = require '../../../../src/handler/error/HandlerError'

describe 'HandlerError', ->

    beforeEach ->
        @cause = new Error 'Message.'
        @subject = new HandlerError 'HandlerName', '/path/to/file', @cause

    it 'stores the supplied error details', ->
        assert.strictEqual @subject.message, "HandlerName could not process '/path/to/file'."
        assert.strictEqual @subject.toString(),
            "HandlerName could not process '/path/to/file'. Caused by:\n\nError: Message."
        assert.strictEqual @subject.handlerName, 'HandlerName'
        assert.strictEqual @subject.filename, '/path/to/file'
        assert.strictEqual @subject.cause, @cause
