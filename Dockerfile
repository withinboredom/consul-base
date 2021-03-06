FROM debian:jessie

MAINTAINER Robert Landers <landers.robert@gmail.com>

RUN apt-get update && apt-get install unzip

ADD https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip /tmp/consul.zip
RUN cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && rm /tmp/consul.zip

# Add consul UI
ADD https://dl.bintray.com/mitchellh/consul/0.5.0_web_ui.zip /tmp/webui.zip
RUN cd /tmp && unzip /tmp/webui.zip \
 && mv dist /ui && rm /tmp/webui.zip \
 && rm -rf /var/lib/apt/lists/*

# Add consul config
ADD ./config /config/

# ONBUILD will make sure that any additional service configuration file is added to docker conatiner as well.
ONBUILD ADD ./config /config/

# Add startup file
ADD ./launch.sh /bin/launch.sh
RUN chmod +x /bin/launch.sh

# Expose consul ports
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp

#Create a mount point
VOLUME ["/data"]

ENV MASTER ""

# Entry point of container
ENTRYPOINT ["/bin/launch.sh"]