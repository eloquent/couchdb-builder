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

    handleFile: (filePath) => new Promise (resolve, reject) =>
        return resolve null if path.extname(filePath) isnt '.coffee'

        fs.readFile filePath, (error, data) =>
            return reject error if error

            try
                js = coffee.compile data.toString()
            catch error
                return reject error

            resolve [
                path.basename filePath, '.coffee'
                util.format @template, js
            ]

            return
