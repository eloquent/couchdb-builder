fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'
util = require 'util'

HandlerError = require './error/HandlerError'

module.exports = class CommonJsHandler

    constructor: (@template) ->
        @template ?= '''
            (function () {
            if (!module) { var module = {}; }

            %s
            return module.exports;
            }).call(this);
        '''

    handleFile: (filePath) => new Promise (resolve, reject) =>
        return resolve null if path.extname(filePath) isnt '.js'

        fs.readFile filePath, (error, data) =>
            if error
                error = new HandlerError 'CommonJsHandler', filePath, error

                return reject error

            resolve [
                path.basename filePath, '.js'
                util.format @template, data.toString()
            ]

            return
