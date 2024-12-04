import QtQuick 2.4
import Lomiri.Components 1.3
import SSO.OnlineAccounts 0.1

Item {
    id: root

    signal finished

    height: contents.height

    property var __account: account
    property string __host: ""
    property bool __busy: false
    property string __hostError: i18n.dtr("lomiri-online-accounts-plugins-caldav", "Invalid host URL")

    Column {
        id: contents
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }
        spacing: units.gu(2)
        
        function formIsValid() {
            return urlField.text.trim() !== "" && usernameField.text.trim() !== "" && passwordField.text.trim() !== ""
        }

        Label {
            id: errorLabel
            anchors { left: parent.left; right: parent.right }
            font.bold: true
            color: theme.palette.normal.negative
            elide: Label.ElideRight
            wrapMode: Text.Wrap
            visible: !__busy && text != ""
        }

        Label {
            anchors { left: parent.left; right: parent.right }
            text: i18n.dtr("lomiri-online-accounts-plugins-caldav", "URL:")
        }

        TextField {
            id: urlField
            anchors { left: parent.left; right: parent.right }
            placeholderText: i18n.dtr("lomiri-online-accounts-plugins-caldav", "http://myserver.com/caldav/")
            focus: true
            enabled: !__busy

            inputMethodHints: Qt.ImhUrlCharactersOnly
        }

        Label {
            anchors { left: parent.left; right: parent.right }
            text: i18n.dtr("lomiri-online-accounts-plugins-caldav", "Username:")
        }

        TextField {
            id: usernameField
            anchors { left: parent.left; right: parent.right }
            placeholderText: i18n.dtr("lomiri-online-accounts-plugins-caldav", "Your username")
            enabled: !__busy
            inputMethodHints: Qt.ImhNoAutoUppercase + Qt.ImhNoPredictiveText + Qt.ImhPreferLowercase

            KeyNavigation.tab: passwordField
        }

        Label {
            anchors { left: parent.left; right: parent.right }
            text: i18n.dtr("lomiri-online-accounts-plugins-caldav", "Password:")
        }

        TextField {
            id: passwordField
            anchors { left: parent.left; right: parent.right }
            placeholderText: i18n.dtr("lomiri-online-accounts-plugins-caldav", "Your password")
            echoMode: TextInput.Password
            enabled: !__busy

            inputMethodHints: Qt.ImhSensitiveData
            Keys.onReturnPressed: login()
        }

        Row {
            id: buttons
            anchors { left: parent.left; right: parent.right }
            height: units.gu(5)
            spacing: units.gu(1)
            Button {
                id: btnCancel
                text: i18n.dtr("lomiri-online-accounts-plugins-caldav", "Cancel")
                width: (parent.width / 2) - 0.5 * parent.spacing
                onClicked: finished()
            }
            Button {
                id: btnContinue
                text: i18n.dtr("lomiri-online-accounts-plugins-caldav", "Continue")
                color: theme.palette.normal.positive
                width: (parent.width / 2) - 0.5 * parent.spacing
                onClicked: login()
                enabled: !__busy && contents.formIsValid()
            }
        }
    }

    ActivityIndicator {
        anchors.centerIn: parent
        running: __busy
    }

    Credentials {
        id: creds
        caption: account.provider.id
        acl: [ "unconfined" ]
        storeSecret: true
        onCredentialsIdChanged: root.credentialsStored()
    }

    AccountService {
        id: globalAccountSettings
        objectHandle: account.accountServiceHandle
        autoSync: false
    }

    function login() {
        var host = cleanUrl(urlField.text)
        var username = usernameField.text
        var password = passwordField.text

        errorLabel.text = ""
        __busy = true

        checkAccount(host, username, password, function cb(success) {
            console.log("callback called: " + success)
            if (success) {
                saveData(host, username, password)
            } else {
                showError(i18n.tr("Could not connect to %1, invalid host or credentials").arg(host))
                __busy = false
            }
        })
    }

    function saveData(host, username, password) {
        __host = host
        var strippedHost = host.replace(/^https?:\/\//, '')
        account.updateDisplayName(username + '@' + strippedHost)
        creds.userName = username
        creds.secret = password
        creds.sync()
    }
    
    function checkAccount(host, username, password, callback) {
        console.log("Trying host " + host + " with " + username)
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                console.log("response: ", request.status, request.responseText)
                if (request.status >= 200 && request.status < 300) {
                   callback(true)
                } else {
                    callback(false)
                }
            }
        }
        var url = host + "/" + username;
        console.log('check url:', url)
        request.open("PROPFIND", url, true, username, encodeURIComponent(password));
        //request.setRequestHeader("Authorization", "Basic " + Qt.btoa(username + ":" + password));
        request.setRequestHeader("Content-type",
                                              "application/xml; charset='utf-8'");

        var xml = '<?xml version="1.0" encoding="UTF-8" ?><propfind xmlns="DAV:">
            <prop>
            <current-user-principal/>
            </prop>
            </propfind>';
        request.send(xml);
    }

    function showError(message) {
        if (!errorLabel.text) errorLabel.text = message
    }

    function credentialsStored() {
        console.log("Credentials stored, id: " + creds.credentialsId)
        if (creds.credentialsId == 0) return

        globalAccountSettings.updateServiceEnabled(true)
        globalAccountSettings.credentials = creds
        globalAccountSettings.updateSettings({
            "host": __host,
            "server_address": __host,
            "webdav_path": '/'

        })
        account.synced.connect(finished)
        account.sync()
        __busy = false
    }

    // check host url for http
    function cleanUrl(url) {
        var host = url.trim()
        return host
    }

}
