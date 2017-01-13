# == Class: asdf
#
# Configure asdf

class asdf (
  String[1] $path = '/opt/asdf',
  String[1] $owner = $facts['id'],
  String[1] $group = $facts['gid'],
  String[1] $repo = 'https://github.com/asdf-vm/asdf',
  Hash[String, Hash] $plugins = {}
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

  create_resources(asdf::plugin, $plugins)
}
