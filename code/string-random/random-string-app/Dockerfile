FROM perl:latest
MAINTAINER mass10
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update & apt-get upgrade & cpan String::Random
COPY app /app
WORKDIR /app
CMD /app/main.pl

