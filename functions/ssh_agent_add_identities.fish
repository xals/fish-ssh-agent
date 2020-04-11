
function ssh_agent_add_identities -d "Add identities"
    for identity in $argv
        ssh-add -l | grep $identity
        or ssh-add $identity
    end
end

