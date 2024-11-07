# Makefile for installing Lua scripts and associated files for Neutrino

# Optional inclusion of a local configuration file
-include Makefile.local

# Ensure SCRIPT_NAME is provided for specific targets
ifeq ($(filter install uninstall check,$(MAKECMDGOALS)),)
else ifndef SCRIPT_NAME
    $(error SCRIPT_NAME is not set. Please set SCRIPT_NAME to the base name of your origin script. Example: make install SCRIPT_NAME=logoupdater)
endif

# Optional custom target program name, prefix, and suffix
PROGRAM_PREFIX ?=
PROGRAM_SUFFIX ?=
TARGET_PROGRAM_NAME ?= $(PROGRAM_PREFIX)$(SCRIPT_NAME)$(PROGRAM_SUFFIX)

# INSTALLDIR can be overridden by setting it in the environment.
INSTALLDIR ?= /usr/share/tuxbox/neutrino/plugins

# Set SOURCE_DIR to the directory containing this Makefile if not provided
SOURCE_DIR ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Define the base name for files
BASE_NAME = $(SCRIPT_NAME)

# Automatically find all files that start with BASE_NAME in SOURCE_DIR and have supported extensions
SCRIPTS = $(wildcard $(SOURCE_DIR)$(SCRIPT_NAME).lua)
CFGFILE = $(wildcard $(SOURCE_DIR)$(SCRIPT_NAME).cfg)
IMAGES = $(wildcard $(SOURCE_DIR)$(SCRIPT_NAME).png)
ASSOCIATED_FILES = $(wildcard $(SOURCE_DIR)$(SCRIPT_NAME).sh) $(wildcard $(SOURCE_DIR)$(SCRIPT_NAME).db) $(wildcard $(SOURCE_DIR)$(SCRIPT_NAME)-linker.sh)
EXTRA_FILES = $(EXTRAFILES)

# Combine all files into one list
FILES = $(SCRIPTS) $(CFGFILE) $(IMAGES) $(ASSOCIATED_FILES) $(EXTRA_FILES)

# Phony targets
.PHONY: all install uninstall clean help check

# Default target
all: install

# Help target to display usage
help:
	@echo "Usage:"
	@echo "  make install SCRIPT_NAME=<name> [options]"
	@echo ""
	@echo "Options:"
	@echo "  Set these environment variables or use Makfile.local."
	@echo "  SCRIPT_NAME=<name>      Base name of the origin script to install (required)."
	@echo "  PROGRAM_PREFIX=<prefix> Optional prefix for installed files."
	@echo "  PROGRAM_SUFFIX=<suffix> Optional suffix for installed files."
	@echo "  TARGET_PROGRAM_NAME=<name> Full name for the installed program."
	@echo "  INSTALLDIR=<path>       Directory to install files to."
	@echo "  SOURCE_DIR=<path>       Directory where the source files are located."
	@echo "  EXTRAFILES=<files>      Additional files to install."

# Check target to ensure files exist before installation
check:
	@echo "Checking required files..."
	@if [ -z "$(FILES)" ]; then \
		echo "Error: No files found for $(SCRIPT_NAME) in $(SOURCE_DIR). Please check the SCRIPT_NAME and ensure the files exist."; \
		exit 1; \
	else \
		echo "All required files are present."; \
	fi

# Install the script and associated files
install: check
	@echo "Installing $(TARGET_PROGRAM_NAME) from $(SOURCE_DIR) to $(INSTALLDIR)"
	@echo "Files to install: $(FILES)"
	@mkdir -p $(INSTALLDIR)
	@installed_count=0; \
	for file in $(FILES); do \
		if [ -f "$$file" ]; then \
			target_file=$(INSTALLDIR)/$(TARGET_PROGRAM_NAME)$${file#$(SOURCE_DIR)$(SCRIPT_NAME)}; \
			case "$$file" in \
				*.lua|*.sh) install -v -m 755 "$$file" "$$target_file" ;; \
				*.png|*.db|*.cfg) install -v -m 644 "$$file" "$$target_file" ;; \
				*) install -v -m 644 "$$file" "$$target_file" ;; \
			esac; \
			installed_count=$$((installed_count + 1)); \
		else \
			echo "Warning: $$file not found in $(SOURCE_DIR) and was not installed."; \
		fi; \
	done; \
	if [ $$installed_count -eq 0 ]; then \
		echo "Warning: No files were actually installed. Please check if SCRIPT_NAME is correct."; \
	fi
	@echo "Installation of $(TARGET_PROGRAM_NAME) complete."

# Uninstall the script and associated files
uninstall:
	@echo "Uninstalling $(TARGET_PROGRAM_NAME) from $(INSTALLDIR)"
	@for file in $(FILES); do \
		target_file=$(INSTALLDIR)/$(TARGET_PROGRAM_NAME)$${file#$(SOURCE_DIR)$(SCRIPT_NAME)}; \
		if [ -f "$$target_file" ]; then \
			rm -f "$$target_file"; \
			echo "Removed $$target_file"; \
		else \
			echo "Warning: $$target_file not found in $(INSTALLDIR)"; \
		fi; \
	done
	@echo "Uninstallation of $(TARGET_PROGRAM_NAME) complete."

# Clean target (optional)
clean:
	@echo "Nothing to clean."
