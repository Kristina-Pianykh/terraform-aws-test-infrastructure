FROM mysql:8.0.32-debian


ARG USER
ARG PASSWORD
ARG DATABASE
ARG PORT
ARG HOST
ARG FILE
ARG TABLE

ENV USER=${USER}
ENV PASSWORD=${PASSWORD}
ENV DATABASE=${DATABASE}
ENV PORT=${PORT}
ENV HOST=${HOST}
ENV FILE=${FILE}
ENV TABLE=${TABLE}

WORKDIR /src
COPY ${FILE} /src/${FILE}
COPY import_data.sh /src/import_data.sh

EXPOSE ${PORT}

RUN chmod +x ./import_data.sh
ENTRYPOINT exec ./import_data.sh -u ${USER} -p ${PASSWORD} -d ${DATABASE} -h ${HOST} -f ${FILE} -t ${TABLE} -P ${PORT}
