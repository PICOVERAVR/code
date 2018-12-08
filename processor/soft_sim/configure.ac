#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([fives], [0.2])
AC_CONFIG_SRCDIR([src/])
AC_CONFIG_HEADERS([config.h]) # used to be config.h

# Checks for programs.
AM_INIT_AUTOMAKE([subdir-objects])
AC_PROG_CC

# Checks for libraries.
PKG_CHECK_MODULES([CHECK], [check >= 0.9.10])

# Checks for header files.
AC_CHECK_HEADERS([stdint.h stdlib.h string.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_TYPE_INT16_T
AC_TYPE_INT8_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_TYPE_UINT8_T

# I'm assuming global compiler flags go here and more specific ones go in correct Makefile
# Need to find a way to check these without using AX_CHECK_COMPILE_FLAG
CFLAGS="-g -Wall -Wextra -Og"

# Checks for library functions.
AC_FUNC_MALLOC
AC_CHECK_FUNCS([memset])

AC_CONFIG_FILES([Makefile
                 src/Makefile
		 test/Makefile])
AC_PROG_CC_C99
AC_OUTPUT

echo "
${PACKAGE_NAME} ${PACKAGE_VERSION} located in ${prefix}.
"
