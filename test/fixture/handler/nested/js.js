var test = 'It works.';
module.exports = function () { return [test, Array.prototype.slice.call(arguments)] };
