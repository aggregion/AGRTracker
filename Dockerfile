FROM ubuntu:18.04

RUN apt clean
RUN apt update && true 1
RUN apt install -y curl gnupg software-properties-common
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt update && true 1
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y nodejs git build-essential nginx

RUN mkdir /agr-tracker
WORKDIR /agr-tracker

ADD . /agr-tracker
ADD agr-tracker.conf /etc/nginx/sites-enabled/agr-tracker.conf

RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -rf ./node_modules && npm ci && node ./patch.js && npm run build

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
