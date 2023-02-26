#ifndef QCIPHER_H
#define QCIPHER_H

#include <QObject>
#include <QString>
#include "cipher.h"

class QCipher : public QObject
{
    Q_OBJECT
public:
    explicit QCipher(QObject *parent = nullptr);

    Q_INVOKABLE QString encrypt(QString plaintext, QString pass);
    Q_INVOKABLE QString decrypt(QString ciphertext, QString pass);

private:
    Cipher c;

signals:

};

#endif // QCIPHER_H
