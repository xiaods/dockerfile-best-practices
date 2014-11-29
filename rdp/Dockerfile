FROM centos:centos7
MAINTAINER Deshi Xiao <xiaods@gmail.com>

RUN yum install -y wget
RUN yum -y install ant ant-nodeps ant-junit ant-scripts ant-javadoc ant-trax gcc gcc-c++ python valgrind ntp python26 git-all python-httplib2 python-setuptools python-devel ccache
 
# Install OpenJDK
RUN yum -y install java-1.7.0-openjdk-devel && yum clean all
ENV JAVA_HOME /usr/lib/jvm/java
ENV PATH $JAVA_HOME/bin:$PATH
# set a bunch of environment variables
RUN yum -y install tar wget; yum clean all

# Public VoltDB ports
EXPOSE 8090
EXPOSE 2192
# Replication Port
EXPOSE 5555
EXPOSE 5556
EXPOSE 5557
# Zookeeper Port
EXPOSE 2181
# Internal Server Port
EXPOSE 3021
EXPOSE 3022
#Admin Port
EXPOSE 21211
# Client Port
EXPOSE 21212
EXPOSE 4334

# hostname
ENV HOSTNAME rapids

ENV VOLTDB_DIST /opt/voltdb/voltdb-voltdb-4.8
ENV PATH $PATH:$VOLTDB_DIST/bin
ENV VOLTDB_HEAPMAX 1024

ENV PATH ${PATH}:${JAVA_HOME}/bin
ENV PATH $PATH:/opt/voltdb/voltdb-voltdb-4.8/bin/
ENV CLASSPATH $CLASSPATH:/opt/voltdb/voltdb-voltdb-4.8/voltdb/*:./

RUN mkdir -p /opt/voltdb \
    && curl -#sSL https://github.com/VoltDB/voltdb/archive/voltdb-4.8.tar.gz | tar -xzf - -C /opt/voltdb \
    && cd /opt/voltdb/voltdb-voltdb-4.8 \
    && ant clean \
    && ant -Djmemcheck=NO_MEMCHECK

#RDP install
RUN useradd -m rapids 
RUN echo "rapids:rdpuser" | chpasswd
RUN mkdir -p /opt/{rdp,voltdb_data};chown rapids.rapids /opt/* -R
RUN su rapids; cd /opt/rdp

ADD rdp-installer-0.8.1-4.run /opt/rdp/
RUN cd /opt/rdp; ./rdp-installer-0.8.1-4.run
RUN cd /opt/rdp/current; cp cfg/log4j.properties .

# Configure VoltDB
RUN mkdir /opt/voltdb_data/genData; chown rapids.rapids /opt/voltdb_data/genData;
RUN su rapids; cd /opt/voltdb_data/genData
ADD tpchPart.jar /opt/voltdb_data/genData/
# dataset
COPY data/LargeNumRows100k.csv /opt/voltdb_data/genData/
COPY data/LargeNumRows20k.csv /opt/voltdb_data/genData/
COPY data/LargeNumRows50k.csv /opt/voltdb_data/genData/
COPY data/lineitem10.csv /opt/voltdb_data/genData/
COPY data/lineitem6.csv /opt/voltdb_data/genData/
COPY data/lineitem7.csv /opt/voltdb_data/genData/
COPY data/lineitem8.csv /opt/voltdb_data/genData/
COPY data/lineitem9.csv /opt/voltdb_data/genData/
COPY data/stage4-12part.csv /opt/voltdb_data/genData/
COPY data/stage4.csv /opt/voltdb_data/genData/
COPY data/tpchCustomer.csv /opt/voltdb_data/genData/
COPY data/tpchLineitem1.csv  /opt/voltdb_data/genData/
COPY data/tpchLineitem2.csv /opt/voltdb_data/genData/
COPY data/tpchLineitem3.csv /opt/voltdb_data/genData/
COPY data/tpchLineitem4.csv /opt/voltdb_data/genData/
COPY data/tpchLineitem5.csv /opt/voltdb_data/genData/
COPY data/tpchNation.csv /opt/voltdb_data/genData/
COPY data/tpchOrders.csv /opt/voltdb_data/genData/
COPY data/tpchPart.csv /opt/voltdb_data/genData/
COPY data/tpchPartSupp.csv /opt/voltdb_data/genData/
COPY data/tpchRegion.csv /opt/voltdb_data/genData/
COPY data/tpchSupplier.csv /opt/voltdb_data/genData/

ADD loadData /opt/voltdb_data/genData/
ADD deploy1node.xml /opt/voltdb_data/
ADD 1nodemaster.sh /opt/voltdb_data/
RUN chmod 744 /opt/voltdb_data/1nodemaster.sh


# Configure RDP



#RUN RDP
CMD ["/opt/voltdb_data/1nodemaster.sh"]
