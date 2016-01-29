CommonCoffeeHandler = require './handler/CommonCoffeeHandler'
CommonJsHandler = require './handler/CommonJsHandler'
CouchBuilder = require './CouchBuilder'
JsonHandler = require './handler/JsonHandler'
TextHandler = require './handler/TextHandler'

builder = new CouchBuilder [
    new CommonCoffeeHandler
    new CommonJsHandler
    new JsonHandler
    new TextHandler
]

module.exports = build: (root) -> return builder.build root
