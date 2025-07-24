#!/bin/bash

DRY_RUN=false

echo "GitHub Mass Privatizer Script"
read -rp "Enter your GitHub username: " USERNAME

if ! command -v gh &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: 'gh' and 'jq' must be installed."
    exit 1
fi

if ! gh auth status &>/dev/null; then
    echo "Logging in to GitHub..."
    gh auth login
fi

echo "Fetching public repositories for user '$USERNAME'..."
repos_json=$(gh repo list "$USERNAME" --visibility public --json name -L 100)
readarray -t repos < <(echo "$repos_json" | jq -r '.[].name')

if [ ${#repos[@]} -eq 0 ]; then
    echo "No public repositories found."
    exit 0
fi

echo "Public repositories:"
for i in "${!repos[@]}"; do
    echo "$((i+1))) ${repos[$i]}"
done

echo
read -rp "Select repos to make private (e.g. 1,3,5-7 or 'all'): " selection

# Remove spaces from input
selection="${selection// /}"

# Build list of indices to process (simple array)
to_process=()

if [[ "$selection" == "all" ]]; then
    for i in "${!repos[@]}"; do
        to_process+=("$i")
    done
else
    IFS=',' read -ra parts <<< "$selection"
    for part in "${parts[@]}"; do
        if [[ "$part" =~ ^[0-9]+$ ]]; then
            idx=$((part-1))
            if (( idx < 0 || idx >= ${#repos[@]} )); then
                echo "Index $part is out of range, skipping."
                continue
            fi
            to_process+=("$idx")
        elif [[ "$part" =~ ^([0-9]+)-([0-9]+)$ ]]; then
            start=${BASH_REMATCH[1]}
            end=${BASH_REMATCH[2]}
            if (( start > end )); then
                echo "Invalid range: $part"
                exit 1
            fi
            for ((i=start; i<=end; i++)); do
                idx=$((i-1))
                if (( idx < 0 || idx >= ${#repos[@]} )); then
                    echo "Index $i is out of range, skipping."
                    continue
                fi
                to_process+=("$idx")
            done
        else
            echo "Invalid input segment: $part"
            exit 1
        fi
    done
fi

echo "Processing selected repositories..."

for idx in "${to_process[@]}"; do
    repo="${repos[$idx]}"
    echo "Making $repo private..."
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] Would make $repo private"
    else
        if ! gh repo edit "$USERNAME/$repo" --visibility private --accept-visibility-change-consequences; then
            echo "Failed to make $repo private"
        fi
    fi
done

echo "Done."
