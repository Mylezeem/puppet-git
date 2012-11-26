class git::params () {
  #
  # Parameters initialization
  #

  $port = '9418'
  $export_all = false
  $base_path = '/opt/'

  $enable_receive_pack = false
  $enable_upload_pack = true
  $enable_upload_archive = false

  $set_firewall_rule = true
  case $::osfamily {
    'RedHat': {
      $devtools_packages = ['gettext', 'make', 'gcc', 'gcc-c++', 'openssl-devel', 'libicu-devel', 'libyaml-devel', 'zlib-devel', 'readline-devel', 'autoconf', 'perl-ExtUtils-MakeMaker', 'xinetd']
      $packages = ['git', 'git-daemon']
    }
    'Debian': {
      $devtools_packages = ['gettext', 'make', 'gcc', 'g++', 'libssl-dev', 'curl', 'libicu-dev', 'libyaml-dev', 'zlib1g-dev', 'libreadline-dev', 'autoconf', 'libmodule-build-perl', 'libmodule-install-perl', 'xinetd']
      $packages = ['git', 'git-daemon-run', 'git-daemon-sysvinit']
    }
    default: {
      fail("Unsupported OS : $::osfamily - Get in touch with the Module maintainer to see how we can fix that")
    }
  }
}
