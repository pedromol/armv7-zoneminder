FROM debian:10

RUN apt-get update  && \
 apt-get install -y gnupg apt-transport-https  wget ca-certificates curl && \
 echo "deb [trusted=yes] https://zmrepo.zoneminder.com/debian/release-1.34 buster/" >> etc/apt/sources.list && \
 wget -O - https://zmrepo.zoneminder.com/debian/archive-keyring.gpg | apt-key add - && \
 apt-get update && \
 apt-get -y install zoneminder && \
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
