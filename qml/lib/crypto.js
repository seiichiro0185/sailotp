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

.import "./sha.js" as SHA

// *** Helper Functions *** //

// Decimal to HEX
function dec2hex(s) { return (s < 15.5 ? '0' : '') + Math.round(s).toString(16); }

// HEX to Decimal
function hex2dec(s) { return parseInt(s, 16); }

// Convert Base32-secret to HEX Value
function base32tohex(base32) {
  var base32chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
  var bits = "";
  var hex = "";

  for (var i = 0; i < base32.length; i++) {
    var val = base32chars.indexOf(base32.charAt(i).toUpperCase());
    bits += leftpad(val.toString(2), 5, '0');
  }

  for (var i = 0; i+4 <= bits.length; i+=4) {
    var chunk = bits.substr(i, 4);
    hex = hex + parseInt(chunk, 2).toString(16) ;
  }
  return hex.length % 2 ? hex + "0" : hex;
}

// Pad Strings to given length
function leftpad(str, len, pad) {
  if (len + 1 >= str.length) {
      str = Array(len + 1 - str.length).join(pad) + str;
  }
  return str;
}

// characters steam uses to generate the final code
var steamChars = ['2', '3', '4', '5', '6', '7', '8', '9', 'B', 'C',
                  'D', 'F', 'G', 'H', 'J', 'K', 'M', 'N', 'P', 'Q',
                  'R', 'T', 'V', 'W', 'X', 'Y']

// *** Main Function *** //

// Calculate an OTP-Value from the given secret
// Parameters are:
//   secret: The secret key in Base32-Notation
//   tpye: either TOTP for timer based or HOTP for counter based calculation
//   counter: counter value for HOTP
function calcOTP(secret, type, counter) {
  // Convert the key to HEX
  var key = base32tohex(secret);
  var factor = "";

  if (type.substr(0, 4) == "TOTP") {
    // Get current Time in UNIX Timestamp format (Seconds since 01.01.1970 00:00 UTC)
    var epoch = Math.round(new Date().getTime() / 1000.0);
    // Get last full 30 / 60 Seconds and convert to HEX
    factor = leftpad(dec2hex(Math.floor(epoch / 30)), 16, '0');
  } else {
    factor = leftpad(dec2hex(counter), 16, '0');
  }

  try {
    // Calculate the SHA-1 HMAC Value from time and key
    var hmacObj = new SHA.jsSHA(factor, 'HEX');
    var hmac = hmacObj.getHMAC(key, 'HEX', 'SHA-1', "HEX");

    // Finally convert the HMAC-Value to the corresponding 6-digit token
    var offset = hex2dec(hmac.substring(hmac.length - 1));

    var code = hex2dec(hmac.substr(offset * 2, 8)) & hex2dec('7fffffff');
    var otp = '';

    // Steam has it's own way of creating the code from the result
    if (type == "TOTP_STEAM") {
      for (var i = 0; i < 5; i++) {
        otp += steamChars[code % steamChars.length];
        code = Math.floor(code/steamChars.length);
      }
    } else {
      otp = code + '';
      otp = (otp).substr(otp.length - 6, 6);
    }
  } catch (e) {
    otp = "Invalid Secret!"
  }

  // return the calculated token
  return otp;
}
