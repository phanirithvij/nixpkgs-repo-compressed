#!/usr/bin/env bash

set -x

# https://stackoverflow.com/a/51468389

REMOTE=origin
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BATCH_SIZE=100000

git show HEAD

# Just mirror if bare git repo is less than 2GB limit
# https://docs.github.com/en/get-started/using-git/troubleshooting-the-2-gb-push-limit
if [ "$(du -sb | awk '{printf $1}')" -le 2000000000 ]; then
        git push $REMOTE --mirror
        exit 0
fi

BRANCHES="$(git branch --remotes | grep origin/ | grep -v '\->')"
for BRANCH in $BRANCHES; do
        git update-ref "refs/heads/${BRANCH#origin/}" "$(git rev-parse "$BRANCH")"
        git pack-refs --all
done

BRANCH=$(git rev-parse --abbrev-ref HEAD)

# check if the branch exists on the remote
if git show-ref --quiet --verify "refs/remotes/$REMOTE/$BRANCH"; then
        # if so, only push the commits that are not on the remote already
        range=$REMOTE/$BRANCH..HEAD
else
        # else push all the commits
        range=HEAD
fi

# count the number of commits to push
n=$(git log --first-parent --format=format:x "$range" | wc -l)

# push each batch
for i in $(seq "$n" -$BATCH_SIZE 1); do
        # get the hash of the commit to push
        h=$(git log --first-parent --reverse --format=format:%H --skip "$i" -n1)
        echo "Pushing $h..."
        git push $REMOTE "${h}:refs/heads/$BRANCH"
done

# push the final partial batch
git push $REMOTE "HEAD:refs/heads/$BRANCH"

# push the all revs
git push --prune
git push --tags
git push $REMOTE '+refs/*:refs/*'
