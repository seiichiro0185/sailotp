/*
 * Copyright (c) 2014, Stefan Brand <seiichiro@seiichiro0185.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this
 *    list of conditions and the following disclaimer in the documentation and/or other 
 *    materials provided with the distribution.
 * 
 * 3. The names of the contributors may not be used to endorse or promote products 
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <QtQuick>
#include <sailfishapp.h>
#include <QGuiApplication>
#include "fileio.h"
#include "qcipher.h"
#include "qzxing.h"
#include "qqrencode.h"

void migrateLocalStorage()
{
    // The new location of the LocalStorage database
    QDir newDbDir(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/QML/OfflineStorage/Databases/");

    if(newDbDir.exists())
        return;

    newDbDir.mkpath(newDbDir.path());

    QString dbname = QString(QCryptographicHash::hash(("harbour-sailotp"), QCryptographicHash::Md5).toHex());



    // The old LocalStorage database
    QFile oldDb(QStandardPaths::writableLocation(QStandardPaths::HomeLocation) + "/.local/share/harbour-sailotp/harbour-sailotp/QML/OfflineStorage/Databases/" + dbname + ".sqlite");
    QFile oldIni(QStandardPaths::writableLocation(QStandardPaths::HomeLocation) + "/.local/share/harbour-sailotp/harbour-sailotp/QML/OfflineStorage/Databases/" + dbname + ".ini");

    qDebug() << "Migrating " + oldDb.fileName() + " to " + newDbDir.absolutePath() + "/" + dbname + ".sqlite";

    // Copy to new Database Location
    oldDb.copy(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/QML/OfflineStorage/Databases/" + dbname + ".sqlite");
    oldIni.copy(QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/QML/OfflineStorage/Databases/" + dbname + ".ini");
}

int main(int argc, char *argv[])
{
    // Get App and QML-View objects
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    // QZXing QR Decoder
    QZXing qrdecoder;
    qrdecoder.registerQMLTypes();

    // Internationalization, Load the Language
    QString locale = QLocale::system().name();
    QTranslator translator;
    translator.load(locale,SailfishApp::pathTo(QString("i18n")).toLocalFile());
    app->installTranslator(&translator);

    // Migrate to new Storage Directory
    migrateLocalStorage();

    // Set some global values
    app->setOrganizationName("org.seiichiro0185");
    app->setOrganizationDomain("org.seiichiro0185");
    app->setApplicationName("harbour-sailotp");
    app->setApplicationVersion(APP_VERSION);

    // Register FileIO Class
    qmlRegisterType<FileIO, 1>("harbour.sailotp.FileIO", 1, 0, "FileIO");
    // Register QCipher Class
    qmlRegisterType<QCipher, 1>("harbour.sailotp.QCipher", 1, 0, "QCipher");

    // Prepare the QML and set Homedir
    view->setSource(SailfishApp::pathTo("qml/harbour-sailotp.qml"));
    view->rootContext()->setContextProperty("XDG_HOME_DIR", QStandardPaths::writableLocation(QStandardPaths::HomeLocation));
    view->rootContext()->setContextProperty("XDG_CACHE_DIR", QStandardPaths::writableLocation(QStandardPaths::CacheLocation));
    view->engine()->addImageProvider("qqrencoder", new QQRencoder());
    view->show();

    // Run the app
    return app->exec();
}

