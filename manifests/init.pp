class git {

  $package = $osfamily ? {
    /(RedHat|Debian)/ => "git",
    'Darwin'          => "git-core",
    default             => undef,
  }

  package {${package} :
    ensure => installed,
  }
}
