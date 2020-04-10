# Check if started

# Symlink is /tmp/ssh-agent-$USER.sock

set --local symlink "/tmp/ssh-agent-$USER.sock"

_ssh_agent

set --local identities $HOME/.ssh/xals.rsa $HOME/.ssh/HOME/.ssh/xals-old.rsa $HOME/.ssh/alexis@sysnove.fr

_ssh_agent_add_identities $identities
