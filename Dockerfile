FROM public.ecr.aws/amazonlinux/amazonlinux:2023

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# ============================================================
# 1. OS / Build tools
# ============================================================
RUN dnf install -y \
        gcc \
        make \
        autoconf \
        automake \
        libtool \
        pkgconf-pkg-config \
        wget \
        tar \
        gzip \
        bzip2 \
        xz \
        which \
        file \
        findutils \
        diffutils \
        patch \
        gettext \
        gettext-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf


# ------------------------------------------------------------
# Amazon Corretto 25 JDK
# ------------------------------------------------------------
RUN dnf install -y \
        java-25-amazon-corretto-devel \
    && \
    dnf clean all && \
    rm -rf /var/cache/dnf

ENV JAVA_HOME=/usr/lib/jvm/java-25-amazon-corretto.x86_64
ENV PATH=${JAVA_HOME}/bin:${PATH}


# ============================================================
# Apache Maven
# ============================================================
ARG MAVEN_VERSION=3.9.16

RUN wget -q \
        "https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
        -O /tmp/apache-maven.tar.gz \
    && \
    tar -xzf /tmp/apache-maven.tar.gz \
        -C /opt \
    && \
    ln -s \
        /opt/apache-maven-${MAVEN_VERSION} \
        /opt/maven \
    && \
    rm -f /tmp/apache-maven.tar.gz

ENV MAVEN_HOME=/opt/maven
ENV PATH=${MAVEN_HOME}/bin:${PATH}

# ------------------------------------------------------------
# GnuCOBOL 3.2
# ------------------------------------------------------------
ARG GNUCOBOL_VERSION=3.2

WORKDIR /tmp



# ============================================================
# GnuCOBOL dependencies
# ============================================================

# GMP
#   COBOL numeric operations
#
# ncurses
#   SCREEN / terminal support
#
# Berkeley DB
#   GnuCOBOL indexed file support
#
# libxml2
#   XML support
#
# json-c
#   JSON support
#
RUN dnf install -y \
        gmp \
        gmp-devel \
        ncurses \
        ncurses-devel \
        libdb \
        libdb-devel \
        libxml2 \
        libxml2-devel \
        json-c \
        json-c-devel \
    && \
    dnf clean all && \
    rm -rf /var/cache/dnf

RUN wget -q \
        https://sourceforge.net/projects/gnucobol/files/gnucobol/${GNUCOBOL_VERSION}/gnucobol-${GNUCOBOL_VERSION}.tar.gz/download \
        -O gnucobol-${GNUCOBOL_VERSION}.tar.gz \
    && \
    tar -xzf gnucobol-${GNUCOBOL_VERSION}.tar.gz  \
    && \
    cd gnucobol-${GNUCOBOL_VERSION} \
    && \
    ./configure --prefix=/usr/local \
    && \
    make -j"$(nproc)" \
    && \
    make install \
    && \
    ldconfig \
    && \
    cd / \
    && \
    rm -rf /tmp/gnucobol-${GNUCOBOL_VERSION} \
              /tmp/gnucobol-${GNUCOBOL_VERSION}.tar.gz

# ------------------------------------------------------------
# Environment
# ------------------------------------------------------------
ENV PATH=/usr/local/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}

# GnuCOBOL runtime / module search path
ENV COB_LIBRARY_PATH=/usr/local/lib

# ============================================================
# Verification
# ============================================================
RUN echo "===== Java =====" && \
    java -version && \
    echo "===== Javac =====" && \
    javac -version && \
    echo "===== Maven =====" && \
    mvn -version && \
    echo "===== GCC =====" && \
    gcc --version && \
    echo "===== GnuCOBOL =====" && \
    cobc --version

WORKDIR /workspace
CMD ["/bin/bash"]
