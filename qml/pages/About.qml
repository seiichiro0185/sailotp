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
      spacing: Theme.paddingSmall

      // Spacer
      Item {
        width: parent.width
        height: Theme.paddingLarge
      }
      Image {
        id: logo
        source: "../sailotp.png"
        anchors.horizontalCenter: parent.horizontalCenter
      }
      Label {
        id: name
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        text: "SailOTP " + Qt.application.version
      }
      Label {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        horizontalAlignment: TextEdit.Center
        text:  qsTr("A simple Sailfish OTP generator")
        color: Theme.primaryColor
      }
      Label {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        horizontalAlignment: TextEdit.Center
        font.pixelSize: Theme.fontSizeSmall
        text:  qsTr("(RFC 6238/4226 compatible)")
        color: Theme.primaryColor
      }
      // Spacer
      Item {
        width: parent.width
        height: Theme.paddingMedium
      }
      Button {
        text: qsTr("Online Manual")
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
          Qt.openUrlExternally("https://www.seiichiro0185.org/sailfish:apps:sailotp:manual")
        }
      }
      Button {
        text: qsTr("Source Code & Issue Tracker")
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
          Qt.openUrlExternally("https://github.com/seiichiro0185/sailotp/")
        }
      }
      // Spacer
      Item {
        width: parent.width
        height: Theme.paddingMedium
      }
      DetailItem {
        width: parent.width
        label: qsTr("Copyright")
        value: "Stefan Brand"
      }
      DetailItem {
        width: parent.width
        label: qsTr("License")
        value: qsTr("BSD (3-clause)")
      }
      Label {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        font.pixelSize: Theme.fontSizeSmall
        horizontalAlignment: TextEdit.Center
        wrapMode: Text.WordWrap
        text: qsTr("Contributors:")
        color: Theme.secondaryHighlightColor
      }
      DetailItem {
        label: qsTr("SteamGuard support")
        value: "Robin Appelman"
      }
      Label {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        font.pixelSize: Theme.fontSizeSmall
        horizontalAlignment: Text.Center
        wrapMode: Text.WordWrap
        text: qsTr("Translators:")
        color: Theme.secondaryHighlightColor
      }
      Label {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.8
        font.pixelSize: Theme.fontSizeSmall
        wrapMode: Text.WordWrap
        text: "Chinese: BirdZhang\nFinnish: Johan Heikkilä\nFrench: Romain Tartière\nItalian: Tichy\nDutch: JSEHV\nRussian: moorchegue\nSpanish: p4moedo\nSwedish: Åke Engelbrektson\nEnglish: Stefan Brand\nGerman: Stefan Brand"
        color: Theme.highlightColor
      }
      LinkedLabel {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        font.pixelSize: Theme.fontSizeSmall
        horizontalAlignment: TextEdit.Center
        plainText: "\n"+qsTr("SailOTP uses the following third party libs:")+'
          http://caligatio.github.io/jsSHA/
          https://code.google.com/archive/p/crypto-js/
          http://sourceforge.net/projects/qzxing/
          http://fukuchi.org/works/qrencode/'
        color: Theme.secondaryHighlightColor
      }
    }
    VerticalScrollDecorator { }
  }
}
