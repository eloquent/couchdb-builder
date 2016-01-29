module.exports = (_process, _console, builder = require '.') ->
    argv = _process.argv.slice 2

    unless argv.length
        _console.error 'Path is required.'

        return _process.exit 1

    return builder.build argv[0]
    .then (result) ->
        return _console.log JSON.stringify result, null, 2
    .catch (error) ->
        return _console.error error.toString()
