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

.import QtQuick.LocalStorage 2.0 as LS

// Get DB Connection
function getDB() {
  return LS.LocalStorage.openDatabaseSync("harbour-sailotp", "1.0", "SailOTP Config Storage", 1000000);
}

// Initialize Table if not exists
function initialize() {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("CREATE TABLE IF NOT EXISTS OTPStorage(title TEXT, secret TEXT);");
    }
  )
}

// Get all OTPs into the list model
function getOTP() {
  var db = getDB();

  db.transaction(
    function(tx) {
      var res = tx.executeSql("select * from OTPStorage;");
      for (var i=0; i < res.rows.length; i++) {
        mainPage.appendOTP(res.rows.item(i).title, res.rows.item(i).secret);
      }
    }
  )
}

// Add a new OTP
function addOTP(title, secret) {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("INSERT INTO OTPStorage VALUES(?, ?);", [title, secret]);
    }
  )
}

// Remove an existing OTP
function removeOTP(title, secret) {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("DELETE FROM OTPStorage WHERE title=? and secret=?;", [title, secret]);
    }
  )
}
