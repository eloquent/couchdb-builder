# CouchDB builder

*A tool for building CouchDB documents from flat files.*

[![Current version image][version-image]][current version]
[![Current build status image][build-image]][current build status]
[![Current coverage status image][coverage-image]][current coverage status]

[build-image]: http://img.shields.io/travis/eloquent/couchdb-builder/master.svg?style=flat-square "Current build status for the master branch"
[coverage-image]: https://img.shields.io/codecov/c/github/eloquent/couchdb-builder/master.svg?style=flat-square "Current test coverage for the master branch"
[current build status]: https://travis-ci.org/eloquent/couchdb-builder
[current coverage status]: https://codecov.io/github/eloquent/couchdb-builder
[current version]: https://www.npmjs.com/package/couchdb-builder
[version-image]: https://img.shields.io/npm/v/couchdb-builder.svg?style=flat-square "This project uses semantic versioning"

<!--

## Installation

Available as [NPM] package [couchdb-builder]:

```
npm install --save couchdb-builder
```

[npm]: http://npmjs.org/
[couchdb-builder]: https://www.npmjs.com/package/couchdb-builder

-->

## What does it do?

*CouchDB builder* recursively reads a directory of flat files in various
formats, and builds a JSON document suitable for use with CouchDB. The most
common application is for CouchDB design documents, that typically contain
embedded code.

## Usage

### Command line usage

    couchdb-builder <source-path> > <destination-path>

### Module usage

*CouchDB builder* implements a [promise]-based interface:

```js
var couchdbBuilder = require('couchdb-builder');
var fs = require('fs');
var jsonStringify = require('json-stable-stringify');

couchdbBuilder.build(sourcePath).then(
    function (result) {
        fs.writeFile(
            targetPath,
            jsonStringify(result) + "\n",
            function (e) {
                console.error('Error writing file: ' + e);
            }
        );
    },
    function (e) {
        console.error('Error building document: ' + e);
    }
);
```

Note that [json-stable-stringify] is used instead of [JSON.stringify] to ensure
idempotent output, which helps reduce diff churn when the build product is
committed to a version control repository.

[promise]: https://promisesaplus.com/

## Differences to [couchdb-compile]

### Better support for CommonJS modules

Module support in [couchdb-compile] involves using [`.toString()`] on the
module's exports. This does not mix well with some common patterns of CommonJS
modules. Take the following module as an example:

```js
var a = 'a';

module.exports = function () {
    return a;
};
```

Using [`.toString()`] on this module would result in the following code:

```js
function () {
    return a;
};
```

Unfortunately, when this code is executed inside CouchDB, the variable `a` will
be `undefined`, and hence the behavior has changed from the original module.

*CouchDB builder* takes a different approach, and instead surrounds the original
source code in a light-weight wrapper. This wrapper allows the original code to
function identically when used inside CouchDB, and when `require`'d as a
CommonJS module.

The same module would look something like this when surrounded in the wrapper:

```js
if (!module) { var module = {}; }

var a = 'a';

module.exports = function () {
    return a;
};

module.exports;
```

This works because CouchDB internally uses [`eval()`], which returns the value
of the last expression evaluated (i.e. `module.exports`).

[`.tostring()`]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Function/toString
[`eval()`]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/eval

### Built-in support for CoffeeScript

CoffeeScript is not directly supported by [couchdb-compile], although there is
currently an open [pull request] designed to address this.

With *CouchDB builder*, CoffeeScript is automatically compiled to JavaScript,
then surrounded with the same light-weight wrapper as any other JavaScript file.
This means that CoffeeScript "just works" without any special configuration.

Although CouchDB *does* natively support CoffeeScript, it currently seems to
re-compile on every execution. It is almost certainly more performant to compile
once (it also simplifies the wrapper code).

[pull request]: https://github.com/jo/couchdb-compile/pull/29

### Idempotent output

When generating JSON output, [couchdb-compile] internally uses [JSON.stringify],
which does not guarantee the order of properties in the output. If the resulting
JSON is committed to a version control repository, this will sometimes produce
"diff churn" (repeated commits to a file that do not change its content in a
meaningful way).

*CouchDB builder* utilizes [json-stable-stringify] instead of [JSON.stringify],
to ensure that its output is idempotent (always the same, given the same input).

### Unsupported features

The following features of [couchdb-compile] are not currently supported. Please
open an issue if further discussion is warranted:

- Attachments.
- Automatic generation of the `_id` key. If no `_id` is specified, the document
  will not have one.
- Special treatment of `index.js` or `index.coffee` files as CommonJS modules.
  All `.js` and `.coffee` files are treated as modules in *CouchDB builder*.

<!-- References -->

[couchdb-compile]: https://github.com/jo/couchdb-compile
[json-stable-stringify]: https://github.com/substack/json-stable-stringify
[json.stringify]: https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify
