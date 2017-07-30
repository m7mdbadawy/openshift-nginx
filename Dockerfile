FROM registry.access.redhat.com/rhel7:latest

MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"

ENV NGINX_VERSION 1.9.2-1.el7.ngx

ADD nginx.repo /etc/yum.repos.d/nginx.repo

RUN curl -sO http://nginx.org/keys/nginx_signing.key && \
    rpm --import ./nginx_signing.key && \
    yum install -y nginx-${NGINX_VERSION} && \
    yum clean all && \
    rm -f ./nginx_signing.key && chmod 777 -R /var/cache/nginx

COPY nginx.conf /etc/nginx/nginx.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 8081

CMD ["nginx", "-g", "daemon off;"]
