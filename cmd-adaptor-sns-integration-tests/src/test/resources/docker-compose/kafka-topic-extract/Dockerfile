#############################################################################
# DO NOT EDIT LOCALLY!!!!!!!
#
# WARNING: This file is controlled centrally, any changes made in the command
# adaptor repository will be overwritten by the RepoSync process.  See
# https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
# DO NOT EDIT LOCALLY!!!!!!!
#############################################################################
FROM amazoncorretto:17

USER root

COPY ./confluent.repo /etc/yum.repos.d/confluent.repo
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN yum clean all \
    && chmod 644 /etc/yum.repos.d/confluent.repo \
    && chmod 755 /usr/local/bin/entrypoint.sh \
    && yum upgrade -y freetype nss nss-util nss-softokn nspr openssl-libs \
    && rpm --import https://packages.confluent.io/rpm/7.2/archive.key \
    && yum update -y cyrus-sasl-lib expat glib2 jetty-jaas \
    && yum clean all \
    && yum install -y confluent-community-2.13.noarch jq shadow-utils tar util-linux \
    && rm -rf /var/cache/yum \
    && yum clean all \
    && mkdir /usr/logs \
    && adduser \
      -u 1000 \
      -U \
      -m \
      -s /bin/bash \
      appuser \
    && chown appuser:appuser /usr/logs \
    && chmod -R 777 /usr/logs

WORKDIR /home/appuser
USER appuser

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
