mod=$(shell basename `pwd`)
bin=bin
doc=doc
img=img
src=src
pwd=hideg.pwd
zip=$(mod).ocmod.zip
pkg=$(mod).zip
datetime=202001010000.00

ifeq ($(shell test -e "EULA.txt" && echo -n yes),yes)
    lic=PAID
    lic_file=EULA.txt
else ifeq ($(shell test -e "LICENSE.txt" && echo -n yes),yes)
    lic=FREE
    lic_file=LICENSE.txt
endif

default: zip

zip: enc
	@mkdir -p "$(bin)"
	@rm -rf "$(bin)/$(zip)"

	@echo Setting date/time...
	@find "$(src)" -exec touch -a -m -t $(datetime) {} \;
	@echo Setting date/time [DONE]

	@echo Making ZIP...;
	cd "$(src)" && zip -9qrX "../$(bin)/$(zip)" * "../$(lic_file)"

	@echo Making ZIP [DONE]

	@echo
	@echo $(lic) module \""$(mod)"\" successfully compiled!
	@echo

enc: pwd
	@if [ "$(lic)" = "PAID" -a -f "$(pwd)" ]; then \
	 	echo Making FCL...; \
		mkdir -p "$(bin)"; \
	 	fcl make -q -f -E.git -Ebin -E$(bin) -Eimg "$(bin)/$(mod)"; \
	 	echo Making FCL [DONE]; \
	 	echo Making HIDEG...; \
	 	hideg "$(bin)/$(mod).fcl"; \
	 	echo Making HIDEG [DONE]; \
		rm -f "$(bin)/$(mod).fcl"; \
	fi

pwd:
	@if [ "$(lic)" = "PAID" -a ! -f "$(pwd)" ]; then \
		hideg; \
	fi

dec: pwd
	@if [ -f "$(pwd)" -a -f "$(bin)/$(mod).fcl.g" ]; then \
		hideg "$(bin)/$(mod).fcl.g"; \
		fcl extr -f "$(bin)/$(mod).fcl"; \
	fi

fcl: pwd
	@if [ -f "$(pwd)" -a -f "$(bin)/$(mod).fcl.g" ]; then \
		hideg "$(bin)/$(mod).fcl.g"; \
		fcl list "$(bin)/$(mod).fcl"; \
		rm -f "$(bin)/$(mod).fcl"; \
	fi
