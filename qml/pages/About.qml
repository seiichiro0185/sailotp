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

// Define the Layout of the About Page
Page {
  id: aboutPage
  Image {
    id: logo
    source: "../sailotp.png"
    anchors.horizontalCenter: parent.horizontalCenter
    y: 200
  }
  Label {
    id: name
    anchors.horizontalCenter: parent.horizontalCenter
    y: 320
    font.bold: true
    text: "SailOTP " + Qt.application.version
  }
  Text {
    id: desc
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: name.bottom
    anchors.topMargin: 20
    text: "A Simple Sailfish OTP Generator<br />(RFC 6238/4226 compatible)"
    color: "white"
  }
  Text {
    id: copyright
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: desc.bottom
    anchors.topMargin: 20
    text: "Copyright: Stefan Brand<br />License: BSD (3-clause)"
    color: "white"
  }
  Button {
    id: homepage
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: copyright.bottom
    anchors.topMargin: 20
    text: "<a href=\"https://www.seiichiro0185.org/gitlab/seiichiro0185/harbour-sailotp.git\">Source Code</a>"
    onClicked: {
      Qt.openUrlExternally("https://www.seiichiro0185.org/gitlab/seiichiro0185/harbour-sailotp.git")
    }
  }
  TextArea {
    id: acknowledgement
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: homepage.bottom
    anchors.topMargin: 20
    width: parent.width
    font.pixelSize: Theme.fontSizeSmall
    horizontalAlignment: TextEdit.Center
    readOnly: true
    text: "SailOTP uses the following third party libs:\n\nhttp://caligatio.github.io/jsSHA/\nhttps://github.com/mdp/gibberish-aes"
    color: "white"
  }
}
