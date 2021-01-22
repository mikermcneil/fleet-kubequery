#!/usr/bin/make -f

# Copyright (c) 2020-present, The kubequery authors
#
# This source code is licensed as defined by the LICENSE file found in the
# root directory of this source tree.
#
# SPDX-License-Identifier: (Apache-2.0 OR GPL-2.0-only)

all: deps test kubequery

deps:
	go mod download

kubequery: deps
	go build -ldflags="-s -w" -o . ./...

test:
	go test -race -cover ./...

docker: kubequery
	docker build -t uptycs/kubequery .

clean:
	rm -f kubequery

.PHONY: all
