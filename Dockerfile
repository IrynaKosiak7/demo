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


EXPOSE 8081/tcp
ENTRYPOINT ["java", "-XX:UseG1GC"]


FROM node:18 as build
WORKDIR /app
COPY  package.json package-lock.json ./

RUN  npm install --legecy-peer-deps
COPY . .
RUN npm run build
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /app/build .
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 81
CMD ["nginx","-g","daemon off"]


FROM node:18 as build
WORKDIR /app
COPY  package.json package-lock.json ./

RUN  npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]

FROM quay.io/keycloak/keycloak:latest AS builder
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

WORKDIR /opt/keycloak

RUN /opt/keycloak/bin/kc.sh build
FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
#VOLUME /home/iryna-kosiakovska/keycloak-import-data:/opt/keycloak/data/import
#VOLUME /home/iryna-kosiakovska/keycloak/data/h2:/opt/keycloak/data/h2
ENV KEYCLOAK_ADMIN: admin
ENV KEYCLOAK_ADMIN_PASSWORD: ${KEYCLOAK_ADMIN_PASSWORD}
ENV KC_HTTP_PORT: 8080
ENV KC_HOSTNAME_URL=http://localhost:8081
ENV KC_HOSTNAME_ADMIN_URL=http://localhost:8081
ENV KC_HTTP_RELATIVE_PATH=/
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
