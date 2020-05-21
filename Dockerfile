FROM registry.redhat.io/jboss-webserver-3/webserver31-tomcat8-openshift

USER root

ENV STI_SCRIPTS_PATH=/usr/local/s2i

RUN curl https://raw.githubusercontent.com/cloudrouter/centos-repo/master/CentOS-Base.repo -o /etc/yum.repos.d/CentOS-Base.repo && \
    curl http://mirror.centos.org/centos-7/7/os/x86_64/RPM-GPG-KEY-CentOS-7 -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    INSTALL_PKGS="git" && \
    yum -y install $INSTALL_PKGS && \
    rpm -V  $INSTALL_PKGS && \
    yum clean all

COPY ./s2i/bin/ $STI_SCRIPTS_PATH
COPY ./contrib/tomcat-extension.jar $JWS_HOME/lib/
COPY ./contrib/server.xml $JWS_HOME/conf/

RUN chmod -R +x $STI_SCRIPTS_PATH
RUN echo "root:root" | chpasswd

# USER 185