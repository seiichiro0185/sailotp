#include <QPainter>
#include "qqrencode.h"
#include "qrencode.h"

QQRencoder::QQRencoder() : QQuickImageProvider(QQuickImageProvider::Image) {}

QImage QQRencoder::requestImage(const QString &id, QSize *size, const QSize &requestedSize) {
    // Inspired by https://code.google.com/p/livepro/source/browse/trunk/gfxengine/QRCodeQtUtil.cpp

    int imgSize = 400;
    if (requestedSize.width() > 0) imgSize = requestedSize.width();

    // Encode QR-Data
    QRcode *qrdata = QRcode_encodeString(qPrintable(id), 0, QR_ECLEVEL_M, QR_MODE_8, 1);

    // Calculate width of the image
    int datawidth = qrdata->width;
    int pixsize = static_cast<int>((imgSize - 16) / datawidth);

    // allocate memory for the image
    QImage image(imgSize, imgSize, QImage::Format_Mono);
    memset(image.scanLine(0),0,image.byteCount());

    // Draw Image from QR-Data
    QPainter painter(&image);
    painter.fillRect(image.rect(),Qt::white);
    for(int x=0;x<datawidth;x++) {
      for(int y=0;y<datawidth;y++) {
        if(1 & qrdata->data[y*datawidth+x]) painter.fillRect(QRect(x*pixsize+16, y*pixsize+16, pixsize, pixsize), Qt::black);
      }
    }

    size->setHeight(image.height());
    size->setWidth(image.width());

    // free up memory
    painter.end();
    QRcode_free(qrdata);

    // return image data
    return image;
}

