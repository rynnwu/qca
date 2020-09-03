# License under Lesser GNU General Public License.
# 
# Description
# -------
#   Qt .pro to build the libqcad2.a, libqca2.a, qcad2.dll, qca2.dll
#   for windows platfrom. Modified from commit 13d0dc5e6d2a
#
# Author (refactor)
# -------
#   Rynn Wu <liveinlow@gmail.com>

# qca qmake profile

QCA_BASE = ..
QCA_INCBASE = ../include
QCA_SRCBASE = .

TEMPLATE = lib
QT      -= gui
TARGET   = qca
DESTDIR  = $$QCA_BASE/lib
windows:DLLDESTDIR = $$QCA_BASE/bin

VERSION = 2.3.1

# Igonre this conf.pri, unnecessary.
# include($$QCA_BASE/conf.pri)

CONFIG += create_prl
windows:!staticlib:DEFINES += QCA_MAKEDLL
staticlib:PRL_EXPORT_DEFINES += QCA_STATIC

QCA_INC = $$QCA_INCBASE/QtCrypto
QCA_CPP = $$QCA_SRCBASE
botan_BASE = $$QCA_SRCBASE/botantools/botan

INCLUDEPATH += $$QCA_INC $$QCA_CPP




# definitions from CMakeList
DEFINES += BOTAN_TYPES_QT
DEFINES += BOTAN_NO_INIT_H
DEFINES += BOTAN_NO_CONF_H
DEFINES += BOTAN_TOOLS_ONLY
DEFINES += BOTAN_MINIMAL_BIGINT

DEFINES += BOTAN_MP_WORD_BITS=32
DEFINES += BOTAN_KARAT_MUL_THRESHOLD=12
DEFINES += BOTAN_KARAT_SQR_THRESHOLD=12
DEFINES += BOTAN_EXT_MUTEX_QT



# botantools
# include($$QCA_SRCBASE/botantools/botantools.pri)

PRIVATE_HEADERS += \
	$$QCA_CPP/qca_safeobj.h \
	$$QCA_CPP/qca_plugin.h \
	$$QCA_CPP/qca_systemstore.h

PUBLIC_HEADERS += \
	$$QCA_INC/qca_export.h \
	$$QCA_INC/qca_support.h \
	$$QCA_INC/qca_tools.h \
	$$QCA_INC/qca_core.h \
	$$QCA_INC/qca_textfilter.h \
	$$QCA_INC/qca_basic.h \
	$$QCA_INC/qca_publickey.h \
	$$QCA_INC/qca_cert.h \
	$$QCA_INC/qca_keystore.h \
	$$QCA_INC/qca_securelayer.h \
	$$QCA_INC/qca_securemessage.h \
	$$QCA_INC/qca_safetimer.h \
	$$QCA_INC/qcaprovider.h \
	$$QCA_INC/qpipe.h

HEADERS += $$PRIVATE_HEADERS $$PUBLIC_HEADERS

# do support first
SOURCES += \
	$$QCA_CPP/support/syncthread.cpp \
	$$QCA_CPP/support/logger.cpp \
	$$QCA_CPP/support/synchronizer.cpp \
	$$QCA_CPP/support/dirwatch.cpp

SOURCES += \
	$$QCA_CPP/qca_safeobj.cpp \
	$$QCA_CPP/qca_tools.cpp \
	$$QCA_CPP/qca_core.cpp \
	$$QCA_CPP/qca_textfilter.cpp \
	$$QCA_CPP/qca_plugin.cpp \
	$$QCA_CPP/qca_basic.cpp \
	$$QCA_CPP/qca_publickey.cpp \
	$$QCA_CPP/qca_cert.cpp \
	$$QCA_CPP/qca_keystore.cpp \
	$$QCA_CPP/qca_securelayer.cpp \
	$$QCA_CPP/qca_securemessage.cpp \
	$$QCA_CPP/qca_default.cpp \
	$$QCA_CPP/support/qpipe.cpp \
	$$QCA_CPP/support/console.cpp

# botantools
INCLUDEPATH += ./botantools/botan

SOURCES += $$QCA_CPP/qca_safetimer.cpp
SOURCES += $$botan_BASE/util.cpp
SOURCES += $$botan_BASE/exceptn.cpp
SOURCES += $$botan_BASE/mutex.cpp
SOURCES += $$botan_BASE/mux_qt/mux_qt.cpp
SOURCES += $$botan_BASE/charset.cpp
SOURCES += $$botan_BASE/defalloc.cpp
SOURCES += $$botan_BASE/mp_comba.cpp
SOURCES += $$botan_BASE/mp_mul.cpp
SOURCES += $$botan_BASE/mp_shift.cpp
SOURCES += $$botan_BASE/mp_misc.cpp
SOURCES += $$botan_BASE/divide.cpp
SOURCES += $$botan_BASE/big_base.cpp
SOURCES += $$botan_BASE/big_code.cpp
SOURCES += $$botan_BASE/big_io.cpp
SOURCES += $$botan_BASE/big_ops2.cpp
SOURCES += $$botan_BASE/big_ops3.cpp
SOURCES += $$botan_BASE/bit_ops.cpp
SOURCES += $$botan_BASE/libstate.cpp
SOURCES += $$botan_BASE/mem_pool.cpp
SOURCES += $$botan_BASE/modules.cpp
SOURCES += $$botan_BASE/mp_asm.cpp
SOURCES += $$botan_BASE/mp_mulop.cpp
SOURCES += $$botan_BASE/parsing.cpp
SOURCES += $$botan_BASE/ml_win32/mlock.cpp


unix:!mac: {
	SOURCES += $$QCA_CPP/qca_systemstore_flatfile.cpp
}
windows: {
	SOURCES += $$QCA_CPP/qca_systemstore_win.cpp
	LIBS += -lcrypt32
}
mac: {
	SOURCES += $$QCA_CPP/qca_systemstore_mac.cpp
	LIBS += -framework Carbon -framework Security
	QMAKE_LFLAGS_SONAME = -Wl,-install_name,"$$LIBDIR/"

	QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.3
}

mac:lib_bundle: {
	QMAKE_FRAMEWORK_BUNDLE_NAME = $$TARGET
	CONFIG(debug, debug|release) {
		!build_pass:CONFIG += build_all
	} else { #release
		!debug_and_release|build_pass {
			FRAMEWORK_HEADERS.version = Versions
			FRAMEWORK_HEADERS.files = $$PUBLIC_HEADERS $$QCA_INC/qca.h $$QCA_INC/QtCrypto
			FRAMEWORK_HEADERS.path = Headers
			QMAKE_BUNDLE_DATA += FRAMEWORK_HEADERS
		}
	}
}

unix: {
	# install
	target.path = $$LIBDIR
	INSTALLS += target

	incfiles.path = $$INCDIR/QtCrypto
	incfiles.files = $$PUBLIC_HEADERS
	incfiles.files += $$QCA_INC/qca.h $$QCA_INC/QtCrypto
	!lib_bundle:INSTALLS += incfiles

	manfiles.path = $$DATADIR/man/man1
	manfiles.files = $$QCA_BASE/man/qcatool2.1
	INSTALLS += manfiles
}

!debug_and_release|build_pass {
	CONFIG(debug, debug|release) {
		mac:TARGET = $$member(TARGET, 0)_debug
		windows:TARGET = $$member(TARGET, 0)d
	}
}
