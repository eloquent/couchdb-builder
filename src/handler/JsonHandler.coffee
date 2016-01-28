fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'

module.exports = class JsonHandler

    handle: (filePath) -> new Promise (resolve, reject) ->
        return resolve null if path.extname(filePath) isnt '.json'

        fs.readFile filePath, (error, json) ->
            return reject error if error

            try
                data = JSON.parse json
            catch error
                return reject error

            resolve [path.basename(filePath, '.json'), data]

            return
