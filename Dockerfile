#
# Dockerfile for 4.3BSD on VAX by wvu
#
# expect(1) and ed(1) are used to automate SIMH
#
# This is my first Dockerfile, so please be kind :)
#

FROM alpine as simh

WORKDIR /simh

# Install build dependencies for SIMH
RUN apk --no-cache add -t build-essential \
      gcc \
      libc-dev \
      make

# Build and "install" SIMH
RUN wget https://github.com/simh/simh/archive/master.zip && \
    unzip master.zip && \
    make -C simh-master vax780 && \
    cp simh-master/BIN/vax780 . && \
    rm -rf simh-master master.zip && \
    apk del build-essential

FROM alpine
LABEL author="wvu"

WORKDIR /simh

ARG SETUP_FILES="install.ini miniroot setup.exp"

# Copy SIMH from the builder
COPY --from=simh /simh/vax780 .

# Install setup dependencies for 4.3BSD
RUN apk --no-cache add -t simh-essential \
      expect \
      libcap

# Copy files, respecting .dockerignore
COPY . .

# Install and configure 4.3BSD
RUN gunzip *.gz && \
    ./setup.exp && \
    chown -R nobody:nobody . && \
    setcap cap_net_bind_service+ep vax780 && \
    rm -f $SETUP_FILES && \
    apk del simh-essential

# sendmail and fingerd are vulnerable
EXPOSE 25 79

# Run the simulator as the "nobody" user
USER nobody
CMD ["./vax780", "boot.ini"]
