
function _ssh_agent_update_link -a symlink -d "Update symlink and SSH_AUTH_SOCK."
    # Check if link is already up to date
    if test $SSH_AUTH_SOCK == $symlink
        echo "Auth Sock is symlink"
        return
    end

    echo "Create symlink: $symlink"
    # Create symlink
    ln -sf $SSH_AUTH_SOCK $symlink

    echo "export ssh auth sock"
    # Update SSH_AUTH_SOCK
    set --export SSH_AUTH_SOCK $symlink
end

function _ssh_agent_add_identities --inherit-variable identities -d "Add identities"
    echo "add identities"
    for identity in $identities
        echo "add identity $identity"
        ssh-add $identity
    end
end

function _ssh_agent -a symlink -d "Check agent presence and connectivity, and start it if necessary."
    echo "_ssh_agent"
    # Symlink seems alive, try to use it.
    if test -z "$SSH_AUTH_SOCK" -a -w $symlink
        echo "Set ssh auth sock to $symlink."
        set -x SSH_AUTH_SOCK $symlink
    end

    # Try to connect to the agent, test it
    if ssh-add -l &>/dev/null
        echo "agent is alive, update link."
        _ssh_agent_update_link $symlink
        return
    end

    echo "cleanup."
    # Agent is not responding, cleanup.
    set --unexport SSH_AUTH_SOCK
    set --unexport SSH_AGENT_PID
    rm -f $symlink

    echo "Run agent"
    # Start SSH agent
    eval (ssh-agent -c | sed '/^echo/d')

    echo "update symlink (2)"
    _ssh_agent_update_link $symlink
end

echo "set symlink"
set --local symlink "/tmp/ssh-agent-$USER.sock"

echo "call _ssh_agent"
_ssh_agent $symlink

echo "call _ssh_agent_add_identities"
_ssh_agent_add_identities
