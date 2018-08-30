SHELL := /bin/bash

DOT_FILES = .aliases.sh .functions.sh .git.aliases .gitconfig .gitignore.global .gvimrc .key-bindings.sh .osx.sh .vimrc Brewfile

.PHONY: setup
setup-dot-files:
	@for file in $(DOT_FILES); do \
		[ ! -f ~/$$file ] && ln -s $$(pwd)/$$file ~/$$file && echo "File '$$file' created." || echo "Skipping '$$file' as it already exists.";  \
	done
