# Makefile to build project.
PROJECT_NAME = create_database
REGION = eu-west-2
PYTHON_INTERPRETER = python3.12
WD=$(shell pwd)
PYTHONPATH=${WD}
SHELL := /bin/bash
PROFILE = default
PIP:=pip
ROOT_DIR := $(shell pwd)
ACTIVATE_ENV := source venv/bin/activate


create-environment:
	@echo "Creating virtual environment for project: $(PROJECT_NAME)..."
	@echo "Python version: $(PYTHON_INTERPRETER)."
	(python -m venv venv)
	@echo "Venv setup."

requirements:
	@echo "Installing requirements..."
	$(PIP) install -r ./requirements.txt
	chmod +x script.sh
	chmod +x remove.sh
	export PYTHONPATH=$(pwd)

run:
	$(ACTIVATE_ENV) && ./script.sh

remove:
	$(ACTIVATE_ENV) && ./remove.sh

autopep:
	autopep8 --in-place --aggressive --aggressive src/*.py

flake:
	flake8  src/*.py

