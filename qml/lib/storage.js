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
      db.changeVersion("", "3",
        function(tx) {
          tx.executeSql("CREATE TABLE IF NOT EXISTS OTPStorage(title TEXT, secret TEXT, type TEXT DEFAULT 'TOPT', counter INTEGER DEFAULT 0, fav INTEGER DEFAULT 0, sort INTEGER DEFAULT 0, len INTEGER default 6, diff INTEGER default 0);");
      });
    } else if (db.version == "1.0") {
      // Upgrade DB Schema to Version 4
      db.changeVersion("1.0", "4",
        function(tx) {
          tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN type TEXT DEFAULT 'TOTP';");
          tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN counter INTEGER DEFAULT 0;");
          tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN fav INTEGER DEFAULT 0;");
          tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN sort INTEGER DEFAULT 0;");
          tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN len INTEGER DEFAULT 6;");
          tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN diff INTEGER DEFAULT 0;");
      });
    } else if (db.version == "2") {
        // Upgrade DB Schema to Version 3
        db.changeVersion("2", "4",
          function(tx) {
            tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN sort INTEGER DEFAULT 0;");
            tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN len INTEGER DEFAULT 6;");
            tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN diff INTEGER DEFAULT 0;");
        });
    } else if (db.version == "3") {
        // Upgrade DB Schema to Version 4
        db.changeVersion("3", "4",
          function(tx) {
            tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN len INTEGER DEFAULT 6;");
            tx.executeSql("ALTER TABLE OTPStorage ADD COLUMN diff INTEGER DEFAULT 0;");
        });
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
      var res = tx.executeSql("select * from OTPStorage order by sort;");
      for (var i=0; i < res.rows.length; i++) {
        appWin.appendOTP(res.rows.item(i).title, res.rows.item(i).secret, res.rows.item(i).type, res.rows.item(i).counter, res.rows.item(i).fav, res.rows.item(i).len, res.rows.item(i).diff);
        if (res.rows.item(i).fav) appWin.setCover(i);
      }
  });
}

// Get all OTP Values and put them into a JSON-Object
function db2json() {
  var db = getDB();
  var otpList = [];

  db.transaction(
    function(tx) {
      var res = tx.executeSql("select * from OTPStorage;");
      for (var i=0; i < res.rows.length; i++) {
        otpList.push({
          "title": res.rows.item(i).title,
          "secret": res.rows.item(i).secret,
          "type": res.rows.item(i).type,
          "counter": res.rows.item(i).counter,
          "sort": res.rows.item(i).sort,
          "len": res.rows.item(i).len,
          "diff": res.rows.item(i).diff,
      });
    }
  });

  if (otpList.length > 0) {
    return(JSON.stringify({"app": "sailotp", "version": 3, "otplist": otpList}));
  } else {
    return("")
  }
}

// Read Values from JSON and put them into the DB
function json2db(jsonString, error) {
  var json = JSON.parse(jsonString);
  error = "";

  if ((json.version != "1" || json.version != "2" || json.version != "3") && json.app != "sailotp" ) {
    error = "Unrecognized format, file is not a SailOTP export";
    return(false);
  } else {
    var otpList = [];
    otpList = json.otplist;
    if (otpList.length > 0) {
      while(otpList.length > 0) {
        var otpItem = otpList.shift();
        if (otpItem.title != "" & otpItem.secret.length >= 16) {
          if (json.version == "1") {
            addOTP(otpItem.title, otpItem.secret, otpItem.type, otpItem.counter, 0, 6, 0);
          } else if (json.version == "2") {
            addOTP(otpItem.title, otpItem.secret, otpItem.type, otpItem.counter, otpItem.sort, 6, 0);
          } else {
            addOTP(otpItem.title, otpItem.secret, otpItem.type, otpItem.counter, otpItem.sort, otpItem.len, otpItem.diff);
          }
        }
      }
      parentPage.refreshOTPList();
      return(true);
    } else {
      error = "File contains no Tokens";
      return(false);
    }
  }
}

// Add a new OTP
function addOTP(title, secret, type, counter, sort, len, diff) {
  var db = getDB();

  db.transaction(
    function(tx) {
      if (checkOTP(title, secret)) {
        console.log("Token " + title + " is already in DB");
      } else {
        tx.executeSql("INSERT INTO OTPStorage VALUES(?, ?, ?, ?, ?, ?, ?, ?);", [title, secret, type, counter, 0, sort, len, diff]);
        console.log("Token " + title + " added.");
      }
  });
}

// Check if an OTP Token already exists in the DB
function checkOTP(title, secret) {
  var db = getDB();
  var res

  db.transaction(
    function(tx) {
      res = tx.executeSql("select title FROM OTPStorage WHERE title=? and secret=?;", [title, secret]);
  });

  return res.rows.length > 0 ? true : false
}

// Remove an existing OTP
function removeOTP(title, secret) {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("DELETE FROM OTPStorage WHERE title=? and secret=?;", [title, secret]);
  });
}

// Set OTP to favourite
function setFav(title, secret) {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("UPDATE OTPStorage set fav = 0");
      tx.executeSql("UPDATE OTPStorage set fav = 1 WHERE title=? and secret=?;", [title, secret]);
  });
}

// Reset favourite Flag for OTP
function resetFav(title, secret) {
  var db = getDB();

  db.transaction(
    function(tx) {
      tx.executeSql("UPDATE OTPStorage set fav = 0");
  });
}

// Change an existing OTP
function changeOTP(title, secret, type, counter, len, diff, oldtitle, oldsecret) {
  var db = getDB();

  db.transaction(
    function(tx) {
        tx.executeSql("UPDATE OTPStorage SET title=?, secret=?, type=?, counter=?, len=?, diff=? WHERE title=? and secret=?;", [title, secret, type, counter, len, diff, oldtitle, oldsecret]);
        console.log("Token " + title + " modified.");
      }
  );
}

function changeOTPSort(title, secret, sort) {
  var db = getDB();

  db.transaction(
    function(tx) {
      if (!checkOTP(title, secret)) {
        console.log("Token " + title + " is not in DB");
      } else {
        tx.executeSql("UPDATE OTPStorage SET sort=? WHERE title=? and secret=?;", [sort, title, secret]);
        console.log("Token " + title + " modified.");
      }
  });
}

// Get the counter for a HOTP value, incerment the counter on request
function getCounter(title, secret, increment) {
  var db = getDB();

  var res = "";

  db.transaction(
    function(tx) {
      res = tx.executeSql("SELECT counter FROM OTPStorage where title=? and secret=?;", [title, secret]);
      if (increment) tx.executeSql("UPDATE OTPStorage set counter=counter+1 WHERE title=? and secret=?;", [title, secret]);
  });

  return res.rows.item(0).counter;
}
