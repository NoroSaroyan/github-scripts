#!/bin/bash

echo "GitHub Archive Inactive Repos Script"
read -rp "Enter your GitHub username or organization: " OWNER
read -rp "Enter inactivity period in days (e.g., 180): " INACTIVE_DAYS

if ! command -v gh &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: 'gh' and 'jq' must be installed."
    exit 1
fi

if ! gh auth status &>/dev/null; then
    echo "Logging in to GitHub..."
    gh auth login
fi

cutoff_date=$(date -d "-$INACTIVE_DAYS days" +"%Y-%m-%dT%H:%M:%SZ")

repos_json=$(gh repo list "$OWNER" --json name,pushedAt -L 100)

mapfile -t inactive_repos < <(echo "$repos_json" | jq -r --arg cutoff "$cutoff_date" '.[] | select(.pushedAt < $cutoff) | .name')

if [ ${#inactive_repos[@]} -eq 0 ]; then
    echo "No inactive repositories found for the given period."
    exit 0
fi

echo "Inactive repositories (no pushes since $cutoff_date):"
for i in "${!inactive_repos[@]}"; do
    echo "$((i+1))) ${inactive_repos[$i]}"
done

read -rp "Select repos to archive (e.g. 1,3,5-7 or 'all'): " selection

declare -A to_process

if [[ "$selection" == "all" ]]; then
    for i in "${!inactive_repos[@]}"; do
        to_process[$i]=1
    done
else
    IFS=',' read -ra parts <<< "$selection"
    for part in "${parts[@]}"; do
        if [[ "$part" =~ ^[0-9]+$ ]]; then
            idx=$((part-1))
            if (( idx < 0 || idx >= ${#inactive_repos[@]} )); then
                echo "Index $part is out of range."
                exit 1
            fi
            to_process[$idx]=1
        elif [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            start=${BASH_REMATCH[1]}
            end=${BASH_REMATCH[2]}
            if (( start < 1 || end > ${#inactive_repos[@]} || start > end )); then
                echo "Invalid range $part."
                exit 1
            fi
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

for idx in "${!to_process[@]}"; do
    repo="${inactive_repos[$idx]}"
    echo "Archiving $repo..."
    gh repo archive "$OWNER/$repo"
done

echo "Done."
