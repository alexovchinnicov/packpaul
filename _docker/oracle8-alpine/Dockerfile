FROM alpine:latest


MAINTAINER  Aleksey Ovchinnikov

# Java Version and other ENV
ENV JAVA_HOME=/opt/java8 \
    PATH=${PATH}:/opt/java8/bin \
    GLIBC_VERSION=2.26-r0 \
    LANG=C.UTF-8


# Extract archive
ADD jdk-8u221-linux-x64.tar.gz /opt/


# do all in one step
RUN set -ex && \
    apk upgrade --update && \
    apk add --update tar libstdc++ curl ca-certificates bash && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    ln -s /opt/jdk1.8.0_221 /opt/java8 && \
    apk del glibc-i18n && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf



