# Define plugin type for asdf
define asdf::plugin (
  Enum['present', 'absent', 'latest'] $ensure = 'latest',
  String[1] $shortname = $title,
  String[1] $repo = $title,
) {
  vcsrepo { "${asdf::path}/plugins/${shortname}":
    ensure   => $ensure,
    provider => git,
    source   => $repo,
    owner    => $asdf::owner,
    group    => $asdf::group
  }
}
