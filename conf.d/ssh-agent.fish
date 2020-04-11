# Check if started

# Symlink is /tmp/ssh-agent-$USER.sock

set --global identities $HOME/.ssh/id_rsa

set --local uid (id -u)
set --local symlink "/tmp/ssh-agent.sock.$uid"

_ssh_agent $symlink

_ssh_agent_add_identities
