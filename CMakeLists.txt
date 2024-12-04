cmake_minimum_required(VERSION 3.5)
project(lomiri-online-accounts-plugins-caldav VERSION 0.5.0 LANGUAGES NONE)

include(FindGettext)
include(FindPkgConfig)
include(GNUInstallDirs)

pkg_check_modules(ONLINE_ACCOUNTS_PLUGINS REQUIRED LomiriOnlineAccountsPlugin)
pkg_get_variable(PLUGIN_QML_DIR LomiriOnlineAccountsPlugin plugin_qml_dir)
pkg_check_modules(LIBACCOUNTS_GLIB REQUIRED libaccounts-glib)
pkg_get_variable(SERVICE_FILE_BASE_DIR libaccounts-glib servicefilesdir)
set(SERVICE_FILE_DIR ${SERVICE_FILE_BASE_DIR}/lomiri)
pkg_get_variable(PROVIDER_FILE_BASE_DIR libaccounts-glib providerfilesdir)
set(PROVIDER_FILE_DIR ${PROVIDER_FILE_BASE_DIR}/lomiri)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

add_subdirectory(accounts)
add_subdirectory(buteo)
add_subdirectory(po)
