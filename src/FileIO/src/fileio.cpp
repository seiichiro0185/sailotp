/*
 * Copyright (c) 2014, Stefan Brand <seiichiro@seiichiro0185.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this
 *    list of conditions and the following disclaimer in the documentation and/or other
 *    materials provided with the distribution.
 *
 * 3. The names of the contributors may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "fileio.h"
#include <QFile>
#include <QDir>
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
      fileContent += line + "\n";
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

bool FileIO::mkpath(const QString& dirpath) {
  if (dirpath.isEmpty()) {
    emit error("Source is empty!");
    return false;
  }

  QDir dir(dirpath);
  return dir.mkpath(dirpath);
}
