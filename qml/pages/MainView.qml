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
  property double lastUpdated: null

  // Add an entry to the list
  function appendOTP(title, secret) {
    otpListModel.append({"secret": secret, "title": title, "otp": ""});
  }

  // Reload the List of OTPs from storage
  function refreshOTPList() {
    otpListModel.clear();
    DB.getOTP();
    refreshOTPValues();
  }

  // Calculate new OTPs for every entry
  function refreshOTPValues() {
		// get seconds from current Date
		var curDate = new Date();
    var seconds = curDate.getSeconds();

		// Iterate over all List entries
    for (var i=0; i<otpListModel.count; i++) {
			// Only update on full 30 / 60 Seconds or if last run of the Functions is more than 2s in the past (e.g. app was in background)
      if (otpListModel.get(i).otp == "" || seconds == 30 || seconds == 0 || (curDate.getTime() - lastUpdated > 2000)) {
        var curOTP = OTP.calcOTP(otpListModel.get(i).secret)
        otpListModel.setProperty(i, "otp", curOTP);
        console.log("Updating Value ", i);
      }
    }

		// Update the Progressbar
    updateProgress.value = 29 - (seconds % 30)
		// Set lastUpdate property
    lastUpdated = curDate.getTime();
  }

  Timer {
    interval: 1000
    running: Qt.application.active // Timer only runs when App is active
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
        text: "Add OTP"
        onClicked: pageStack.push(Qt.resolvedUrl("AddOTP.qml"), {parentPage: mainPage})
      }
    }

    ProgressBar {
      id: updateProgress
      width: parent.width
      maximumValue: 29
      anchors.top: parent.top
      anchors.topMargin: 48
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
        width: otpList.width
        contentHeight: Theme.itemSizeMedium

        function remove() {
					// Show 5s countdown, then delete from DB and List
          remorseAction("Deleting", function() { DB.removeOTP(title, secret); otpListModel.remove(index) })
        }

        ListView.onRemove: animateRemoval()
        Rectangle {
          anchors.horizontalCenter: parent.horizontalCenter

          Label {
              id: otpLabel
              text: model.title
              color: Theme.secondaryColor
              anchors.horizontalCenter: parent.horizontalCenter
          }

          Label {
              id: otpValue
              anchors.top: otpLabel.bottom
              text: model.otp
              anchors.horizontalCenter: parent.horizontalCenter
              color: Theme.highlightColor
              font.pixelSize: Theme.fontSizeLarge
          }
        }

        Component {
          id: otpContextMenu
          ContextMenu {
            MenuItem {
              text: "Edit"
              onClicked: {
                pageStack.push(Qt.resolvedUrl("AddOTP.qml"), {parentPage: mainPage, paramLabel: title, paramKey: secret})
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
      }
    }
  }
}


