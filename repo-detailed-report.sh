#!/bin/bash

read -rp "Enter full repo name (owner/repo): " REPO

if ! command -v gh &>/dev/null || ! command -v jq &>/dev/null; then
    echo "Error: gh and jq must be installed."
    exit 1
fi

if ! gh auth status &>/dev/null; then
    echo "Logging in to GitHub..."
    gh auth login
fi

output_file="${REPO//\//_}_detailed_report.csv"

echo "Field,Value" > "$output_file"

repo_json=$(gh repo view "$REPO" --json name,description,licenseInfo,defaultBranchRef,archived,isFork,size,createdAt,updatedAt,topics,hasIssuesEnabled,hasWikiEnabled,hasProjectsEnabled,stargazerCount,forkCount,openIssueCount,openPullRequestsCount,watchers,homepageUrl,isTemplate,subscribersCount,securityPolicy -q '.')

languages_json=$(gh api "repos/$REPO/languages")
languages=$(echo "$languages_json" | jq -r 'to_entries | map("\(.key): \(.value) bytes") | join(", ")')

security_policy=$(echo "$repo_json" | jq -r '.securityPolicy != null')

declare -A fields

fields["Name"]=$(echo "$repo_json" | jq -r '.name')
fields["Description"]=$(echo "$repo_json" | jq -r '.description // ""' | sed 's/"/""/g')
fields["License"]=$(echo "$repo_json" | jq -r '.licenseInfo.spdxId // ""')
fields["Default Branch"]=$(echo "$repo_json" | jq -r '.defaultBranchRef.name // ""')
fields["Archived"]=$(echo "$repo_json" | jq -r '.archived')
fields["Is Fork"]=$(echo "$repo_json" | jq -r '.isFork')
fields["Size (KB)"]=$(echo "$repo_json" | jq -r '.size')
fields["Created At"]=$(echo "$repo_json" | jq -r '.createdAt')
fields["Updated At"]=$(echo "$repo_json" | jq -r '.updatedAt')
fields["Topics"]=$(echo "$repo_json" | jq -r '.topics | join(",")')
fields["Has Issues Enabled"]=$(echo "$repo_json" | jq -r '.hasIssuesEnabled')
fields["Has Wiki Enabled"]=$(echo "$repo_json" | jq -r '.hasWikiEnabled')
fields["Has Projects Enabled"]=$(echo "$repo_json" | jq -r '.hasProjectsEnabled')
fields["Stars"]=$(echo "$repo_json" | jq -r '.stargazerCount')
fields["Forks"]=$(echo "$repo_json" | jq -r '.forkCount')
fields["Open Issues"]=$(echo "$repo_json" | jq -r '.openIssueCount')
fields["Open Pull Requests"]=$(echo "$repo_json" | jq -r '.openPullRequestsCount')
fields["Watchers"]=$(echo "$repo_json" | jq -r '.watchers')
fields["Subscribers"]=$(echo "$repo_json" | jq -r '.subscribersCount')
fields["Is Template"]=$(echo "$repo_json" | jq -r '.isTemplate')
fields["Homepage URL"]=$(echo "$repo_json" | jq -r '.homepageUrl // ""')
fields["Security Policy Exists"]=$security_policy
fields["Languages"]="$languages"

for key in "${!fields[@]}"; do
    echo "\"$key\",\"${fields[$key]}\"" >> "$output_file"
done

echo "Detailed report saved to $output_file"
