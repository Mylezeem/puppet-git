# Definition: git::ssh
#
# This class configure the ssh protocol for git use
#
# Parameters:
#
#   [*user*]       - The SSH git user
#   [*base_path*]  - The base path directory to store the git repos
#
# Actions:
#
#   - Create git user/group
#   - Configure authorized_keys through hiera
#
# Requires:
#
#   - SSH (It is considered installed)
#
# Sample Usage:
#
#   git::ssh{'git' :
#     user      => 'git',
#     base_path => '/opt/git',
#   }
#
define git::ssh(
  $user       = $name,
  $base_path  = "/${git::params::base_path}/${user}") {

  require git

  if $base_path == "/${git::params::base_path}/" {
    fail("[git::ssh] base_path is a mandatory parameter")
  }

  group {$user :
    ensure => present,
  }

  user {$user :
    ensure           => present,
    home             => $base_path,
    comment          => "SSH GIT User ${user}",
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
    ensure  => directory,
    owner   => $user,
    group   => $user,
    mode    => '0700',
    require => User[$user],
  }

  file {"/${base_path}/.ssh" :
    ensure    => directory,
    owner     => $user,
    group     => $user,
    mode      => '0600',
    require => File[$base_path],
  }

  #
  # Here one can manage the SSH authorized_keys via hiera
  # The hiera_puppet being broken with definition, there is sno way
  # to provide a default out-of-the box ::data class
  #
  # Please configure correctly your hiera backend (YAML, JSON, etc...) for the following to work
  # and uncomment
  #

  #$keys = hiera_hash('ssh_keys')
  #create_resources('ssh_authorized_key', $keys, {require => File["/${base_path}/.ssh"]})
}
