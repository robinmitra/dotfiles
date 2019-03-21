SHELL := /bin/bash

DOT_FILES = .aliases.sh .functions.sh .git.aliases .gitconfig .gitignore.global .gvimrc .hyper.js .ideavimrc .key-bindings.sh .netrc .osx.sh .pypirc .vimrc Brewfile
HISTORY_FILES = .lesshst .psql_history .python_history .zhistory 


.PHONY: setup-dot-files setup-history setup-ssh-config

setup: setup-dot-files setup-history-files setup-ssh-config

setup-dot-files:
	@echo -e "\nSetting up dot files..."
	@for file in $(DOT_FILES); do \
		[ ! -f ~/$$file ] && ln -s $$(pwd)/$$file ~/$$file && echo "File '$$file' created." || echo "Skipping '$$file' as it already exists.";  \
	done

setup-history-files:
	@echo -e "\nSetting up history files..."
	@for file in $(DOT_FILES); do \
		[ ! -f ~/$$file ] && ln -s ~/Dropbox/histories/$$file ~/$$file && echo "File '$$file' created." || echo "Skipping '$$file' as it already exists.";  \
	done

setup-ssh-config:
	@echo -e "\nSetting up ssh config..."
	@[ ! -f ~/.ssh/config ] && ln -s $$(pwd)/sshconfig ~/.ssh/config && echo "SSH config created." || echo "Skipping SSH config as it already exists."
