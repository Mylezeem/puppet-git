class git::params () {
  #
  # Parameters initialization
  #

  $ssh_user = 'git'
  $git_user = 'public_git'

  $protocol = 'ssh'
  $port = '9418'

  $export_all = false
  $base_path = '/opt/git'

  $enable_receive_pack = false
  $enable_upload_pack = true
  $enable_upload_archive = false

  $set_firewall_rule = true
}
