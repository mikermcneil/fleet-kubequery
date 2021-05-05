#!/usr/bin/make -f

# Copyright (c) 2020-present, The kubequery authors
#
# This source code is licensed as defined by the LICENSE file found in the
# root directory of this source tree.
#
# SPDX-License-Identifier: (Apache-2.0 OR GPL-2.0-only)

ifeq ($(VERSION),)
	VERSION := $(shell git describe --tags HEAD | cut -d'-' -f1-2 | sed 's/-/./')
endif

all: deps lint test build kubequery.yaml

deps:
	@go mod download

lint:
	@go get golang.org/x/lint/golint
	@golint ./...

build: deps
	@go build -ldflags="-s -w -X main.VERSION=${VERSION}" -o bin ./...

test:
	@go test -race -cover ./...

integration:
	@node integration/index.js

docker: build
	@docker build --build-arg KUBEQUERY_VERSION=${VERSION} -t uptycs/kubequery:${VERSION} .

genschema: build
	@echo "\`\`\`sql" >  docs/schema.md
	@./bin/genschema      >> docs/schema.md
	@echo "\`\`\`"    >> docs/schema.md

kubequery.yaml:
	@sed -e "s/^/    /g" etc/kubequery.flags > etc/kubequery.flags.tmp
	@sed -e "s/^/    /g" etc/kubequery.conf > etc/kubequery.conf.tmp
	@sed -e "/kubequery.flags: |/r etc/kubequery.flags.tmp" \
		-e "/kubequery.conf: |/r etc/kubequery.conf.tmp"    \
		kubequery-template.yaml > kubequery.yaml
	@rm -f etc/*.tmp

clean:
	@rm -rf vendor kubequery.yaml bin/kubequery bin/genschema bin/uuidgen etc/*.tmp

.PHONY: all integration
