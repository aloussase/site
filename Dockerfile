FROM haskell:9.4.8

WORKDIR /app

RUN cabal update

COPY aloussase-website.cabal aloussase-website.cabal
RUN cabal build --only-dependencies -j4

COPY . /app/
RUN cabal install -j4

COPY index.html index.html

RUN awk '/<\/style>/ {print "  <link href=\"/styles.css\" rel=\"stylesheet\"/>\n  <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css\" />"} !/<\/style>/ {print $0}' index.html > tmp.html	
RUN mv -f tmp.html index.html

ENTRYPOINT aloussase-website
