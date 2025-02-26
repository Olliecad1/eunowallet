TEMPLATE = app
TARGET = euno-qt
VERSION = 1.0.4.2
INCLUDEPATH += src src/json src/qt src/qt/plugins/mrichtexteditor
DEFINES += ENABLE_WALLET
DEFINES += BOOST_THREAD_USE_LIB BOOST_SPIRIT_THREADSAFE
CONFIG += no_include_pwd
CONFIG += thread
CONFIG += static
QT += core gui network printsupport
QMAKE_CXXFLAGS = -fpermissive -std=c++11

greaterThan(QT_MAJOR_VERSION, 4) {
    QT += widgets
    DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
}

isEmpty(BDB_LIB_SUFFIX) {
    macx:BDB_LIB_SUFFIX = -4.8
}
isEmpty(MINIUPNPC_LIB_SUFFIX) {
    windows:MINIUPNPC_LIB_SUFFIX=-miniupnpc
}

windows {
	# for extra security on Windows: enable ASLR and DEP via GCC linker flags
	win32:QMAKE_LFLAGS *= -Wl,--dynamicbase -Wl,--nxcompat
	# on win32: enable GCC large address aware linker flag
	win32:QMAKE_LFLAGS *= -Wl,--large-address-aware -static
	win32:QMAKE_LFLAGS += -static-libgcc -static-libstdc++
	lessThan(QT_MAJOR_VERSION, 5): win32:QMAKE_LFLAGS *= -static
}


linux {
     LIBS += -lboost_system$$BOOST_LIB_SUFFIX -lboost_filesystem$$BOOST_LIB_SUFFIX -lboost_program_options$$BOOST_LIB_SUFFIX -lboost_thread$$BOOST_THREAD_LIB_SUFFIX
     CONFIG+= static
     DEFINES+= STATIC
     #QMAKE_LFLAGS += -static
     SECP256K1_LIB_PATH = $$PWD/src/secp256k1/.libs
     SECP256K1_INCLUDE_PATH = $$PWD/src/secp256k1/include
}

macx {
#  QMAKE_LFLAGS *= -static
  BOOST_INCLUDE_PATH = /usr/local/opt/boost@1.59/include
  BOOST_LIB_PATH = /usr/local/opt/boost@1.59/lib
  QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11
  OPENSSL_INCLUDE_PATH = /usr/local/Cellar/openssl/1.0.2o_2/include
  OPENSSL_LIB_PATH = /usr/local/Cellar/openssl/1.0.2o_2/lib
  BDB_LIB_PATH = /usr/local/Cellar/berkeley-db@4/4.8.30/lib
  BDB_INCLUDE_PATH = /usr/local/Cellar/berkeley-db@4/4.8.30/include
  QRENCODE_INCLUDE_PATH = /usr/local/Cellar/qrencode/4.0.2/include
  QRENCODE_LIB_PATH = /usr/local/Cellar/qrencode/4.0.2/lib
  MINIUPNPC_INCLUDE_PATH = /usr/local/Cellar/miniupnpc/2.1/include
  MINIUPNPC_LIB_PATH = /usr/local/Cellar/miniupnpc/2.1/lib
  SECP256K1_LIB_PATH = $$PWD/src/secp256k1/.libs
  SECP256K1_INCLUDE_PATH = $$PWD/src/secp256k1/include
}

# Dependency library locations can be customized with:
#    BOOST_INCLUDE_PATH, BOOST_LIB_PATH, BDB_INCLUDE_PATH,
#    BDB_LIB_PATH, OPENSSL_INCLUDE_PATH and OPENSSL_LIB_PATH respectively
OBJECTS_DIR = build
MOC_DIR = build
UI_DIR = build

# use: qmake "RELEASE=1"
contains(RELEASE, 1) {
    # MaC compile for maximum compatibility (10.11, 32-bit)
    macx:QMAKE_CXXFLAGS += -stdlib=libc++ -mmacosx-version-min=10.11 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    macx:QMAKE_CFLAGS += -mmacosx-version-min=10.11 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    macx:QMAKE_LFLAGS += -mmacosx-version-min=10.11 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    macx:QMAKE_OBJECTIVE_CFLAGS += -mmacosx-version-min=10.11 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    macx:QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11
    !windows:!macx {
        #Linux: static link
        LIBS += -Wl,-Bstatic
        linux:QMAKE_LFLAGS *= -static
    }
}

contains(RELEASE_AMD64, 1) {
    # Mac: optimised 64-bit x86
    macx:QMAKE_CFLAGS += -DMOVQ_FIX -arch x86_64 -fomit-frame-pointer -mdynamic-no-pic -I/usr/local/amd64/include
    macx:QMAKE_CXXFLAGS += -arch x86_64 -fomit-frame-pointer -mdynamic-no-pic -I/usr/local/amd64/include -stdlib=libc++
    macx:QMAKE_LFLAGS += -arch x86_64 -L/usr/local/amd64/lib
    # Mac: 10.11+ compatibility
    macx:QMAKE_CFLAGS += -mmacosx-version-min=10.11 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    macx:QMAKE_CXXFLAGS += -mmacosx-version-min=10.11 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    macx:QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11
}

# use: qmake RELEASE_I386=1
contains(RELEASE_I386, 1) {
    # Mac: optimised 32-bit x86
    macx:QMAKE_CFLAGS += -arch i386 -fomit-frame-pointer -msse2 -mdynamic-no-pic -I/usr/local/i386/include
    macx:QMAKE_CXXFLAGS += -arch i386 -stdlib=libc++ -fomit-frame-pointer -msse2 -mdynamic-no-pic -I/usr/local/i386/include
    macx:QMAKE_LFLAGS += -arch i386 -L/usr/local/i386/lib
    # Mac: 10.5+ compatibility; Qt with Cocoa is broken on 10.4
    macx:QMAKE_CFLAGS += -mmacosx-version-min=10.11 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    macx:QMAKE_CXXFLAGS += -mmacosx-version-min=10.11 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
    macx:QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.11
    # Windows: optimised 32-bit x86
    win32:QMAKE_CFLAGS += -march=i686 -fomit-frame-pointer
    win32:QMAKE_CXXFLAGS += -march=i686 -fomit-frame-pointer
}

!win32 {
# for extra security against potential buffer overflows: enable GCCs Stack Smashing Protection
QMAKE_CXXFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
QMAKE_LFLAGS *= -fstack-protector-all --param ssp-buffer-size=1
# We need to exclude this for Windows cross compile with MinGW 4.2.x, as it will result in a non-working executable!
# This can be enabled for Windows, when we switch to MinGW >= 4.4.x.
}


# use: qmake "USE_QRCODE=1"
# libqrencode (http://fukuchi.org/works/qrencode/index.en.html) must be installed for support
contains(USE_QRCODE, 1) {
    message(Building with QRCode support)
    DEFINES += USE_QRCODE
    LIBS += -lqrencode
}

# use: qmake "USE_UPNP=1" ( enabled by default; default)
#  or: qmake "USE_UPNP=0" (disabled by default)
#  or: qmake "USE_UPNP=-" (not supported)
# miniupnpc (http://miniupnp.free.fr/files/) must be installed for support
contains(USE_UPNP, -) {
    message(Building without UPNP support)
} else {
    message(Building with UPNP support)
    count(USE_UPNP, 0) {
        USE_UPNP=1
    }
    DEFINES += USE_UPNP=$$USE_UPNP MINIUPNP_STATICLIB STATICLIB __STDC_FORMAT_MACROS=1
    INCLUDEPATH += $$MINIUPNPC_INCLUDE_PATH
    LIBS += $$join(MINIUPNPC_LIB_PATH,,-L,) -lminiupnpc
    win32:LIBS += -liphlpapi
}

# use: qmake "USE_DBUS=1" or qmake "USE_DBUS=0"
linux:count(USE_DBUS, 0) {
    USE_DBUS=1
}
contains(USE_DBUS, 1) {
    message(Building with DBUS (Freedesktop notifications) support)
    DEFINES += USE_DBUS
    QT += dbus
}

contains(BITCOIN_NEED_QT_PLUGINS, 1) {
    DEFINES += BITCOIN_NEED_QT_PLUGINS
    QTPLUGIN += qcncodecs qjpcodecs qtwcodecs qkrcodecs qtaccessiblewidgets
}

# LIBSEC256K1 SUPPORT
QMAKE_CXXFLAGS *= -DUSE_SECP256K1

INCLUDEPATH += src/leveldb/include src/leveldb/helpers
LIBS += $$PWD/src/leveldb/libleveldb.a $$PWD/src/leveldb/libmemenv.a
SOURCES += src/txdb-leveldb.cpp \
	src/bloom.cpp \
    src/hash.cpp \
    src/aes_helper.c \
    src/blake.c \
    src/bmw.c \
    src/cubehash.c \
    src/echo.c \
    src/groestl.c \
    src/jh.c \
    src/keccak.c \
    src/luffa.c \
    src/shavite.c \
    src/simd.c \
    src/skein.c

!win32 {
    # we use QMAKE_CXXFLAGS_RELEASE even without RELEASE=1 because we use RELEASE to indicate linking preferences not -O preferences
    # genleveldb.commands = cd $$PWD/src/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a
} else {
    # make an educated guess about what the ranlib command is called
    isEmpty(QMAKE_RANLIB) {
        QMAKE_RANLIB = $$replace(QMAKE_STRIP, strip, ranlib)
    }
    LIBS += -lshlwapi
    #genleveldb.commands = cd $$PWD/src/leveldb && CC=$$QMAKE_CC CXX=$$QMAKE_CXX TARGET_OS=OS_WINDOWS_CROSSCOMPILE $(MAKE) OPT=\"$$QMAKE_CXXFLAGS $$QMAKE_CXXFLAGS_RELEASE\" libleveldb.a libmemenv.a && $$QMAKE_RANLIB $$PWD/src/leveldb/libleveldb.a && $$QMAKE_RANLIB $$PWD/src/leveldb/libmemenv.a
}
genleveldb.target = $$PWD/src/leveldb/libleveldb.a
genleveldb.depends = FORCE
PRE_TARGETDEPS += $$PWD/src/leveldb/libleveldb.a
QMAKE_EXTRA_TARGETS += genleveldb

# regenerate src/build.h
!windows|contains(USE_BUILD_INFO, 1) {
    genbuild.depends = FORCE
    genbuild.commands = cd $$PWD; /bin/sh share/genbuild.sh $$OUT_PWD/build/build.h
    genbuild.target = $$OUT_PWD/build/build.h
    PRE_TARGETDEPS += $$OUT_PWD/build/build.h
    QMAKE_EXTRA_TARGETS += genbuild
    DEFINES += HAVE_BUILD_INFO
}

contains(USE_O3, 1) {
    message(Building O3 optimization flag)
    QMAKE_CXXFLAGS_RELEASE -= -O2
    QMAKE_CFLAGS_RELEASE -= -O2
    QMAKE_CXXFLAGS += -O3
    QMAKE_CFLAGS += -O3
}

*-g++-32 {
    message("32 platform, adding -msse2 flag")

    QMAKE_CXXFLAGS += -msse2
    QMAKE_CFLAGS += -msse2
}

QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wno-ignored-qualifiers -Wformat -Wformat-security -Wno-unused-parameter -Wstack-protector
QMAKE_CXXFLAGS_WARN_ON += -Wno-unused-variable -fpermissive

windows:QMAKE_CXXFLAGS_WARN_ON += -Wno-cpp -Wno-maybe-uninitialized
!macx:QMAKE_CXXFLAGS_WARN_ON += -Wno-unused-local-typedefs
macx:QMAKE_CXXFLAGS_WARN_ON += -Wno-deprecated-declarations

# Input
DEPENDPATH += src src/json src/qt
HEADERS += src/qt/bitcoingui.h \
    src/qt/transactiontablemodel.h \
    src/qt/addresstablemodel.h \
    src/qt/optionsdialog.h \
    src/qt/coincontroldialog.h \
    src/qt/coincontroltreewidget.h \
    src/qt/sendcoinsdialog.h \
    src/qt/addressbookpage.h \
    src/qt/signverifymessagedialog.h \
    src/qt/aboutdialog.h \
    src/qt/editaddressdialog.h \
    src/qt/bitcoinaddressvalidator.h \
    src/alert.h \
    src/addrman.h \
    src/base58.h \
    src/bignum.h \
    src/chainparams.h \
    src/chainparamsseeds.h \
    src/checkpoints.h \
    src/compat.h \
    src/coincontrol.h \
    src/sync.h \
    src/util.h \
    src/hash.h \
    src/uint256.h \
    src/kernel.h \
    src/pbkdf2.h \
    src/serialize.h \
    src/core.h \
    src/main.h \
    src/miner.h \
    src/net.h \
    src/key.h \
    src/eckey.h \
    src/db.h \
    src/txdb.h \
    src/txmempool.h \
    src/walletdb.h \
    src/script.h \
    src/scrypt.h \
    src/init.h \
    src/mruset.h \
    src/json/json_spirit_writer_template.h \
    src/json/json_spirit_writer.h \
    src/json/json_spirit_value.h \
    src/json/json_spirit_utils.h \
    src/json/json_spirit_stream_reader.h \
    src/json/json_spirit_reader_template.h \
    src/json/json_spirit_reader.h \
    src/json/json_spirit_error_position.h \
    src/json/json_spirit.h \
    src/qt/clientmodel.h \
    src/qt/guiutil.h \
    src/qt/transactionrecord.h \
    src/qt/guiconstants.h \
    src/qt/optionsmodel.h \
    src/qt/monitoreddatamapper.h \
    src/qt/trafficgraphwidget.h \
    src/qt/transactiondesc.h \
    src/qt/transactiondescdialog.h \
    src/qt/bitcoinamountfield.h \
    src/wallet.h \
    src/keystore.h \
    src/qt/transactionfilterproxy.h \
    src/qt/transactionview.h \
    src/qt/walletmodel.h \
    src/rpcclient.h \
    src/rpcprotocol.h \
    src/rpcserver.h \
    src/timedata.h \
    src/qt/overviewpage.h \
    src/qt/csvmodelwriter.h \
    src/crypter.h \
    src/qt/sendcoinsentry.h \
    src/qt/qvalidatedlineedit.h \
    src/qt/bitcoinunits.h \
    src/qt/qvaluecombobox.h \
    src/qt/askpassphrasedialog.h \
    src/protocol.h \
    src/qt/notificator.h \
    src/qt/paymentserver.h \
    src/allocators.h \
    src/ui_interface.h \
    src/qt/rpcconsole.h \
    src/version.h \
    src/netbase.h \
    src/clientversion.h \
    src/threadsafety.h \
    src/tinyformat.h \
    src/stealth.h \
    src/qt/flowlayout.h \
    src/qt/darksendconfig.h \
    src/masternode.h \
    src/darksend.h \
    src/instantx.h \
    src/activemasternode.h \
    src/spork.h \
    src/crypto/common.h \
    src/crypto/hmac_sha256.h \
    src/crypto/hmac_sha512.h \
    src/crypto/rfc6979_hmac_sha256.h \
    src/crypto/ripemd160.h \
    src/crypto/sha1.h \
    src/crypto/sha256.h \
    src/crypto/sha512.h \
    src/eccryptoverify.h \
    src/qt/masternodemanager.h \
    src/qt/addeditadrenalinenode.h \
    src/qt/adrenalinenodeconfigdialog.h \
    src/qt/qcustomplot.h \
    src/smessage.h \
    src/qt/messagepage.h \
    src/qt/messagemodel.h \
    src/qt/sendmessagesdialog.h \
    src/qt/sendmessagesentry.h \
    src/qt/extendedoptionsmenu.h \
    src/qt/plugins/mrichtexteditor/mrichtextedit.h \
    src/qt/qvalidatedtextedit.h \
	src/bloom.h \
	src/hashblock.h \
	src/sph_skein.h \
    src/sph_keccak.h \
    src/sph_jh.h \
    src/sph_groestl.h \
    src/sph_bmw.h \
    src/sph_luffa.h \
    src/sph_cubehash.h \
    src/sph_echo.h \
    src/sph_shavite.h \
    src/sph_simd.h \
    src/sph_types.h \
	src/txdb-leveldb.h \
        extendedoptionsmenu.h
SOURCES += src/qt/bitcoin.cpp src/qt/bitcoingui.cpp \
    src/qt/transactiontablemodel.cpp \
    src/qt/addresstablemodel.cpp \
    src/qt/optionsdialog.cpp \
    src/qt/sendcoinsdialog.cpp \
    src/qt/coincontroldialog.cpp \
    src/qt/coincontroltreewidget.cpp \
    src/qt/addressbookpage.cpp \
    src/qt/signverifymessagedialog.cpp \
    src/qt/aboutdialog.cpp \
    src/qt/editaddressdialog.cpp \
    src/qt/bitcoinaddressvalidator.cpp \
    src/alert.cpp \
    src/chainparams.cpp \
    src/version.cpp \
    src/sync.cpp \
    src/txmempool.cpp \
    src/util.cpp \
    src/netbase.cpp \
    src/key.cpp \
    src/eckey.cpp \
    src/script.cpp \
    src/scrypt.cpp \
    src/core.cpp \
    src/main.cpp \
    src/miner.cpp \
    src/init.cpp \
    src/net.cpp \
    src/checkpoints.cpp \
    src/addrman.cpp \
    src/db.cpp \
    src/walletdb.cpp \
    src/qt/clientmodel.cpp \
    src/qt/guiutil.cpp \
    src/qt/transactionrecord.cpp \
    src/qt/optionsmodel.cpp \
    src/qt/monitoreddatamapper.cpp \
    src/qt/trafficgraphwidget.cpp \
    src/qt/transactiondesc.cpp \
    src/qt/transactiondescdialog.cpp \
    src/qt/bitcoinstrings.cpp \
    src/qt/bitcoinamountfield.cpp \
    src/qt/extendedoptionsmenu.cpp \
    src/wallet.cpp \
    src/keystore.cpp \
    src/qt/transactionfilterproxy.cpp \
    src/qt/transactionview.cpp \
    src/qt/walletmodel.cpp \
    src/rpcclient.cpp \
    src/rpcprotocol.cpp \
    src/rpcserver.cpp \
    src/rpcdump.cpp \
    src/rpcmisc.cpp \
    src/rpcnet.cpp \
    src/rpcmining.cpp \
    src/rpcwallet.cpp \
    src/rpcblockchain.cpp \
    src/rpcrawtransaction.cpp \
    src/timedata.cpp \
    src/qt/overviewpage.cpp \
    src/qt/csvmodelwriter.cpp \
    src/crypter.cpp \
    src/qt/sendcoinsentry.cpp \
    src/qt/qvalidatedlineedit.cpp \
    src/qt/bitcoinunits.cpp \
    src/qt/qvaluecombobox.cpp \
    src/qt/askpassphrasedialog.cpp \
    src/protocol.cpp \
    src/qt/notificator.cpp \
    src/qt/paymentserver.cpp \
    src/qt/rpcconsole.cpp \
    src/noui.cpp \
    src/kernel.cpp \
    src/pbkdf2.cpp \
    src/stealth.cpp \
    src/qt/flowlayout.cpp \
    src/qt/darksendconfig.cpp \
    src/masternode.cpp \
    src/darksend.cpp \
    src/rpcdarksend.cpp \
    src/instantx.cpp \
    src/activemasternode.cpp \
    src/spork.cpp \
    src/masternodeconfig.cpp \
    src/crypto/hmac_sha256.cpp \
    src/crypto/hmac_sha512.cpp \
    src/crypto/rfc6979_hmac_sha256.cpp \
    src/crypto/ripemd160.cpp \
    src/crypto/sha1.cpp \
    src/crypto/sha256.cpp \
    src/crypto/sha512.cpp \
    src/eccryptoverify.cpp \
    src/qt/masternodemanager.cpp \
    src/qt/addeditadrenalinenode.cpp \
    src/qt/adrenalinenodeconfigdialog.cpp \
    src/qt/qcustomplot.cpp \
    src/smessage.cpp \
    src/qt/messagepage.cpp \
    src/qt/messagemodel.cpp \
    src/qt/sendmessagesdialog.cpp \
    src/qt/sendmessagesentry.cpp \
    src/qt/qvalidatedtextedit.cpp \
    src/qt/plugins/mrichtexteditor/mrichtextedit.cpp \
    src/rpcsmessage.cpp


RESOURCES += \
    src/qt/bitcoin.qrc \
    ubuntufont.qrc \
    src/qt/res/resupdated.qrc

FORMS += \
    src/qt/forms/coincontroldialog.ui \
    src/qt/forms/sendcoinsdialog.ui \
    src/qt/forms/addressbookpage.ui \
    src/qt/forms/signverifymessagedialog.ui \
    src/qt/forms/aboutdialog.ui \
    src/qt/forms/editaddressdialog.ui \
    src/qt/forms/transactiondescdialog.ui \
    src/qt/forms/overviewpage.ui \
    src/qt/forms/sendcoinsentry.ui \
    src/qt/forms/askpassphrasedialog.ui \
    src/qt/forms/rpcconsole.ui \
    src/qt/forms/optionsdialog.ui \
    src/qt/forms/darksendconfig.ui \
    src/qt/forms/masternodemanager.ui \
    src/qt/forms/addeditadrenalinenode.ui \
    src/qt/forms/adrenalinenodeconfigdialog.ui \
    src/qt/forms/messagepage.ui \
    src/qt/forms/sendmessagesentry.ui \
    src/qt/forms/sendmessagesdialog.ui \
    src/qt/plugins/mrichtexteditor/mrichtextedit.ui\
    src/qt/forms/extendedoptionsmenu.ui

contains(USE_QRCODE, 1) {
HEADERS += src/qt/qrcodedialog.h
SOURCES += src/qt/qrcodedialog.cpp
FORMS += src/qt/forms/qrcodedialog.ui
}

CODECFORTR = UTF-8

# for lrelease/lupdate
# also add new translations to src/qt/bitcoin.qrc under translations/
TRANSLATIONS = $$files(src/qt/locale/bitcoin_*.ts)

isEmpty(QMAKE_LRELEASE) {
    win32:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]\\lrelease.exe
    else:QMAKE_LRELEASE = $$[QT_INSTALL_BINS]/lrelease
}
isEmpty(QM_DIR):QM_DIR = $$PWD/src/qt/locale
# automatically build translations, so they can be included in resource file
TSQM.name = lrelease ${QMAKE_FILE_IN}
TSQM.input = TRANSLATIONS
TSQM.output = $$QM_DIR/${QMAKE_FILE_BASE}.qm
TSQM.commands = $$QMAKE_LRELEASE ${QMAKE_FILE_IN} -qm ${QMAKE_FILE_OUT}
TSQM.CONFIG = no_link
QMAKE_EXTRA_COMPILERS += TSQM

# "Other files" to show in Qt Creator
OTHER_FILES += \
    doc/*.rst doc/*.txt doc/README README.md res/bitcoin-qt.rc

# platform specific defaults, if not overridden on command line
isEmpty(BOOST_LIB_SUFFIX) {
    macx:BOOST_LIB_SUFFIX = -mt
    windows:BOOST_LIB_SUFFIX = -mgw44-mt-s-1_49
}

isEmpty(BOOST_THREAD_LIB_SUFFIX) {
    BOOST_THREAD_LIB_SUFFIX = $$BOOST_LIB_SUFFIX
}

isEmpty(BDB_LIB_PATH) {
    macx:BDB_LIB_PATH = /opt/local/lib/db48
}

isEmpty(BDB_LIB_SUFFIX) {
    macx:BDB_LIB_SUFFIX = -4.8
}

isEmpty(BDB_INCLUDE_PATH) {
    macx:BDB_INCLUDE_PATH = /opt/local/include/db48
}

isEmpty(BOOST_LIB_PATH) {
    macx:BOOST_LIB_PATH = /opt/local/lib
}

isEmpty(BOOST_INCLUDE_PATH) {
    macx:BOOST_INCLUDE_PATH = /opt/local/include
}

windows:DEFINES += WIN32
windows:RC_FILE = src/qt/res/bitcoin-qt.rc
windows:!contains(MINGW_THREAD_BUGFIX, 0) {
    # At least qmake's win32-g++-cross profile is missing the -lmingwthrd
    # thread-safety flag. GCC has -mthreads to enable this, but it doesn't
    # work with static linking. -lmingwthrd must come BEFORE -lmingw, so
    # it is prepended to QMAKE_LIBS_QT_ENTRY.
    # It can be turned off with MINGW_THREAD_BUGFIX=0, just in case it causes
    # any problems on some untested qmake profile now or in the future.
    DEFINES += _MT BOOST_THREAD_PROVIDES_GENERIC_SHARED_MUTEX_ON_WIN
    QMAKE_LIBS_QT_ENTRY = -lmingwthrd $$QMAKE_LIBS_QT_ENTRY
}

macx:HEADERS += src/qt/macdockiconhandler.h src/qt/macnotificationhandler.h
macx:OBJECTIVE_SOURCES += src/qt/macdockiconhandler.mm src/qt/macnotificationhandler.mm
macx:LIBS += -framework Foundation -framework ApplicationServices -framework AppKit -framework CoreServices
macx:DEFINES += MAC_OSX MSG_NOSIGNAL=0
macx:ICON = src/qt/res/icons/euno.icns
macx:QMAKE_CFLAGS_THREAD += -pthread
macx:QMAKE_LFLAGS_THREAD += -pthread
macx:QMAKE_CXXFLAGS_THREAD += -pthread
macx:QMAKE_INFO_PLIST = share/qt/Info.plist


# Set libraries and includes at end, to use platform-defined defaults if not overridden
INCLUDEPATH += $$SECP256K1_INCLUDE_PATH $$BOOST_INCLUDE_PATH $$BDB_INCLUDE_PATH $$OPENSSL_INCLUDE_PATH $$QRENCODE_INCLUDE_PATH
LIBS += $$join(SECP256K1_LIB_PATH,,-L,) $$join(BOOST_LIB_PATH,,-L,) $$join(BDB_LIB_PATH,,-L,) $$join(OPENSSL_LIB_PATH,,-L,) $$join(QRENCODE_LIB_PATH,,-L,)
LIBS += -lssl -lcrypto -ldb_cxx$$BDB_LIB_SUFFIX
# -lgdi32 has to happen after -lcrypto (see  #681)
windows:LIBS += -lws2_32 -lshlwapi -lmswsock -lole32 -loleaut32 -luuid -lgdi32
LIBS += -lsecp256k1
LIBS += -lboost_system$$BOOST_LIB_SUFFIX -lboost_filesystem$$BOOST_LIB_SUFFIX -lboost_program_options$$BOOST_LIB_SUFFIX -lboost_thread$$BOOST_THREAD_LIB_SUFFIX
windows:LIBS += -lboost_chrono$$BOOST_LIB_SUFFIX




contains(RELEASE, 1) {
    !windows:!macx {
        # Linux: turn dynamic linking back on for c/c++ runtime libraries
        LIBS += -Wl,-Bdynamic
    }
}

!windows:!macx {
    DEFINES += LINUX
    LIBS += -lrt -ldl
}

system($$QMAKE_LRELEASE -silent $$_PRO_FILE_)
