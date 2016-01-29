HandlerError = require '../../../../src/handler/error/HandlerError'

describe 'HandlerError', ->

    it 'stores the supplied error details', ->
        @cause = new Error 'Message.'
        @subject = new HandlerError 'HandlerName', '/path/to/file', @cause

        assert.strictEqual @subject.message, "HandlerName could not process '/path/to/file'."
        assert.strictEqual @subject.toString(),
            "HandlerName could not process '/path/to/file'. Caused by:\n\nError: Message."
        assert.strictEqual @subject.handlerName, 'HandlerName'
        assert.strictEqual @subject.filename, '/path/to/file'
        assert.strictEqual @subject.cause, @cause

    it 'handles errors with no cause', ->
        @subject = new HandlerError 'HandlerName', '/path/to/file'

        assert.strictEqual @subject.message, "HandlerName could not process '/path/to/file'."
        assert.strictEqual @subject.toString(), "HandlerName could not process '/path/to/file'."
        assert.strictEqual @subject.handlerName, 'HandlerName'
        assert.strictEqual @subject.filename, '/path/to/file'
        assert.isUndefined @subject.cause
