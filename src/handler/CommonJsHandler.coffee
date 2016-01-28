fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'
util = require 'util'

module.exports = class CommonJsHandler

    constructor: (@template) ->
        @template ?= '''
            function () {
                var module = {};

                (function () {

            %s
                })();

                return module.exports.apply(this, arguments);
            }
        '''

    handle: (filePath) -> new Promise (resolve, reject) =>
        if path.extname(filePath) isnt '.js'
            resolve null

            return

        fs.readFile filePath, (error, data) =>
            if error
                reject error

                return

            resolve [
                path.basename filePath, '.js'
                util.format @template, data.toString()
            ]

            return
