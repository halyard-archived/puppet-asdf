# == Class: asdf
#
# Configure asdf

class asdf (
  String[1] $path = '/opt/asdf',
  String[1] $owner = $facts['id'],
  String[1] $group = $facts['gid'],
  String[1] $repo = 'https://github.com/asdf-vm/asdf',
  Hash[String[1], Hash] $plugins = {},
  Hash[String[1], Hash] $versions = {}
) {
  vcsrepo { $path:
    ensure   => latest,
    provider => git,
    source   => $repo,
    owner    => $owner,
    group    => $group
  }

  $packages = [
    'automake',
    'autoconf',
    'openssl',
    'libyaml',
    'readline',
    'libxslt',
    'libtool',
    'unixodbc'
  ]

  package { $packages:
    ensure   => present,
    provider => brew,
    before   => Vcsrepo[$path]
  }

  $plugins.each |String[1] $plugin, Hash $plugin_data| {
    if has_key($plugin_data, 'versions') {
      Asdf::Version { $plugin:
        versions => $plugin_data['versions']
      }
    }
  }

  create_resources(asdf::plugin, $plugins)
}
