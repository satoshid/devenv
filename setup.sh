#!/bin/sh

#set -x

pushd `dirname $0` > /dev/null 2>&1
SRC__DIRNAME="`pwd`"
popd > /dev/null 2>&1
WORK_DIRNAME="${SRC__DIRNAME}/work$$"

usage()
{
    echo "Usage: $0 [-ch]"
    echo " -c: clean all"
    echo " -h: help"
}

clean_all()
{
    pushd ${HOME} > /dev/null 2>&1
    ls -a | grep -v -E '^\.$|^\.\.$|^\.bash_history$|^\.bash_logout$|^\.bashrc$|^\.bash_profile$|^\.emacs$|^\.mozilla$|^setup\.sh$|^src$|^bin$' | xargs rm -rf
    popd > /dev/null 2>&1
}

while getopts ch opt "$@"
do
  case $opt in
      c)
	  clean_all
	  exit 1
	  ;;
      h)
	  usage
	  exit 1
	  ;;
      *)
	  exit 1
	  ;;
  esac
done

install_libevent()
{
    if [ -h ${HOME}/local/lib/libevent.so ]; then
	echo "libevent: already installed."
	return
    fi

    LIBEVENT=libevent-2.0.21-stable
    LIBEVENT_TARBALL=${LIBEVENT}.tar.gz
    wget http://sourceforge.net/projects/levent/files/libevent/libevent-2.0/${LIBEVENT_TARBALL}/download
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "libevent: exit wget" $0
	exit $rc
    fi
    tar zxvf ${LIBEVENT_TARBALL}
    pushd ${LIBEVENT} > /dev/null 2>&1
    ./configure --prefix=${HOME}/local
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "libevent: exit configure" $0
	exit $rc
    fi

    make
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "libevent: exit make" $0
	exit $rc
    fi

    make install
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "libevent: exit make install" $0
	exit $rc
    fi
    popd > /dev/null 2>&1
}

install_tmux()
{
    if [ -x ${HOME}/local/bin/tmux ]; then
	echo "tmux: already installed."
	return
    fi
    
    TMUX=tmux-1.9a
    TMUX_TARBALL=${TMUX}.tar.gz
    wget http://downloads.sourceforge.net/tmux/${TMUX_TARBALL}
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "tmux: exit wget" $0
	exit $rc
    fi
    
    tar zxvf ${TMUX_TARBALL}
    pushd ${TMUX} > /dev/null 2>&1
    ./configure --prefix=${HOME}/local LIBEVENT_LIBS="-L${HOME}/local/lib -levent" LIBEVENT_CFLAGS="-I${HOME}/local/include"
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "tmux: exit configure" $0
	exit $rc
    fi

    make
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "tmux: exit make" $0
	exit $rc
    fi

    make install
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "tmux: exit make install" $0
	exit $rc
    fi

    popd > /dev/null 2>&1
}

configure_tmux()
{
    cp ${SRC__DIRNAME}/.tmux.conf ${HOME}/
}

configure_bash()
{
    cat << EOF > ${HOME}/.bashrc
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
alias tmux="SHELL=/bin/zsh LD_LIBRARY_PATH=${HOME}/local/lib ${HOME}/local/bin/tmux -2"
EOF

export PATH="${HOME}/local/bin:${HOME}/.cask/bin:${HOME}/.rbenv/bin:${PATH}"
}

configure_zsh()
{
    cp ${SRC__DIRNAME}/.zshrc ${HOME}/
}

install_emacs()
{
    if [ -x ${HOME}/local/bin/emacs ]; then
	echo "emacs: already installed."
	return
    fi

    EMACS=emacs-24.3
    EMACS_TARBALL=${EMACS}.tar.gz
    wget http://ftp.jaist.ac.jp/pub/GNU/emacs/${EMACS_TARBALL}
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "emacs: exit wget" $0
	exit $rc
    fi

    tar zxvf ${EMACS_TARBALL}
    pushd ${EMACS} > /dev/null 2>&1
    ./configure --prefix=${HOME}/local
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "emacs: exit configure" $0
	exit $rc
    fi

    make
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "emacs: exit make" $0
	exit $rc
    fi

    make install
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "emacs: exit make install" $0
	exit $rc
    fi

    popd > /dev/null 2>&1
}

configure_emacs()
{
    if [ ! -d ${HOME}/.cask ]; then
	curl -fsSkL https://raw.github.com/cask/cask/master/go | python
    fi

    DOT_EMACS_DIRNAME="${HOME}/.emacs.d"
    if [ ! -d ${DOT_EMACS_DIRNAME} ]; then
	mkdir ${DOT_EMACS_DIRNAME}
    fi

    if [ -f ${HOME}/.emacs ]; then
	mv ${HOME}/.emacs ${HOME}/.emacs.orig
    fi

    cp ${SRC__DIRNAME}/.emacs.d/init.el ${DOT_EMACS_DIRNAME}/
    cp ${SRC__DIRNAME}/.emacs.d/Cask ${DOT_EMACS_DIRNAME}/

    pushd ${DOT_EMACS_DIRNAME} > /dev/null 2>&1
    cask
    popd > /dev/null 2>&1
}

install_global()
{
    if [ -x ${HOME}/local/bin/global ]; then
	echo "global: already installed."
	return
    fi

    GLOBAL=global-6.3.1
    GLOBAL_TARBALL=${GLOBAL}.tar.gz
    wget http://tamacom.com/global/global-6.3.1.tar.gz
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "global: exit wget" $0
	exit $rc
    fi

    tar zxvf ${GLOBAL_TARBALL}
    pushd ${GLOBAL} > /dev/null 2>&1
    ./configure --prefix=${HOME}/local
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "global: exit configure" $0
	exit $rc
    fi

    make
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "global: exit make" $0
	exit $rc
    fi

    make install
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "global: exit make install" $0
	exit $rc
    fi

    popd > /dev/null 2>&1
}

install_cmake()
{
    if [ -x ${HOME}/local/bin/cmake ]; then
	echo "cmake: already installed."
	return
    fi

    CMAKE=cmake-3.0.1
    CMAKE_TARBALL=${CMAKE}.tar.gz
    wget http://www.cmake.org/files/v3.0/cmake-3.0.1.tar.gz
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "cmake: exit wget" $0
	exit $rc
    fi

    tar zxvf ${CMAKE_TARBALL}
    pushd ${CMAKE} > /dev/null 2>&1
    ./configure --prefix=${HOME}/local
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "cmake: exit configure" $0
	exit $rc
    fi

    make
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "cmake: exit make" $0
	exit $rc
    fi

    make install
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "cmake: exit make install" $0
	exit $rc
    fi

    popd > /dev/null 2>&1
}

install_gmock()
{
    if [ -f ${HOME}/local/lib/libgmock_main.a ]; then
	echo "gmock: already installed."
	return
    fi

    GMOCK=gmock-1.7.0
    GMOCK_ZIP=${GMOCK}.zip
    wget https://googlemock.googlecode.com/files/${GMOCK_ZIP}
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "gmock: exit wget" $0
	exit $rc
    fi

    unzip ${GMOCK_ZIP}

    pushd ${GMOCK} > /dev/null 2>&1
    make -C make
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "gmock: exit make" $0
	exit $rc
    fi
    cp -a make/gmock_main.a ${HOME}/local/lib/libgmock_main.a
    cp -a include/gmock ${HOME}/local/include/
    popd > /dev/null 2>&1

    pushd ${GMOCK}/gtest > /dev/null 2>&1
    make -C make
    rc=$?
    if [ $rc -gt 0 ]; then
	echo "gtest: exit make" $0
	exit $rc
    fi
    cp -a make/gtest_main.a ${HOME}/local/lib/libgtest_main.a
    cp -a include/gtest ${HOME}/local/include/
    popd > /dev/null 2>&1
}

install_ruby()
{
    if [ ! -d ${HOME}/.rbenv ]; then
        git clone https://github.com/sstephenson/rbenv.git ${HOME}/.rbenv
        rc=$?
        if [ $rc -gt 0 ]; then
	    echo "rbenv: exit git" $0
	    exit $rc
        fi
    fi

    if [ ! -d ${HOME}/.rbenv/plugins/ruby-build ]; then
        git clone https://github.com/sstephenson/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build
        rc=$?
        if [ $rc -gt 0 ]; then
	    echo "ruby-build: exit git" $0
	    exit $rc
        fi
    fi

    RUBY_CONFIGURE_OPTS="--enable-shared --disable-install-doc" rbenv install 1.9.3-p547
    RUBY_CONFIGURE_OPTS="--enable-shared --disable-install-doc" rbenv install 2.1.2
    rbenv global 1.9.3-p547
}

mkdir ${WORK_DIRNAME}
pushd ${WORK_DIRNAME} > /dev/null 2>&1

# tmux
install_libevent
install_tmux
configure_tmux
configure_bash

# zsh
configure_zsh

# emacs
install_emacs
configure_emacs

# global
install_global

# cmake
install_cmake

# gmock
install_gmock

# ruby
install_ruby

popd > /dev/null 2>&1
rm -rf ${WORK_DIRNAME}

exit 0
