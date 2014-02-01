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

SOURCES += src/harbour-sailotp.cpp \
    src/fileio.cpp

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
    qml/lib/gibberish-aes.js

HEADERS += \
    src/fileio.h

