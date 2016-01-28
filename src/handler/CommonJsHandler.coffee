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
            }).call(this);
            return module.exports.apply(this, arguments);
            }
        '''

    handle: (filePath) -> new Promise (resolve, reject) =>
        return resolve null if path.extname(filePath) isnt '.js'

        fs.readFile filePath, (error, data) =>
            return reject error if error

            resolve [
                path.basename filePath, '.js'
                util.format @template, data.toString()
            ]

            return
