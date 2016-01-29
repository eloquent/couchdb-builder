path = require 'path'
Promise = require 'bluebird'

module.exports = class CouchBuilder

    constructor: (@handlers = [], @_readdirp = require 'readdirp') ->

    build: (root) -> new Promise (resolve, reject) =>
        closeError = null
        entries = []

        stream = @_readdirp root: root, entryType: 'files'

        stream.on 'data', (entry) ->
            entries.push entry

            return

        stream.on 'end', =>
            @_processEntries entries
            .then (result) -> return resolve result
            .catch (error) -> return reject error

            return

        stream.on 'warn', (error) ->
            closeError = error
            stream.destroy()

            return

        stream.on 'close', -> return reject closeError
        stream.on 'error', (error) -> return reject error

        return

    _processEntries: (entries) -> new Promise (resolve, reject) =>
        entries.sort (left, right) ->
            return if left.path < right.path then -1 else 1

        Promise.all(@_processPath entry.fullPath for entry in entries)
        .then (results) =>
            result = {}

            for entry, i in entries
                if results[i]?
                    atoms = entry.path.split path.sep
                    atoms[atoms.length - 1] = results[i][0]

                    @_set result, atoms, results[i][1]

            return resolve result
        .catch (error) -> return reject error

        return

    _processPath: (filePath) -> new Promise (resolve, reject) =>
        promises = []

        Promise.all(handler.handleFile filePath for handler in @handlers)
        .then (results) ->
            return resolve result for result in results when result?
            return resolve null
        .catch (error) -> return reject error

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
