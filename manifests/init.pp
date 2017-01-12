# == Class: asdf
#
# Configure asdf

class asdf (
  $path = '/opt/asdf',
  $owner = $facts['id'],
  $group = $facts['gid'],
  $repo = 'https://github.com/asdf-vm/asdf'
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
    ensure   => latest,
    provider => brew,
    before   => Vcsrepo[$path]
  }
}
