module.exports = class HandlerError extends Error

    constructor: (@handlerName, @filename, @cause) ->
        @message = "#{@handlerName} could not process '#{@filename}'."

    toString: ->
        string = @message
        string += " Caused by:\n\n#{@cause.toString()}" if @cause

        return string
