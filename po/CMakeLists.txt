find_program(GETTEXT_XGETTEXT_EXECUTABLE xgettext)

set(DOMAIN lomiri-online-accounts-plugins-caldav)
set(POT_FILE ${DOMAIN}.pot)

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/LINGUAS LINGUAS
     REGEX "^[^#].*")
string(REGEX MATCHALL "[^ \t]+" LANGS "${LINGUAS}")

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/POTFILES.in
  ${CMAKE_CURRENT_BINARY_DIR}/POTFILES COPYONLY
)

add_custom_target(${POT_FILE} ALL
  COMMENT "Generating translation template"
  COMMAND ${CMAKE_COMMAND} -E env "GETTEXTDATADIRS=${CMAKE_SOURCE_DIR}"
          ${GETTEXT_XGETTEXT_EXECUTABLE} -o ${POT_FILE}
          -D ${CMAKE_SOURCE_DIR}
          -D ${CMAKE_CURRENT_SOURCE_DIR}
          -D ${CMAKE_CURRENT_BINARY_DIR}
          --keyword=_ --keyword=N_
          --keyword=tr --keyword=tr:1,2
          --keyword=dtr:2 --keyword=dtr:2,3
          --package-name='${DOMAIN}'
          --copyright-holder='Ubports Foundation'
          --from-code=utf-8
          --files-from=${CMAKE_CURRENT_BINARY_DIR}/POTFILES)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${POT_FILE}
               ${CMAKE_CURRENT_BINARY_DIR}/${POT_FILE}
               COPYONLY)
foreach(LANG ${LANGS})
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${LANG}.po
                   ${CMAKE_CURRENT_BINARY_DIR}/${LANG}.po
                   COPYONLY)
endforeach(LANG)
gettext_process_pot_file(${POT_FILE} ALL
                         INSTALL_DESTINATION ${CMAKE_INSTALL_LOCALEDIR}
                         LANGUAGES ${LANGS})
