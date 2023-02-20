#include "qcipher.h"

QCipher::QCipher(QObject *parent) : QObject(parent)
{
    c = Cipher("aes-256-cbc", "sha256");
}

QString QCipher::encrypt(QString plaintext, QString pass)
{
    std::string enc;
    enc = c.encrypt(plaintext.toStdString(), pass.toStdString());
    return QString::fromUtf8(enc.c_str());
}

QString QCipher::decrypt(QString ciphertext, QString pass)
{
    std::string dec;
    dec = c.decrypt(ciphertext.toStdString(), pass.toStdString());
    return QString::fromUtf8(dec.c_str());
};
