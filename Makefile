BIN = ./node_modules/.bin

.PHONY: bootstrap bootstrap-js bootstrap-ruby start test docs release-docs;

SRC = $(shell find ./lib ./index.js ./test -type f -name '*.js')

test: lint
	@node test/lib/mockServer &
	@$(BIN)/karma start --single-run

bootstrap: bootstrap-js bootstrap-ruby

bootstrap-js: package.json
	@npm install

bootstrap-ruby: docs/Gemfile
	@which bundle > /dev/null || gem install bundler
	@cd docs && bundle install

test-watch: lint
	@node test/lib/mockServer &
	@$(BIN)/karma start

lint: bootstrap-js
	@$(BIN)/jsxcs $(SRC);
	@$(BIN)/jsxhint $(SRC);

release: test build
	@git add dist && (git diff --exit-code > /dev/null && git commit -m "Rebuilding source")
	@npm version patch
	@bower version patch
	@git push origin master && git push --tags
	@npm publish

build: lint
	@mkdir -p dist
	@$(BIN)/browserify --require ./index.js  --standalone Marty > dist/marty.js
	@cat dist/marty.js | $(BIN)/uglifyjs > dist/marty.min.js
	@gzip dist/marty.min.js -c > dist/marty.min.js.gz

docs: bootstrap-ruby
	@cd docs && bundle exec jekyll serve -w

release-docs: bootstrap-ruby
	@cd docs && bundle exec rake release