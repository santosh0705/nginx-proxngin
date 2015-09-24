#
# nginx-proxngin Docker image building
#

#
#  From this base-image / starting-point
#
FROM nginx:latest

#
#  Authorship
#
MAINTAINER Santosh Kumar Gupta <santosh0705@gmail.com>

#
#  Copy utilities and configuration files
#
ADD https://raw.githubusercontent.com/santosh0705/proxngin/master/proxngin /usr/sbin/proxngin
COPY runit /etc/service

#
#  Update apt
#  Install python, runit
#  Clean up logs and unwanted things
#
RUN apt-get update && \
    apt-get upgrade --yes --force-yes && \
    apt-get install python runit --yes --force-yes && \
    apt-get clean && \
    mkdir -p /etc/nginx/dynamic.d && \
    sed -i '/include.*\/\*\.conf\;/a\    include /etc/nginx/dynamic.d/*.conf;' /etc/nginx/nginx.conf && \
    chmod +x /etc/service/*/run /usr/sbin/proxngin && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc,info,gnome/help} /etc/ld.so.cache /var/cache/ldconfig/* && \
    echo -n > /var/log/lastlog && \
    echo -n > /var/log/wtmp

#
#  Finally launch the entry point
#
CMD ["/usr/sbin/runsvdir-start"]
