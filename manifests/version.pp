# Define version type for asdf
define asdf::version (
  Enum['present', 'absent', 'latest'] $ensure = 'latest',
  Variant[String[1], Array[String[1], 1]] $versions,
  String[1] $plugin = $title,
) {
  $version_array = any2array($versions)

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
        require => Exec["${bin} plugin-add ${_shortname} ${repo}"]
      }
    }
  }
}
