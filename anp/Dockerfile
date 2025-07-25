#From https://github.com/bgernert/docker-radsecproxy/blob/master/Dockerfile
# Use official Alpine release
FROM alpine:3.22.0 as build

# Maintainer
LABEL maintainer="Björn Gernert <mail@bjoern-gernert.de>"

ENV RADSECVERSION 1.11.2
ENV RADSECURL https://github.com/radsecproxy/radsecproxy/releases/download/${RADSECVERSION}/
ENV RADSECFILENAME radsecproxy-${RADSECVERSION}.tar.gz

# Change working dir
WORKDIR /root

# Update apk
RUN apk update

# Install buildtools
RUN apk add --no-cache make g++ openssl-dev nettle-dev musl-dev

# Create output dir
RUN mkdir output

# Download Radsecproxy source files
RUN wget ${RADSECURL}${RADSECFILENAME}

# Untar Radsecproxy
RUN tar xf ${RADSECFILENAME} --strip-components=1

# Configure
RUN ./configure --prefix=/root/output --sysconfdir=/etc

# Make and install to output dir
RUN make && make install

# --- --- ---

# Create Radsecproxy container
FROM alpine:3.22.0

# Update apk
RUN apk update

# Install openssl, ca-certificates, nettle and tini
RUN apk add --no-cache openssl ca-certificates bash nettle tini bind-tools grep

# Copy from 'build' stage
COPY --from=build /root/output/ /
COPY --from=build /root/radsecproxy.conf-example /etc/radsecproxy.conf

# Copy start.sh
COPY start.sh /root/start.sh

# Make start.sh executeable
RUN chmod u+x /root/start.sh

# Create Radsecproxy logging and certs dir
RUN mkdir /var/log/radsecproxy
RUN mkdir -p /etc/radsecproxy/certs

# Export volumes
VOLUME /var/log/radsecproxy

# Make Radsecproxy's ports available
EXPOSE 1812
EXPOSE 1813

# Set Tini entrypoint
ENTRYPOINT ["/sbin/tini", "--"]
COPY configs/radsecproxy/naptr-openroaming.sh /etc/radsecproxy/naptr-openroaming.sh
RUN chmod +x /etc/radsecproxy/naptr-openroaming.sh
# Start Radsecproxy
CMD ["/root/start.sh"]
