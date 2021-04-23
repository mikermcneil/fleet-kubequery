#!/usr/bin/make -f

# Copyright (c) 2020-present, The kubequery authors
#
# This source code is licensed as defined by the LICENSE file found in the
# root directory of this source tree.
#
# SPDX-License-Identifier: (Apache-2.0 OR GPL-2.0-only)

all: deps test build kubequery.yaml

deps:
	@go mod download

build: deps
	@go build -ldflags="-s -w -X main.VERSION=${VERSION}" -o bin ./...

test:
	@go test -race -cover ./...

docker: build
	@docker build --build-arg KUBEQUERY_VERSION=${VERSION} -t uptycs/kubequery:${VERSION} .

genschema: build
	@echo "\`\`\`sql" >  docs/schema.md
	@./genschema      >> docs/schema.md
	@echo "\`\`\`"    >> docs/schema.md

kubequery.yaml:
	@sed -e "s/^/    /g" etc/kubequery.flags > etc/kubequery.flags.tmp
	@sed -e "s/^/    /g" etc/kubequery.conf > etc/kubequery.conf.tmp
	@sed -e "/kubequery.flags: |/r etc/kubequery.flags.tmp" \
		-e "/kubequery.conf: |/r etc/kubequery.conf.tmp"    \
		kubequery-template.yaml > kubequery.yaml
	@rm -f etc/*.tmp

clean:
	@rm -f kubequery.yaml bin/kubequery bin/genschema bin/uuidgen etc/*.tmp

.PHONY: all
	ifeq ($(VERSION),)
		VERSION := $(shell git describe --tags HEAD)
	endif
