# For MPP demo 

FROM centos:centos7
MAINTAINER Deshi Xiao <xiaods@gmail.com>

# Install OpenJDK
RUN yum -y install java-1.7.0-openjdk-devel;yum -y install tar wget; yum clean all
RUN echo export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64 > /etc/profile.d/java.sh

# Zookeeper
RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-3.4.6 /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]

ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]
