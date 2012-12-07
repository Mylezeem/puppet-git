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
      package {$git::params::packages :
        ensure => latest,
      }
      $git_daemon = $::osfamily ? {
        'RedHat' => '/usr/libexec/git-core/git-daemon',
        default  => '/usr/lib/git-core/git-daemon',
      }
    }
    'source' : {

      require devtools

      exec {"curl -L http://git-core.googlecode.com/files/git-${version}.tar.gz | tar -xzf - && cd git-${version} && ./configure --without-tcltk  && make && make install && rm -rf /root/git-${version}" :
        cwd       =>  '/root',
        user      =>  'root',
        path      =>  ['/usr/local/bin', '/bin', '/usr/bin'],
        timeout   =>  0,
        logoutput =>  on_failure,
        unless    =>  "/bin/bash -c \"[[ `git --version | cut -d\' \' -f3` = \'${version}\'* ]]\"",
        provider  =>  'shell',
      }
      $git_daemon = '/usr/local/libexec/git-core/git-daemon'
    }
    default : { fail("[git] The provider you selected ${provider} is not valid") }
  }
}
