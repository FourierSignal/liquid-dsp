# CMake Lists for liquid-dsp

# This is shamelessly based on the work by quiet

# https://github.com/quiet/quiet-dsp/blob/win/CMakeLists.txt

# This must ALWAYS be the first (non comment/empty) line on a CMake file
cmake_minimum_required(VERSION 3.0)

# Declare project name
project(liquiddsp C CXX)

# Read the project's version num. from the .h
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/include/liquid.h" liquid_h)
string(REGEX MATCH "\\#define LIQUID_VERSION[ ]+\"([0-9]+\\.[0-9]+\\.[0-9]+)\""
             LIQUID_VERSION_MATCHES "${liquid_h}")
if(NOT LIQUID_VERSION_MATCHES)
  message(FATAL_ERROR "Failed to extract version number from liquid.h")
endif(NOT LIQUID_VERSION_MATCHES)
set(LIQUID_VERSION ${CMAKE_MATCH_1})

message("-- Configuring for liquid-dsp ${LIQUID_VERSION}")

# Check X-compilation
if(CMAKE_CROSSCOMPILING AND NOT HOST_C_COMPILER)
  message(
    FATAL_ERROR
      "Please, define HOST_C_COMPILER to the path of the host C compiler.")
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
                      "${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules")

# Load up the macro functions
include(CheckCPUID)
include(CheckIncludeFile)
include(CheckLibraryExists)
include(CheckRequiredFunction)
include(CheckTypeSize)
include(LiquidBuildSamples)
include(FindPackageHandleStandardArgs)

# Include source directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR}/include)

# Build options
option(LIQUID_FFTOVERRIDE "Force internal FFT even if libfftw is available" OFF)
option(LIQUID_SIMDOVERRIDE "Force overriding of SIMD (use portable C code)" OFF)
# TODO: Change this to build targets as build targets
option(LIQUID_BUILD_SHARED "Build shared library" ON)
option(LIQUID_BUILD_STATIC "Build static library" ON)
option(LIQUID_BUILD_EXAMPLES "Build examples" OFF)
option(LIQUID_BUILD_SANDBOX "Build sandbox" OFF)
# X-compilation options
option(LIQUID_FORCE_X86_MMX "Force MMX (useful for cross-compiling)" OFF)
option(LIQUID_FORCE_X86_SSE "Force SSE (useful for cross-compiling)" OFF)
option(LIQUID_FORCE_X86_SSE2 "Force SSE2 (useful for cross-compiling)" OFF)
option(LIQUID_FORCE_X86_SSE3 "Force SSE3 (useful for cross-compiling)" OFF)
option(LIQUID_FORCE_X86_SSSE3 "Force SSSE3 (useful for cross-compiling)" OFF)
option(LIQUID_FORCE_X86_SSE41 "Force SSE4.1 (useful for cross-compiling)" OFF)
option(LIQUID_FORCE_X86_SSE42 "Force SSE4.2 (useful for cross-compiling)" OFF)
option(LIQUID_FORCE_X86_AVX "Force AVX (useful for cross-compiling)" OFF)
option(LIQUID_FORCE_PPC_ALTIVEC "Force AltiVec (useful for cross-compiling)"
       OFF)
option(LIQUID_FORCE_ARM_NEON "Force NEON (useful for cross-compiling)" OFF)
option(LIQUID_FORCE_ARM64_NEON
       "Force AArch64 NEON (useful for cross-compiling)" OFF)
option(LIQUID_CXX "Compile in C++ mode. Always on for Windows/MSVC." OFF)

# Check necessary files
check_include_file(sys/resource.h HAVE_SYS_RESOURCE_H)

check_include_file(complex.h HAVE_COMPLEX_H)
check_include_file(float.h HAVE_FLOAT_H)
check_include_file(getopt.h HAVE_GETOPT_H)
check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(memory.h HAVE_MEMORY_H)
check_include_file(unistd.h HAVE_UNISTD_H)

check_include_file(mmintrin.h HAVE_MMINTRIN_H)
check_include_file(emmintrin.h HAVE_EMMINTRIN_H)
check_include_file(immintrin.h HAVE_IMMINTRIN_H)
check_include_file(pmmintrin.h HAVE_PMMINTRIN_H)
check_include_file(smmintrin.h HAVE_SMMINTRIN_H)
check_include_file(tmmintrin.h HAVE_TMMINTRIN_H)
check_include_file(xmmintrin.h HAVE_XMMINTRIN_H)

# Check types
check_type_size(int SIZEOF_INT)
check_type_size("unsigned int" SIZEOF_UNSIGNED_INT)

# Check mathematics
check_required_function("sinf sin" m HAVE_SINF)
check_required_function("cosf cos" m HAVE_COSF)
check_required_function("expf exp" m HAVE_EXPF)
check_required_function(cargf m HAVE_CARGF)
check_required_function(cexpf m HAVE_CEXPF)
check_required_function(crealf m HAVE_CREALF)
check_required_function(cimagf m HAVE_CIMAGF)
check_required_function("sqrtf sqrt" m HAVE_SQRTF)

check_library_exists(m sqrtf "" HAVE_LIBM)
check_function_exists(sinf HAVE_SINGLE_FP)
if(NOT HAVE_SINGLE_FP)
  unset(HAVE_SINGLE_FP CACHE)
  check_library_exists(m sinf "" HAVE_SINGLE_FP)
endif()

# Look for optinal FEC library
find_path(fec_include NAMES fec.h)
find_library(fec_library NAMES fec)
find_package_handle_standard_args(Fec DEFAULT_MSG fec_library fec_include)
mark_as_advanced(fec_include fec_library)
if(FEC_FOUND)
  set(HAVE_FEC_H 1)
  set(HAVE_LIBFEC 1)
  add_library(fec UNKNOWN IMPORTED)
  set_target_properties(
    fec
    PROPERTIES IMPORTED_LOCATION "${fec_library}" INTERFACE_INCLUDE_DIRECTORIES
                                                  "${fec_include}")
else()
  unset(HAVE_FEC_H CACHE)
endif()
# TODO: Download it is forced needed

# Look for optional FFTW3
find_path(fftw3_include NAMES fftw3.h)
find_library(fftw3_library NAMES fftw3f)
find_package_handle_standard_args(Fftw3 DEFAULT_MSG fftw3_library fftw3_include)
mark_as_advanced(fftw3_include fftw3_library)
if(FFTW3_FOUND)
  set(HAVE_FFTW3_H 1)
  add_library(fftw3f UNKNOWN IMPORTED)
  set_target_properties(
    fftw3f
    PROPERTIES IMPORTED_LOCATION "${fftw3_library}"

               INTERFACE_INCLUDE_DIRECTORIES "${fftw3_include}")
else()
  unset(HAVE_FFTW3_H CACHE)
endif()
# TODO: Download it is forced needed

# Now check stuff
check_cpuid("mmx" HAVE_MMX ${LIQUID_FORCE_X86_MMX})
check_cpuid("sse" HAVE_SSE ${LIQUID_FORCE_X86_SSE})
check_cpuid("sse2" HAVE_SSE2 ${LIQUID_FORCE_X86_SSE2})
check_cpuid("sse3" HAVE_SSE3 ${LIQUID_FORCE_X86_SSE3})
check_cpuid("ssse3" HAVE_SSSE3 ${LIQUID_FORCE_X86_SSSE3})
check_cpuid("sse41" HAVE_SSE41 ${LIQUID_FORCE_X86_SSE41})
check_cpuid("sse42" HAVE_SSE42 ${LIQUID_FORCE_X86_SSE42})
check_cpuid("avx" HAVE_AVX ${LIQUID_FORCE_X86_AVX})
check_cpuid("vmx" HAVE_ALTIVEC ${LIQUID_FORCE_PPC_ALTIVEC})
check_cpuid("neon" HAVE_NEON ${LIQUID_FORCE_ARM_NEON})
check_cpuid("neon64" HAVE_NEON64 ${LIQUID_FORCE_ARM64_NEON})

# Usual path separator. If WIND32 this will be changed
set(OS_PATH_SEP "/")

# Different options depending on the system
if(CMAKE_C_COMPILER_ID MATCHES "GNU" OR CMAKE_C_COMPILER_ID MATCHES "Clang")
  if(HAVE_AVX)
    set(_EXTRA_C_FLAGS "-mavx")
  elseif(HAVE_SSE42)
    set(_EXTRA_C_FLAGS "-msse4.2")
  elseif(HAVE_SSE41)
    set(_EXTRA_C_FLAGS "-msse4.1")
  elseif(HAVE_SSSE3)
    set(_EXTRA_C_FLAGS "-mssse3")
  elseif(HAVE_SSE3)
    set(_EXTRA_C_FLAGS "-msse3")
  elseif(HAVE_SSE2)
    set(_EXTRA_C_FLAGS "-msse2")
  elseif(HAVE_SSE)
    set(_EXTRA_C_FLAGS "-msse")
  elseif(HAVE_MMX)
    set(_EXTRA_C_FLAGS "-mmmx")
  elseif(HAVE_ALTIVEC)
    if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
      set(_EXTRA_C_FLAGS "-fno-common -faltivec")
    else()
      set(_EXTRA_C_FLAGS "-maltivec")
    endif()
  elseif(HAVE_NEON)
    set(_EXTRA_C_FLAGS "-mfpu=neon-vfpv4")
  elseif(HAVE_NEON64)
    # No extra flags needed
  endif()
  set(_EXTRA_C_FLAGS "${_EXTRA_C_FLAGS} -ffast-math")

  if(LIQUID_CXX)
    set(CMAKE_CXX_FLAGS "-DLIQUID_BUILD_CPLUSPLUS -Werror=vla")
    if(CMAKE_C_COMPILER_ID MATCHES "Clang")
      add_definitions("-x c++")
    endif()
  endif()
elseif(CMAKE_C_COMPILER_ID MATCHES "MSVC")
  set(LIQUID_CXX ON)
  # for now, simd doesnt work on msvc because of gcc builtin usage
  set(LIQUID_SIMDOVERRIDE ON)
  set(_EXTRA_C_FLAGS "/wd4003 /DLIQUID_BUILD_CPLUSPLUS")
  set(OS_PATH_SEP "\\")

  # we use our custom getopt here since windows lacks getopt.h
  include_directories(${CMAKE_CURRENT_SOURCE_DIR}/external/getopt)
  set(GETOPT_SOURCES external/getopt/getopt.c)
  add_library(getopt STATIC ${GETOPT_SOURCES})
  set(GETOPT_LIBRARY getopt)
endif()

# Check if we're in C++ mode
if(LIQUID_CXX)
  # Not presently supported in c++ mode
  set(LIQUID_BUILD_EXAMPLES OFF)
  set(LIQUID_BUILD_SANDBOX OFF)
endif()

# Now sources are set on the sources.cmake file (because it's 500 lines long)
include(cmake/sources.cmake)

# Generate the config.h file
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/config.h.cmake
               ${CMAKE_CURRENT_BINARY_DIR}/include/config.h)

# Finally put the lib together
set(liquid_SOURCES
    src/libliquid.c
    ${agc_SOURCES}
    ${audio_SOURCES}
    ${buffer_SOURCES}
    ${channel_SOURCES}
    ${dotprod_SOURCES}
    ${equalization_SOURCES}
    ${fec_SOURCES}
    ${fft_SOURCES}
    ${filter_SOURCES}
    ${framing_SOURCES}
    ${math_SOURCES}
    ${matrix_SOURCES}
    ${modem_SOURCES}
    ${multichannel_SOURCES}
    ${nco_SOURCES}
    ${optim_SOURCES}
    ${quantization_SOURCES}
    ${random_SOURCES}
    ${sequence_SOURCES}
    ${utility_SOURCES}
    ${vector_SOURCES})
if(LIQUID_CXX)
  set_source_files_properties(${liquid_SOURCES} PROPERTIES LANGUAGE CXX)
endif()

if(NOT LIQUID_BUILD_SHARED AND NOT LIQUID_BUILD_STATIC)
  message(
    FATAL_ERROR "Please, define LIQUID_BUILD_SHARED and/or LIQUID_BUILD_STATIC."
  )
endif()

# Shared lib logic
if(LIQUID_BUILD_SHARED)
  add_library(liquid-shared SHARED ${liquid_SOURCES})
  if(HAVE_LIBM)
    target_link_libraries(liquid-shared m)
  endif()
  if(FEC_FOUND)
    target_link_libraries(liquid-shared fec)
  endif()
  if(NOT LIQUID_FFTOVERRIDE AND FFTW3_FOUND)
    target_link_libraries(liquid-shared fftw3f)
  endif()
  set_property(TARGET liquid-shared PROPERTY OUTPUT_NAME "liquid")
  set_property(TARGET liquid-shared PROPERTY SOVERSION "${LIQUID_VERSION}")
  set_property(TARGET liquid-shared PROPERTY COMPILE_FLAGS "${_EXTRA_C_FLAGS}")
  set(LIQUID_LIBRARY liquid-shared)
  set(LIQUID_SHARED_LIBRARY liquid-shared)
endif()

# Static lib logic
if(LIQUID_BUILD_STATIC)
  add_library(liquid-static STATIC ${liquid_SOURCES})
  if(HAVE_LIBM)
    target_link_libraries(liquid-static m)
  endif()
  if(FEC_FOUND)
    target_link_libraries(liquid-static fec)
  endif()
  if(NOT LIQUID_FFTOVERRIDE AND FFTW3_FOUND)
    target_link_libraries(liquid-static fftw3f)
  endif()
  set_property(TARGET liquid-static PROPERTY OUTPUT_NAME "liquid")
  set_property(TARGET liquid-static PROPERTY COMPILE_FLAGS "${_EXTRA_C_FLAGS}")

  if(NOT LIQUID_LIBRARY)
    set(LIQUID_LIBRARY liquid-static)
  endif()
  set(LIQUID_STATIC_LIBRARY liquid-static)
endif()

# Build the autoscript tool, needed by autotest and benchmark.
if(CMAKE_CROSSCOMPILING)
  #
  # Cross-compile the tool with the host compiler, the CMake Toolchain file
  # shall define this variable to point to the host compiler.
  #
  add_custom_target(
    autoscript
    COMMAND ${HOST_C_COMPILER} -o autoscript
            "${CMAKE_CURRENT_SOURCE_DIR}/scripts/autoscript.c"
            "${CMAKE_CURRENT_SOURCE_DIR}/scripts/main.c")
else()
  add_executable(autoscript scripts/autoscript.c scripts/main.c)
endif()

# Autotest
set(autotest_ALL_SOURCES
    ${agc_AUTOTESTS_SOURCES}
    ${audio_AUTOTESTS_SOURCES}
    ${buffer_AUTOTESTS_SOURCES}
    ${channel_AUTOTESTS_SOURCES}
    ${dotprod_AUTOTESTS_SOURCES}
    ${equalization_AUTOTESTS_SOURCES}
    ${fec_AUTOTESTS_SOURCES}
    ${fft_AUTOTESTS_SOURCES}
    ${filter_AUTOTESTS_SOURCES}
    ${framing_AUTOTESTS_SOURCES}
    ${math_AUTOTESTS_SOURCES}
    ${matrix_AUTOTESTS_SOURCES}
    ${modem_AUTOTESTS_SOURCES}
    ${multichannel_AUTOTESTS_SOURCES}
    ${nco_AUTOTESTS_SOURCES}
    ${optim_AUTOTESTS_SOURCES}
    ${quantization_AUTOTESTS_SOURCES}
    ${random_AUTOTESTS_SOURCES}
    ${sequence_AUTOTESTS_SOURCES}
    ${utility_AUTOTESTS_SOURCES}
    ${vector_AUTOTESTS_SOURCES})

set(autotest_SOURCES
    autotest/autotest.c autotest/autotestlib.c autotest/null_autotest.c
    ${autotest_ALL_SOURCES} ${autotest_EXTRA_SOURCES})

if(LIQUID_CXX)
  set_source_files_properties(${autotest_SOURCES} PROPERTIES LANGUAGE CXX)
endif()

add_custom_target(
  autotest_include
  COMMAND "$<TARGET_FILE:autoscript>" "${OS_PATH_SEP}" "autotest"
          ${autotest_ALL_SOURCES} >
          "${CMAKE_CURRENT_BINARY_DIR}/autotest_include.h"
  DEPENDS autoscript
  BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/autotest_include.h"
  WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")

add_executable(autotest EXCLUDE_FROM_ALL ${autotest_SOURCES})
set_property(TARGET autotest PROPERTY COMPILE_FLAGS "${_EXTRA_C_FLAGS}")
add_dependencies(autotest autotest_include)
target_link_libraries(autotest ${LIQUID_LIBRARY})
if(GETOPT_LIBRARY)
  target_link_libraries(autotest ${GETOPT_LIBRARY})
endif(GETOPT_LIBRARY)

add_custom_target(
  autotest_run
  COMMAND "$<TARGET_FILE:autotest>"
  DEPENDS autotest
  WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")

# Benchmark

# Benchmark can be built only if sys/resource.h has been found.
if(HAVE_SYS_RESOURCE_H)
  set(benchmark_ALL_SOURCES
      ${agc_BENCHMARKS_SOURCES}
      ${audio_BENCHMARKS_SOURCES}
      ${buffer_BENCHMARKS_SOURCES}
      ${channel_BENCHMARKS_SOURCES}
      ${dotprod_BENCHMARKS_SOURCES}
      ${equalization_BENCHMARKS_SOURCES}
      ${fec_BENCHMARKS_SOURCES}
      ${fft_BENCHMARKS_SOURCES}
      ${filter_BENCHMARKS_SOURCES}
      ${framing_BENCHMARKS_SOURCES}
      ${math_BENCHMARKS_SOURCES}
      ${matrix_BENCHMARKS_SOURCES}
      ${modem_BENCHMARKS_SOURCES}
      ${multichannel_BENCHMARKS_SOURCES}
      ${nco_BENCHMARKS_SOURCES}
      ${optim_BENCHMARKS_SOURCES}
      ${quantization_BENCHMARKS_SOURCES}
      ${random_BENCHMARKS_SOURCES}
      ${sequence_BENCHMARKS_SOURCES}
      ${utility_BENCHMARKS_SOURCES}
      ${vector_BENCHMARKS_SOURCES})

  set(benchmark_SOURCES bench/bench.c ${benchmark_ALL_SOURCES}
                        ${benchmark_EXTRA_SOURCES})

  add_custom_target(
    benchmark_include
    COMMAND "$<TARGET_FILE:autoscript>" "${OS_PATH_SEP}" "benchmark"
            ${benchmark_ALL_SOURCES} >
            "${CMAKE_CURRENT_BINARY_DIR}/benchmark_include.h"
    DEPENDS autoscript
    BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/benchmark_include.h"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")

  add_executable(benchmark EXCLUDE_FROM_ALL ${benchmark_SOURCES})
  add_dependencies(benchmark benchmark_include)
  target_link_libraries(benchmark ${LIQUID_LIBRARY})
else()
  message(
    WARNING
      "Benchmark suite cannot be compiled because sys/resource.h header hasn't been found."
  )
endif()

# Examples
if(LIQUID_BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()

# Sandbox
if(LIQUID_BUILD_SANDBOX)
  add_subdirectory(sandbox)
endif()

# Installation
install(
  TARGETS ${LIQUID_STATIC_LIBRARY} ${LIQUID_SHARED_LIBRARY}
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION "lib${LIB_SUFFIX}"
  LIBRARY DESTINATION "lib${LIB_SUFFIX}")
install(FILES include/liquid.h DESTINATION include/liquid)
