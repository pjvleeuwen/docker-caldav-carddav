FROM postgres:9.6.3

 ENV POSTGRES_USER      postgres
 ENV POSTGRES_PASSWORD  postgres
 ENV POSTGRES_DB        postgres

 RUN apt-get update && \
     `# davical/update-davical-database requirements` \
     apt-get install -y libdbi-perl libyaml-perl libdbd-pg-perl && \
     apt-get autoremove -y && \
     rm -rf /var/lib/apt/lists/*

COPY initdb-0?-* /docker-entrypoint-initdb.d/
COPY davical/ /docker-entrypoint-initdb.d/davical
 RUN chown root:root -R /docker-entrypoint-initdb.d/ \
  && chmod 777 -R /docker-entrypoint-initdb.d/

