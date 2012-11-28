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
      $packages = ['git', 'git-daemon', 'xinetd']
    }
    'Debian': {
      $packages = ['git', 'git-daemon-run', 'xinetd']
    }
    default: {
      fail("Unsupported OS : $::osfamily - Get in touch with the Module maintainer to see how we can fix that")
    }
  }
}
