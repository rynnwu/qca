# License under Lesser GNU General Public License.
#
# Description
# -------
#   Qt .pro to build the libqca-ossl2.a libqca-ossld2.a, and
#   qca-ossl2.dll. qca-ossld2.dll
#   for windows platfrom. Modified from commit 13d0dc5e6d2a.
#
# Author (refactor)
# -------
#   Rynn Wu <liveinlow@gmail.com>
#
TEMPLATE = lib
CONFIG += plugin
QT -= gui
DESTDIR = lib

VERSION = 2.0.0

# Include and link to qca
INCLUDEPATH += $$quote(../../include/QtCrypto)
CONFIG(debug, debug|release) {
        LIBS += -L$$quote(../../lib) -lqcad2
} else {
        LIBS += -L$$quote(../../lib) -lqca2
}

unix:include(conf.pri)
windows:CONFIG += crypto
windows:include(conf_win.pri)

CONFIG += create_prl

SOURCES = qca-ossl.cpp

windows:{
        WINLOCAL_PREFIX=$$quote(../../openssl)

	OPENSSL_PREFIX = $$WINLOCAL_PREFIX
	DEFINES += OSSL_097

	INCLUDEPATH += $$OPENSSL_PREFIX/include
        LIBS += -L$$OPENSSL_PREFIX/lib
        LIBS += -llibssl
        LIBS += -lopenssl
        LIBS += -llibcrypto
}

!debug_and_release|build_pass {
        CONFIG(debug, debug|release) {
                mac:TARGET = $$member(TARGET, 0)_debug
                windows:TARGET = $$member(TARGET, 0)d
        }
}
