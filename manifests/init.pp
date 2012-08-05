class git {

  $git_package = $osfamily ? {
    /(RedHat|Debian)/ => "git",
    'Darwin'          => "git-core",
    default             => undef,
  }

  package {"${git_package}" :
    ensure => installed,
  }
}
