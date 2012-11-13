# Class: git::data
#
#   This class emulat the behavior of a the hiera call in the git class
#
# Actions:
#
#   Get git instances (git/ssh) to create
#
# Warning:
#
#   The ssh_keys from git::ssh definitions needs to be inform by a yaml backend and not a puppet one due to a current issue with hiera_puppet
#
#
class git::data () {
  $git = {
    'git'  => {
      protocol => 'ssh',
      ssh_user => 'git',
    },
    'perso_1' => {
      protocol    => 'git',
      git_user    => 'perso_1',
      base_path   => '/opt/git_perso_1',
      export_all  => true,
    }
  }
}
