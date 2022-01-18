FROM alpine:latest

LABEL org.opencontainers.image.authors="yangmo"
LABEL org.opencontainers.image.description="Alpine Linux with JRE 1.8.0_301"

#更换aline源
RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/community" > /etc/apk/repositories \
 && echo "http://mirrors.aliyun.com/alpine/latest-stable/main" >> /etc/apk/repositories
#update apk
RUN apk update && apk upgrade \
 && apk --no-cache add ca-certificates
# bash vim wget curl net-tools
#RUN apk add bash bash-doc bash-completion
#RUN apk add vim wget curl net-tools
RUN rm -rf /var/cache/apk/*
RUN #/bin/bash

#setup glibc
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-bin-2.32-r0.apk \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-i18n-2.32-r0.apk \
 && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && apk add glibc-2.32-r0.apk \
 && apk add glibc-bin-2.32-r0.apk \
 && apk add glibc-i18n-2.32-r0.apk \
 && rm -rf *.apk

#setup date
RUN apk add --no-cache tzdata \
 && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo 'Asia/Shanghai' >/etc/timezone

#setup language 解决中文乱码
RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG=en_US.UTF-8

# 使用ADD/COPY命令 源文件必须和Dockfile位于同一目录下
ADD jre-8u301-linux-x64.tar.gz /usr/local

#setup java env
ENV JAVA_HOME=/usr/local/jre1.8.0_301
ENV PATH=$PATH:.:$JAVA_HOME/bin
ENV CALSSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

# jre瘦身参考文章:https://blog.csdn.net/weixin_45139031/article/details/103598890
