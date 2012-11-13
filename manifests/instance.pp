define git::instance(
  $package,
  $protocol = $git::params::protocol,
  $ssh_user = $git::params::ssh_user,
  $git_user = $git::params::git_user,
  $base_path = $git::params::base_path,
  $port = $git::params::port,
  $export_all = $git::params::export_all,
  $enable_receive_pack = $git::params::enable_receive_pack,
  $enable_upload_pack = $git::params::enable_upload_pack,
  $enable_upload_archive = $git::params::enable_upload_archive,
  $set_firewall_rule = $git::params::set_firewall_rule) {

  if $protocol != 'none' {
    case $protocol {
      ssh: {
        git::ssh { "git-ssh-${ssh_user}" :
          ssh_user => $ssh_user,
          package  => $package,
        }
      }
      git: {
        git::git {"git-git-${git_user}" :
          git_user              => $git_user,
          package               => $package,
          base_path             => $base_path,
          export_all            => $export_all,
          enable_receive_pack   => $enable_receive_pack,
          enable_upload_pack    => $enable_upload_pack,
          enable_upload_archive => $enable_upload_archive,
          port                  => $port,
        }
      }
    }
  }
}
