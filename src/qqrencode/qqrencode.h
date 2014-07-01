#ifndef QQRENCODE_H
#define QQRENCODE_H

#include <QObject>
#include <QImage>
#include <QQuickImageProvider>

QT_BEGIN_NAMESPACE

class QQRencoder : public QQuickImageProvider {
public:
    explicit QQRencoder();
    virtual QImage requestImage(const QString &id, QSize *size, const QSize& requestedSize);
};

#endif // QQRENCODE_H
