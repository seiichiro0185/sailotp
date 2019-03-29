TARGET = harbour-sailotp

DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_BUILDNUM=\\\"$$RELEASE\\\"

CONFIG += sailfishapp

SOURCES += src/harbour-sailotp.cpp

DISTFILES += qml/harbour-sailotp.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainView.qml \
    qml/pages/AddOTP.qml \
    qml/pages/About.qml \
    qml/pages/ExportPage.qml \
    qml/pages/ScanOTP.qml \
    qml/pages/QRPage.qml \
    qml/pages/Settings.qml \
    qml/components/NotifyBanner.qml \
    qml/lib/urldecoder.js \
    qml/lib/storage.js \
    qml/lib/crypto.js \
    qml/lib/cryptojs-aes.js \
    qml/lib/sha.js \
    qml/sailotp.png \
    rpm/harbour-sailotp.spec \
    rpm/harbour-sailotp.yaml \
    rpm/harbour-sailotp.changes \
    translations/*.ts \
    harbour-sailotp.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += sailfishapp_i18n

TRANSLATIONS = translations/harbour-sailotp-de.ts \
    translations/harbour-sailotp-es.ts \
    translations/harbour-sailotp-fi.ts \
    translations/harbour-sailotp-fr.ts \
    translations/harbour-sailotp-it.ts \
    translations/harbour-sailotp-pt_BR.ts \
    translations/harbour-sailotp-ru.ts \
    translations/harbour-sailotp-sv.ts \
    translations/harbour-sailotp-nl.ts \
    translations/harbour-sailotp-zh_CN.ts

include(src/qzxing/QZXing.pri)
include(src/FileIO/FileIO.pri)
include(src/qqrencode/qqrencode.pri)   
