# Class: git
#
#   This class installs the git and git-daemon package
#
# Parameters:
#
# Actions:
#
#   Install the git & git-daemon packages
#
# Requires:
#
#   - SSH (It is considered installed)
#
# Sample Usage:
#
# include git
#
# class {'git':
#   provider => 'source',
#   version  => '1.7.4',
# }
#
#
class git (
  $provider = 'package',
  $version  = 'latest') {

  include git::params

  case $provider {
    'package' : {
      $git_package = $::osfamily ? {
        'Darwin'  =>  "git-core",
        default   =>  "git",
      }

      $packages = [$git_package, 'git-daemon']

      package {$packages :
        ensure => latest,
      }
    }
    'source' : {
      package {$git::params::devtools_packages :
        ensure => latest,
      }

      exec {"curl -L http://git-core.googlecode.com/files/git-${version}.tar.gz | tar -xzf - && cd git-${version} && ./configure --without-tcltk  && make && make install && rm -rf /root/git-${version}" :
        cwd       =>  '/root',
        user      =>  'root',
        path      =>  ['/usr/local/bin', '/bin', '/usr/bin'],
        timeout   =>  0,
        logoutput =>  on_failure,
        unless    =>  "[[ `git --version | cut -d\' \' -f3` = \'${version}\'* ]]",
        provider  =>  'shell',
        require   =>  Package[$git::params::devtools_packages],
      }
    }
}
