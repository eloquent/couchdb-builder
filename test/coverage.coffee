path = require 'path'
coffeeCoverage = require 'coffee-coverage'

basePath = path.resolve __dirname, '../src'
coverageVar = coffeeCoverage.findIstanbulVariable()

coffeeCoverage.register
    instrumentor: 'istanbul'
    basePath: basePath
    coverageVar: coverageVar
    writeOnExit: if coverageVar? then null else 'coverage/coverage-coffee.json'
    initAll: not process.env.COFFEECOV_INIT_ALL? or process.env.COFFEECOV_INIT_ALL? == 'true'
