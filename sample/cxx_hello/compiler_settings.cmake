find_package(Threads)

set(cxx_base_flags "${cxx_base_flags} -Wall -Wshadow")
set(cxx_base_flags "${cxx_base_flags} -Wextra")
set(cxx_base_flags "${cxx_base_flags} -Werror")

function(cxx_library_with_flags name type flags libs)
  add_library(${name} ${type} ${ARGN})
  if (flags)
    set_target_properties(${name}
      PROPERTIES
      COMPILE_FLAGS "${flags}"
      LINK_FLAGS "")
  endif()
  foreach(lib "${libs}")
    target_link_libraries(${name} ${lib})
  endforeach()
#  install(TARGETS ${name} DESTINATION lib)
endfunction()

function(cxx_static_library name libs)
  cxx_library_with_flags(${name} STATIC "${cxx_base_flags}" "${libs}" ${ARGN})
endfunction()

function(cxx_shared_library name libs)
  cxx_library_with_flags(${name} SHARED "${cxx_base_flags}" "${libs}" ${ARGN})
endfunction()

function(cxx_executable_with_flags name flags libs)
  add_executable(${name} ${ARGN})
  if (flags)
    set_target_properties(${name}
      PROPERTIES
      COMPILE_FLAGS "${flags}")
  endif()
  foreach (lib "${libs}")
    target_link_libraries(${name} ${lib})
  endforeach()
endfunction()

function(cxx_executable name libs)
  cxx_executable_with_flags(${name} "${cxx_base_flags}" "${libs}" ${ARGN})
endfunction()

function(cxx_test_with_flags name flags libs)
  cxx_executable_with_flags(${name} "${flags}" "${libs}" ${ARGN})
  target_link_libraries(${name} ${CMAKE_THREAD_LIBS_INIT})
  target_link_libraries(${name} gmock_main)
  add_test(${name} ${name})
endfunction()

function(cxx_test name libs)
  cxx_test_with_flags("${name}" "${cxx_base_flags}" "${libs}" ${ARGN})
endfunction()

function(include_parent_directories)
  get_directory_property(dir PARENT_DIRECTORY)
  while(dir)
    include_directories(${dir})
    get_directory_property(dir ${dir} PARENT_DIRECTORY)
  endwhile()
endfunction()
