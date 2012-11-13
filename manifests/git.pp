# Definition: git::git
#
# This class configure the git protocol for git use
#
# Parameters:
#
#   [*git_user*]                - The OS username to use for the git protocol
#   [*base_path*]               - The base path for the git daemon
#   [*export_all*]              - When using git daemon should all repo be exported
#   [*enable_receive_pack*]     - Should receive-pack be enabled
#   [*enable_upload_pack*]      - Should upload-pack be enabled
#   [*enable_upload_archive*]   - Should upload-archive be enabled
#   [*set_firewall_rule*]       - Should the port 9418 be open in your firewall (Not active yet)
#   [*package*]                 - The git package required
#   [*port*]                    - The port to use for the git-daemon
#
# Actions:
#
#   - Ensure git package is installed
#   - Create git user/group
#   - Configure the git xinetd configuration file
#
# Requires:
#
# Sample Usage:
#
#   git::git{'git-ssh' :
#     ssh_user => 'git_ssh',
#     package  => 'git',
#   }
#
define git::git($git_user, $package, $base_path, $export_all, $enable_receive_pack, $enable_upload_pack, $enable_upload_archive, $port) {

  group {$git_user :
    ensure => present,
  }

  user {$git_user :
    ensure           => present,
    home             => "/home/${git_user}",
    comment          => 'The SSH Git User',
    gid              => $git_user,
    shell            => '/usr/bin/git-shell',
    password_min_age => '0',
    password_max_age => '99999',
    password         => '*',
    require          => Package[$package],
  }

  $h = get_cwd_hash_path($base_path, $git_user)
  create_resources('file', $h)

  file {$base_path :
    ensure  =>  directory,
    owner   =>  $git_user,
    group   =>  $git_user,
    mode    =>  '0700',
  }

  file {"/etc/xinetd.d/git":
    ensure  =>  present,
    content =>  template("git/git.erb"),
    mode    =>  '0600',
    require =>  Package['git-daemon'],
    notify  =>  Service['xinetd'],
  }

}
