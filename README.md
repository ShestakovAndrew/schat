
# Simple Chat 2.3.3

Simple Chat - это простой и мощный кроссплатформенный чат клиент-сервер для локальных сетей и Интернета.


## Установка Windows

### Компиляция
- Скачать VS2010
- Скачать ``qt-opensource-windows-x86-vs2010-4.8.7.exe``

---
Через Visual Studio 2010:

- Скачать расширение ``qt-vs-addin-1.1.11-opensource.exe``
- Открыть склонированный проект через установленное расширение VS2010

Через Qt Creator:

- Скачать Qt Creator
- Открыть склонированный проект через Qt Creator
---

- Запустить сборку
### Создание установочного файла

- Вывод сборки будет в ``build/%имя_билда%/``
- Перейти в ``os/win32``
- Запустить ``nsis.cmd`` для сборки исполняемого файла (если будет ошибка, нужно поправить пути)

Если qt нестатический, то при запуске на компьютере где нет нужных dll будут ошибки. Решение собрать qt статически и собирать через него, либо в ``/engine/sections/Qt.nsh`` добавить недостающие dll в сборку (немного раздуется exe).

- Установочный файл будет лежать в ``win32/out/``

## Установка Ubuntu-16.04

### Компиляция
- Установить Ubuntu-16.04
- Обновить данные:
```
    apt-get update -y && apt-get upgrade -y
```
- установить зависимости:
```
    sudo apt-get install build-essential libqt4-dev qt4-dev-tools qt4-qmake qt4-designer libxss-dev pkg-config libqtwebkit-dev zlib1g-dev debhelper libhunspell-dev libgeoip-dev -y
```
- Запустить генерацию Makefile:
```
    qmake -r
```
- Запустить сборку Makefile:
```
    make
```

Результат сборки будет находится в ``schat/out/``, готовый вариант прикреплён в релиз ``out.tar``

### Копирование собранных файлов
- Установить сборку по Makefile:
```
    make install
```

Если запускать через wsl, нужно отключить использование разделяемой памяти для клиента:
```
cd schat/out
export QT_X11_NO_MITSHM=1 ./schat2
```
### Создание .deb файлов
- Перейти в директорию:
```
    cd os/ubuntu/
```
- Запустить сборку установщика:
```
    ./build.sh
```

Файлы ``.deb`` будут находиться в ``schat/os/ubuntu/deb``
