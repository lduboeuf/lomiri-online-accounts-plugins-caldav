# this assumes ITS files are located in ${CMAKE_SOURCE_DIR}/its
function(gettext_merge_xml_translations source_files)
    foreach(source_file ${source_files})
        add_custom_target("${source_file}" ALL
                          COMMENT "Merging translations into ${source_file}"
                          COMMAND ${CMAKE_COMMAND} -E env "GETTEXTDATADIRS=${CMAKE_SOURCE_DIR}"
                                  ${GETTEXT_MSGFMT_EXECUTABLE}
                                  --xml
                                  --template=${CMAKE_CURRENT_SOURCE_DIR}/${source_file}.in
                                  -d ${CMAKE_SOURCE_DIR}/po
                                  -o ${source_file}
                          )
    endforeach()
endfunction()

add_subdirectory(plugin)
add_subdirectory(services)
