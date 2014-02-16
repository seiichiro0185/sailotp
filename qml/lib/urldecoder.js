
function decode(url) {
  // otpauth://totp/user@host.com?secret=JBSWY3DPEHPK3PXP
  // otpauth://totp/user@host.com?secret=JBSWY3DPEHPK3PXP

  if (url.search(/^otpauth:\/\/[th]otp\/.*?.*/) != -1) {
    var ret = {"type": "", "title": "", "secret": "", "counter": ""};
    ret.type = url.slice(10,14).toUpperCase();
    ret.title = url.slice(15, url.indexOf("?"));
    var pstr = url.slice(url.indexOf("?")+1, url.length);
    var params = pstr.split("&");

    for (var i = 0; i < params.length; ++i) {
      pstr = params[i];
      var tmp = pstr.split("=");
      if (tmp[0] == "secret") ret.secret = tmp[1];
      if (tmp[0] == "counter") ret.counter = tmp[1];
    }

    return ret;
  }
}

