fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'

module.exports = class JsonHandler

    handle: (filePath) -> new Promise (resolve, reject) ->
        if path.extname(filePath) isnt '.json'
            resolve null

            return

        fs.readFile filePath, (error, json) ->
            if error
                reject error

                return

            try
                data = JSON.parse json
            catch error
                reject error

                return

            resolve [path.basename(filePath, '.json'), data]

            return
