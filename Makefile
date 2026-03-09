.PHONY: nvim
nvim:
	ln -sf $(CURDIR)/nvim ~/.config/nvim

.PHONY: zsh
zsh:
	ln -sf $(CURDIR)/zshrc/antigen ~/.zshrc

.PHONY: agents
agents:
	ln -sf $(CURDIR)/agents/statusline-command.sh ~/.claude/statusline-command.sh
