# Class: git
#
#   This class installs git server and client according to the selected protocol
#
# Parameters:
#
#   [*protocol*]                - The protocol git will be installed to use
#   [*ssh_user*]                - The OS username to use for the ssh protocol
#   [*git_user*]                - The OS username to use for the git protocol
#   [*base_path*]               - The base path for the git daemon
#   [*export_all*]              - When using git daemon should all repo be exported
#   [*enable_receive_pack*]     - Should receive-pack be enabled
#   [*enable_upload_pack*]      - Should upload-pack be enabled
#   [*enable_upload_archive*]   - Should upload-archive be enabled
#   [*set_firewall_rule*]       - Should the port 9418 be open in your firewall (Not active yet)
#
# Actions:
#
#   - Install git to use the protocol specified
#   - Manage git account SSH Keys
#
# Requires:
#
#   - SSH (It is considered installed)
#
# Sample Usage:
#
# class {'git':
#   protocol: 'none',
# }
#
# class{'git':
#   ssh_user: git,
#   protocol: 'ssh',
# }
#
# class{'git':
#   git_user: public_git,
#   protocol: 'git',
#   export_all: true,
#   base_path: '/opt/git',
#   enable_receive_pack: true,
#   enable_upload_pack: true,
#   enable_archive: true,
#   set_firewall_rule : true,
# }
#
class git (
  $protocol = $git::params::protocol,
  $ssh_user = $git::params::ssh_user,
  $git_user = $git::params::git_user,
  $base_path = $git::params::base_path,
  $export_all = $git::params::export_all,
  $enable_receive_pack = $git::params::enable_receive_pack,
  $enable_upload_pack = $git::params::enable_upload_pack,
  $enable_upload_archive = $git::params::enable_upload_archive,
  $set_firewall_rule = $git::params::set_firewall_rule) inherits git::params {

  $package = $osfamily ? {
    'Darwin'  =>  "git-core",
    default   =>  "git",
  }

  package {$package :
    ensure => latest,
  }

  if $protocol != 'none' {
    case $protocol {
      ssh: {
        git::ssh { 'git-ssh' :
          ssh_user => $ssh_user,
          package  => $package,
        }
      }
      git: {
        git::git {'git-git' :
          git_user              => $git_user,
          package               => $package,
          base_path             => $base_path,
          export_all            => $export_all,
          enable_receive_pack   => $enable_receive_pack,
          enable_upload_pack    => $enable_upload_pack,
          enable_upload_archive => $enable_upload_archive,
        }
      }
      /(git-ssh|ssh-git)/: {
        git::git {'git-git' :
          git_user              => $git_user,
          package               => $package,
          base_path             => $base_path,
          export_all            => $export_all,
          enable_receive_pack   => $enable_receive_pack,
          enable_upload_pack    => $enable_upload_pack,
          enable_upload_archive => $enable_upload_archive,
        }
        git::ssh { 'git-ssh' :
          ssh_user => $ssh_user,
          package  => $package,
        }
      }
    }
  }
}
