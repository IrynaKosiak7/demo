FROM docker.io/library/openjdk:21-jdk-slim AS builder
LABEL authors="iryna-kosiakovska"
RUN groupadd -g 1001 -r builder && useradd -u 1001 -r -g builder -m -d /builder builder
WORKDIR . /usr/home/demo
#ENV JAR_FILE=target/minimum-image.jar
#COPY --chown=builder ${JAR_FILE} application.jar
#RUN java -Djarmode=layertools -jar application.jar
COPY --chown=builder:builder run.sh run.sh


FROM docker.io/library/openjdk:21-jdk-slim
RUN groupadd -g 1001 -r app && useradd -u 1001 -r -g app app
USER app
WORKDIR /springboot
COPY --from=builder /builder/dependencies/ ./

COPY --from=builder /builder/spring-boot-loader/ ./

COPY --from=builder /builder/snapshot-dependencies/ ./

COPY --from=builder /builder/application ./

COPY --from=builder /builder/run.sh/  ./


EXPOSE 8080/tcp
ENTRYPOINT ["java", "-XX:UseG1GC"]


#FROM ubuntu:latest
#ARG MY_VAR
#RUN echo "Var value: $MY_VAR"
#RUN echo "Hello world!"
#RUN echo "\
#Hello\
#world!" \
#MAINTAINER Iryna Kosiakovska
# LABEL version=1.0
#RUN apt-get update
#COPY . /home/demo
