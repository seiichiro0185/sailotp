#include "qzxing.h"

#include <QtCore>
#include <zxing/common/GlobalHistogramBinarizer.h>
#include <zxing/Binarizer.h>
#include <zxing/BinaryBitmap.h>
#include <zxing/MultiFormatReader.h>
#include <zxing/DecodeHints.h>
#include "CameraImageWrapper.h"

using namespace zxing;

QZXing::QZXing(QObject *parent) : QObject(parent)
{
    decoder = new MultiFormatReader();
    setDecoder(DecoderFormat_QR_CODE);
    /*setDecoder(DecoderFormat_QR_CODE |
               DecoderFormat_DATA_MATRIX |
               DecoderFormat_UPC_E |
               DecoderFormat_UPC_A |
               DecoderFormat_EAN_8 |
               DecoderFormat_EAN_13 |
               DecoderFormat_CODE_128 |
               DecoderFormat_CODE_39 |
               DecoderFormat_ITF |
               DecoderFormat_Aztec);*/
}

QZXing::~QZXing() {
    delete (MultiFormatReader*)decoder;
    decoder = 0;
}

void QZXing::setDecoder(DecoderFormatType hint)
{
    DecodeHints newHints;

    if(hint & DecoderFormat_QR_CODE)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_QR_CODE);

    if(hint & DecoderFormat_DATA_MATRIX)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_DATA_MATRIX);

    if(hint & DecoderFormat_UPC_E)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_UPC_E);

    if(hint & DecoderFormat_UPC_A)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_UPC_A);

    if(hint & DecoderFormat_EAN_8)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_EAN_8);

    if(hint & DecoderFormat_EAN_13)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_EAN_13);

    if(hint & DecoderFormat_CODE_128)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_CODE_128);

    if(hint & DecoderFormat_CODE_39)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_CODE_39);

    if(hint & DecoderFormat_ITF)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_ITF);

    if(hint & DecoderFormat_Aztec)
        newHints.addFormat((BarcodeFormat)BarcodeFormat_AZTEC);

    supportedFormats = newHints.getCurrentHint();
}


QString QZXing::decodeImage(QImage image)
{
    Ref<Result> result;
    emit decodingStarted();

    try {
        Ref<LuminanceSource> source(new CameraImageWrapper(image));

        Ref<Binarizer> binarizer;
        binarizer = new GlobalHistogramBinarizer(source);

        Ref<BinaryBitmap> binary(new BinaryBitmap(binarizer));

        DecodeHints hints((int)supportedFormats);

        result = ((MultiFormatReader*)decoder)->decode(binary, hints);

        QString string = QString(result->getText()->getText().c_str());
        emit tagFound(string);
        emit decodingFinished(true);
        return string;
    }
    catch(zxing::Exception& e)
    {
       qDebug() << "[decodeImage()] Exception:" << e.what();
       emit decodingFinished(false);
       return "";
    }
}

QVariantHash QZXing::decodeImageEx(QImage image)
{
    QVariantHash resultMap;
    Ref<Result> result;
    emit decodingStarted();

    try {
        Ref<LuminanceSource> source(new CameraImageWrapper(image));

        Ref<Binarizer> binarizer;
        binarizer = new GlobalHistogramBinarizer(source);

        Ref<BinaryBitmap> binary(new BinaryBitmap(binarizer));

        DecodeHints hints((int)supportedFormats);

        result = ((MultiFormatReader*)decoder)->decode(binary, hints);

        QString string = QString(result->getText()->getText().c_str());
        QList<QVariant> points;
        emit tagFound(string);
        emit decodingFinished(true);
        resultMap.insert("content", string);

        std::vector<Ref<ResultPoint> > resultPoints = result->getResultPoints();
        for (unsigned int i = 0; i < resultPoints.size(); i++) {
            points.append(QPoint(resultPoints[i]->getX(), resultPoints[i]->getY()));
        }
        resultMap.insert("points", points);
    }
    catch(zxing::Exception& e)
    {
       qDebug() << "[decodeImage()] Exception:" << e.what();
       emit decodingFinished(false);
       resultMap.insert("content", QString(""));
       resultMap.insert("points", QList<QVariant>());
    }
    return resultMap;
}

QString QZXing::decodeImageFromFile(QString imageFilePath)
{
    //used to have a check if this image exists
    //but was removed because if the image file path doesn't point to a valid image
    // then the QImage::isNull will return true and the decoding will fail eitherway.
    return decodeImage(QImage(imageFilePath));
}

QString QZXing::decodeImageQML(const QUrl &imageUrl)
{
    return decodeSubImageQML(imageUrl);
}

QString QZXing::decodeSubImageQML(const QUrl &imageUrl,
                                  const double offsetX, const double offsetY,
                                  const double width, const double height)
{

    QString imagePath = imageUrl.path();
    imagePath = imagePath.trimmed();
    QFile file(imagePath);

    if (!file.exists()) {
        qDebug() << "[decodeSubImageQML()] The file" << file.fileName() << "does not exist.";
        emit decodingFinished(false);
        return "";
    }

    QImage img(imageUrl.path());

    if(!(offsetX == 0 && offsetY == 0 && width == 0 && height == 0)) {
        img = img.copy(offsetX, offsetY, width, height);
    }

    return decodeImage(img);

}

