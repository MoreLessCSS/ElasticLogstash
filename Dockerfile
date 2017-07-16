#Docker default CentosJava image
FROM nimmis/java-centos

MAINTAINER me <me@me.com>
LABEL Description="elasticsearch 5.4"

ENV ES_VERSION=5.4.0 \
    JAVA_HOME="/usr/java/jre1.8.0_121/" \
    HEAP_SIZE="2g" \
    JVM_OPTS="-Xmx2g -Xms2g -XX:MaxPermSize=1024m" \
    ES_JAVA_OPTS="-Xmx2g -Xms2g"

RUN useradd -ms /bin/bash elasticsearch \
        && yum install -y net-tools wget which openssl

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
COPY /repos/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
RUN yum install -y logstash

COPY /filters/logstash-filter.conf /etc/logstash/conf.d/logstash-filter.conf

RUN chown -R elasticsearch:elasticsearch /usr/share/logstash/ \
    && chown -R elasticsearch:elasticsearch /var/log/logstash/ \
    && chown -R elasticsearch:elasticsearch /etc/logstash/

EXPOSE 24224:24224

USER elasticsearch
CMD ["/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash-filter.conf"]