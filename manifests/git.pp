# Definition: git::git
#
# This class configure the git protocol for git use
#
# Parameters:
#
#   [*git_user*]                - The OS username to use for the git protocol
#   [*git_base_path*]           - The base path for the git daemon
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
#   git::git{'public_git' :
#     user        => 'public_git',
#     base_path   => '/opt/public_git',
#   }
#
define git::git(
  $user                   = $name,
  $base_path              = "/${git::params::base_path}/${user}",
  $export_all             = $git::params::export_all,
  $enable_receive_pack    = $git::params::enable_receive_pack,
  $enable_upload_pack     = $git::params::enable_upload_pack,
  $enable_upload_archive  = $git::params::enable_upload_archive,
  $port                   = $git::params::port) {

  require git

  $git_daemon = $git::git_daemon

  if $base_path == "/${git::params::base_path}/" {
    fail ("[git::git] base_path is a mandatory parameter")
  }

  group {$user :
    ensure => present,
  }

  user {$user :
    ensure           => present,
    home             => $base_path,
    comment          => "The Git Git User ${user}",
    gid              => $user,
    shell            => $git_shell,
    password_min_age => '0',
    password_max_age => '99999',
    password         => '*',
    require          => Class['git'],
  }

  $h = get_cwd_hash_path($base_path, $user)
  create_resources('file', $h)

  file {$base_path :
    ensure  =>  directory,
    owner   =>  $user,
    group   =>  $user,
    mode    =>  '0700',
  }

  file {"/etc/xinetd.d/git":
    ensure  =>  present,
    content =>  template("git/git.erb"),
    mode    =>  '0600',
    require =>  User[$user],
    notify  =>  Service['xinetd'],
  }

  service {'xinetd' :
    ensure     => running,
    hasrestart => true,
    hasstatus  => false,
    enable     => true,
  }
}
