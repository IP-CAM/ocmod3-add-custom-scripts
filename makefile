mod=$(shell basename `pwd`)
bin=bin
doc=doc
img=img
src=src
pwd=hideg.pwd
zip=$(mod).ocmod.zip
pkg=$(mod).zip
ymd=202001010000.00


# ckeck module license type
ifeq ($(shell test -e "EULA.txt" && echo -n yes),yes)
    lic=EULA.txt
	ign="yes"
else ifeq ($(shell test -e "LICENSE.txt" && echo -n yes),yes)
    lic=LICENSE.txt
endif

# check availiability of necessary tools
ifeq (, $(shell which fcl))
    $(error "ERROR: fcl not found!");
else ifeq (, $(shell which hideg))
    $(error "ERROR: hideg not found!")
endif

default: zip

# making zip-file
zip: enc
	@mkdir -p "$(bin)"
	@rm -rf "$(bin)/$(zip)"

	@echo Setting date/time...
	@find "$(src)" -exec touch -a -m -t $(ymd) {} \;
	@echo Setting date/time [DONE]

	@echo Making ZIP...;
	cd "$(src)" && zip -9qrX "../$(bin)/$(zip)" * "../$(lic)"

	@echo Making ZIP [DONE]

	@echo
	@echo Module \""$(mod)"\" successfully compiled!
	@echo

# packing/encrypting bin-file
enc: pwd
	@echo
	@echo ----------------
	@if [ -f "$(pwd)" ]; then \
		echo Making FCL...; \
		mkdir -p "$(bin)"; \
		fcl make -q -f -E$(bin) -E$(img) -E.git -Ehideg.pwd "$(bin)/$(mod)"; \
		echo Making FCL [DONE]; \
		echo Making HIDEG...; \
		hideg "$(bin)/$(mod).fcl"; \
		echo Making HIDEG [DONE]; \
		rm -f "$(bin)/$(mod).fcl"; \
	fi

# check pwd-file
pwd: git
	@if [ ! -f "$(pwd)" ]; then \
		hideg; \
	fi

# exclude src dir for paid modules and add for free
git:
	@if [ ! -z $(ign) ]; then \
		grep -xqF -- "src" ".gitignore" || echo "src" >> ".gitignore"; \
	else \
		grep -v "src" ".gitignore" > ".gitignore.tmp"; \
		mv -f .gitignore.tmp .gitignore; \
	fi

# decrypting/unpacking bin
dec: pwd
	@if [ -f "$(pwd)" -a -f "$(bin)/$(mod).fcl.g" ]; then \
		hideg "$(bin)/$(mod).fcl.g"; \
		fcl extr -f "$(bin)/$(mod).fcl"; \
	elif [ -a -f "$(bin)/$(mod).fcl" ]; then \
		fcl extr -f "$(bin)/$(mod).fcl"; \
	fi

# show list of files in fcl-file
list: pwd
	@if [ -f "$(pwd)" -a -f "$(bin)/$(mod).fcl.g" ]; then \
		hideg "$(bin)/$(mod).fcl.g"; \
		fcl list "$(bin)/$(mod).fcl"; \
		rm -f "$(bin)/$(mod).fcl"; \
	elif [ -a -f "$(bin)/$(mod).fcl" ]; then \
		fcl list -f "$(bin)/$(mod).fcl"; \
	fi
