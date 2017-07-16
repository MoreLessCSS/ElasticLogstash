#Docker default CentosJava image
FROM nimmis/java-centos

MAINTAINER me <me@me.com>
LABEL Description="elasticsearch 5.4"

ENV ES_VERSION=5.4.0 \
CLUSTER_NAME="me" \
CLUSTER_NAME="meCustomer" \
    NODE_NAME="elkmaster1" \
    HTTP_PORT_ES=9200 \
    NETWORK_HOST=0.0.0.0 \
    MINIMUM_MASTER_NODES=1 \
    MAXIMUM_LOCAL_STORAGE_NODES=1 \
    NODE_ATTR_RACK=centOS7 \
    ELASTIC_PWD="getme" \
    GOSU_VERSION=1.9 \
    JAVA_HOME="/usr/java/jre1.8.0_131/" \
    HEAP_SIZE="2g" \
    JVM_OPTS="-Xmx2g -Xms2g -XX:MaxPermSize=1024m" \
    ES_JAVA_OPTS="-Xmx2g -Xms2g"

WORKDIR /opt

RUN useradd -ms /bin/bash elasticsearch \
        && yum install -y net-tools wget which openssl

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
COPY /repos/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
RUN yum install -y logstash

RUN chown -R elasticsearch:elasticsearch /usr/share/logstash/ \
    && chown -R elasticsearch:elasticsearch /var/log/logstash/ \
    && chown -R elasticsearch:elasticsearch /etc/logstash/

EXPOSE 24224:24224

USER elasticsearch
CMD ["/usr/share/logstash/bin/logstash -e 'input { stdin { } } output { stdout {} }'"]
