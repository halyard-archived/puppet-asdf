# Define version type for asdf
define asdf::version (
  Variant[String[1], Array[String[1], 1]] $versions,
  Enum['present', 'absent'] $ensure = 'present',
  String[1] $plugin = $title,
) {
  $version_array = any2array($versions)

  Exec {
    user  => $asdf::owner,
    group => $asdf::group
  }

  $bin = "${asdf::path}/bin/asdf"

  $version_array.each |version| {
    if $ensure == 'present' {
      exec { "${bin} install ${plugin} ${version}":
        unless  => "${bin} list ${plugin} | grep ${version}",
        require => Asdf::Plugin[$plugin]
      }
    } else {
      exec { "${bin} uninstall ${plugin} ${version}":
        onlyif => "${bin} list ${plugin} | grep ${version}"
      }
    }
  }
}
