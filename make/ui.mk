# ============================================================
# 🎨 Terminal UI
# ============================================================

RESET   := $(shell tput sgr0)

ERROR   := $(shell tput bold; tput setaf 1)✗ 
WARNING := $(shell tput bold; tput setaf 3)⚠ 

SUCCESS := $(shell tput bold; tput setaf 2)✔ 

ACTION  := ⚙ 
INFO    := $(shell tput setaf 6)ℹ 
