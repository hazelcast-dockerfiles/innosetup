FROM ubuntu:20.04

# get at least error information from wine
ENV WINEDEBUG -all,err+all \
    DISPLAY :99

COPY bin/* /usr/bin/

RUN apt-get update \
    && apt-get install -y curl wget unzip procps xvfb \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -o APT::Immediate-Configure=false wine wine32 \
    && echo "Installing Inno Setup binaries" \
    && curl -SL "http://files.jrsoftware.org/is/6/innosetup-6.0.5.exe" -o is.exe \
    && wine-x11-run wine is.exe /SP- /VERYSILENT /ALLUSERS /SUPPRESSMSGBOXES \
    && rm -rf is.exe /var/lib/apt/lists/*
