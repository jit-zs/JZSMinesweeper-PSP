

LUA_FILES = $(wildcard *.lua)

all: 
	$(foreach FILE, $(LUA_FILES), cp -f $(FILE) bin/$(FILE);)

%.lua:
	cp -f $@ bin/$@

test:
	@echo $(LUA_FILES)