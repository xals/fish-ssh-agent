function _ssh_agent_update_link -a symlink -d "Update symlink and SSH_AUTH_SOCK."
    # Check if link is already up to date
    if test $SSH_AUTH_SOCK = $symlink
        return
    end

    # Create symlink
    ln -sf $SSH_AUTH_SOCK $symlink

    # Update SSH_AUTH_SOCK
    set --erase --global SSH_AUTH_SOCK
    set --export --universal SSH_AUTH_SOCK $symlink
end

function ssh_agent -d "Check agent presence and connectivity, and start it if necessary."
    # Define link path
    set --local uid (id -u)
    set --local symlink "/tmp/ssh-agent.sock.$uid"

    # Symlink seems alive, try to use it.
    if test -z "$SSH_AUTH_SOCK" -a -w $symlink
        set -x --universal SSH_AUTH_SOCK $symlink
    end

    # Try to connect to the agent, test it
    if ssh-add -l >/dev/null
        _ssh_agent_update_link $symlink
        return
    end

    # Agent is not responding, cleanup.
    set --unexport --universal SSH_AUTH_SOCK
    set --unexport --universal SSH_AGENT_PID
    rm -f $symlink

    # Start SSH agent
    eval (ssh-agent -c | sed '/^echo/d')

    _ssh_agent_update_link $symlink
end
