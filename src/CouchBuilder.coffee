Promise = require 'bluebird'

module.exports = class CouchBuilder

    constructor: (
        handlers = []
        @_readdirp = require 'readdirp'
        @_path = require 'path'
    ) ->
        @handlers = (Promise.method handler for handler in handlers)

    build: (path) -> new Promise (resolve, reject) =>
        closeError = null
        entries = []

        stream = @_readdirp root: path, entryType: 'files'

        stream.on 'data', (entry) ->
            entries.push entry

            return

        stream.on 'warn', (error) ->
            closeError = error
            stream.destroy()

            return

        stream.on 'error', (error) ->
            reject error

            return

        stream.on 'end', =>
            @_processEntries entries
            .then (result) ->
                resolve result

                return

            return

        stream.on 'close', ->
            reject closeError

            return

        return

    _processEntries: (entries) -> new Promise (resolve, reject) =>
        entries.sort (left, right) ->
            if left.path < right.path
                return -1
            else if left.path > right.path
                return 1

            return 0

        Promise.all(@_processPath entry.fullPath for entry in entries)
        .then (results) =>
            result = {}

            for entry, i in entries
                @_set result, entry.path.split(@_path.sep), results[i]

            resolve result

            return

        return

    _processPath: (path) -> new Promise (resolve, reject) =>
        promises = []

        Promise.all(handler path for handler in @handlers)
        .then (results) ->
            for result in results when result?
                resolve result

                return

            resolve null

            return

        return

    _set: (object, atoms, value) ->
        atomCount = atoms.length
        atom = atoms.shift()

        if atomCount is 1
            object[atom] = value
        else
            object[atom] ?= {}
            @_set object[atom], atoms, value

        return
