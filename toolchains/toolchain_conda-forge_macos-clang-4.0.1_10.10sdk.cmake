# Toolchain for conda/conda-forge macOS pseudo cross compilers (circa May, 2019)
#   - clang 4.0.1
#   - macOS 10.10 SDK

# Tested on macOS 10.11.6 host using CMake 3.14.3

# TOOLCHAIN_PREFIX env var is REQUIRED!
# For Qt Creator, setting this as a CMake var doesn't get recognized during toolchain loading
if(EXISTS "$ENV{TOOLCHAIN_PREFIX}")
  set(_tc_prefix                "$ENV{TOOLCHAIN_PREFIX}")
  message(STATUS "Conda clang TOOLCHAIN_PREFIX env var = ${_tc_prefix}")
else()
  message(STATUS "Conda clang TOOLCHAIN_PREFIX env var = $ENV{TOOLCHAIN_PREFIX}")
  message(FATAL_ERROR "No TOOLCHAIN_PREFIX env var set or its directory does not exist.")
endif()

# Configure local variables
# Compilation tools target (default for conda is Mac OS X 10.9)
set(_tc_target                  "x86_64-apple-darwin13.4.0")
# Target OS/SDK
set(_sdk_ver                    "10.10")
#   /opt is a 'standard' location for macOS SDKs and conda builds
set(_sdk_path                   "/opt/MacOSX${_sdk_ver}.sdk")
set(_darwin_ver                 "14.0.0")
set(_darwin_target              "x86_64-apple-darwin${_darwin_ver}")

# Target system (cross compile)
# Qt is compiled against 10.10 SDK, even though most everything else is 10.9 (i.e. darwin13.4.0)
set(CMAKE_SYSTEM                "Darwin-${_darwin_ver}")
set(CMAKE_SYSTEM_NAME           "Darwin")
set(CMAKE_SYSTEM_VERSION        "${_darwin_ver}")
set(CMAKE_SYSTEM_PROCESSOR      "x86_64")

# BIN utils (CMakeFindBinUtils.cmake)
SET(CMAKE_AR                    "${_tc_prefix}/bin/${_tc_target}-ar" CACHE FILEPATH "Archiver")
SET(CMAKE_RANLIB                "${_tc_prefix}/bin/${_tc_target}-ranlib" CACHE FILEPATH "Ranlib")
SET(CMAKE_LINKER                "${_tc_prefix}/bin/${_tc_target}-ld")
SET(CMAKE_NM                    "${_tc_prefix}/bin/${_tc_target}-nm")
SET(CMAKE_STRIP                 "${_tc_prefix}/bin/${_tc_target}-strip")
set(CMAKE_INSTALL_NAME_TOOL     "${_tc_prefix}/bin/${_tc_target}-install_name_tool")

# Compilers
SET(CMAKE_C_COMPILER            "${_tc_prefix}/bin/${_tc_target}-clang")
set(CMAKE_C_COMPILER_TARGET     "${_sdk_target}")
SET(CMAKE_C_COMPILER_AR         "${_tc_prefix}/bin/${_tc_target}-ar" CACHE FILEPATH "C Archiver")
SET(CMAKE_C_COMPILER_RANLIB     "${_tc_prefix}/bin/${_tc_target}-ranlib" CACHE FILEPATH "C Ranlib")
SET(CMAKE_CXX_COMPILER          "${_tc_prefix}/bin/${_tc_target}-clang++")
set(CMAKE_CXX_COMPILER_TARGET   "${_sdk_target}")
SET(CMAKE_CXX_COMPILER_AR       "${_tc_prefix}/bin/${_tc_target}-ar" CACHE FILEPATH "C++ Archiver")
SET(CMAKE_CXX_COMPILER_RANLIB   "${_tc_prefix}/bin/${_tc_target}-ranlib" CACHE FILEPATH "C++ Ranlib")

# LLVM
# (leave undefined for now)
# set(CMAKE_OBJCOPY               "")
# set(CMAKE_OBJDUMP               "${_tc_prefix}/bin/llvm-objdump")

# SDK
set(CMAKE_OSX_DEPLOYMENT_TARGET "${_sdk_ver}" CACHE STRING "macOS Target")
set(CMAKE_OSX_SYSROOT           "${_sdk_path}")

# Preprocessor flags
set(ENV{CPPFLAGS}               "$ENV{CPPFLAGS} -D_FORTIFY_SOURCE=2 -mmacosx-version-min=${_sdk_ver}")

# C flags
set(CMAKE_C_FLAGS               "${CMAKE_C_FLAGS} -march=core2 -mtune=haswell -mssse3 -ftree-vectorize -m64 -fPIC -fPIE -fstack-protector-strong -O2 -pipe" CACHE STRING "Flags used by the C compiler during all build types.")

# CXX flags
set(CMAKE_CXX_FLAGS             "${CMAKE_CXX_FLAGS} -march=core2 -mtune=haswell -mssse3 -ftree-vectorize  -m64 -fPIC -fPIE -fstack-protector-strong -O2 -pipe -stdlib=libc++ -fvisibility-inlines-hidden -std=c++14 -fmessage-length=0" CACHE STRING "Flags used by the CXX compiler during all build types.")

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS      "${CMAKE_EXE_LINKER_FLAGS} -pie -headerpad_max_install_names -mmacosx-version-min=${_sdk_ver} -Qunused-arguments" CACHE STRING "Flags used by the linker during all build types.")
set(CMAKE_MODULE_LINKER_FLAGS   "${CMAKE_MODULE_LINKER_FLAGS} -headerpad_max_install_names -mmacosx-version-min=${_sdk_ver} -Qunused-arguments" CACHE STRING "Flags used by the linker during the creation of modules during all build types.")
set(CMAKE_SHARED_LINKER_FLAGS   "${CMAKE_SHARED_LINKER_FLAGS} -headerpad_max_install_names -mmacosx-version-min=${_sdk_ver} -Qunused-arguments" CACHE STRING "Flags used by the linker during the creation of shared libraries during all build types.")
# -dead_strip_dylibs

# Finding
set(CMAKE_FIND_FRAMEWORK        "LAST" CACHE STRING "How to try to find frameworks")

# Constant environment variables
set(ENV{AS}                     "${_tc_prefix}/bin/${_tc_target}-as")
set(ENV{CHECKSYMS}              "${_tc_prefix}/bin/${_tc_target}-checksyms")
set(ENV{CODESIGN_ALLOCATE}      "${_tc_prefix}/bin/${_tc_target}-codesign_allocate")
set(ENV{INDR}                   "${_tc_prefix}/bin/${_tc_target}-indr")
set(ENV{LIBTOOL}                "${_tc_prefix}/bin/${_tc_target}-libtool")
set(ENV{LIPO}                   "${_tc_prefix}/bin/${_tc_target}-lipo")
set(ENV{NMEDIT}                 "${_tc_prefix}/bin/${_tc_target}-nmedit")
set(ENV{OTOOL}                  "${_tc_prefix}/bin/${_tc_target}-otool")
set(ENV{PAGESTUFF}              "${_tc_prefix}/bin/${_tc_target}-pagestuff")
set(ENV{REDO_PREBINDING}        "${_tc_prefix}/bin/${_tc_target}-redo_prebinding")
set(ENV{SEGEDIT}                "${_tc_prefix}/bin/${_tc_target}-segedit")
set(ENV{SEG_ADDR_TABLE}         "${_tc_prefix}/bin/${_tc_target}-seg_addr_table")
set(ENV{SEG_HACK}               "${_tc_prefix}/bin/${_tc_target}-seg_hack")
set(ENV{SIZE}                   "${_tc_prefix}/bin/${_tc_target}-size")
set(ENV{STRINGS}                "${_tc_prefix}/bin/${_tc_target}-strings")

# Old fix for conda-forge M4
# set(ENV{M4}                     "${_tc_prefix}/bin/m4")
