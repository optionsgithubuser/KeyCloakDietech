FROM quay.io/keycloak/keycloak-x:latest as builder

#https://www.keycloak.org/server/containers
RUN /opt/keycloak/bin/kc.sh build --db=postgres

FROM quay.io/keycloak/keycloak-x:latest
COPY --from=builder /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

# copy the theme
WORKDIR /opt/keycloak/themes
RUN mkdir govradar_theme
COPY govradar_theme govradar_theme

ARG KC_DB_URL_HOST
ARG KC_DB_PASSWORD
ARG KC_DB_USERNAME

#setting the build args to env variables
ENV KC_DB_PASSWORD=$KC_DB_PASSWORD
ENV KC_DB_USERNAME=$KC_DB_USERNAME
ENV KC_DB_URL=jdbc:postgresql://$KC_DB_URL_HOST/keycloak2

EXPOSE 8080
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start --proxy=edge --hostname-strict=false --db-username=$KC_DB_USERNAME --db-password=$KC_DB_PASSWORD --db-url=$KC_DB_URL"]