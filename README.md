# SailOTP

SailOTP is a Sailfish Implementation of the Google-Authenticator algorithm,
also known as Timebased One Time Pad (TOPT) as described in RFC 6238. A growing
number of sites uses this algorithm for two-factor-authentication, including
Github, Linode and several Google services.

At the moment the App is quite basic. One can add new OTP-entries using the
pulley-menu. The main view of the app will show a List off all entries and
their current One-Time-Tokens. The entries will be regenerated every 30 seconds, the remaining time for the current tokens is shown through a progress bar at the top of the app. An entry can be deleted by long-pressing on it.

## Known Limitations

At the moment the only way to insert new entries into the app is to insert the
title and secret key by hand. It's not possible to use the QR-Codes some sites
provide directly.

## Contact and Issues

If you find any bugs or want to suggest a feature, feel free to use Githubs
Issues feature.

## License

SailOTP is licensed under a 3-Clause BSD-License. See COPYING for details.

## Accnowledgements

SailOTP uses the SHA-1 and HMAC-Implementation from 

<a href="https://github.com/Caligatio/jsSHA" target="_blank">https://github.com/Caligatio/jsSHA</a>

The implementation of the TOTP-algorithm was inspired by:

<a href="http://blog.tinisles.com/2011/10/google-authenticator-one-time-password-algorithm-in-javascript/" target="_blank">http://blog.tinisles.com/2011/10/google-authenticator-one-time-password-algorithm-in-javascript/</a>

