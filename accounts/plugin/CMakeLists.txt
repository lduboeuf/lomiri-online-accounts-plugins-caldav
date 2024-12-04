set(PROVIDER_FILES
    generic-caldav.provider
)

gettext_merge_xml_translations(${PROVIDER_FILES})

foreach(PROVIDER_FILE ${PROVIDER_FILES})
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROVIDER_FILE}
        DESTINATION ${PROVIDER_FILE_DIR}
    )
endforeach()

set(PLUGIN_QML_FILES
    qml/Main.qml
    qml/NewAccount.qml
)

install(FILES ${PLUGIN_QML_FILES}
    DESTINATION ${PLUGIN_QML_DIR}/generic-caldav
)

set(PLUGIN_ICON
    online-accounts-caldav.png
)

install(FILES ${PLUGIN_ICON}
    DESTINATION ${CMAKE_INSTALL_FULL_DATADIR}/icons/suru/apps/128
)
