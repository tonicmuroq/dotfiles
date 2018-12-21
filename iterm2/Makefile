.PHONY: help build install clean

prefix ?= $(HOME)/Library/Application Support

help:
	@printf 'Commands:\n\n'
	@printf '  %s\n' "help"
	@printf '  %s\n' "build"
	@printf '  %s\n' "clean"
	@printf '  %s\n' "install"

build: profiles.plist

install: build
	cp "profiles.plist" "$(prefix)/iTerm2/DynamicProfiles/Profiles"

clean:
	find . -type f \( -name '*.plist' -or -name '*.json' \) -delete -print

%.json: %.json.in
	m4 shutil.m4 "$<" | python -m json.tool > "$@"

%.plist: %.json
	plutil -convert xml1 "$<" -o "$@"
