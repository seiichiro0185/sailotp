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


import QtQuick 2.0
import Sailfish.Silica 1.0
import "../lib/storage.js" as DB
import "../lib/crypto.js" as OTP

Page {
  id: mainPage

  allowedOrientations: Orientation.All

  // This holds the time of the last update of the page as Unix Timestamp (in Milliseconds)
  property double lastUpdated: 0
  property double seconds_global: 0

  // Reload the List of OTPs from storage
  function refreshOTPList() {
    otpList.visible = false;
    otpList.model = null; // Hack to prevent unaccessible pulley after List refresh
    appWin.listModel.clear();
    DB.getOTP();
    refreshOTPValues();
    otpList.model = appWin.listModel; // Hack to prevent unaccessible pulley after List refresh
    otpList.visible = true;
  }

  // Calculate new OTPs for every entry
  function refreshOTPValues() {
    // get seconds from current Date
    var curDate = new Date();
    seconds_global = curDate.getSeconds() % 30

    // Iterate over all List entries
    for (var i=0; i<appWin.listModel.count; i++) {
      if (appWin.listModel.get(i).type === "TOTP" || appWin.listModel.get(i).type === "TOTP_STEAM" ) {
        // Take derivation into account if set
        var seconds = (curDate.getSeconds() + appWin.listModel.get(i).diff) % 30;
        // Only update on full 30 / 60 Seconds or if last run of the Functions is more than 2s in the past (e.g. app was in background)
        if (appWin.listModel.get(i).otp === "------" || seconds == 0 || (curDate.getTime() - lastUpdated > 2000)) {
          var curOTP = OTP.calcOTP(appWin.listModel.get(i).secret, appWin.listModel.get(i).type, appWin.listModel.get(i).len, appWin.listModel.get(i).diff, 0);
          appWin.listModel.setProperty(i, "otp", curOTP);
        } else if (appWin.coverType === "HOTP" && (curDate.getTime() - lastUpdated > 2000) && appWin.listModel.get(i).fav === 1) {
          // If we are coming back from the CoverPage update OTP value if current favourite is HOTP
          appWin.listModel.setProperty(i, "otp", appWin.coverOTP);
        }
      }
    }

    // Set lastUpdate property
    lastUpdated = curDate.getTime();
  }

  Timer {
    interval: 500
    // Timer only runs when app is acitive and we have entries
    running: Qt.application.active && appWin.listModel.count
    repeat: true
    onTriggered: refreshOTPValues();
  }

  SilicaFlickable {
    anchors.fill: parent

    PullDownMenu {
      MenuItem {
        text: qsTr("About")
        onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
      }
      MenuItem {
        text: qsTr("Settings")
        visible: true
        onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
      }
      MenuItem {
        text: qsTr("Export / Import")
        onClicked: pageStack.push(Qt.resolvedUrl("ExportPage.qml"), {parentPage: mainPage, mode: "export"})
      }
      MenuItem {
        text: qsTr("Add Token")
        onClicked: pageStack.push(Qt.resolvedUrl("ScanOTP.qml"), {parentPage: mainPage})
      }
    }


    SilicaListView {
      id: otpList
      anchors.fill: parent
      model: appWin.listModel
      width: parent.width

      ViewPlaceholder {
        enabled: otpList.count == 0
        text: qsTr("Nothing here")
        hintText: qsTr("Pull down to add a OTP")
      }

      header: Row {
        height: Theme.itemSizeSmall
        width: parent.width
        ProgressBar {
          id: updateProgress
          anchors.top: parent.top
          // Hack to get the Progress Bar in roughly the same spot on Light and Dark Ambiances
          anchors.topMargin: Theme.colorScheme === 0 ? Theme.paddingLarge * 1.1 : Theme.paddingSmall * 0.6
          height: Theme.itemSizeSmall
          width: parent.width * 0.65
          maximumValue: 29
          value: 29 - seconds_global
          // Only show when there are enries
          visible: appWin.listModel.count
        }
        PageHeader {
          id: header
          anchors.top: parent.top
          height: Theme.itemSizeSmall
          width: parent.width * 0.35
          title: "SailOTP"
        }
      }

      delegate: ListItem {
        id: otpListItem
        menu: otpContextMenu
        contentHeight: Theme.itemSizeMedium
        width: parent.width

        function remove() {
          // Show 5s countdown, then delete from DB and List
          remorseAction(qsTr("Deleting"), function() { DB.removeOTP(title, secret); appWin.listModel.remove(index) })
        }

        function moveEntry(direction, index) {
          if (direction) {
            appWin.listModel.move(index, index-1, 1);
          } else {
            appWin.listModel.move(index, index+1, 1);
          }
          for (var i=0; i<appWin.listModel.count; i++) {
              DB.changeOTPSort(appWin.listModel.get(i).title, appWin.listModel.get(i).secret, i);
          }
        }

        onClicked: {
          if (settings.hideTokens) {
            otpValue.visible = !otpValue.visible
          } else if (settings.showQrDefaultAction) {
            pageStack.push(Qt.resolvedUrl("QRPage.qml"), {paramQrsource: otp, paramLabel: title, paramQRId: index});
          } else {
              Clipboard.text = otp
              notify.show(qsTr("Token for ") + title + qsTr(" copied to clipboard"), 3000);
          }
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
                appWin.setCover(index)
                if (type == "HOTP") appWin.coverOTP = otp
                for (var i=0; i<appWin.listModel.count; i++) {
                  if (i != index) {
                    appWin.listModel.setProperty(i, "fav", 0);
                  } else {
                    appWin.listModel.setProperty(i, "fav", 1);
                  }
                }
              } else {
                DB.resetFav(title, secret);
                appWin.setCover(-1);
                appWin.listModel.setProperty(index, "fav", 0);
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
              visible: !settings.hideTokens
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
            appWin.listModel.setProperty(index, "counter", DB.getCounter(title, secret, true));
            appWin.listModel.setProperty(index, "otp", OTP.calcOTP(secret, "HOTP", len, 0, counter));
            if (fav == 1) appWin.coverOTP = otp;
          }
        }

        Component {
          id: otpContextMenu
          ContextMenu {
            MenuItem {
              text: qsTr("Copy to Clipboard")
              visible: settings.hideTokens || settings.showQrDefaultAction
              onClicked: {
                Clipboard.text = otp
                notify.show(qsTr("Token for ") + title + qsTr(" copied to clipboard"), 3000);
              }
            }
            MenuItem {
              text: qsTr("Show Token as QR-Code")
              visible: !settings.showQrDefaultAction
              onClicked: pageStack.push(Qt.resolvedUrl("QRPage.qml"), {paramQrsource: otp, paramLabel: title, paramQRId: index});
            }
            MenuItem {
              text: qsTr("Move up")
              visible: index > 0 ? true : false;
              onClicked: moveEntry(1, index);
            }
            MenuItem {
              text: qsTr("Move down")
              visible: index < appWin.listModel.count - 1 ? true : false;
              onClicked: moveEntry(0, index);
            }
            MenuItem {
              text: qsTr("Edit")
              onClicked: {
                pageStack.push(Qt.resolvedUrl("AddOTP.qml"), {parentPage: mainPage, paramLabel: title, paramKey: secret, paramType: type, paramLen: len, paramDiff: diff, paramCounter: DB.getCounter(title, secret, false)})
              }
            }
            MenuItem {
              text: qsTr("Delete")
              onClicked: remove()
            }
          }
        }
      }
      VerticalScrollDecorator{}

      Component.onCompleted: {
        // Load list of OTP-Entries
        refreshOTPList();
      }
    }
  }
}
