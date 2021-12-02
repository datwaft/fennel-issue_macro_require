FROM debian:buster-slim

# Install dependencies
RUN apt-get update && apt-get install -y wget zip unzip python3 python3-pip

# Install LuaJIT and LuaRocks
RUN pip3 install hererocks
RUN hererocks /opt/here --luarocks ^ --luajit ^
ENV PATH /opt/here/bin:$PATH

# Install readline
RUN apt-get update && apt-get install -y libreadline-dev
RUN luarocks install readline

# Install fennel
WORKDIR /usr/local/bin
RUN wget https://fennel-lang.org/downloads/fennel-1.0.0 -O fennel
RUN chmod +x fennel

# Copy test
COPY repro /root/repro

# Finish
WORKDIR /root
