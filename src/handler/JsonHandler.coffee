fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'

HandlerError = require './error/HandlerError'

module.exports = class JsonHandler

    handleFile: (filePath) -> new Promise (resolve, reject) ->
        return resolve null if path.extname(filePath) isnt '.json'

        fs.readFile filePath, (error, json) ->
            if error
                error = new HandlerError 'JsonHandler', filePath, error

                return reject error

            try
                data = JSON.parse json
            catch error
                error = new HandlerError 'JsonHandler', filePath, error

                return reject error

            resolve [path.basename(filePath, '.json'), data]

            return
