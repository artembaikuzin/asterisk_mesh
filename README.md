# AsteriskMesh

[![Build Status](https://travis-ci.org/ybinzu/asterisk_mesh.svg?branch=master)](https://travis-ci.org/ybinzu/asterisk_mesh)

Asterisk mesh network config generator. This gem is under construction.

## Installation

    $ gem install asterisk_mesh

## Usage

#### Script command line parameters

    $ bundle exec exe/asterisk_mesh --help
    Usage: asterisk_mesh.rb [options]
        -n, --network=NETWORK_FILE       Sets network file (asterisk_mesh.yml by default)
        -v, --version                    Prints version number
        
#### Network file example
```yaml

---
asterisk_mesh:
  output: /Users/deploy/servers/shared_mesh
  nodes:
    - extension: 1XX
      primary_digits: 3
      name: north
      host: north.srv.acme.com

    - extension: 2XX
      primary_digits: 3
      name: west
      host: west.srv.acme.com

    - extension: 3XX
      primary_digits: 3
      name: south
      host: south.srv.acme.com

    - extension: 4XX
      primary_digits: 3
      name: east
      host: east.srv.acme.com

    - extension: 1XX
      primary_digits: 3
      prefix: "1"
      operator_prefix: acme
      name: partners
      host: partners.server.com

```

#### Execution

    $ bundle exec exe/asterisk_mesh
    Parsing network file...OK
    Building network...OK
    Exporting nodes to /Users/deploy/servers/shared_mesh/...OK
    
    5 nodes have been exported (5 static, 0 dynamic):
    STATIC  : north
    STATIC  : west
    STATIC  : south
    STATIC  : east
    STATIC  : partners

#### Results

    .
    ├── east
    │   ├── extensions.conf
    │   ├── iax.conf
    │   └── iax_register.conf
    ├── north
    │   ├── extensions.conf
    │   ├── iax.conf
    │   └── iax_register.conf
    ├── partners
    │   ├── extensions.conf
    │   ├── iax.conf
    │   └── iax_register.conf
    ├── south
    │   ├── extensions.conf
    │   ├── iax.conf
    │   └── iax_register.conf
    └── west
        ├── extensions.conf
        ├── iax.conf
        └── iax_register.conf

Each config file can be included on each node respectively.

## TODO

1. Write proper README.md.
1. Move dialplan and iax config from classes to external template files.
1. Fair static nodes load rotation (dial macros?). For now, it is always first static node has high load.
1. Load configuration from external yml file / network file.
1. Dry run mode.
1. Verbosity and logging.
1. Code documentation.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ybinzu/asterisk_mesh.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

