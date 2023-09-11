#From tomcat:8.0.51-jre8-alpine

#From tomcat:jre11
#RUN rm -rf /usr/local/tomcat/webapps/*
#COPY ./target/usermgmt-webapp.war /usr/local/tomcat/webapps/ROOT.war
#CMD ["catalina.sh","run"]


FROM openjdk:11-jre-slim
ARG _BASE_URL="https://archive.apache.org/dist/tomcat"
ARG TOMCAT_VERSION="9.0.41"
ARG TOMCAT_BASE="tomcat-9"

RUN set -eux; \
    apt-get update; \
    apt-get install -y wget;

RUN set -eux; \
    groupadd -r tomcat --gid=120; \
    useradd -r -g tomcat --uid=1000 tomcat

WORKDIR /opt

RUN wget ${_BASE_URL}/${TOMCAT_BASE}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

RUN tar -xvzf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    rm -rf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    mv apache-tomcat-${TOMCAT_VERSION} apacheTomcat && \
    chown -R tomcat:tomcat apacheTomcat

RUN apt-get remove -y wget

ARG Package_Name="demo"

RUN rm -rf /opt/apacheTomcat/webapps/*

COPY ./target/usermgmt-webapp.war /opt/apacheTomcat/webapps/ROOT.war

WORKDIR /opt/apacheTomcat

EXPOSE 8080

USER tomcat

CMD ["./bin/catalina.sh","run"]
