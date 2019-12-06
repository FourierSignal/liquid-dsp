include(CheckFunctionExists)
include(CheckLibraryExists)

macro(check_required_function FUNCTIONS_SPACE LIBRARY VARIABLE)
  string(REPLACE " " ";" FUNCTIONS ${FUNCTIONS_SPACE})
  foreach(FUNCTION ${FUNCTIONS})
    # First try without any library.
    check_function_exists("${FUNCTION}" ${VARIABLE})
    if(NOT ${VARIABLE})
      unset(${VARIABLE} CACHE)
      # Retry with the library specified
      check_library_exists("${LIBRARY}" "${FUNCTION}" "" ${VARIABLE})
    endif()

    if(${VARIABLE})
      break()
    else()
      unset(${VARIABLE} CACHE)
    endif()
  endforeach()
  if(NOT ${VARIABLE})
    list(LENGTH FUNCTIONS functions_length)
    if(functions_length EQUAL 1)
      message(FATAL_ERROR "Required function '${FUNCTIONS}' not found")
    else()
      string(REPLACE " " ", " FUNCTIONS_COMMA ${FUNCTIONS_SPACE})
      message(
        FATAL_ERROR
          "Required function not found, require one of ${FUNCTIONS_COMMA}")
    endif()
  endif()
endmacro()
