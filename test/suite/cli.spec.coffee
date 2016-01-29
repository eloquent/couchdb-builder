Promise = require 'bluebird'

cli = require '../../src/cli'

describe 'CLI', ->

    beforeEach ->
        @process =
            argv: ['a', 'b', 'c']
            exit: sinon.spy()
        @console = sinon.spyObject 'console', ['log', 'error']
        @builder = sinon.spyObject 'builder', ['build']

    it 'outputs indented JSON', ->
        expected = '''
            {
              "a": 1,
              "b": 2
            }
        '''
        @builder.build.returns Promise.resolve a: 1, b: 2

        return cli @process, @console, @builder
        .then =>
            sinon.assert.calledWith @builder.build, 'c'
            sinon.assert.calledWith @console.log, expected

    it 'outputs error messages on failure', ->
        @builder.build.returns Promise.reject 'Error message.'

        return cli @process, @console, @builder
        .then =>
            sinon.assert.calledWith @console.error, 'Error message.'

    it 'requires a path argument', ->
        @process.argv = ['a', 'b']
        cli @process, @console, @builder

        sinon.assert.calledWith @console.error, 'Path is required.'
