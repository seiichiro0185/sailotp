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
import harbour.sailotp.FileIO 1.0 // Import FileIO Class
import "../lib/storage.js" as DB // Import the storage library for Config-Access
import "../lib/gibberish-aes.js" as Gibberish //Import AES encryption library

// Define Layout of the Export / Import Page
Dialog {
  id: exportPage

  // We get the Object of the parent page on call to refresh it after adding a new Entry
  property QtObject parentPage: null

  property string mode: "import"

  // FileIO Object for reading / writing files
  FileIO {
    id: exportFile
    source: fileName.text
    onError: console.log(msg)
  }

  SilicaFlickable {
    id: exportFlickable
    anchors.fill: parent

    VerticalScrollDecorator {}

    Column {
      anchors.fill: parent
      DialogHeader {
        acceptText: mode == "export" ? "Export" : "Import"
      }

      /*ComboBox {
        id: modeSel
        label: "Mode: "
        menu: ContextMenu {
          MenuItem { text: "Export"; onClicked: { mode = "export" } }
          MenuItem { text: "Import"; onClicked: { mode = "import" } }
        }
      }*/
      TextField {
        id: fileName
        width: parent.width
        label: "Filename"
        placeholderText: "File to Export / Import"
        focus: true
        horizontalAlignment: TextInput.AlignLeft
      }
      TextField {
        id: filePassword
        width: parent.width
        label: "Password"
        placeholderText: "Password for the Export"
        echoMode: TextInput.Password
        focus: true
        horizontalAlignment: TextInput.AlignLeft
      }
    }
  }

  // Check if we can continue
  canAccept: fileName.text.length > 0 && filePassword.text.length > 0 ? true : false

  // Do the DB-Export / Import
  // TODO: Error handling and enctyption
  onDone: {
    if (result == DialogResult.Accepted) {
      if (mode == "export") {
        console.log("Exporting to " + fileName.text);
        exportFile.write(Gibberish.AES.enc(DB.db2json(), filePassword.text));
      } else if(mode == "import") {
        console.log("Importing ftom " + fileName.text);
        DB.json2db(Gibberish.AES.dec(exportFile.read(), filePassword.text))
      }
    }
  }
}
