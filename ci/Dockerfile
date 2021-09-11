FROM docker.io/ubuntu:21.04

RUN apt-get update && apt-get install -y \
	curl \
	luarocks \
	unzip

RUN luarocks install luacheck

WORKDIR /tmp
RUN curl -L -o stylua.zip https://github.com/JohnnyMorganz/StyLua/releases/download/v0.10.1/stylua-0.10.1-linux.zip
RUN unzip stylua.zip
RUN chmod +x stylua
RUN mv stylua /usr/local/bin

