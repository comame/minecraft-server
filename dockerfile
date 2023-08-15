FROM ubuntu as jre

RUN apt update && apt install -y wget

RUN wget -q https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz -O jdk.tar.gz
RUN tar xf jdk.tar.gz


FROM ubuntu

RUN apt update && apt upgrade -y

RUN adduser user
USER user
WORKDIR /home/user

COPY --from=jre /jdk-17.0.8 /jre
COPY ./server.jar /server.jar

CMD [ "/jre/bin/java", "-jar", "-Xmx6G", "-Dlog4j2.formatMsgNoLookups=true", "/server.jar", "nogui" ]
