#
# Author: Samuel M.H. <samuel.mh@gmail.com>
# Description:
#    Make-based utility to manage the project.
#    Idea taken from:
#     - http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html

#
### PRECONFIG
#

PYTHON_VERSION := 3.5

#
### PATHS
#

#Car Damage Estimation
LIBRARY = ai_games


#Don't touch
PATH_PROJECT = $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
PATH_VENV = $(PATH_PROJECT)/venv
PATH_LIBRARY = $(PATH_PROJECT)/$(LIBRARY)
PATH_DATA = $(PATH_PROJECT)/data
PATH_CONFIG = $(PATH_LIBRARY)/config


#
### Autodocumenting thing, don't touch
#
.PHONY: help

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


#
### Install the project Python dependencies
#
virtualenv-create: ## Create a development environment (virtualenv).
	@echo "Create the environment in "$(PATH_PROJECT)
	@virtualenv -p python$(PYTHON_VERSION) $(PATH_VENV)
	@echo "Install requirements"
	$(PATH_VENV)'/bin/pip' install -r $(PATH_PROJECT)'/deploy/requirements.txt'
	@echo "Create symbolic links"
	# Link to project
	@ln -s $(PATH_PROJECT) $(PATH_VENV)'/'
	# Link code to project library so it is in the PYTHONPATH
	@ln -s $(PATH_LIBRARY) $(PATH_VENV)'/lib/python$(PYTHON_VERSION)/site-packages/'

test:
	# Make tictactoe game available
	@echo $(PATH_PROJECT)
	@ln -s $(PATH_PROJECT)'/ai_games/tictactoe/game.py' $(PATH_VENV)'/bin/tictactoe'
	@chmod +x $(PATH_VENV)'/bin/tictactoe'


#
### Run things
#
notebooks-start_server: ## Start the Jupyter notebook server
	@$(PATH_VENV)/bin/jupyter notebook --NotebookApp.default_url=/tree/ai_games --ip=0.0.0.0
