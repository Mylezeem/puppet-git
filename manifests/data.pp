# Class: git::data
#
#   This class emulat the behavior of a the hiera call in the git::ssh definition
#
# Actions:
#
#   Fill out the $ssh_user/.ssh/authorized_keys file of authorized user's public keys
#
# Warning:
#
#   My public key will be of no use for you, please do not forget to CHANGE it
#
#
class git::data {

  $ssh_keys = ["me-laptop" => {ensure => present, user => 'git', type => 'ssh-rsa', key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA1v0siG38jaK4Y/3pD8PmRgLE1iG8oO9XcZErp5gRsF0ZHb6ue1pUqYwIyW57RkjbPJI5Y/Tb/TvicuNX2ConOYBoPQ4BcIbtFoIOnp4kTTDF5HNAEHmyjfKCu1fJn6nz4B8HuNEjxFze1Dhh45/Dz2QaQOOytKNlOAT8YKxcTLH7Iis2ttUSLxwBuf/caJcdVBgJIGC+nPnSLmnyHzEUtliwbfvQi9NMRmpHsb6MDPThDaLdalNWpct698MLdircuigrPLATmR2Zqk31zw07f0rEzBl+JcpIwrfVY+vZeHdVge8ee3hrC9DpJiDNaNMjSPrBSoW2KxK+NVe9JvQZDw=='}]

}
