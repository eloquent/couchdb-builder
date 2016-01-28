coffee = require 'coffee-script'
fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'
util = require 'util'

module.exports = class CommonCoffeeHandler

    constructor: (@template) ->
        @template ?= '''
            function () {
            var module = {};

            %s
            return module.exports.apply(this, arguments);
            }
        '''

    handle: (filePath) -> new Promise (resolve, reject) =>
        if path.extname(filePath) isnt '.coffee'
            resolve null

            return

        fs.readFile filePath, (error, data) =>
            if error
                reject error

                return

            resolve [
                path.basename filePath, '.coffee'
                util.format @template, coffee.compile data.toString()
            ]

            return
