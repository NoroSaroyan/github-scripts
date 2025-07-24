#!/bin/bash

read -rp "Enter GitHub username or organization: " OWNER

if ! command -v gh &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: gh and jq must be installed."
    exit 1
fi

if ! gh auth status &>/dev/null; then
    echo "Logging in to GitHub..."
    gh auth login
fi

all_repos=()
page=1
while :; do
    repos_json=$(gh repo list "$OWNER" --json name -L 100 --page "$page")
    count=$(echo "$repos_json" | jq 'length')
    if (( count == 0 )); then
        break
    fi
    for i in $(seq 0 $((count - 1))); do
        repo_name=$(echo "$repos_json" | jq -r ".[$i].name")
        all_repos+=("$repo_name")
    done
    ((page++))
done

echo "Repositories for $OWNER:"
for i in "${!all_repos[@]}"; do
    echo "$((i + 1))) ${all_repos[$i]}"
done

read -rp "Enter repo indexes or ranges separated by commas (e.g. 1,3-5): " selection

expand_selection() {
    local input=$1
    local result=()
    IFS=',' read -ra parts <<< "$input"
    for part in "${parts[@]}"; do
        if [[ "$part" =~ ^[0-9]+-[0-9]+$ ]]; then
            start=${part%-*}
            end=${part#*-}
            for ((j=start; j<=end; j++)); do
                result+=("$j")
            done
        else
            result+=("$part")
        fi
    done
    echo "${result[@]}"
}

selected_indexes=($(expand_selection "$selection"))

output_file="${OWNER}_selected_repos_report.csv"
echo "Name,Description,Languages,Stars,Forks,OpenIssues,OpenPRs,License,Archived,DefaultBranch,SizeMB,CreatedAt,UpdatedAt,IsFork,Topics,HasIssues" > "$output_file"

for idx in "${selected_indexes[@]}"; do
    repo_name="${all_repos[$((idx - 1))]}"
    if [[ -z "$repo_name" ]]; then
        echo "Skipping invalid index $idx"
        continue
    fi

    repo_json=$(gh repo view "$OWNER/$repo_name" --json name,description,stargazerCount,forkCount,openIssueCount,licenseInfo,archived,defaultBranchRef,size,createdAt,updatedAt,isFork,topics,hasIssuesEnabled)
    pr_count=$(gh pr list -R "$OWNER/$repo_name" --state open --json totalCount --jq '.totalCount')

    lang_json=$(gh api "repos/$OWNER/$repo_name/languages")
    languages=$(echo "$lang_json" | jq -r 'keys | join(",")')

    size_kb=$(echo "$repo_json" | jq -r '.size')
    size_mb=$(awk "BEGIN {printf \"%.2f\", $size_kb/1024}")

    description=$(echo "$repo_json" | jq -r '.description // ""' | sed 's/"/""/g')

    echo "\"$repo_name\",\"$description\",\"$languages\",$(echo "$repo_json" | jq '.stargazerCount'),$(echo "$repo_json" | jq '.forkCount'),$(echo "$repo_json" | jq '.openIssueCount'),$pr_count,\"$(echo "$repo_json" | jq -r '.licenseInfo.spdxId // ""')\",$(echo "$repo_json" | jq '.archived'),\"$(echo "$repo_json" | jq -r '.defaultBranchRef.name // ""')\",$size_mb,\"$(echo "$repo_json" | jq -r '.createdAt')\",\"$(echo "$repo_json" | jq -r '.updatedAt')\",$(echo "$repo_json" | jq '.isFork'),\"$(echo "$repo_json" | jq -r '.topics | join(",")')\",$(echo "$repo_json" | jq '.hasIssuesEnabled')" >> "$output_file"
done

echo "Report saved to $output_file"
