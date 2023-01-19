FROM debian:11

RUN ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split && \
    ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb && \
    ln -s /usr/bin/nscd /usr/sbin/nscd && \
    ln -s /bin/tar /usr/sbin/tar && \
    ln -s /bin/rm /usr/sbin/rm

RUN apt-get update && \
 apt-get install -y gnupg apt-transport-https wget ca-certificates curl wget apt-utils && \
 echo "deb [trusted=yes] https://zmrepo.zoneminder.com/debian/release-1.36 bullseye/" > etc/apt/sources.list.d/zoneminder.list && \
 apt update && \
 apt install -y zoneminder && \
 adduser www-data video && \
 systemctl enable zoneminder.service && \
 a2enconf zoneminder && \
 a2enmod rewrite

# Expose http port
EXPOSE 80

RUN mkdir -p /var/cache/zoneminder && chown www-data:www-data -R /var/cache/zoneminder

# Configure entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
