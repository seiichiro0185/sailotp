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

Page {
  id: qrpage

  allowedOrientations: Orientation.All

  property string paramType: ""
  property string paramLabel: ""
  property string paramKey: ""
  property int paramLen: 6
  property int paramCounter: 0

  Label {
    id: qrLabel
    text: paramLabel
    color: Theme.highlightColor
    font.pixelSize: Theme.fontSizeLarge
    anchors.horizontalCenter: parent.horizontalCenter
    y: 96
  }

  Image {
    id: qrImage
    anchors.horizontalCenter: parent.horizontalCenter
    y: 200
    cache: false
  }

  Component.onCompleted: {

    var otpurl = "";
    if (paramType == "TOTP") {
      if (paramLabel != "" && paramKey != "")
        otpurl = "otpauth://totp/"+paramLabel+"?secret="+paramKey+"&digits="+paramLen;

    } else if (paramType == "HOTP") {
      if (paramLabel != "" && paramKey != "" && paramCounter > 0)
        otpurl = "otpauth://hotp/"+paramLabel+"?secret="+paramKey+"&counter="+paramCounter+"&digits="+paramLen;
    }
    if (otpurl != "") {
      qrImage.source = "image://qqrencoder/"+otpurl;
    } else {
      notify.show(qsTr("Can't create QR-Code from incomplete settings!"), 4000);
    }
  }
}
