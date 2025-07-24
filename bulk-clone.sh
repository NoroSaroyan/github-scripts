#!/bin/bash

echo "GitHub Bulk Clone Script"
read -rp "Enter GitHub username or organization: " OWNER

if ! command -v gh &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: 'gh' and 'jq' must be installed."
    exit 1
fi

if ! gh auth status &>/dev/null; then
    echo "Logging in to GitHub..."
    gh auth login
fi

read -rp "Clone using SSH or HTTPS? (ssh/https): " protocol
protocol=${protocol,,}
if [[ "$protocol" != "ssh" && "$protocol" != "https" ]]; then
    echo "Invalid option, defaulting to SSH."
    protocol="ssh"
fi

repos_json=$(gh repo list "$OWNER" --visibility public --json name,sshUrl,url -L 100)

mapfile -t repos < <(echo "$repos_json" | jq -r '.[].name')

if [ ${#repos[@]} -eq 0 ]; then
    echo "No public repositories found for $OWNER."
    exit 0
fi

echo "Public repositories:"
for i in "${!repos[@]}"; do
    echo "$((i+1))) ${repos[$i]}"
done

read -rp "Select repos to clone (e.g. 1,3,5-7 or 'all'): " selection

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
            if (( idx < 0 || idx >= ${#repos[@]} )); then
                echo "Index $part is out of range."
