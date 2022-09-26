# Colors for displaying text in the terminal
RED    := $(shell tput -Txterm setaf 1)
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
BOLD   := $(shell tput -Txterm bold)
RESET  := $(shell tput -Txterm sgr0)

TARGET_MAX_CHAR_NUM=30

## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
.PHONY: help

# Build Hoogle database. Run Ghcid and local Hoogle server. Update database and generate CTags on save.
dev:
	-stack build --fast
	# -stack hoogle --rebuild
	# -stack hoogle --server 2> /dev/null 1> /dev/null &
	-stack exec ghcid -- \
	  --command 'stack repl :dev --ghc-options "-O0 -fno-code -ignore-dot-ghci -ferror-spans"' \
	  --test ':! stack exec hasktags -- --ctags . && stack hoogle -- generate --local sean-passion-project && clear && echo "Press ENTER to exit."' \
	  --warnings \
	  --outputfile ghcid.txt &
	@read
	-pkill ghcid
	-pkill hoogle
	-clear
.PHONY: dev

# dev:
# 	-stack build --fast
# 	-stack exec ghcid -- \
# 	  --command 'stack repl :dev --ghc-options "-O0 -fno-code -ignore-dot-ghci -ferror-spans"' \
# 	  --test ':! stack exec hasktags -- --ctags . && clear && echo "Press ENTER to exit."' \
# 	  --warnings \
# 	  --outputfile ghcid.txt &
# 	@read
# 	-pkill ghcid
# 	-clear
# .PHONY: dev

## Run GHCi
dev-repl:
	stack repl :dev --ghc-options '-O0 -ignore-dot-ghci -ghci-script .ghci.dev'