# Base image https://hub.docker.com/u/rocker/
FROM rocker/tidyverse:4.4.1

COPY /R /

RUN Rscript setup.R

ENTRYPOINT ["Rscript", "main.R"]