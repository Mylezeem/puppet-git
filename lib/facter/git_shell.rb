# Facter: git_shell
#
#   Indicate the right path to the git-shell binary, priority to the package installed one
#
Facter.add("git_shell") do
  setcode do
    File.exists?('/usr/bin/git-shell') ? '/usr/bin/git-shell' : '/usr/local/bin/git-shell'
  end
end
