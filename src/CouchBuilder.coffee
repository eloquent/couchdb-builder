module.exports = class CouchBuilder

    constructor: (@_readdirp = require 'readdirp') ->

    build: (path, callback) ->
        stream = @_readdirp root: path, entryType: 'files'
        paths = []
        closeError = null

        stream.on 'data', (entry) -> paths.push entry.path
        stream.on 'warn', (error) ->
            closeError = error
            stream.destroy()
        stream.on 'error', (error) -> callback error
        stream.on 'end', ->
            paths.sort()
            callback null, paths
        stream.on 'close', -> callback closeError, null

        return
