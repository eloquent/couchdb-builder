fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'
util = require 'util'

HandlerError = require './error/HandlerError'

module.exports = class CommonCoffeeHandler

    constructor: (@template) ->
        @template ?=
            "(function () {\n\n%s\nreturn module.exports;\n}).call(this);"

    handleFile: (filePath) => new Promise (resolve, reject) =>
        return resolve null if path.extname(filePath) isnt '.coffee'

        fs.readFile filePath, (error, data) =>
            if error
                error = new HandlerError 'CommonCoffeeHandler', filePath, error

                return reject error

            coffee = require 'coffee-script'

            try
                js = coffee.compile data.toString(), bare: true
            catch error
                error = new HandlerError 'CommonCoffeeHandler', filePath, error

                return reject error

            resolve [
                path.basename filePath, '.coffee'
                util.format @template, js
            ]

            return
