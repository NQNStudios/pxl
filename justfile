# run all tests
default: test

# submit a pull request
pr: fmt clippy test
	@echo Checking for FIXME/TODO...
	! grep --color -En 'FIXME|TODO' src/*.rs
	@echo Checking for long lines...
	! grep --color -En '.{101}' src/*.rs
	git branch | grep '^ *master'
	git diff --exit-code
	git diff --cached --exit-code
	git push github

# run all tests
test:
	cargo test

# format rust sourcecode with rustfmt
fmt:
	cargo fmt

watch:
	cargo watch --clear --exec fmt --exec check

# check for out-of-date dependencies
outdated:
	cargo outdated

# everyone's favorite animate paper clip
clippy:
	cargo +nightly clippy

# run the conway's game of life example
life:
	cargo run --package pxl --release --example life

# run the custom shader example
shaders:
	cargo run --package pxl --release --example shaders

# run the blaster visualizer example
blaster:
	cargo run --package pxl --release --example blaster

# clean up the feature branch named BRANCH
done BRANCH:
	git checkout master
	git pull --rebase github master
	git diff --no-ext-diff --quiet --exit-code {{BRANCH}} --
	git branch -D {{BRANCH}}
