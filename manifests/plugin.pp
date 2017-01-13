# Define plugin type for asdf
define asdf::plugin (
  Enum['present', 'absent', 'latest'] $ensure = 'latest',
  Variant[String[1], Undef] $shortname = undef,
  String[1] $repo = $title,
) {
  if $shortname == undef {
    $_shortname = split($repo, '-')[-1]
  } else {
    $_shortname = $shortname
  }

  $plugin_path = "${asdf::path}/plugins/${_shortname}"
  $version_path = "${asdf::path}/installs/${_shortname}"

  vcsrepo { $plugin_path:
    ensure   => $ensure,
    provider => git,
    source   => $repo,
    owner    => $asdf::owner,
    group    => $asdf::group,
    require  => Vcsrepo[$asdf::path]
  }

  if $ensure == 'absent' {
    file { $version_path:
      ensure => absent,
      force  => true
    }
  }
}
