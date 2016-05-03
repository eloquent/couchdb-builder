chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai
global.assert = chai.assert
global.expect = chai.expect

sinon.spyObject = (name, methods) ->
    object = name: name
    object[method] = sinon.stub() for method in methods

    object
global.sinon = sinon
