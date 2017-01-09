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
    ensure   => present,
    provider => git,
    source   => $repo,
    owner    => $owner,
    group    => $group
  }
}
