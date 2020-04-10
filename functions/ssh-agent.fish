
function _ssh_agent_update_link -a symlink -d "Update symlink and SSH_AUTH_SOCK."
    # Check if link is already up to date
    if test $SSH_AUTH_SOCK == $symlink
        return
    end

    # Create symlink
    ln -sf $SSH_AUTH_SOCK $symlink

    # Update SSH_AUTH_SOCK
    set --export SSH_AUTH_SOCK $symlink
end

function _ssh_agent_add_identities --inherit-variable identities -d "Add identities"
    for identity in $identities
        ssh-add $identity
    end
end

function _ssh_agent -a symlink -d "Check agent presence and connectivity, and start it if necessary."
    # Symlink seems alive, try to use it.
    if test -z "$SSH_AUTH_SOCK" -a -w $symlink
        set -x SSH_AUTH_SOCK $symlink
    end

    # Try to connect to the agent, test it
    if ssh-add -l &>/dev/null
        _ssh_agent_update_link $symlink
        return
    end

    # Agent is not responding, cleanup.
    set --unexport SSH_AUTH_SOCK
    set --unexport SSH_AGENT_PID
    rm -f $symlink

    # Start SSH agent
    eval (ssh-agent -c | sed '/^echo/d')

    _ssh_agent_update_link $symlink
end

set --local symlink "/tmp/ssh-agent-$USER.sock"

_ssh_agent $symlink
_ssh_agent_add_identities
