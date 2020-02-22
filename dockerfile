FROM ubuntu as jre

RUN apt update && apt install -y wget

RUN wget -q https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz -O openjdk.tar.gz
RUN tar xf openjdk.tar.gz

RUN /jdk-13.0.2/bin/jlink --no-header-files --no-man-pages --compress=2 --add-modules java.base,java.compiler,java.desktop,java.logging,java.management,java.naming,java.rmi,java.scripting,java.sql,java.xml,jdk.sctp,jdk.unsupported,jdk.zipfs --output /jre


FROM ubuntu

RUN adduser user

USER user
WORKDIR /home/user

COPY --from=jre /jre jre

COPY ./server.properties server.properties
RUN echo "eula=true" | cat > eula.txt

COPY server.jar server.jar

CMD [ "./jre/bin/java", "-jar", "./server.jar", "nogui" ]
