#
# chipKIT extensions for Arduino Makefile
# System part (i.e. project independent)
#
# Copyright (C) 2011, 2012, 2013 Christopher Peplin
# <chris.peplin@rhubarbtech.com>, based on work that is Copyright Martin
# Oldfield
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
# Modified by John Wallbank for Visual Studio
#
#    Development changes, John Wallbank,
#
#   - made inclusion of WProgram.h optional so that
#    including it in the source doesn't mess up compile error line numbers
#   - parameterised the routine used to reset the serial port
#

########################################################################
# Makefile distribution path
#

# The show_config_variable is unavailable before we include the common makefile,
# so we defer logging the ARDMK_DIR info until it happens in Arduino.mk
ifndef ARDMK_DIR
    # presume it's a level above the path to our own file
    ARDMK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..)
endif

ifdef ARDMK_DIR
    ifndef ARDMK_PATH
        ARDMK_PATH = $(ARDMK_DIR)/bin
    endif
else
    echo $(error "ARDMK_DIR is not defined")
endif

include $(ARDMK_DIR)/arduino-mk/Common.mk

ifndef MPIDE_DIR
    AUTO_MPIDE_DIR := $(firstword \
        $(call dir_if_exists,/usr/share/mpide) \
        $(call dir_if_exists,/Applications/Mpide.app/Contents/Resources/Java) )
    ifdef AUTO_MPIDE_DIR
       MPIDE_DIR = $(AUTO_MPIDE_DIR)
       $(call show_config_variable,MPIDE_DIR,[autodetected])
    else
        echo $(error "mpide_dir is not defined")
    endif
else
    $(call show_config_variable,MPIDE_DIR,[USER])
endif

ifndef MPIDE_PREFERENCES_PATH
    AUTO_MPIDE_PREFERENCES_PATH := $(firstword \
        $(call dir_if_exists,$(HOME)/.mpide/preferences.txt) \
        $(call dir_if_exists,$(HOME)/Library/Mpide/preferences.txt) )
    ifdef AUTO_MPIDE_PREFERENCES_PATH
       MPIDE_PREFERENCES_PATH = $(AUTO_MPIDE_PREFERENCES_PATH)
       $(call show_config_variable,MPIDE_PREFERENCES_PATH,[autodetected])
    endif
endif


AVR_TOOLS_DIR = $(ARDUINO_DIR)/hardware/pic32/compiler/pic32-tools

ALTERNATE_CORE = pic32
ALTERNATE_CORE_PATH = $(MPIDE_DIR)/hardware/pic32
ARDUINO_CORE_PATH = $(ALTERNATE_CORE_PATH)/cores/$(ALTERNATE_CORE)
ARDUINO_PREFERENCES_PATH = $(MPIDE_PREFERENCES_PATH)
ARDUINO_DIR = $(MPIDE_DIR)

ARDUINO_VERSION = 23

CC_NAME = pic32-gcc
CXX_NAME = pic32-g++
AR_NAME = pic32-ar
OBJDUMP_NAME = pic32-objdump
OBJCOPY_NAME = pic32-objcopy
SIZE_NAME = pic32-size

LDSCRIPT = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) ldscript)
LDSCRIPT_FILE = $(ARDUINO_CORE_PATH)/$(LDSCRIPT)

MCU_FLAG_NAME=mprocessor
LDFLAGS  += -T$(ARDUINO_CORE_PATH)/$(LDSCRIPT)
CPPFLAGS += -mno-smart-io -fno-short-double
CFLAGS_STD =

include $(ARDMK_DIR)/arduino-mk/Arduino.mk
