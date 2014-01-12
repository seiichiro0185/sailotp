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

// Get DB Connection, Initialize or Upgrade DB
function getDB() {
  try {
    var db = LS.LocalStorage.openDatabaseSync("harbour-sailotp", "", "SailOTP Config Storage", 1000000);

    if (db.version == "") {
      // Initialize an empty DB, Create the Table
      db.changeVersion("", "2",
        function(tx) {
          tx.executeSql("CREATE TABLE IF NOT EXISTS OTPStorage(title TEXT, secret TEXT, type TEXT, counter INTEGER, fav INTEGER);");
        }
      );
    } else if (db.version == "1.0") {
      // Upgrade DB Schema to Version 2
      db.changeVersion("1.0", "2",
        function(tx) {
          tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN type TEXT DEFAULT 'TOTP';");
          tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN counter INTEGER DEFAULT 0;");
          tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN fav INTEGER DEFAULT 0;");
        }
      );
    }
  } catch (e) {
    // DB Failed to open
    console.log("Could not open DB: " + e);
  }

  return db;
}

// Get all OTPs into the list model
function getOTP() {
  var db = getDB();

  db.transaction(
    function(tx) {
      var res = tx.executeSql("select * from OTPStorage;");
      for (var i=0; i < res.rows.length; i++) {
        mainPage.appendOTP(res.rows.item(i).title, res.rows.item(i).secret, res.rows.item(i).type, res.rows.item(i).counter, res.rows.item(i).fav);
        if (res.rows.item(i).fav) mainPage.setCoverOTP(res.rows.item(i).title, res.rows.item(i).secret, res.rows.item(i).type);
      }
    }
  )
}

// Add a new OTP
function addOTP(title, secret, type, counter) {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("INSERT INTO OTPStorage VALUES(?, ?, ?, ?, ?);", [title, secret, type, counter, 0]);
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

function setFav(title, secret) {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("UPDATE OTPStorage set fav = 0");
      tx.executeSql("UPDATE OTPStorage set fav = 1 WHERE title=? and secret=?;", [title, secret]);
    }
  )
}

function resetFav(title, secret) {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("UPDATE OTPStorage set fav = 0");
    }
  )
}

// Change an existing OTP
function changeOTP(title, secret, type, counter, oldtitle, oldsecret) {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("UPDATE OTPStorage SET title=?, secret=?, type=?, counter=? WHERE title=? and secret=?;", [title, secret, type, counter, oldtitle, oldsecret]);
    }
  )
}


// Get the counter for a HOTP value, incerment the counter on request
function getCounter(title, secret, increment) {
  var db = getDB();

  var res = "";

  db.transaction(
    function(tx) {
      res = tx.executeSql("SELECT counter FROM OTPStorage where title=? and secret=?;", [title, secret]);
      if (increment) tx.executeSql("UPDATE OTPStorage set counter=counter+1 WHERE title=? and secret=?;", [title, secret]);
    }
  )

  return res.rows.item(0).counter;
}
