.PHONY: all nvim zsh agents git kitty ssh iterm2

all: nvim zsh agents git kitty ssh iterm2

nvim:
	ln -sf $(CURDIR)/nvim ~/.config/nvim

zsh:
	ln -sf $(CURDIR)/zshrc/antigen ~/.zshrc

agents:
	ln -sf $(CURDIR)/agents/statusline-command.sh ~/.claude/statusline-command.sh

git:
	ln -sf $(CURDIR)/git/gitconfig ~/.gitconfig
	ln -sf $(CURDIR)/git/gitignore ~/.gitignore

kitty:
	mkdir -p ~/.config/kitty
	ln -sf $(CURDIR)/kitty/kitty.conf ~/.config/kitty/kitty.conf
	ln -sf $(CURDIR)/kitty/current-theme.conf ~/.config/kitty/current-theme.conf
	ln -sf $(CURDIR)/kitty/equalize.py ~/.config/kitty/equalize.py

ssh:
	mkdir -p ~/.ssh
	ln -sf $(CURDIR)/ssh/config ~/.ssh/config

iterm2:
	mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
	ln -sf $(CURDIR)/iterm2/tonyseek.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/tonyseek.json
