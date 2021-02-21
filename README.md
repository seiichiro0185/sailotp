# SailOTP

SailOTP is a Sailfish Implementation of the Google-Authenticator algorithms, also known as TOPT (timer based) and HOTP (counter based) as described in RFC 6238 and 4226. A growing number of sites uses this algorithm for two-factor-authentication, including Github, Linode and several Google services.

One can add new OTP-entries using the pulley-menu. Codes can be added using the integrated QR-Code-Reader or by manually typing in the token information.

The main view of the app will show a list off all entries and their current One-Time-Tokens. The entries will be regenerated every 30 seconds, the remaining time for the current tokens is shown through a progress bar at the top of the app. HOTP-type tokens are not updated automatically, instead a refresh button is shown on the right of the token to calculate the next value and increment the counter. An entry can be edited, deleted or moved up and down in the list by long-pressing on it.

In edit-mode one can show a QR-Code of the entry (e.g. for importing it on another device) through the pulley menu.

One entry can be stared by tapping the star icon on the left. the stared item will be shown on the ActiveCover. If the Token is timer based, it will be refreshed every 30 seconds. 5 seconds before the token changes it's color will change to red. For counter based tokens a cover action to calculate the next token is shown instead. The item can be unstared by tapping the star icon again on the main view.

From the main view a token can be copied to the clipboard by tapping on it.

From the pulley menu the token database can be exported to a file for backup purposes. The backup is a AES-256-CBC encrypted and
Base64 encoded file containing a JSON-representation of the database. It can be decrypted with openssl using the following command:

openssl enc -d -a -A -md md5 -aes-256-cbc -in <file>

if you need the information outside of SailOTP.

Importing the file is also possible from the pulley menu. If a file contains tokens that are already in the database (title and secret of the token match an existing one), these tokens will not be added again.

It is also possible to generate tokens for SteamGuard (Steams TOTP-Variant for 2-Factor-Auth). To use this feature, one will have to activate it using the original Steam Android app. After activating it one can get the secret code from '/opt/alien/data/data/com.valvesoftware.android.steam.community/files/Steamguard-$STEAMID'. This file contains json data, including the OTP-URL in the form 'otpauth://totp/Steam:$STEAM_USERNAME?secret=$SECRET&issuer=Steam'. The code from this URL can be added manually using the 'Steam Guard'-OTP-Type in SailOTP.

## Contact and Issues

If you find any bugs or want to suggest a feature, feel free to use Githubs Issues feature at
<a href="https://github.com/seiichiro0185/sailotp/issues" target="_blank">https://github.com/seiichiro0185/sailotp/issues</a>
or write an email to sailfish _AT_ seiichiro0185.org

## License

SailOTP is licensed under a 3-Clause BSD-License. See COPYING for details.

## Acknowledgements

SailOTP uses the SHA-1 and HMAC-Implementation from 

<a href="https://github.com/Caligatio/jsSHA" target="_blank">https://github.com/Caligatio/jsSHA</a>

SailOTP also uses the AES-Implementation from

<a href="https://code.google.com/archive/p/crypto-js/" target="_blank">https://code.google.com/archive/p/crypto-js/</a>

The implementation of the TOTP-algorithm was inspired by:

<a href="http://blog.tinisles.com/2011/10/google-authenticator-one-time-password-algorithm-in-javascript/" target="_blank">http://blog.tinisles.com/2011/10/google-authenticator-one-time-password-algorithm-in-javascript/</a>

An adapted version of the QZXing-library is used for QRCode-decoding
<a href="http://sourceforge.net/projects/qzxing/">http://sourceforge.net/projects/qzxing/</a>

The qrencode library is used for QRCode-encoding existing tokens for export to other devices.
<a href="http://fukuchi.org/works/qrencode/">http://fukuchi.org/works/qrencode/</a>

## Translations

The following people have contributed to translating SailOTP:

  * Chinese: BirdZhang
  * Finnish: Johan Heikkilä (hevanaa), Jyri-Petteri Paloposki (ZeiP)
  * French: Romain Tartière (smortex)
  * Italian: Tichy
  * Hungarian: 1Zgp
  * Russian: moorchegue
  * Spanish: p4moedo
  * Swedish: Åke Engelbrektson (eson57)
  * English: Stefan Brand (seiichiro0185)
  * German: Stefan Brand (seiichiro0185)
