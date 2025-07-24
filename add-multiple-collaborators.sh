#!/bin/bash

read -rp "Enter the full repository name (owner/repo): " REPO
read -rp "Enter collaborators (comma-separated usernames or path to file): " INPUT
read -rp "Enter permission level (pull/push/admin), default 'push': " PERM
PERM=${PERM:-push}

if ! command -v gh &>/dev/null; then
    echo "gh CLI not found."
    exit 1
fi

if [[ -f "$INPUT" ]]; then
    mapfile -t COLLABS < "$INPUT"
else
    IFS=',' read -ra COLLABS <<< "$INPUT"
fi

for user in "${COLLABS[@]}"; do
    user=$(echo "$user" | xargs)
    if [[ -z "$user" ]]; then
        continue
    fi
    echo "Adding $user to $REPO with $PERM permission..."
    gh api --method PUT "/repos/$REPO/collaborators/$user" -f permission="$PERM"
done

echo "Done."
