Promise = require 'bluebird'

module.exports = class CouchBuilder

    constructor: (@_readdirp = require 'readdirp') ->

    build: (path) -> new Promise (resolve, reject) =>
        closeError = null
        entries = []

        stream = @_readdirp root: path, entryType: 'files'

        stream.on 'data', (entry) -> entries.push entry
        stream.on 'warn', (error) ->
            closeError = error
            stream.destroy()
        stream.on 'error', (error) -> reject error
        stream.on 'end', =>
            @_processEntries entries
            .then (result) -> resolve result
        stream.on 'close', -> reject closeError

        return

    _processEntries: (entries) -> new Promise (resolve, reject) =>
        entries.sort (left, right) ->
            if left.path < right.path
                return -1
            else if left.path > right.path
                return 1

            return 0

        Promise.all(@_processEntry entry for entry in entries)
        .then (results) -> resolve results

        return

    _processEntry: (entry) -> new Promise (resolve, reject) ->
        resolve entry.path

        return
