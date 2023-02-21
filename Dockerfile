FROM ubuntu:20.04
LABEL maintainer="tajogi@tajogi.ru"

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY . .
EXPOSE 3128
RUN chmod +x install.sh && ./install.sh && chmod +x start.sh
ENTRYPOINT ./start.sh
