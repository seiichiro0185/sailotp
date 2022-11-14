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
import Nemo.Configuration 1.0
import "pages"
import "components"

ApplicationWindow
{
  id: appWin

  // Properties to pass values between MainPage and Cover
  property alias listModel: otpListModel
  property string coverTitle: "SailOTP"
  property string coverSecret: ""
  property string coverType: ""
  property string coverOTP: "------"
  property int coverLen: 6
  property int coverDiff: 0
  property int coverPeriod: 30
  property int coverIndex: 0

  // Global Listmodel for Tokens
  ListModel { id: otpListModel }

  // Global Component for showing notification banners
  NotifyBanner { id: notify }

  // Global Settings Storage
  ConfigurationGroup
  {
      id: settings
      path: "/apps/harbour-sailotp"

      property bool showQrDefaultAction: false
      property bool hideTokens: false
  }

  // Add an entry to the list
  function appendOTP(title, secret, type, counter, fav, len, diff, period) {
    listModel.append({"secret": secret, "title": title, "fav": fav, "type": type, "counter": counter, "len": len, "diff": diff, "period": period, "otp": "------", "itemVisible": true});
  }

  // Set the OTP shown on the Cover
  function setCover(index) {
    if (index >= 0 && index < listModel.count) {
      coverTitle = listModel.get(index).title;
      coverSecret = listModel.get(index).secret;
      coverType = listModel.get(index).type;
      coverLen = listModel.get(index).len;
      coverDiff = listModel.get(index).diff;
      coverPeriod = listModel.get(index).period;
      coverIndex = index;
      if (coverType == "TOTP") { coverOTP = "------"; } else { coverOTP = listModel.get(index).otp; }
      for (var i=0; i<listModel.count; i++) {
        if (i != index) {
          listModel.setProperty(i, "fav", 0);
        } else {
          listModel.setProperty(i, "fav", 1);
        }
      }
    } else {
      coverTitle = "SailOTP";
      coverSecret = "";
      coverType = "";
      coverIndex = -1;
    }
  }

  initialPage: Component { MainView { } }
  cover: Qt.resolvedUrl("cover/CoverPage.qml")

}


