FROM rust:1.78.0-slim-bookworm AS builder

ARG VERSION=efc1fec8b0f96b5663d7257a0c2cffd8ef143219
ENV REPO=https://github.com/blockstream/electrs.git

WORKDIR /build

RUN apt-get update
RUN apt-get install -y git cargo clang cmake libsnappy-dev

#RUN git clone --branch $VERSION $REPO .

#RUN cargo build --release --bin electrs
RUN cargo install --git "https://github.com/Blockstream/electrs.git" --root /build
RUN ls -lah /build/
RUN ls -lah /build/bin


FROM debian:bookworm-slim

COPY --from=builder /build/bin/electrs /bin/electrs

# Electrum RPC Mainnet
EXPOSE 50001
# Electrum RPC Testnet
EXPOSE 60001
# Electrum RPC Regtest
EXPOSE 60401

# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT

HEALTHCHECK CMD curl -fSs http://localhost:4224/ || exit 1

ENTRYPOINT [ "electrs" ]


