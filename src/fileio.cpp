#include "fileio.h"
#include <QFile>
#include <QTextStream>

FileIO::FileIO(QObject *parent) :
  QObject(parent)
{

}

QString FileIO::read()
{
  if (mSource.isEmpty()){
    emit error("source is empty");
    return QString();
  }

  QFile file(mSource);
  QString fileContent;
  if ( file.open(QIODevice::ReadOnly) ) {
    QString line;
    QTextStream t( &file );
    do {
      line = t.readLine();
      fileContent += line;
    } while (!line.isNull());

    file.close();
  } else {
    emit error("Unable to open the file");
    return QString();
  }
  return fileContent;
}

bool FileIO::write(const QString& data)
{
  if (mSource.isEmpty())
    return false;

  QFile file(mSource);
  if (!file.open(QFile::WriteOnly | QFile::Truncate))
    return false;

  QTextStream out(&file);
  out << data;

  file.close();

  return true;
}

bool FileIO::exists()
{
  if (mSource.isEmpty()) {
    emit error("Source is empty!");
    return false;
  }

  QFile file(mSource);
  return file.exists();
}

bool FileIO::exists(const QString& filename)
{
  if (filename.isEmpty()) {
    emit error("Source is empty!");
    return false;
  }

  QFile file(filename);
  return file.exists();
}
