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
import QtMultimedia 5.0
import Sailfish.Silica 1.0
import Sailfish.Media 1.0 // Not allowed in harbour, but normal VideoOutput doesn't work yet!
import harbour.sailotp.QZXing 2.2
import harbour.sailotp.FileIO 1.0
import "../lib/urldecoder.js" as URL

Page {
  id: scanPage

  property QtObject parentPage: null

  Timer {
    id: scanTimer
    interval: 100
    running: false
    repeat: false
    onTriggered: {
      if (fileIO.mkpath(XDG_CACHE_DIR)) {
        busy.running = true
        cam.imageCapture.captureToLocation(XDG_CACHE_DIR + "/qrscan.jpg");
      } else {
        notify.show(qsTr("Can't access temporary directory"), 3000);
      }
    }
  }

  SilicaFlickable {
    anchors.fill: parent

    PullDownMenu {
      MenuItem {
        text: qsTr("Add manually")
        onClicked: pageStack.replace(Qt.resolvedUrl("AddOTP.qml"), {parentPage: parentPage, paramNew: true})
      }
    }

    PageHeader {
      id: header
      title: "Scan Code"
    }

    BusyIndicator {
      id: busy
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      anchors.topMargin: 16
      running: false
    }

    Camera {
      id: cam

      flash.mode: Camera.FlashOff
      captureMode: Camera.CaptureStillImage
      focus.focusMode: Camera.FocusContinuous

      imageCapture {
        onImageSaved: {
          decoder.decodeImageFromFile(XDG_CACHE_DIR + "/qrscan.jpg");
        }
      }
    }

    QZXing {
      id: decoder

      enabledDecoders: QZXing.DecoderFormat_QR_CODE
      onDecodingStarted: console.log("Decoding of image started...")

      onTagFound: {
        console.log("Barcode data: " + tag)
        var ret = URL.decode(tag);
        busy.running = false
        if (ret && ret.type != "" && ret.title != "" && ret.secret != "" && (ret.counter != "" || ret.type == "TOTP")) {
          pageStack.replace(Qt.resolvedUrl("AddOTP.qml"), {parentPage: parentPage, paramLabel: ret.title, paramKey: ret.secret, paramType: ret.type, paramCounter: ret.counter, paramNew: true})
        } else {
          notify.show(qsTr("No valid Token data found."), 3000);
        }
      }

      onDecodingFinished: if (succeeded==false) scanTimer.start();
    }

    FileIO {
      id: fileIO
    }

    GStreamerVideoOutput {
      id: prev
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: header.bottom
      source: cam
      MouseArea {
        anchors.fill: parent
        onClicked: scanTimer.start();
      }
    }

    Text {
      id: text

      anchors.top: prev.bottom
      anchors.topMargin: 32
      anchors.horizontalCenter: parent.horizontalCenter
      width: parent.width - 2*Theme.paddingLarge

      wrapMode: Text.Wrap
      maximumLineCount: 4
      font.pixelSize: Theme.fontSizeSmall
      color: Theme.primaryColor
      text: qsTr("Tap the picture to start scanning. Pull down to add Token manually.")
    }
  }
}
