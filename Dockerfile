# Ejabberd 14.07
FROM ubuntu:14.04
# ORIGINAL MAINTAINER Rafael Römhild <rafael@roemhild.de>
MAINTAINER John Regan <john@jrjrtech.com>

ENV DEBIAN_FRONTEND noninteractive

# enable universe repo
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list \
&&  echo "deb http://archive.ubuntu.com/ubuntu/ trusty-security main universe" >> /etc/apt/sources.list \
&&  echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates main universe" >> /etc/apt/sources.list \
&& apt-get update && \
    apt-get -y install curl build-essential \
    m4 git libncurses5-dev libssh-dev libyaml-dev libexpat-dev libssl-dev \
    libldap2-dev unixodbc-dev odbc-postgresql libmyodbc tdsodbc xsltproc  \
    libxml2-utils fop recode && \
    addgroup ejabberd && \
    adduser \
      --system \
      --ingroup ejabberd \
      --home /opt/ejabberd \
      --disabled-login \
      ejabberd && \
    mkdir -p /src/erlang && \
    cd /src/erlang && \
    curl -R -L -O http://erlang.org/download/otp_src_17.3.tar.gz && \
    tar xf otp_src_17.3.tar.gz && \
    cd otp_src_17.3 && \
    ./configure --enable-smp-support --with-odbc && \
    make && \
    make install && \
    cd / && rm -rf /src/erlang && \
    mkdir -p /src/ejabberd && \
    cd /src/ejabberd && \
    curl -R -L -O "http://www.process-one.net/downloads/downloads-action.php?file=/ejabberd/14.07/ejabberd-14.07.tgz" && \
    tar xf ejabberd-14.07.tgz && \
    cd ejabberd-14.07 && \
    ./configure \
      --enable-user=ejabberd \
      --enable-nif \
      --enable-odbc \
      --enable-mysql \
      --enable-pgsql \
      --enable-json \
      --enable-http && \
    git clone https://github.com/esl/lhttpc deps/lhttpc && \
    recode latin1..utf8 deps/lhttpc/src/lhttpc.app.src && \
    make && \
    make install && \
    cd / && rm -rf /src/ejabberd && \
    apt-get -y remove \
      m4 git libncurses5-dev libssh-dev libyaml-dev libexpat-dev libssl-dev \
      libldap2-dev unixodbc-dev odbc-postgresql libmyodbc tdsodbc xsltproc  \
      libxml2-utils fop recode && \
    apt-get autoremove -y && \
    apt-get install -y \
      unixodbc odbc-postgresql libmyodbc tdsodbc curl libldap-2.4 \
      libyaml-0-2 libexpat1 openssl libssl1.0.0 && \
    sed -i 's/-detach//' /sbin/ejabberdctl

ADD ./ejabberd.yml /etc/ejabberd/
ADD ./ejabberdctl.cfg /etc/ejabberd/

RUN touch /var/log/ejabberd/dummy && \
    touch /var/lib/ejabberd/dummy && \
    touch /etc/ejabberd/dummy && \
    chown -R ejabberd:ejabberd /var/log/ejabberd && \
    chown -R ejabberd:ejabberd /var/lib/ejabberd && \
    chown -R ejabberd:ejabberd /etc/ejabberd


# docker sets up really restrictive permissions
# on empty volumes, so let's make some dumb files

USER ejabberd
VOLUME ["/etc/ejabberd"]
VOLUME ["/var/log/ejabberd"]
VOLUME ["/var/lib/ejabberd"]

EXPOSE 5222 5269 5280
CMD ["start"]
ENTRYPOINT ["ejabberdctl"]
