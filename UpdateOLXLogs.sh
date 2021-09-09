#!/usr/bin/env bash

# repo_uri="https://amjithtitus09:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
repo_uri="https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
remote_name="origin"
main_branch="master"
target_branch="master"

cd "$GITHUB_WORKSPACE"

git config user.name "$GITHUB_ACTOR"
git config user.email "${GITHUB_ACTOR}@bots.github.com"

echo "Before checkout"
git checkout "$target_branch"
echo "Before rebase"
echo "$GITHUB_ACTOR"
echo "${remote_name}/${main_branch}"
git rebase "${remote_name}/${main_branch}"
echo "Before OLX_crawler"

# chmod +x scrape && ./scrape
python OLX_crawler.py
echo "Before add"

git add ad_id_list.txt
echo "After add"

set +e 
git status | grep 'new file\|modified'
if [ $? -eq 0 ]
then
    set -e
    git commit -am "OLX data updated on - $(TZ=":Asia/Kolkata" date)"
    git remote set-url "$remote_name" "$repo_uri"
    git push --force-with-lease "$remote_name" "$target_branch"
else
    set -e
    echo "no changes since last run"
fi
