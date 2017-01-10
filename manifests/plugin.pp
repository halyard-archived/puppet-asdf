# Define plugin type for asdf
define asdf::plugin (
  Enum['present', 'absent', 'latest'] $ensure = 'latest',
  Variant[String[1], Undef] $shortname = undef,
  String[1] $repo = $title,
) {
  if $shortname == undef {
    $shortname = split($repo, '-')[-1]
  }
  $path = "${asdf::path}/plugins/${shortname}"

  Exec {
    cwd   => "${asdf::path}/bin",
    user  => $asdf::owner,
    group => $asdf::group
  }

  if $ensure == 'absent' {
    exec { "./asdf plugin-remove ${shortname} ${repo}":
      onlyif => "test -d ${path}"
    }
  } else {
    exec { "./asdf plugin-add ${shortname} ${repo}":
      creates => $path
    }
    if $ensure == 'latest' {
      exec { "./asdf plugin-update ${shortname}":
        require => Exec["./asdf plugin-add ${shortname} ${repo}"]
      }
    }
  }
}
