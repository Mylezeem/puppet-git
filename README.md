puppet-git
==========

The purpose of this puppet-git module is to manage git installation on a server.

This module allows one to setup git over two different protocols :

  * SSH
  * GIT
  * HTTP (Hopefully coming soon)

## Git

One can install git either from the package repository one have set up on his server or from source for a specific version

### Package

```
include git
```

This example will install the latest version of git from the repositories

### Source

```
class {'git':
  provider  => 'source',
  version   => '1.8.0',
}
```

This example will download / compile and install the version 1.8.0 from the source code


## Protocols

### SSH

The module creates the git user/group and manages the content of the authorized_keys file of the git `$ssh_user`

There is two line commented on the ssh.pp file, configure correctly a hiera.yml to use anything but hiera_puppet
as a backend (known issue with definition) and uncomment those two lines to manager your SSH authorized keys dynamically

```
git::ssh {'git' :
  user      => 'git',
  base_path => '/opt/git',
}
```

### GIT

The module create a public_git user/group, create a folder that will be the base repo and sets the git daemon as a xinetd service.

`git daemon` arguments can be found in `/etc/xinetd.d/git`

**Note** : Even though it is a definition - it can have multiple instances - this would require knowledge on how inetd works and /etc/services works.
It is recommended to use it as a class - singleton.

```
git::git {'public_git' :
  user      =>  'public_git',
  base_path =>  '/opt/public_git',
}
```

### HTTP

Hopefully coming soon

## License

GPLv3
