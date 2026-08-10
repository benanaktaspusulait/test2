#############################################################################
# DO NOT EDIT LOCALLY!!!!!!!
#
# WARNING: This file is controlled centrally, any changes made in the command
# adaptor repository will be overwritten by the RepoSync process.  See
# https://gitlab.digital.homeoffice.gov.uk/dacc-de/dde-adaptor-reposync
#############################################################################
FROM python:3.10-slim

COPY requirements.txt /tmp
RUN apt-get clean \
  && apt-get update \
  && apt-get install -y gcc librdkafka1 librdkafka-dev \
  && apt-get clean \
  && pip install -r /tmp/requirements.txt

COPY app.py /usr/local/bin
COPY topic-templates.txt /usr/local/bin
ENTRYPOINT /usr/local/bin/app.py
