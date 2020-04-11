
function ssh_agent_add_identities -d "Add identities"
    for identity in $argv
        if test -r $identity
            ssh-add -l | grep -q $identity
            or ssh-add $identity
        end
    end
end

