set(SERVICE_FILES
    lomiri-generic-caldav.service
    lomiri-owncloud-caldav.service
    lomiri-nextcloud-caldav.service
    google-calendars.service
)

gettext_merge_xml_translations("${SERVICE_FILES}")

foreach(SERVICE_FILE ${SERVICE_FILES})
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${SERVICE_FILE}
        DESTINATION ${SERVICE_FILE_DIR}
    )
endforeach()
