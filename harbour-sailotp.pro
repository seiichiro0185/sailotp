# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-sailotp

DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_BUILDNUM=\\\"$$RELEASE\\\"

CONFIG += sailfishapp

SOURCES += src/harbour-sailotp.cpp

OTHER_FILES += qml/harbour-sailotp.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-sailotp.spec \
    rpm/harbour-sailotp.yaml \
    harbour-sailotp.desktop \
    qml/pages/MainView.qml \
    qml/pages/AddOTP.qml \
    qml/pages/About.qml \
    qml/lib/storage.js \
    qml/lib/crypto.js \
    qml/lib/sha.js \
    qml/sailotp.png \
    qml/pages/ExportPage.qml \
    qml/components/NotifyBanner.qml \
    qml/pages/ScanOTP.qml \
    qml/lib/urldecoder.js \
    qml/pages/QRPage.qml \
    rpm/harbour-sailotp.changes

i18n.files = i18n/*.qm
i18n.path = /usr/share/$${TARGET}/i18n

INSTALLS += i18n

lupdate_only {
    SOURCES = qml/*.qml \
              qml/pages/*.qml \
              qml/covers/*.qml \
              qml/components/*.qml

    TRANSLATIONS = i18n/de.ts \
                   i18n/en.ts \
                   i18n/fi.ts \
                   i18n/fr.ts \
                   i18n/ru.ts \
                   i18n/sv.ts
}

include(src/qzxing/QZXing.pri)
include(src/FileIO/FileIO.pri)
include(src/qqrencode/qqrencode.pri)

DISTFILES += \
    qml/lib/cryptojs-aes.js
