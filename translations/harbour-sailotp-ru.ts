<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE TS>
<TS version="2.1" language="ru_RU">
<context>
    <name>About</name>
    <message>
        <location filename="../qml/pages/About.qml" line="75"/>
        <source>A Simple Sailfish OTP Generator
(RFC 6238/4226 compatible)</source>
        <translation>Простой генератор OTP для Sailfish
(совместим с RFS 6238/4226)</translation>
    </message>
    <message>
        <location filename="../qml/pages/About.qml" line="84"/>
        <source>Copyright: Stefan Brand
License: BSD (3-clause)</source>
        <translation>Авторские права: Стефан Брэнд
Лицензия: BSD (3-clause)</translation>
    </message>
    <message>
        <location filename="../qml/pages/About.qml" line="110"/>
        <source>SailOTP uses the following third party libs:</source>
        <translation>SailOTP использует следующие сторонние библиотеки:</translation>
    </message>
    <message>
        <location filename="../qml/pages/About.qml" line="121"/>
        <source>Contributors:</source>
        <translation>Участники:</translation>
    </message>
    <message>
        <location filename="../qml/pages/About.qml" line="121"/>
        <source>Support</source>
        <translation>Поддержка</translation>
    </message>
    <message>
        <location filename="../qml/pages/About.qml" line="132"/>
        <source>Translators:</source>
        <translation>Переводчики:</translation>
    </message>
</context>
<context>
    <name>ExportPage</name>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="63"/>
        <source>File already exists, choose &quot;Overwrite existing&quot; to overwrite it.</source>
        <translation>Файл уже существует, выберите: «Перезаписать существующий» для его перезаписи.</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="72"/>
        <source>Given file does not exist!</source>
        <translation>Данный файл не существует!</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="91"/>
        <location filename="../qml/pages/ExportPage.qml" line="107"/>
        <source>Export</source>
        <translation>Экспорт</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="91"/>
        <location filename="../qml/pages/ExportPage.qml" line="107"/>
        <source>Import</source>
        <translation>Импорт</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="114"/>
        <source>Filename</source>
        <translation>Имя файла</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="115"/>
        <source>File to import</source>
        <translation>Файл для импорта</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="115"/>
        <source>File to export</source>
        <translation>Файл для экспорта</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="128"/>
        <source>Overwrite existing</source>
        <translation>Перезаписать существующий</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="134"/>
        <source>Password</source>
        <translation>Пароль</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="135"/>
        <source>Password for the file</source>
        <translation>Пароль для файла</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="148"/>
        <source>Passwords don&apos;t match!</source>
        <translation>Пароли не совпадают!</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="148"/>
        <source>Passwords match!</source>
        <translation>Пароли совпадают!</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="149"/>
        <source>Repeated Password for the file</source>
        <translation>Повторный пароль для файла</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="173"/>
        <source>Here you can Import Tokens from a file. Put in the file location and the password you used on export. Pull left to start the import.</source>
        <translation>Здесь можно импортировать токены из файла. Введите путь к файлу и пароль, использованный при экспорте. Потяните влево чтобы начать импорт.</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="189"/>
        <source>Here you can export Tokens to a file. The exported file will be encrypted with AES-256-CBC and Base64 encoded. Choose a strong password, the file will contain the secrets used to generate the Tokens for your accounts. Pull left to start the export.</source>
        <translation>Здесь можно экспортировать токены в файл. Экспортированный файл будет зашифрован с использованием AES-256-CBC и кодирован в Base64. Выберите сильный пароль — файл будет содержать секреты, использованные для генерации токенов для Ваших аккаунтов. Потяните влево чтобы начать экспорт.</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="189"/>
        <source>To view the content of the export file outside of SailOTP use the following openssl command:</source>
        <translatorcomment>Translated using Google Translate</translatorcomment>
        <translation>Чтобы просмотреть содержимое файла экспорта за пределами SailOTP, используйте следующую команду openssl:</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="211"/>
        <source>Error writing to file </source>
        <translation>Ошибка при записи в файл </translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="213"/>
        <source>Token Database exported to </source>
        <translation>База данных токенов экспортирована в </translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="216"/>
        <source>Could not encrypt tokens. Error: </source>
        <translation>Не удалось зашифровать токены. Ошибка: </translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="219"/>
        <source>Could not read tokens from Database</source>
        <translation>Не удалось прочесть токены из базы данных</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="230"/>
        <source>Tokens imported from </source>
        <translation>Токены импортированы из </translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="235"/>
        <source>Unable to decrypt file, did you use the right password?</source>
        <translation>Не удалось расшифровать файл. Был ли введен правильный пароль?</translation>
    </message>
    <message>
        <location filename="../qml/pages/ExportPage.qml" line="238"/>
        <source>Could not read from file </source>
        <translation>Не удалось прочесть из файла </translation>
    </message>
</context>
<context>
    <name>MainView</name>
    <message>
        <location filename="../qml/pages/MainView.qml" line="95"/>
        <source>About</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="99"/>
        <source>Settings</source>
        <translation type="unfinished">настройки</translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="104"/>
        <source>Export / Import</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="108"/>
        <source>Add Token</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="122"/>
        <source>Nothing here</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="123"/>
        <source>Pull down to add a OTP</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="158"/>
        <source>Deleting</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="179"/>
        <location filename="../qml/pages/MainView.qml" line="253"/>
        <source>Token for </source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="179"/>
        <location filename="../qml/pages/MainView.qml" line="253"/>
        <source> copied to clipboard</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="249"/>
        <source>Copy to Clipboard</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="257"/>
        <source>Show Token as QR-Code</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="262"/>
        <source>Move up</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="267"/>
        <source>Move down</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="272"/>
        <source>Edit</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/MainView.qml" line="278"/>
        <source>Delete</source>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>QRPage</name>
    <message>
        <location filename="../qml/pages/QRPage.qml" line="74"/>
        <source>Can&apos;t create QR-Code from an empty String</source>
        <translation type="unfinished"></translation>
    </message>
</context>
<context>
    <name>ScanOTP</name>
    <message>
        <location filename="../qml/pages/ScanOTP.qml" line="54"/>
        <source>Can&apos;t access temporary directory</source>
        <translation>Не удалось получить доступ к временной директории</translation>
    </message>
    <message>
        <location filename="../qml/pages/ScanOTP.qml" line="64"/>
        <source>Add manually</source>
        <translation>Добавить вручную</translation>
    </message>
    <message>
        <location filename="../qml/pages/ScanOTP.qml" line="71"/>
        <source>Scan Code</source>
        <translation>Отсканировать код</translation>
    </message>
    <message>
        <location filename="../qml/pages/ScanOTP.qml" line="71"/>
        <source>Scanning...</source>
        <translation>Сканирование...</translation>
    </message>
    <message>
        <location filename="../qml/pages/ScanOTP.qml" line="96"/>
        <source>No valid Token data found.</source>
        <translation>Не найдено корректных данных для токена.</translation>
    </message>
    <message>
        <location filename="../qml/pages/ScanOTP.qml" line="137"/>
        <source>Tap the picture to start / stop scanning. Pull down to add Token manually.</source>
        <translation>Нажмите на изображение чтобы начать / остановить сканирование. Потяните вниз чтобы добавить токен вручную.</translation>
    </message>
</context>
<context>
    <name>Settings</name>
    <message>
        <location filename="../qml/pages/Settings.qml" line="50"/>
        <source>Settings</source>
        <translation type="unfinished">настройки</translation>
    </message>
    <message>
        <location filename="../qml/pages/Settings.qml" line="52"/>
        <source>Behaviour</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/Settings.qml" line="56"/>
        <source>Show Token as QR on Tap</source>
        <translation type="unfinished"></translation>
    </message>
    <message>
        <location filename="../qml/pages/Settings.qml" line="69"/>
        <source>Hide Tokens and Reveal on Tap</source>
        <translation type="unfinished"></translation>
    </message>
</context>
</TS>
