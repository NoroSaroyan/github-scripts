#!/bin/bash

echo "GitHub Mass Publicizer Script"
read -rp "Enter your GitHub username: " USERNAME

if ! command -v gh &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: 'gh' and 'jq' must be installed."
    exit 1
fi

if ! gh auth status &>/dev/null; then
    echo "Logging in to GitHub..."
    gh auth login
fi

echo "Fetching private repositories for user '$USERNAME'..."
repos_json=$(gh repo list "$USERNAME" --visibility private --json name -L 100)

mapfile -t repos < <(echo "$repos_json" | jq -r '.[].name')

if [ ${#repos[@]} -eq 0 ]; then
    echo "No private repositories found."
    exit 0
fi

echo "Private repositories:"
for i in "${!repos[@]}"; do
    echo "$((i+1))) ${repos[$i]}"
done

echo
read -rp "Select repos to make public (e.g. 1,3,5-7 or 'all'): " selection

declare -A to_process

if [[ "$selection" == "all" ]]; then
    for i in "${!repos[@]}"; do
        to_process[$i]=1
    done
else
    IFS=',' read -ra parts <<< "$selection"
    for part in "${parts[@]}"; do
        if [[ "$part" =~ ^[0-9]+$ ]]; then
            idx=$((part-1))
            to_process[$idx]=1
        elif [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            start=${BASH_REMATCH[1]}
            end=${BASH_REMATCH[2]}
            for ((i=start; i<=end; i++)); do
                idx=$((i-1))
                to_process[$idx]=1
            done
        else
            echo "Invalid input segment: $part"
            exit 1
        fi
    done
fi

echo "Processing selected repositories..."

for idx in "${!to_process[@]}"; do
    repo="${repos[$idx]}"
    echo "Making $repo public..."
    gh repo edit "$USERNAME/$repo" --visibility public
done

echo "Done."
