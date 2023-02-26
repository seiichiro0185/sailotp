#include "qcipher.h"

QCipher::QCipher(QObject *parent) : QObject(parent)
{
    c = Cipher("aes-256-cbc", "sha256");
}

QString QCipher::encrypt(QString plaintext, QString pass)
{
    try {
      std::string enc;
      enc = c.encrypt(plaintext.toStdString(), pass.toStdString());
      return QString::fromUtf8(enc.c_str());
    } catch (...) {
      return "";
    }

}

QString QCipher::decrypt(QString ciphertext, QString pass)
{
    try {
      std::string dec;
      dec = c.decrypt(ciphertext.toStdString(), pass.toStdString());
      return QString::fromUtf8(dec.c_str());
    } catch (...) {
      return "";
    }
};
