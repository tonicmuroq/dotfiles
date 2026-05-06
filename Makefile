.PHONY: all nvim zsh agents git kitty ssh iterm2

all: nvim zsh agents git kitty ssh iterm2

nvim:
	ln -sfn $(CURDIR)/nvim ~/.config/nvim

zsh:
	ln -sf $(CURDIR)/zshrc/antigen ~/.zshrc

agents:
	ln -sf $(CURDIR)/agents/statusline-command.sh ~/.claude/statusline-command.sh

git:
	ln -sf $(CURDIR)/git/gitconfig ~/.gitconfig
	ln -sf $(CURDIR)/git/gitignore ~/.gitignore

kitty:
	ln -sfn $(CURDIR)/kitty ~/.config/kitty

ssh:
	mkdir -p ~/.ssh
	ln -sf $(CURDIR)/ssh/config ~/.ssh/config
	ln -sf $(CURDIR)/ssh/allowed_signers ~/.ssh/allowed_signers

iterm2:
	mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
	ln -sf $(CURDIR)/iterm2/tonic.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/tonic.json
	defaults write com.googlecode.iterm2 HideTab -bool false
	defaults write com.googlecode.iterm2 QuitWhenAllWindowsClosed -bool true
	defaults write com.googlecode.iterm2 ShowFullScreenTabBar -bool false
	defaults write com.googlecode.iterm2 ShowPaneTitles -bool false
	defaults write com.googlecode.iterm2 SplitPaneDimmingAmount -float 0.2
	defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 5
	defaults write com.googlecode.iterm2 WindowNumber -bool false
	defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "A2EA77C9-57BB-4497-B6C2-DC1E7B761E70"
