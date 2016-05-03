lib: node_modules $(shell find src)
	rm -rf lib
	node_modules/.bin/coffee --output lib --compile src

test: node_modules
	node_modules/.bin/mocha test/suite

coverage: node_modules
	node_modules/.bin/mocha --require test/coverage test/suite
	node_modules/.bin/istanbul report

lint: node_modules
	node_modules/.bin/coffeelint --file coffeelint.json src
	node_modules/.bin/coffeelint --file test/coffeelint.json test/suite

ci: coverage

.PHONY: test coverage lint ci

node_modules:
	npm install
