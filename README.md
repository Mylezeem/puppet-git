puppet-git
==========

The purpose of this puppet-git module is to manage git installation on a server.

This module allows one to setup git over two different protocols :

  * SSH
  * GIT

## SSH

The module creates the git user/group and manages the content of the authorized_keys file of the git `$ssh_user`

In order to make it run out of the box do have a hiera.yaml file configure at least as the following 

```
---
:backends:
  - puppet

:puppet:
  :datasource: data
```

## GIT


The module create a public_git user/group, create a folder that will be the base repo and sets the git daemon as a xinetd service.

`git daemon` arguments can be found in `/etc/xinetd.d/git`

## Parameters

* `ssh_user` : The GIT SSH user
* `git_user` : The GIT GIT user
* `protocol` : The protocol to be used. Possible values :
  * `none` : Only install git package
  * `ssh`  : Configure git to work with the ssh protoco  `git@host:`
  * `git`  : Configure git to work with the git protocol `git://`
  * `git-ssh | ssh-git` : Configure git to work with both ssh and git
* `base_path` : The base path for the git daemon
* `enable_receive_pack` : `true` or `false`
* `enable_upload_pack` : `true` or `false`
* `enable_upload_archive`: `true` or `false`


## Sample Usage

### SSH

```
class {'git' :
  protocol  => 'ssh',
  ssh_user  => 'git',
}
```

### GIT

A simple definition would look like this :

```
class {'git' :
  protocol  => 'git',
}
```

When a more complex one would be like this :

```
class {'git':
  protocol      => 'git',
  git_user      => 'public_git',
  export_all    => true,
  base_path     => '/opt/git',
  receive_pack  => true,
}
```

### GIT & SSH

One can configure its box with this module so it can serves data with both protocols

```
class {'git':
  protocol  =>  'git-ssh',
}
```

### None

Simply install the git package

```
class {'git' :
  protocole =>  'none',
}
```
