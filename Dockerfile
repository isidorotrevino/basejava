FROM ubuntu:14.04
MAINTAINER Isidoro Trevino "isidoro.trevino@vintec.mx"

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME/bin
ENV GVM_AUTO_ANSWER true

RUN echo "===> Installing java dependencies..." && \
	sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo "===> install Java And main utilities"  && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections  && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
	DEBIAN_FRONTEND=noninteractive  apt-get install -y --force-yes   \
	oracle-java8-installer oracle-java8-set-default  \
	libxext-dev libxrender-dev libxtst-dev \
	curl \
	wget \
	unzip \
	groovy && \
	echo "===> Installing SDK Manager..."  && \
	(curl -s get.sdkman.io | bash) && \
	/bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh" && \
	/bin/bash -c "echo sdkman_auto_answer=true > ~/.sdkman/etc/config" && \
	echo "===> Creating user..." && \
    mkdir -p /home/developer && \
    mkdir -p /documents && \
    mkdir -p /projects && \
    mkdir -p /home/developer/.m2 && \
    mkdir -p /home/developer/.gradle && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    cp -r /root/.sdkman /home/developer/.sdkman && \
    echo "export SDKMAN_DIR=/home/developer/.sdkman" >> /home/developer/.bashrc && \
    echo "[[ -s \"/home/developer/.sdkman/bin/sdkman-init.sh\" ]] && source \"/home/developer/.sdkman/bin/sdkman-init.sh\"" >> /home/developer/.bashrc && \
    chown developer:developer -R /home/developer && \
    chown developer:developer -R /documents && \
    chown developer:developer -R /projects && \
    chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo && \
	echo "===> clean up..."  && \
    rm -rf /var/cache/oracle-jdk8-installer  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

USER developer
WORKDIR /projects
VOLUME [ "/home/developer/.m2","/home/developer/.gradle","/projects"]
CMD ["/bin/bash"]

