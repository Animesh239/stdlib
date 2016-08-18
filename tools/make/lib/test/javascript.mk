
# VARIABLES #

# Define the Node environment:
NODE_ENV_TEST ?= $(NODE_ENV)

# Define the Node path:
NODE_PATH_TEST ?= $(NODE_PATH)

# Define the test runner to use when running JavaScript tests:
JAVASCRIPT_TEST_RUNNER ?= tape


# DEPENDENCIES #

ifeq ($(JAVASCRIPT_TEST_RUNNER), tape)
	include $(TOOLS_MAKE_LIB_DIR)/test/tape.mk
endif


# TARGETS #

# Run JavaScript unit tests.
#
# This target runs JavaScript unit tests using a specified test runner and pipes TAP output to a reporter which is expected to be [tap-spec][1].
#
# To install tap-spec:
#     $ npm install tap-spec
#
# [1]: https://github.com/scottcorgan/tap-spec

test-javascript: test-javascript-local

.PHONY: test-javascript


# Run JavaScript unit tests locally.
#
# This target runs JavaScript unit tests locally.

test-javascript-local: $(NODE_MODULES)
	$(QUIET) for test in $(TESTS); do \
		echo ''; \
		echo "Running test: $$test"; \
		NODE_ENV=$(NODE_ENV_TEST) \
		NODE_PATH=$(NODE_PATH_TEST) \
		$(JAVASCRIPT_TEST) \
			$(JAVASCRIPT_TEST_FLAGS) \
			$$test \
		| $(TAP_REPORTER) || exit 1; \
	done

.PHONY: test-javascript-local


# Generate a JavaScript test summary.
#
# This target runs JavaScript unit tests and aggregates TAP output as a test summary. The test summary is expected to be generated by [tap-summary][1].
#
# To install tap-summary:
#      $ npm install tap-summary
#
# [1]: https://github.com/zoubin/tap-summary

test-javascript-summary: $(NODE_MODULES)
	$(QUIET) for test in $(TESTS); do \
		echo ''; \
		echo "Running test: $$test"; \
		NODE_ENV=$(NODE_ENV_TEST) \
		NODE_PATH=$(NODE_PATH_TEST) \
		$(JAVASCRIPT_TEST) \
			$(JAVASCRIPT_TEST_FLAGS) \
			$$test \
		| $(TAP_SUMMARY) || exit 1; \
	done

.PHONY: test-javascript-summary
