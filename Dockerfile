ARG BASE_CONTAINER=ubuntu:latest
FROM $BASE_CONTAINER

LABEL maintainer="Jose Ventura <jose.ventura.roda@gmail.com>"

USER root

ENV HADOOP_VERSION 3.2.1

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y 
                openjdk-8-jdk-headless \
                wget ssh pdsh rsync sudo \
                nano iproute2 iputils-ping && \
    rm -rf /var/lib/apt/lists/*



# CMD cd ~/ && mkdir .ssh && ssh-keygen -q -t rsa -N '' -f .ssh/id_rsa && \ 
#     cat .ssh/id_rsa.pub>>.ssh/authorized_keys

# #Activate PubkeyAuthentication
# RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' \
#        /etc/ssh/sshd_config

# RUN echo -e "# disable ipv6\n\
# net.ipv6.conf.all.disable_ipv6 = 1\n\
# net.ipv6.conf.default.disable_ipv6 = 1\n\
# net.ipv6.conf.lo.disable_ipv6 = 1">>/etc/sysctl.conf

RUN useradd -m -s $(which bash) -G sudo hadoop
RUN echo hadoop:password | chpasswd


RUN cd /tmp && \
    wget -q http://apache.rediris.es/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar xzf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/local --owner hadoop --group hadoop --no-same-owner && \
    rm hadoop-${HADOOP_VERSION}.tar.gz 
RUN cd /usr/local && ln -s hadoop-${HADOOP_VERSION} hadoop

RUN chown -R hadoop:hadoop /usr/local/hadoop-${HADOOP_VERSION}

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_CONF ${HADOOP_HOME}/etc/hadoop
ENV PATH ${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin
ENV HADOOP_MAPRED_HOME=${HADOOP_HOME}
ENV HADOOP_COMMON_HOME=${HADOOP_HOME}
ENV HADOOP_HDFS_HOME=${HADOOP_HOME}
ENV YARN_HOME=${HADOOP_HOME}
ENV PDSH_RCMD_TYPE ssh

USER hadoop

