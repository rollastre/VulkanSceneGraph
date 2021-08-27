#
# macros provided by the vsg library
#

# set directory where vsgMacros.cmake is located
# VSG_MACROS_INSTALLED is defined in src/vsg/vsgConfig.cmake.in
if(NOT VSG_MACROS_INSTALLED)
    set(VSG_MACROS_DIR ${CMAKE_SOURCE_DIR})
endif()
message(STATUS "Reading 'vsg_...' macros from ${VSG_MACROS_DIR}/vsgMacros.cmake - look there for documentation")

#
# setup build related variables
#
macro(setup_build_vars)
    set(CMAKE_DEBUG_POSTFIX "d" CACHE STRING "add a postfix, usually d on windows")
    set(CMAKE_RELEASE_POSTFIX "" CACHE STRING "add a postfix, usually empty on windows")
    set(CMAKE_RELWITHDEBINFO_POSTFIX "rd" CACHE STRING "add a postfix, usually empty on windows")
    set(CMAKE_MINSIZEREL_POSTFIX "s" CACHE STRING "add a postfix, usually empty on windows")

    # Change the default build type to Release
    if(NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel." FORCE)
    endif(NOT CMAKE_BUILD_TYPE)

    if(CMAKE_COMPILER_IS_GNUCXX)
        set(VSG_WARNING_FLAGS -Wall -Wparentheses -Wno-long-long -Wno-import -Wreturn-type -Wmissing-braces -Wunknown-pragmas -Wmaybe-uninitialized -Wshadow -Wunused -Wno-misleading-indentation -Wextra)
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(VSG_WARNING_FLAGS -Wall -Wparentheses -Wno-long-long -Wno-import -Wreturn-type -Wmissing-braces -Wunknown-pragmas -Wshadow -Wunused -Wextra)
    endif()

    set(VSG_WARNING_FLAGS ${VSG_WARNING_FLAGS} CACHE STRING "Compiler flags to use." FORCE)
    add_compile_options(${VSG_WARNING_FLAGS})

    # set upper case <PROJECT>_VERSION_... variables
    string(TOUPPER ${PROJECT_NAME} UPPER_PROJECT_NAME)
    set(${UPPER_PROJECT_NAME}_VERSION ${PROJECT_VERSION})
    set(${UPPER_PROJECT_NAME}_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
    set(${UPPER_PROJECT_NAME}_VERSION_MINOR ${PROJECT_VERSION_MINOR})
    set(${UPPER_PROJECT_NAME}_VERSION_PATCH ${PROJECT_VERSION_PATCH})
endmacro()

#
# setup directory related variables
#
macro(setup_dir_vars)
    set(OUTPUT_BINDIR ${PROJECT_BINARY_DIR}/bin)
    set(OUTPUT_LIBDIR ${PROJECT_BINARY_DIR}/lib)

    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_LIBDIR})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_BINDIR})

    include(GNUInstallDirs)

    if(WIN32)
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_BINDIR})
        # set up local bin directory to place all binaries
        make_directory(${OUTPUT_BINDIR})
        make_directory(${OUTPUT_LIBDIR})
        set(INSTALL_TARGETS_DEFAULT_FLAGS
            EXPORT ${PROJECT_NAME}Targets
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_BINDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
        )
    else()
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_LIBDIR})
        # set up local bin directory to place all binaries
        make_directory(${OUTPUT_LIBDIR})
        set(INSTALL_TARGETS_DEFAULT_FLAGS
            EXPORT ${PROJECT_NAME}Targets
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
    endif()
endmacro()

#
# add feature summary
#
macro(add_feature_summary)
    include(FeatureSummary)
    feature_summary(WHAT ALL)
endmacro()

#
# add 'MAINTAINER' option
#
# available arguments:
#
#    PREFIX    prefix for branch and tag name
#    RCLEVEL   release candidate level
#
# added cmake targets:
#
#    tag-run      create a tag in the git repository with name <prefix>-<major>.<minor>.<patch>
#    branch-run   create a branch in the git repository with name <prefix>-<major>.<minor>
#    tag-test     show the command to create a tag in the git repository
#    branch-test  show the command to create a branch in the git repository
#
macro(add_option_maintainer)
    set(options)
    set(oneValueArgs PREFIX RCLEVEL)
    set(multiValueArgs)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    option(MAINTAINER "Enable maintainer build methods, such as making git branches and tags." OFF)
    if(MAINTAINER)

        #
        # Provide target for tagging a release
        #
        set(VSG_BRANCH ${ARGS_PREFIX}-${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR})

        set(GITCOMMAND git -C ${CMAKE_SOURCE_DIR})
        set(ECHO ${CMAKE_COMMAND} -E echo)
        set(REMOTE origin)

        if(ARGS_RCLEVEL EQUAL 0)
            set(RELEASE_NAME ${ARGS_PREFIX}-${PROJECT_VERSION})
        else()
            set(RELEASE_NAME ${ARGS_PREFIX}-${PROJECT_VERSION}-rc${ARGS_RCLEVEL})
        endif()

        set(RELEASE_MESSAGE "Release ${RELEASE_NAME}")
        set(BRANCH_MESSAGE "Branch ${VSG_BRANCH}")

        add_custom_target(tag-test
            COMMAND ${ECHO} ${GITCOMMAND} tag -a ${RELEASE_NAME} -m \"${RELEASE_MESSAGE}\"
            COMMAND ${ECHO} ${GITCOMMAND} push ${REMOTE} ${RELEASE_NAME}
        )

        add_custom_target(tag-run
            COMMAND ${GITCOMMAND} tag -a ${RELEASE_NAME} -m "${RELEASE_MESSAGE}"
            COMMAND ${GITCOMMAND} push ${REMOTE} ${RELEASE_NAME}
        )

        add_custom_target(branch-test
            COMMAND ${ECHO} ${GITCOMMAND} branch ${VSG_BRANCH}
            COMMAND ${ECHO} ${GITCOMMAND} push ${REMOTE} ${VSG_BRANCH}
        )

        add_custom_target(branch-run
            COMMAND ${GITCOMMAND} branch ${VSG_BRANCH}
            COMMAND ${GITCOMMAND} push ${REMOTE} ${VSG_BRANCH}
        )

    endif()
endmacro()

#
# add 'clang-format' build target to enforce a standard code style guide.
#
# available arguments:
#
#    FILES      list with file names or file name pattern
#    EXCLUDES   list with file names to exclude from the list
#               given by the FILES argument
#
macro(add_target_clang_format)
    set(options)
    set(oneValueArgs )
    set(multiValueArgs FILES EXCLUDE)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    find_program(CLANGFORMAT clang-format)
    if (CLANGFORMAT)
        file(GLOB FILES_TO_FORMAT
            ${ARGS_FILES}
        )
        foreach(EXCLUDE ${ARGS_EXCLUDES})
            list(REMOVE_ITEM FILES_TO_FORMAT ${EXCLUDE})
        endforeach()
        add_custom_target(clang-format
            COMMAND ${CLANGFORMAT} -i ${FILES_TO_FORMAT}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Automated code format using clang-format"
        )
    endif()
endmacro()

#
# add 'clobber' build target to clear all the non git registered files/directories
#
macro(add_target_clobber)
    add_custom_target(clobber
        COMMAND git -C ${CMAKE_SOURCE_DIR} clean -d -f -x
    )
endmacro()

#
# add 'cppcheck' build target to provide static analysis of codebase
#
# available arguments:
#
#    FILES             list with file names or file name pattern
#    SUPPRESSIONS_LIST filename for list with suppressions (optional)
#
# used global cmake variables:
#
#    CPPCHECK_EXTRA_OPTIONS - add extra options to cppcheck command line
#
macro(add_target_cppcheck)
    set(options)
    set(oneValueArgs SUPPRESSIONS_LIST)
    set(multiValueArgs FILES)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    find_program(CPPCHECK cppcheck)
    if (CPPCHECK)
        file(RELATIVE_PATH PATH_TO_SOURCE ${PROJECT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR} )
        if (PATH_TO_SOURCE)
            set(PATH_TO_SOURCE "${PATH_TO_SOURCE}/")
        endif()

        include(ProcessorCount)
        ProcessorCount(CPU_CORES)

        if(ARGS_SUPPRESSIONS_LIST)
            set(SUPPRESSION_LIST "--suppressions-list=${ARGS_SUPPRESSIONS_LIST}")
        endif()
        set(CPPCHECK_EXTRA_OPTIONS "" CACHE STRING "additional commandline options to use when invoking cppcheck")
        add_custom_target(cppcheck
            COMMAND ${CPPCHECK} -j ${CPU_CORES} --quiet --enable=style --language=c++
                ${CPPCHECK_EXTRA_OPTIONS}
                ${SUPPRESSION_LIST}
                ${ARGS_FILES}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Static code analysis using cppcheck"
        )
    endif()
endmacro()

#
# add 'docs' build target
#
# available arguments:
#
#    FILES      list with file or directory names
#
macro(add_target_docs)
    set(options)
    set(oneValueArgs )
    set(multiValueArgs FILES)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # create doxygen build target
    find_package(Doxygen QUIET)
    if (DOXYGEN_FOUND)
        set(DOXYGEN_GENERATE_HTML YES)
        set(DOXYGEN_GENERATE_MAN NO)

        doxygen_add_docs(
            docs
            ${ARGS_FILES}
            COMMENT "Use doxygen to Generate html documentaion"
        )
    endif()
endmacro()

#
# add 'uninstall' build target
#
macro(add_target_uninstall)
    if(VSG_MACROS_INSTALLED)
        set(DIR ${VSG_MACROS_DIR})
    else()
        set(DIR ${CMAKE_SOURCE_DIR}/build)
    endif()
    add_custom_target(uninstall
        COMMAND ${CMAKE_COMMAND} -P ${DIR}/uninstall.cmake
    )
    # install file for client packages if running in vsg repo
    if(NOT VSG_MACROS_INSTALLED)
        install(FILES ${CMAKE_SOURCE_DIR}/build/uninstall.cmake DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/vsg)
    endif()
endmacro()
