#############################################################################
# DO NOT EDIT LOCALLY!!!!!!!
#
# WARNING: This file is controlled centrally, any changes made in the command
# adaptor repository will be overwritten by the RepoSync process.  See
# https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
# DO NOT EDIT LOCALLY!!!!!!!
#############################################################################
FROM amazoncorretto:17

WORKDIR /tmp

RUN yum install -y \
        shadow-utils \
        unzip \
    && yum update -y ca-certificates cpio curl cyrus-sasl-lib expat glib2 libcurl libdb libssh2 libdb-utils libnghttp2 libpng libtasn1 libxml2 ncurses ncurses-base ncurses-libs nss nss-util nss-softokn nspr openldap openssl-libs python python-libs sqlite xz-libs yum zlib \
    && yum erase -y vim-data \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && curl --fail --silent --show-error --location --output /tmp/envconsul.zip https://releases.hashicorp.com/envconsul/0.13.4/envconsul_0.13.4_linux_amd64.zip \
    && echo "53656bd797ea7e1b91459edfc072613e3a229ede5bd8619465cf961ec450fdc5  /tmp/envconsul.zip" | sha256sum --check --status - \
    && unzip /tmp/envconsul.zip \
    && rm -f /tmp/envconsul.zip \
    && mv envconsul /usr/local/bin/envconsul \
    && chown root:root /usr/local/bin/envconsul \
    && chmod 0755 /usr/local/bin/envconsul \
    && adduser \
      -u 1000 \
      -U \
      -m \
      -s /bin/bash \
      fdpuser

COPY ./target/cmd-adaptor-sns-exec.jar /local/cmd-adaptor-sns-exec.jar
COPY ./target/dependencies/opentelemetry-javaagent.jar /local/opentelemetry-javaagent.jar

RUN chmod 0755 /local/cmd-adaptor-sns-exec.jar \
    && chown fdpuser:fdpuser /local/cmd-adaptor-sns-exec.jar \
    && chmod 0755 /local/opentelemetry-javaagent.jar \
    && chown fdpuser:fdpuser /local/opentelemetry-javaagent.jar

# Run Application as non-root
WORKDIR /home/fdpuser
USER fdpuser

CMD ["java", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8077", "-javaagent:/local/opentelemetry-javaagent.jar", "-Dcom.sun.management.jmxremote", "-Dcom.sun.management.jmxremote.port=9012", "-Dcom.sun.management.jmxremote.rmi.port=9012", "-Dcom.sun.management.jmxremote.authenticate=false", "-Dcom.sun.management.jmxremote.local.only=false", "-Dcom.sun.management.jmxremote.ssl=false", "-Djava.rmi.server.hostname=localhost", "-jar", "/local/cmd-adaptor-sns-exec.jar"]
