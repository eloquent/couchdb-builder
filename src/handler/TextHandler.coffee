fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'

HandlerError = require './error/HandlerError'

module.exports = class TextHandler

    constructor: (@extensions = ['', '.txt']) ->

    handleFile: (filePath) => new Promise (resolve, reject) =>
        extension = path.extname filePath

        return resolve null unless extension in @extensions

        fs.readFile filePath, (error, data) ->
            if error
                error = new HandlerError 'TextHandler', filePath, error

                return reject error

            resolve [
                path.basename filePath, extension
                data.toString().replace /(?:\r\n|\r|\n)$/, ''
            ]

            return
