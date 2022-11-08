FROM tomcat:9.0-jdk11
RUN apt-get update
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install maven git -y
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
RUN mvn package -f boxfuse-*/
RUN cp boxfuse-*/target/*.war /usr/local/tomcat/webapps/