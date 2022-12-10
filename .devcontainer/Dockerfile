FROM ubuntu:jammy-20221130
RUN apt-get update && apt-get install -y software-properties-common git ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
RUN git clone https://github.com/neovim/neovim
RUN cd neovim && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo
RUN cd neovim && make install

# UID 1000 conveniently corresponds to default user on Ubuntu desktop installation
RUN groupadd -g 1000 ubuntu && \
    useradd -r -m -u 1000 -g ubuntu ubuntu
USER ubuntu