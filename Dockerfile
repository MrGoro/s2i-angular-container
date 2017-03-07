FROM ryanj/centos7-s2i-nodejs:current

# This image provides a S2I for building Angular applications an running them inside a web container (nginx).

MAINTAINER Philipp Schürmann <spam@mrgoro.de>

LABEL summary="Platform for building and running Angular applications" \
      io.k8s.description="Platform for building and running Angular applications" \
      io.k8s.display-name="Angular" \
      io.openshift.expose-services="80:http" \
      io.openshift.tags="builder,angular" \
      com.redhat.dev-mode="DEV_MODE:true" \
      com.redhat.deployments-dir="/opt/app-root/src" \
      com.redhat.dev-mode.port="DEBUG_PORT:5858"

RUN yum install --setopt=tsflags=nodocs -y centos-release-scl-rh \
 && yum install --setopt=tsflags=nodocs -y bcrypt rh-nginx${NGINX_VERSION/\./} \
 && yum clean all -y \
 && mkdir -p /opt/app-root/etc/nginx.conf.d /opt/app-root/run \
 && chmod -R a+rx  $NGINX_VAR_DIR/lib/nginx \
 && chmod -R a+rwX $NGINX_VAR_DIR/lib/nginx/tmp \
                   $NGINX_VAR_DIR/log \
                   $NGINX_VAR_DIR/run \
                   /opt/app-root/run

COPY ./etc/ /opt/app-root/etc
COPY ./.s2i/bin/ ${STI_SCRIPTS_PATH}

RUN cp /opt/app-root/etc/nginx.server.sample.conf /opt/app-root/etc/nginx.conf.d/default.conf \
 && chown -R 1001:1001 /opt/app-root

USER 1001

EXPOSE 8080

CMD ["usage"]