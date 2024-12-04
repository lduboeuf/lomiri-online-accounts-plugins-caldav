set(SYNC_PROFILE_FILES
    lomiri-generic-caldav.xml
    lomiri-owncloud-caldav.xml
    lomiri-nextcloud-caldav.xml
    lomiri-google-caldav.xml
)

foreach(SYNC_PROFILE_FILE ${SYNC_PROFILE_FILES})
    install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/${SYNC_PROFILE_FILE}
        DESTINATION ${CMAKE_INSTALL_FULL_SYSCONFDIR}/buteo/profiles/sync
    )
endforeach()
