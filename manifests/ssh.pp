# Definition: git::ssh
#
# This class configure the ssh protocol for git use
#
# Parameters:
#
#   [*ssh_user*]  - The SSH git user
#   [*package*]   - The git package required
#
# Actions:
#
#   - Ensure git package is installed
#   - Create git user/group
#   - Configure authorized_keys through hiera
#
# Requires:
#
#   - SSH (It is considered installed)
#
# Sample Usage:
#
#   git::ssh{'git-ssh' :
#     ssh_user => 'git_ssh',
#     package  => 'git',
#   }
#
define git::ssh($ssh_user, $package = 'git') {

  group {$ssh_user :
    ensure => present,
  }

  user {$ssh_user :
    ensure           => present,
    home             => "/home/${ssh_user}",
    comment          => 'The SSH Git User',
    gid              => $ssh_user,
    shell            => '/usr/bin/git-shell',
    password_min_age => '0',
    password_max_age => '99999',
    password         => '*',
    require          => Package[$package],
  }

  file {"/home/${ssh_user}" :
    ensure  => directory,
    owner   => $ssh_user,
    group   => $ssh_user,
    mode    => '0700',
    require => User[$ssh_user],
  }

  file {"/home/${ssh_user}/.ssh" :
    ensure    => directory,
    owner     => $ssh_user,
    group     => $ssh_user,
    mode      => '0600',
    require => File["/home/${ssh_user}"],
  }

  $keys = hiera_hash('ssh_keys')
  create_resources('ssh_authorized_key', $keys)
}
