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
import harbour.sailotp.FileIO 1.0 // Import FileIO Class
import "../lib/storage.js" as DB // Import the storage library for Config-Access
import "../lib/cryptojs-aes.js" as CryptoJS //Import AES encryption library

// Define Layout of the Export / Import Page
Dialog {
  id: exportPage

  allowedOrientations: Orientation.All

  // We get the Object of the parent page on call to refresh it after adding a new Entry
  property QtObject parentPage: null
  property string mode: "import"

  function fillNum(num) {
    if (num < 10) {
      return("0"+num);
    } else {
      return(num)
    }
  }

  function creFileName() {
    var date = new Date();
    return(XDG_HOME_DIR + "/sailotp_"+date.getFullYear()+fillNum(date.getMonth()+1)+fillNum(date.getDate())+".aes");
  }

  function checkFileName(file) {
    if (mode == "export") {
      if (exportFile.exists(file) && !fileOverwrite.checked) {
        notify.show(qsTr("File already exists, choose \"Overwrite existing\" to overwrite it."), 4000);
        return(false)
      } else {
        return(true)
      }
    } else {
      if (exportFile.exists(file)) {
        return(true)
      } else {
        notify.show(qsTr("Given file does not exist!"), 4000);
        return(false)
      }
    }
  }

  // FileIO Object for reading / writing files
  FileIO {
    id: exportFile
    source: fileName.text
    onError: { console.log(msg); }
  }

  SilicaFlickable {
    id: exportFlickable
    anchors.fill: parent

    PullDownMenu {
      MenuItem {
        text: mode == "export" ? qsTr("Import") : qsTr("Export")
        onClicked: {
          if (mode == "export") {
            mode = "import"
          } else {
            mode = "export"
          }
        }
      }
    }

    VerticalScrollDecorator {}

    Column {
      anchors.fill: parent
      DialogHeader {
        acceptText: mode == "export" ? qsTr("Export") : qsTr("Import")
      }

      TextField {
        id: fileName
        width: parent.width
        text: mode == "export" ? creFileName() : XDG_HOME_DIR + "/";
        label: qsTr("Filename")
        placeholderText: mode == "import" ? qsTr("File to import") : qsTr("File to export")
        focus: true
        horizontalAlignment: TextInput.AlignLeft

        EnterKey.enabled: text.length > 0
        EnterKey.iconSource: "image://theme/icon-m-enter-next"
        EnterKey.onClicked: filePassword.focus = true
      }

      TextSwitch {
        id: fileOverwrite
        checked: false
        visible: mode == "export"
        text: qsTr("Overwrite existing")
      }

      TextField {
        id: filePassword
        width: parent.width
        label: qsTr("Password")
        placeholderText: qsTr("Password for the file")
        echoMode: TextInput.Password
        focus: true
        horizontalAlignment: TextInput.AlignLeft

        EnterKey.enabled: text.length > 0
        EnterKey.iconSource: mode == "export" ? "image://theme/icon-m-enter-next" : "image://theme/icon-m-enter-accept"
        EnterKey.onClicked: mode == "export" ? filePasswordCheck.focus = true : exportPage.accept()
      }

      TextField {
        id: filePasswordCheck
        width: parent.width
        label: (filePassword.text != filePasswordCheck.text && filePassword.text.length > 0) ? qsTr("Passwords don't match!") : qsTr("Passwords match!")
        placeholderText: qsTr("Repeated Password for the file")
        visible: mode == "export"
        echoMode: TextInput.Password
        focus: true
        horizontalAlignment: TextInput.AlignLeft

        EnterKey.enabled: filePassword.text == filePasswordCheck.text && filePassword.text.length > 0
        EnterKey.iconSource: "image://theme/icon-m-enter-accept"
        EnterKey.onClicked: exportPage.accept()
      }

      Text {
        id: importText

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        width: parent.width - 2*Theme.paddingLarge

        wrapMode: Text.Wrap
        maximumLineCount: 15
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.secondaryColor

        visible: mode == "import"
        text: qsTr("Here you can Import Tokens from a file. Put in the file location and the password you used on export. Pull left to start the import.")
      }

      Text {
        id: exportText

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        width: parent.width - 2*Theme.paddingLarge

        wrapMode: Text.Wrap
        maximumLineCount: 15
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.secondaryColor

        visible: mode == "export"
        text: qsTr("Here you can export Tokens to a file. The exported file will be encrypted with AES-256-CBC and Base64 encoded. Choose a strong password, the file will contain the secrets used to generate the Tokens for your accounts. Pull left to start the export.")
      }
    }
  }

  // Check if we can continue
  canAccept: fileName.text.length > 0 && filePassword.text.length > 0 && (mode == "import" || filePassword.text == filePasswordCheck.text) && checkFileName(fileName.text) ? true : false

  // Do the DB-Export / Import
  onDone: {
    if (result == DialogResult.Accepted) {
      var plainText = ""
      var chipherText = ""

      if (mode == "export") {
        // Export Database to File
        plainText = DB.db2json();

        if (plainText != "") {
          try {
            chipherText = CryptoJS.CryptoJS.AES.encrypt(plainText, filePassword.text);
            if (!exportFile.write(chipherText)) {
              notify.show(qsTr("Error writing to file ")+ fileName.text, 4000);
            } else {
              notify.show(qsTr("Token Database exported to ")+ fileName.text, 4000);
            }
          } catch(e) {
            notify.show(qsTr("Could not encrypt tokens. Error: "), 4000);
          }
        } else {
          notify.show(qsTr("Could not read tokens from Database"), 4000);
        }
      } else if(mode == "import") {
        // Import Tokens from File

        chipherText = exportFile.read();
        if (chipherText != "") {
          try {
            var errormsg = ""
            plainText = CryptoJS.CryptoJS.AES.decrypt(chipherText, filePassword.text).toString(CryptoJS.CryptoJS.enc.Utf8);
            if (DB.json2db(plainText, errormsg)) {
              notify.show(qsTr("Tokens imported from ")+ fileName.text, 4000);
            } else {
              notify.show(errormsg, 4000);
            }
          } catch (e) {
            notify.show(qsTr("Unable to decrypt file, did you use the right password?"), 4000);
          }
        } else {
          notify.show(qsTr("Could not read from file ") + fileName.text, 4000);
        }
      }
    }
  }
}
