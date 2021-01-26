SHELL := /bin/bash

DOT_FILES = .aliases.sh .functions.sh .git.aliases .gitconfig .gitignore.global .gvimrc .hyper.js .ideavimrc .key-bindings.sh .osx.sh .vimrc Brewfile
HISTORY_FILES = .lesshst .psql_history .python_history .zhistory 
TEMPLATE_FILES = .netrc .pypirc

.PHONY: setup-dot-files setup-history setup-ssh-config

setup: setup-dot-files setup-history-files setup-ssh-config setup-from-templates setup-docker-config

# Manual steps:
# 1. Install Homebrew.
# 1. Install ZSH.
# 1. Copy over AWS credentials.
# 1. Install Prezto.
# 1. Import GPG private/public key pairs.
# 1. Enable FZF bindings.

# Step 1
setup-brew:
	@echo -e "\nSetting up Homebrew bundle..."
	brew tap homebrew/bundle
	brew bundle
	@echo -e "Done."

# Step 2
setup-dot-files:
	@echo -e "\nSetting up dot files..."
	@for file in $(DOT_FILES); do \
		[ ! -f ~/$$file ] && ln -s $$(pwd)/$$file ~/$$file && echo "File '$$file' created." || echo "Skipping '$$file' as it already exists.";  \
	done
	@echo -e "Done."

# Step 3
setup-history-files:
	@echo -e "\nSetting up history files..."
	@for file in $(HISTORY_FILES); do \
		[ ! -f ~/$$file ] && ln -s ~/Dropbox/histories/$$file ~/$$file && echo "File '$$file' created." || echo "Skipping '$$file' as it already exists.";  \
	done
	@echo -e "Done."

# Step 4
setup-ssh-config:
	@echo -e "\nSetting up SSH config..."
	@[ ! -f ~/.ssh/config ] && ln -s $$(pwd)/sshconfig ~/.ssh/config && echo "SSH config created." || echo "Skipping SSH config as it already exists."
	@echo -e "Done."

# Step 5
setup-from-templates:
	@echo -e "\nCopying template files..."
	@for file in $(TEMPLATE_FILES); do \
		[ ! -f ~/$$file ] && cp $$(pwd)/$$file ~/$$file && echo "File '$$file' created." || echo "Skipping '$$file' as it already exists.";  \
	done
	@echo -e "Done. Don't forget to update the placeholder credentials!"

# Step 6
setup-docker-config:
	@echo -e "\nSetting up Docker config..."
	@[ ! -f ~/.docker/config.json ] && ln -s $$(pwd)/docker/config.json ~/.docker/config.json && echo "Docker config created." || echo "Skipping Docker config as it already exists."
	@echo -e "Done."
