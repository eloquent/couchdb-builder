fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'

module.exports = class TextHandler

    constructor: (@extensions = ['', '.txt']) ->

    handle: (filePath) -> new Promise (resolve, reject) =>
        extension = path.extname filePath

        unless extension in @extensions
            resolve null

            return

        fs.readFile filePath, (error, data) ->
            if error
                reject error

                return

            resolve [
                path.basename filePath, extension
                data.toString().replace /(?:\r\n|\r|\n)$/, ''
            ]

            return
