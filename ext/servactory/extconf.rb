# frozen_string_literal: true

require "mkmf"

# Add any special configuration for your C extension here
# For example:
# $CFLAGS << " -Wall -Wextra -Werror"

# Creates a Makefile for compiling the C extension
create_makefile("servactory/servactory")
