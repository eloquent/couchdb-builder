test = 'It works.'
module.exports = -> [test, Array.prototype.slice.call(arguments)]
