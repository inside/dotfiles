FROM ubuntu

MAINTAINER Yann Thomas-Gérard <inside@gmail.com>

WORKDIR /root

RUN apt-get -y update && apt-get install -y \
    ctags \
    curl \
    gcc \
    git \
    liblua5.2-dev \
    make \
    php5-cli \
    python \
    python-dev \
    ruby \
    ruby-dev \
    silversearcher-ag \
    tmux \
    tree \
    wget \
    zsh

RUN git clone git@github.com:vim/vim.git && \
    cd vim/src && \
    ./configure \
        --disable-gui \
        --enable-luainterp \
        --enable-pythoninterp \
        --enable-rubyinterp \
        --with-features=big \
        --with-compiledby=inside \
        --without-x && \
    make && \
    make install

CMD ["zsh"]
