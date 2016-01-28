fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'

module.exports = class TextHandler

    constructor: (@extensions = ['', '.txt']) ->

    handle: (filePath) -> new Promise (resolve, reject) =>
        extension = path.extname filePath

        return resolve null unless extension in @extensions

        fs.readFile filePath, (error, data) ->
            return reject error if error

            resolve [
                path.basename filePath, extension
                data.toString().replace /(?:\r\n|\r|\n)$/, ''
            ]

            return
