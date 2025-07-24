#!/bin/bash

if ! command -v gh &>/dev/null || ! command -v jq &>/dev/null; then
  echo "Please install 'gh' CLI and 'jq' to run this script."
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo "Please login to GitHub CLI:"
  gh auth login || exit 1
fi

read -rp "Enter GitHub username or organization: " OWNER

all_repos=()
page=1
while :; do
  repos_json=$(gh repo list "$OWNER" --json name -L 100 --page "$page" 2>/dev/null)
  count=$(echo "$repos_json" | jq 'length')
  ((count == 0)) && break
  for i in $(seq 0 $((count - 1))); do
    all_repos+=("$(echo "$repos_json" | jq -r ".[$i].name")")
  done
  ((page++))
done

if [ ${#all_repos[@]} -eq 0 ]; then
  echo "No repositories found for user/org '$OWNER'."
  exit 1
fi

echo "Repositories for $OWNER:"
for i in "${!all_repos[@]}"; do
  echo "$((i+1))) ${all_repos[i]}"
done

read -rp "Enter repo indexes or ranges separated by commas (e.g. 1,3-5): " selection

expand_selection() {
  local input=$1
  local result=()
  IFS=',' read -ra parts <<< "$input"
  for part in "${parts[@]}"; do
    if [[ $part =~ ^[0-9]+-[0-9]+$ ]]; then
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

read -rp "Choose time range in days (default 7): " days
days=${days:-7}

read -rp "Choose output format (md/csv, default md): " format
format=${format:-md}

since_date=$(date -u -d "-$days days" +%Y-%m-%dT%H:%M:%SZ)

print_header() {
  if [[ $format == "csv" ]]; then
    echo "Repo,Commits,PRs Opened,PRs Merged,PRs Closed,Issues Opened,Issues Closed"
  else
    echo "| Repo | Commits | PRs Opened | PRs Merged | PRs Closed | Issues Opened | Issues Closed |"
    echo "|------|---------|------------|------------|------------|--------------|--------------|"
  fi
}

print_line() {
  local repo=$1
  local commits=$2
  local prs_opened=$3
  local prs_merged=$4
  local prs_closed=$5
  local issues_opened=$6
  local issues_closed=$7

  if [[ $format == "csv" ]]; then
    echo "\"$repo\",$commits,$prs_opened,$prs_merged,$prs_closed,$issues_opened,$issues_closed"
  else
    echo "| $repo | $commits | $prs_opened | $prs_merged | $prs_closed | $issues_opened | $issues_closed |"
  fi
}

get_commit_count() {
  local repo=$1
  local count=0

  local response_headers
  response_headers=$(gh api -I "repos/$repo/commits?since=$since_date&per_page=1" 2>/dev/null)
  local link_header
  link_header=$(echo "$response_headers" | grep -i '^link:' || echo "")

  if [[ $link_header =~ page=([0-9]+)>; rel=\"last\" ]]; then
    count="${BASH_REMATCH[1]}"
  else
    count=$(gh api "repos/$repo/commits?since=$since_date" --jq 'length' 2>/dev/null || echo 0)
  fi

  echo "$count"
}

print_header > /tmp/report_output.$$ 

for idx in "${selected_indexes[@]}"; do
  repo_name="${all_repos[$((idx - 1))]}"
  if [[ -z "$repo_name" ]]; then
    echo "Skipping invalid index $idx" >&2
    continue
  fi
  full_repo="$OWNER/$repo_name"

  commits=$(get_commit_count "$full_repo")
  prs_opened=$(gh pr list -R "$full_repo" --state open --search "created:>=$since_date" --json totalCount --jq '.totalCount' 2>/dev/null || echo 0)
  prs_closed=$(gh pr list -R "$full_repo" --state closed --search "closed:>=$since_date" --json totalCount --jq '.totalCount' 2>/dev/null || echo 0)
  prs_merged=$(gh pr list -R "$full_repo" --state closed --search "merged:>=$since_date" --json totalCount --jq '.totalCount' 2>/dev/null || echo 0)

  issues_opened=$(gh issue list -R "$full_repo" --state open --search "created:>=$since_date" --json totalCount --jq '.totalCount' 2>/dev/null || echo 0)
  issues_closed=$(gh issue list -R "$full_repo" --state closed --search "closed:>=$since_date" --json totalCount --jq '.totalCount' 2>/dev/null || echo 0)

  print_line "$repo_name" "$commits" "$prs_opened" "$prs_merged" "$prs_closed" "$issues_opened" "$issues_closed" >> /tmp/report_output.$$
done

echo
read -rp "Save output to file? (y/n, default n): " save
save=${save:-n}

if [[ $save == [yY] ]]; then
  read -rp "Enter output filename (e.g. report.md or report.csv): " filename
  if [[ -z "$filename" ]]; then
    echo "Invalid filename. Outputting to console instead."
    cat /tmp/report_output.$$
  else
    mv /tmp/report_output.$$ "$filename"
    echo "Report saved to $filename"
  fi
else
  cat /tmp/report_output.$$
  rm /tmp/report_output.$$
fi
