// Generated by CoffeeScript 1.10.0
(function() {
  var HandlerError, JsonHandler, Promise, fs, path;

  fs = require('fs');

  path = require('path');

  Promise = require('bluebird');

  HandlerError = require('./error/HandlerError');

  module.exports = JsonHandler = (function() {
    function JsonHandler() {}

    JsonHandler.prototype.handleFile = function(filePath) {
      return new Promise(function(resolve, reject) {
        if (path.extname(filePath) !== '.json') {
          return resolve(null);
        }
        return fs.readFile(filePath, function(error, json) {
          var data, error1;
          if (error) {
            error = new HandlerError('JsonHandler', filePath, error);
            return reject(error);
          }
          try {
            data = JSON.parse(json);
          } catch (error1) {
            error = error1;
            error = new HandlerError('JsonHandler', filePath, error);
            return reject(error);
          }
          resolve([path.basename(filePath, '.json'), data]);
        });
      });
    };

    return JsonHandler;

  })();

}).call(this);
