from alpine:latest as build

RUN apk add --update go git gcc g++

ENV GOPATH /go

RUN go get -u github.com/gogits/gogs

WORKDIR $GOPATH/src/github.com/gogits/gogs

RUN go build -tags "sqlite"

RUN rm -rf .git vendor conf docker pkg


from alpine:latest as run

RUN apk add --update git openssh-keygen

ENV USER root

COPY --from=build /go/src/github.com/gogits/gogs /gogs


WORKDIR /gogs

CMD ./gogs web

VOLUME /gogs/custom/conf/
