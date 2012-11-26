# Facter: git_daemon
#
#   Indicate the right path to the git-daemon binary, priority to the package installed one
#
Facter.add("git_daemon") do
  setcode do
    File.exists?('/usr/libexec/git-core/git-daemon') ? '/usr/libexec/git-core/git-daemon' : '/usr/local/libexec/git-core/git-daemon'
  end
end
