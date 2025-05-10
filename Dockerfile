FROM node AS builder

WORKDIR /build

RUN npm i -g elm

COPY static/ static/

RUN cd static && elm make src/Main.elm

FROM haskell:9.4.8

WORKDIR /app

RUN cabal update

COPY --from=builder /build/static/index.html index.html

COPY aloussase-website.cabal aloussase-website.cabal
RUN cabal build --only-dependencies -j4

COPY . /app/
RUN cabal install -j4

ENTRYPOINT aloussase-website
