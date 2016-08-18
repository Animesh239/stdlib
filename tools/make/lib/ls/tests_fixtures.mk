
# VARIABLES #

# Determine the host kernel:
KERNEL ?= $(shell uname -s)

# On Mac OSX, in order to use `|` and other regular expression operators, we need to use enhanced regular expression syntax (-E); see https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man7/re_format.7.html#//apple_ref/doc/man/7/re_format.

ifeq ($(KERNEL), Darwin)
	find_kernel_prefix := -E
else
	find_kernel_prefix :=
endif

# Define a suffix for pretty printing results as a list:
find_print_tests_fixtures_list := -exec printf '%s\n' {} \;

# Define the command flags:
FIND_TESTS_FIXTURES_FLAGS ?= \
	-name "$(TESTS_FIXTURES_PATTERN)" \
	-path "$(ROOT_DIR)/**/$(TESTS_FIXTURES_FOLDER)/**" \
	-regex "$(TESTS_FIXTURES_FILTER)" \
	-not -path "$(ROOT_DIR)/.*" \
	-not -path "$(NODE_MODULES)/*" \
	-not -path "$(TOOLS_DIR)/*" \
	-not -path "$(BUILD_DIR)/*" \
	-not -path "$(REPORTS_DIR)/*"

ifneq ($(KERNEL), Darwin)
	FIND_TESTS_FIXTURES_FLAGS := -regextype posix-extended $(FIND_TESTS_FIXTURES_FLAGS)
endif

# Define the list of files:
TESTS_FIXTURES ?= $(shell find $(find_kernel_prefix) $(ROOT_DIR) $(FIND_TESTS_FIXTURES_FLAGS))


# TARGETS #

# List test fixture files.
#
# This target prints a newline-delimited list of test fixture files.

list-tests-fixtures:
	$(QUIET) find $(find_kernel_prefix) $(ROOT_DIR) $(FIND_TESTS_FIXTURES_FLAGS) $(find_print_tests_fixtures_list)

.PHONY: list-tests-fixtures
