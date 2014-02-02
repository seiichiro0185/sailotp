/*
 * Copyright (c) 2013, Stefan Brand <seiichiro@seiichiro0185.org>
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


import QtQuick 2.0
import Sailfish.Silica 1.0
import "../lib/storage.js" as DB
import "../lib/crypto.js" as OTP

Page {
  id: mainPage

  ListModel {
    id: otpListModel
  }

  // This holds the time of the last update of the page as Unix Timestamp (in Milliseconds)
  property double lastUpdated: 0

  // Add an entry to the list
  function appendOTP(title, secret, type, counter, fav) {
    otpListModel.append({"secret": secret, "title": title, "fav": fav, "type": type, "counter": counter, "otp": "------"});
  }

  // Hand favorite over to the cover
  function setCoverOTP(title, secret, type) {
    appWin.coverTitle = title
    appWin.coverSecret = secret
    appWin.coverType = type
    if (secret = "") {
      appWin.coverOTP = "";
    } else if (type == "HOTP") {
      appWin.coverOTP = "------";
    }
  }

  // Reload the List of OTPs from storage
  function refreshOTPList() {
    otpList.visible = false;
    otpListModel.clear();
    DB.getOTP();
    refreshOTPValues();
    otpList.visible = true;
  }

  // Calculate new OTPs for every entry
  function refreshOTPValues() {
    // get seconds from current Date
    var curDate = new Date();
    var seconds = curDate.getSeconds();

    // Iterate over all List entries
    for (var i=0; i<otpListModel.count; i++) {
      if (otpListModel.get(i).type == "TOTP") {
        // Only update on full 30 / 60 Seconds or if last run of the Functions is more than 2s in the past (e.g. app was in background)
        if (otpListModel.get(i).otp == "------" || seconds == 30 || seconds == 0 || (curDate.getTime() - lastUpdated > 2000)) {
          var curOTP = OTP.calcOTP(otpListModel.get(i).secret, "TOTP")
          otpListModel.setProperty(i, "otp", curOTP);
        }
      } else if (appWin.coverType == "HOTP" && (curDate.getTime() - lastUpdated > 2000) && otpListModel.get(i).fav == 1) {
        // If we are coming back from the CoverPage update OTP value if current favourite is HOTP
        otpListModel.setProperty(i, "otp", appWin.coverOTP);
      }
    }

    // Update the Progressbar
    updateProgress.value = 29 - (seconds % 30)
    // Set lastUpdate property
    lastUpdated = curDate.getTime();
  }

  Timer {
    interval: 500
    // Timer only runs when app is acitive and we have entries
    running: Qt.application.active && otpListModel.count
    repeat: true
    onTriggered: refreshOTPValues();
  }

  SilicaFlickable {
    anchors.fill: parent

    PullDownMenu {
      MenuItem {
        text: "About"
        onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
      }
      MenuItem {
        text: "Export Token-DB"
        onClicked: pageStack.push(Qt.resolvedUrl("ExportPage.qml"), {parentPage: mainPage, mode: "export"})
      }
      MenuItem {
        text: "Import Token-DB"
        onClicked: pageStack.push(Qt.resolvedUrl("ExportPage.qml"), {parentPage: mainPage, mode: "import"})
      }
      MenuItem {
        text: "Add Token"
        onClicked: pageStack.push(Qt.resolvedUrl("AddOTP.qml"), {parentPage: mainPage})
      }
    }

    ProgressBar {
      id: updateProgress
      width: parent.width
      maximumValue: 29
      anchors.top: parent.top
      anchors.topMargin: 48
      // Only show when there are enries
      visible: otpListModel.count
    }

    SilicaListView {
      id: otpList
      header: PageHeader {
        title: "SailOTP"
      }
      anchors.fill: parent
      model: otpListModel
      width: parent.width

      ViewPlaceholder {
        enabled: otpList.count == 0
        text: "Nothing here"
        hintText: "Pull down to add a OTP"
      }

      delegate: ListItem {
        id: otpListItem
        menu: otpContextMenu
        contentHeight: Theme.itemSizeMedium
        width: parent.width

        function remove() {
          // Show 5s countdown, then delete from DB and List
          remorseAction("Deleting", function() { DB.removeOTP(title, secret); otpListModel.remove(index) })
        }

        onClicked: {
          Clipboard.text = otp
          notify.show("Token for " + title + " copied to clipboard", 3000);
        }

        ListView.onRemove: animateRemoval()
        Rectangle {
          id: listRow
          width: parent.width
          anchors.horizontalCenter: parent.horizontalCenter

          IconButton {
            icon.source: fav == 1 ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite"
            anchors.left: parent.left
            onClicked: {
              if (fav == 0) {
                DB.setFav(title, secret)
                setCoverOTP(title, secret, type)
                if (type == "HOTP") appWin.coverOTP = otp
                for (var i=0; i<otpListModel.count; i++) {
                  if (i != index) {
                    otpListModel.setProperty(i, "fav", 0);
                  } else {
                    otpListModel.setProperty(i, "fav", 1);
                  }
                }
              } else {
                DB.resetFav(title, secret)
                setCoverOTP("SailOTP", "", "")
                otpListModel.setProperty(index, "fav", 0);
              }
            }
          }

          Column {
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
              id: otpLabel
              text: model.title
              color: Theme.secondaryColor
              anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
              id: otpValue
              text: model.otp
              color: Theme.highlightColor
              font.pixelSize: Theme.fontSizeLarge
              anchors.horizontalCenter: parent.horizontalCenter
            }
          }
        }

        // Show an update button on HTOP-Type Tokens
        IconButton {
          icon.source: "image://theme/icon-m-refresh"
          anchors.right: parent.right
          visible: type == "HOTP" ? true : false
          onClicked: {
            otpListModel.setProperty(index, "counter", DB.getCounter(title, secret, true));
            otpListModel.setProperty(index, "otp", OTP.calcOTP(secret, "HOTP", counter));
            if (fav == 1) appWin.coverOTP = otp;
          }
        }

        Component {
          id: otpContextMenu
          ContextMenu {
            MenuItem {
              text: "Edit"
              onClicked: {
                pageStack.push(Qt.resolvedUrl("AddOTP.qml"), {parentPage: mainPage, paramLabel: title, paramKey: secret, paramType: type, paramCounter: DB.getCounter(title, secret, false)})
              }
            }
            MenuItem {
              text: "Delete"
              onClicked: remove()
            }
          }
        }
      }
      VerticalScrollDecorator{}

      Component.onCompleted: {
        // Load list of OTP-Entries
        refreshOTPList();
        console.log("SailOTP Version " + Qt.application.version + " started");
      }
    }
  }
}


