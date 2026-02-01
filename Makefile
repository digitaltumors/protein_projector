.PHONY: clean clean-test clean-pyc clean-build docs help
.DEFAULT_GOAL := help

# 1. Find all source files in the platform directory
MD_SOURCES := $(wildcard platforms/dnanexus/protein_projector/*.md)
SH_SOURCES := $(wildcard platforms/dnanexus/protein_projector/src/*.sh)
PY_SOURCES := $(wildcard platforms/dnanexus/protein_projector/test/*.py)

# 2. Convert source paths to build paths
MD_TARGETS := $(patsubst platforms/dnanexus/protein_projector/%.md, build/protein_projector/%.md, $(MD_SOURCES))
SH_TARGETS := $(patsubst platforms/dnanexus/protein_projector/src/%.sh, build/protein_projector/src/%.sh, $(SH_SOURCES))
PY_TARGETS := $(patsubst platforms/dnanexus/protein_projector/test/%.py, build/protein_projector/test/%.py, $(PY_SOURCES))



define BROWSER_PYSCRIPT
import os, webbrowser, sys

try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

build/protein_projector/resources/protein_projector.tar.gz: docker/Dockerfile ## Builds Protein Projector Docker Container file
	@mkdir -p `dirname $@`
	@cv=` grep 'RUN pip install cellmaps_coembedding==' $< | sed "s/^.*==//"`; \
	docker build -t digitaltumors/protein_projector:$$cv -f $< .; \
	docker save digitaltumors/protein_projector:$$cv -o $@

build/protein_projector/dxapp.json: platforms/dnanexus/protein_projector/dxapp.json ## Builds dxapp.json
	@cv=` grep 'RUN pip install cellmaps_coembedding==' docker/Dockerfile | sed "s/^.*==//"`; \
	cat $< | sed "s/@@VERSION@@/$$cv/g" > $@
	echo "Copying dxapp.json to $@ and setting version"

build/protein_projector/src/%.sh: platforms/dnanexus/protein_projector/src/%.sh
	@cp $< $@

build/protein_projector/test/%.py: platforms/dnanexus/protein_projector/test/%.py
	@cp $< $@

build/protein_projector/%.md: platforms/dnanexus/protein_projector/%.md
	@cp $< $@

applet: build/protein_projector/resources/protein_projector.tar.gz \
        build/protein_projector/dxapp.json \
        $(MD_TARGETS) \
        $(SH_TARGETS) \
        $(PY_TARGETS)
	@echo "Build complete."

dockerpush: ## push image to dockerhub
	@cv=` grep 'RUN pip install cellmaps_coembedding==' docker/Dockerfile | sed "s/^.*==//"`; \
	docker push digitaltumors/protein_projector:$$cv


