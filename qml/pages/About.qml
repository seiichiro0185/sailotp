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

// Define the Layout of the About Page
Page {
  id: aboutPage

  allowedOrientations: Orientation.All

  SilicaFlickable {
    id: flickable
    anchors.fill: parent
    width: parent.width
    contentHeight: column.height

    Column {
      id: column
      width: parent.width
      spacing: Theme.paddingLarge

      Image {
        id: logo
        source: "../sailotp.png"
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
      }
      Label {
        id: name
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        text: "SailOTP " + Qt.application.version
      }
      TextArea {
        id: desc
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        horizontalAlignment: TextEdit.Center
        readOnly: true
        text:  qsTr("A Simple Sailfish OTP Generator\n(RFC 6238/4226 compatible)")
        color: "white"
      }
      TextArea {
        id: copyright
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        horizontalAlignment: TextEdit.Center
        readOnly: true
        text: qsTr("Copyright: Stefan Brand\nLicense: BSD (3-clause)")
        color: "white"
      }
      Button {
        id: homepage
        anchors.horizontalCenter: parent.horizontalCenter
        text: "<a href=\"https://www.seiichiro0185.org/gitlab/seiichiro0185/harbour-sailotp.git\">Source Code</a>"
        onClicked: {
          Qt.openUrlExternally("https://www.seiichiro0185.org/gitlab/seiichiro0185/harbour-sailotp.git")
        }
      }
      TextArea {
        id: acknowledgement
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        font.pixelSize: Theme.fontSizeSmall
        horizontalAlignment: TextEdit.Center
        readOnly: true
        text: qsTr("SailOTP uses the following third party libs:")+"\n\nhttp://caligatio.github.io/jsSHA/\nhttps://github.com/mdp/gibberish-aes/\nhttp://sourceforge.net/projects/qzxing/\nhttp://fukuchi.org/works/qrencode/"
        color: "white"
      }

      TextArea {
        id: contributors
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        font.pixelSize: Theme.fontSizeSmall
        horizontalAlignment: TextEdit.Center
        readOnly: true
        text: qsTr("Contributors:")+"\n\nRobin Apelmann: SteamGuard "+qsTr("Support")
        color: "white"
      }

      TextArea {
        id: translators
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        font.pixelSize: Theme.fontSizeSmall
        horizontalAlignment: TextEdit.Center
        readOnly: true
        text: qsTr("Translators:")+"\n\nSwedish: Åke Engelbrektson\nEnglish: Stefan Brand\nGerman: Stefan Brand"
        color: "white"
      }
    }
    VerticalScrollDecorator { }
  }
}
