.PHONY: nvim
nvim:
	ln -sf $(CURDIR)/nvim ~/.config/nvim

.PHONY: zsh
zsh:
	ln -sf $(CURDIR)/zshrc/antigen ~/.zshrc
