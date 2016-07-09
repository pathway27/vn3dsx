export SHORTNAME	:= VNDSx
export LONGNAME 	:= Visual Novel Reader
export VERSION 		:= 1.4.9
ICON 		:= -b logo.bmp
EFS			:= $(CURDIR)/tools/efs/efs

#------------------------------------------------------------------------------
.SUFFIXES:
#------------------------------------------------------------------------------
ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM)
endif

include $(DEVKITARM)/ds_rules

export TARGET := $(shell basename $(CURDIR))
export TOPDIR := $(CURDIR)

.PHONY: $(TARGET).arm7 $(TARGET).arm9 dist-shared dist dist-src

#------------------------------------------------------------------------------
# main targets
#------------------------------------------------------------------------------
all: $(TARGET).nds $(TARGET)-EFS.nds

#------------------------------------------------------------------------------

dist-shared:
	@rm -rf dist
	@mkdir dist
	@mkdir dist/vnds
	cp license.txt dist/vnds
	cp readme.txt dist/vnds
	cp ChangeLog dist/vnds
	cp -r manual/ dist/vnds
	cp -r tools/ dist/vnds

dist: $(TARGET).nds
	$(MAKE) dist-shared
	cp $(TARGET).nds dist/vnds
	cp -r vnds/* dist/vnds
	rm -rf dist/vnds/novels
	@mkdir dist/vnds/novels
	@find dist/vnds/ -type d -name ".svn" | xargs rm -r
	@rm -f $(TARGET)-$(VERSION).7z
	cd dist && 7za a ../$(TARGET)-$(VERSION).7z vnds

dist-src:
	$(MAKE) dist-shared
	cp Makefile dist/vnds
	cp logo.bmp dist/vnds
	cp -r src/ dist/vnds
	cp -r src-art/ dist/vnds
	@mkdir dist/vnds/vnds
	cp -r vnds/* dist/vnds/vnds
	rm -rf dist/vnds/vnds/novels
	@mkdir dist/vnds/vnds/novels
	@find dist/vnds/src/ -type d -name "build" | xargs rm -r
	@find dist/vnds/     -type d -name ".svn"  | xargs rm -r
	@rm -f $(TARGET)-$(VERSION)-src.7z
	cd dist && 7za a ../$(TARGET)-$(VERSION)-src.7z vnds

$(TARGET)-EFS.nds: $(TARGET).nds
	rm -rf dist
	@mkdir dist
	cp -r vnds/* dist/
	cp $(TARGET).nds dist/
	@find dist/ -type d -name ".svn" | xargs rm -r
	@ndstool -c $(TARGET)-EFS.nds -7 $(TARGET).arm7 -9 $(TARGET).arm9 $(ICON) "$(SHORTNAME);$(LONGNAME);$(VERSION)" -d $(CURDIR)/dist
	@$(EFS) $(notdir $@)

$(TARGET).nds: $(TARGET).arm7 $(TARGET).arm9
	@ndstool -c $(TARGET).nds -7 $(TARGET).arm7 -9 $(TARGET).arm9 $(ICON) "$(SHORTNAME);$(LONGNAME);$(VERSION)"

#------------------------------------------------------------------------------
$(TARGET).arm7	: arm7/$(TARGET).elf
$(TARGET).arm9	: arm9/$(TARGET).elf

#------------------------------------------------------------------------------
arm7/$(TARGET).elf:
	$(MAKE) -C src/arm7
	
#------------------------------------------------------------------------------
arm9/$(TARGET).elf:
	$(MAKE) -C src/arm9

#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
clean:
	$(MAKE) -C src/arm9 clean
	$(MAKE) -C src/arm7 clean
	rm -f $(TARGET).nds $(TARGET)-EFS.nds $(TARGET).arm7 $(TARGET).arm9 $(TARGET)-$(VERSION).7z $(TARGET)-$(VERSION)-src.7z
	rm -rf dist
