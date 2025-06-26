STATUS: WIP

## WHY

- A nixpkgs git repo clone as of 2025-july is ~5GB and took around 20mins to
  clone
- This repo is the nixpkgs repo mirrored with compression done beforehand so it
  is ~1GB as of 2025-july and took around 9mins to clone.

- Command to compress is `git repack -adf --window=250` From
  https://discourse.nixos.org/t/how-we-shrunk-our-javascript-monorepo-git-size-by-94/55041

This nixpkgs-compressed repo is for testing purposes. And will be deleted after
that.

## TODO

- Keep it both compressed and up-to-date via some gha
- git clone --mirror

### Resources

- https://stackoverflow.com/questions/6150188/how-to-update-a-git-clone-mirror
- https://stackoverflow.com/questions/3959924/whats-the-difference-between-git-clone-mirror-and-git-clone-bare
- https://stackoverflow.com/questions/64981184/would-git-remote-add-mirror-fetch-make-same-repo-with-git-clone-mirror
- https://stackoverflow.com/questions/2199897/how-to-convert-a-normal-git-repository-to-a-bare-one/2199939#2199939

- best option is for github to run it on nixos/nixpkgs along with many other
  huge repos they might be hosting.

- might need to delete it and recreate once in a while to kill accumulated
  cruft.
- git clone --bare and editing git config to include `refs/heads/*:refs/heads/*`
  and `refs/tags/*:refs/tags/*` along with any other refs (e.g. git-bug,
  git-appraise, git-review etc.) except `refs/pull` and `refs/pulls`
  - because these cannot be pushed to the new repo, github rejects these refs
  - so best not to use git clone --mirror or use it by filtering out pulls
  - https://stackoverflow.com/questions/47776357/git-push-mirror-without-pull-refs
- https://christoph.ruegg.name/blog/git-howto-mirror-a-github-repository-without-pull-refs
