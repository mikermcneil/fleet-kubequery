/**
 * Copyright (c) 2020-present, The kubequery authors
 *
 * This source code is licensed as defined by the LICENSE file found in the
 * root directory of this source tree.
 *
 * SPDX-License-Identifier: (Apache-2.0 OR GPL-2.0-only)
 */

package main

import (
	"context"
	"flag"
	"fmt"
	"time"

	"github.com/Uptycs/kubequery/internal/k8s"
	"github.com/Uptycs/kubequery/internal/k8s/tables"
	"github.com/kolide/osquery-go"
	"github.com/kolide/osquery-go/plugin/table"
)

var (
	socket   = flag.String("socket", "", "Path to the extensions UNIX domain socket")
	timeout  = flag.Int("timeout", 3, "Seconds to wait for autoloaded extensions")
	interval = flag.Int("interval", 3, "Seconds delay between connectivity checks")
)

func main() {
	flag.Parse()
	if *socket == "" {
		panic("Missing required --socket argument")
	}

	err := k8s.Init()
	if err != nil {
		panic(err.Error())
	}

	// TODO: Version and SDK version
	server, err := osquery.NewExtensionManagerServer(
		"kubequery",
		*socket,
		osquery.ServerTimeout(time.Second*time.Duration(*timeout)),
		osquery.ServerPingInterval(time.Second*time.Duration(*interval)),
	)
	if err != nil {
		panic(fmt.Sprintf("Error launching kubequery: %s\n", err))
	}
	defer server.Shutdown(context.Background())

	for _, t := range tables.GetTables() {
		server.RegisterPlugin(table.NewPlugin(t.Name, t.Columns, t.GenFunc))
	}
	if err := server.Run(); err != nil {
		panic(err)
	}
}
