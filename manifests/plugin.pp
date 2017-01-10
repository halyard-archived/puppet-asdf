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
  $path = "${asdf::path}/plugins/${_shortname}"
  $bin = "${asdf::path}/bin/asdf"

  Exec {
    user  => $asdf::owner,
    group => $asdf::group
  }

  if $ensure == 'absent' {
    exec { "${bin} plugin-remove ${_shortname} ${repo}":
      onlyif => "test -d ${path}"
    }
  } else {
    exec { "${bin} plugin-add ${_shortname} ${repo}":
      creates => $path
    }
    if $ensure == 'latest' {
      exec { "${bin} plugin-update ${_shortname}":
        require => Exec["./asdf plugin-add ${_shortname} ${repo}"]
      }
    }
  }
}
