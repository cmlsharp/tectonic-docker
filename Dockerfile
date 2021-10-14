FROM rust:latest as builder
RUN apt-get update && apt-get upgrade && apt-get install -y libfontconfig1-dev libgraphite2-dev libharfbuzz-dev libicu-dev zlib1g-dev

# use a version with better caching implemented
RUN cargo install --git https://github.com/tectonic-typesetting/tectonic.git --force tectonic
WORKDIR /usr/src/tex
COPY *.tex ./
RUN for f in *.tex; do tectonic $f; done

FROM rust:latest
RUN apt-get update \
     && apt-get install -y --no-install-recommends libfontconfig1 libgraphite2-3 libharfbuzz0b libicu-dev zlib1g libharfbuzz-icu0 libssl1.1 ca-certificates \
    && rm -rf /var/lib/apt/lists/* 

COPY --from=builder /usr/local/cargo/bin/tectonic /usr/bin/
COPY --from=builder /root/.cache/Tectonic/ /root/.cache/Tectonic/
WORKDIR /usr/src/tex

