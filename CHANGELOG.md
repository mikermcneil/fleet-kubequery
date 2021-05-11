# kubequery change log

<a name="1.0.0"></a>
## [1.0.0](https://github.com/Uptycs/kubequery/releases/tag/1.0.0)

[Git Commits](https://github.com/Uptycs/kubequery/compare/0.3.0...1.0.0)

### New Features

* New `kubequeryi` command line to easily invoke shell
* Easy to use with [query-tls](https://github.com/Uptycs/query-tls)

### Under the Hood improvements

* Upgrade to basequery 4.8.0
* Switch to light weigh busybox docker image
* Simple NodeJS based integration test

### Table Changes

* Added `cluster_name` and `cluster_uid` to tables missing those columns
* Break up `resources` in `*_containers` tables to `resource_limits` and `resource_requests`
* Added new table `kubernetes_component_statuses`
* Removed table `kubernetes_storage_capacities`

### Bug Fixes

### Documentation

### Build

* Upgrade to Go 1.16

### Security Issues

### Packs

* Added default query pack for all kubernetes tables


<a name="0.3.0"></a>
## [0.3.0](https://github.com/Uptycs/kubequery/releases/tag/0.3.0)

[Git Commits](https://github.com/Uptycs/kubequery/compare/0.2.0...0.3.0)

### New Features

### Under the Hood improvements

* Upgrade to basequery 4.7.0

### Table Changes

### Bug Fixes

### Documentation

* Validate the installation was successful [PR-12](https://github.com/Uptycs/kubequery/pull/12)

### Build

### Security Issues

### Packs


<a name="0.2.0"></a>
## [0.2.0](https://github.com/Uptycs/kubequery/releases/tag/0.2.0)

[Git Commits](https://github.com/Uptycs/kubequery/compare/0.1.0...0.2.0)

### New Features

* Added `kubernetes_events` table.

### Under the Hood improvements

* Switch to [basequery](https://github.com/Uptycs/basequery). This is stripped download version of Osquery with support for extension events and other features.

### Table Changes

* kubernetes_events

### Bug Fixes

### Documentation

* Validate the installation was successful [PR-12](https://github.com/Uptycs/kubequery/pull/12)

### Build

### Security Issues

### Packs
