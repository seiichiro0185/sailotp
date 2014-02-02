# SailOTP

SailOTP is a Sailfish Implementation of the Google-Authenticator algorithms,
also known as TOPT (timer based) and HOTP (counter based) as described in RFC 6238 and 4226. A growing
number of sites uses this algorithm for two-factor-authentication, including
Github, Linode and several Google services.

One can add new OTP-entries using the pulley-menu. The type of token can be selected. Title and the shared
secret have to be provided. For counter based HOTP-tokens the counter value for the next update of the
Token can be set. The default of 1 is the standard value for new HOTP-tokens and should not be changed.

The main view of the app will show a list off all entries and their current One-Time-Tokens. 
The entries will be regenerated every 30 seconds, the remaining time for the current tokens is shown 
through a progress bar at the top of the app. HOTP-type tokens are not updated automatically, instead
a refresh button is shown on the right of the token to calculate the next value and increment the counter
An entry can be edited or deleted by long-pressing on it.

One entry can be stared by tapping the star icon on the left. the stared item will be shown
on the ActiveCover. If the Token is timer based, it will be refreshed every 30 seconds. 5 seconds before the token changes it's
color will change to red. For counter based tokens a cover action to calculate the next token is shown instead.
The item can be unstared by tapping the star icon again on the main view.

From the main view a token can be copied to the clipboard by tapping on it.

From the pulley menu the token database can be exported to a file for backup purposes. The backup is a AES-256-CBC encrypted and
Base64 encoded file containing a JSON-representation of the database. It can be decrypted with openssl using the following command:
 
    openssl enc -d -a -aes-256-cbc -in <file>

if you need the information outside of SailOTP.

Importing the file is also possible from the pulley menu. If a file contains tokens that are already in the database 
(title and secret of the token match an existing one), these tokens will not be added again.

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

SailOTP also uses the AES-Implementation from

<a href="https://github.com/mdp/gibberish-aes" target="_blank">https://github.com/mdp/gibberish-aes</a>

The implementation of the TOTP-algorithm was inspired by:

<a href="http://blog.tinisles.com/2011/10/google-authenticator-one-time-password-algorithm-in-javascript/" target="_blank">http://blog.tinisles.com/2011/10/google-authenticator-one-time-password-algorithm-in-javascript/</a>

