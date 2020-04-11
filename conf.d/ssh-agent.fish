# Check if started

# Symlink is /tmp/ssh-agent-$USER.sock

set -q identities; or set --global identities $HOME/.ssh/id_rsa

set --local uid (id -u)
set --local symlink "/tmp/ssh-agent.sock.$uid"

ssh_agent $symlink

#_ssh_agent_add_identities
