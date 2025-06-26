[![full nixpkgs repo size](https://img.shields.io/github/repo-size/nixos/nixpkgs?style=for-the-badge&label=nixpkgs)](https://github.com/nixos/nixpkgs)
[![compressed repo size](https://img.shields.io/github/repo-size/phanirithvij/nixpkgs-compressed?style=for-the-badge&label=compressed)](https://github.com/phanirithvij/nixpkgs-compressed)

STATUS: WIP | EXPERIMENTAL

> [!WARNING]
> Github may ban legitimate accounts because of using too much space. In this
> case, mirroring huge repositories instead of forking. The author of this
> program cannot be held responsible if your github account gets banned. YOU
> HAVE BEEN WARNED.

> [!WARNING]
> The nixpkgs-compressed repo is for testing purposes. And WILL be deleted
> without notice. If you are not @phanirithvij and find this useful, hard fork
> this repo and adapt.

## WHY

- https://discourse.nixos.org/t/how-we-shrunk-our-javascript-monorepo-git-size-by-94/55041
- A nixpkgs git repo clone as of 2025-july is ~5GB and took around 20mins to
  clone
- This repo creates a nixpkgs mirror with git pack compression done beforehand
  (~1.3GB) as of 2025-july and took around 6mins to clone.
- Ideal option is for github to run it on nixos/nixpkgs along with many other
  huge repos they might be hosting. Until that happens this is marginally useful

This can only be useful if

- can't afford to clone nixos/nixpkgs
- need a full git history of nixpkgs i.e. shallow clones are not an option
- repo can be a bit behind nixos/nixpkgs
- can't afford to keep nixos/nixpkgs in gha cache (actions/cache)

### commands

```bash
# to get a quick nixpkgs update
gh workflow run create.yml -f skip_repack=true
# to get a slow compressed nixpkgs update
gh workflow run create.yml -f skip_repack=true
# WIP, buggy for now
gh workflow run create.yml -f repo_name=linux-cmp -f origin_repo="https://github.com/torvalds/linux" -f skip_repack=true
# bigger repo
gh workflow run create.yml -f repo_name=aosp-cmp -f origin_repo="https://github.com/aosp-mirror/platform_frameworks_base"
# home-manager
gh workflow run create.yml -f repo_name=home-manager-compressed -f origin_repo="https://github.com/nix-community/home-manager"
# small test repo
gh repo delete ghtmpcli
# create repo
gh repo create --public linux-cmp
```

## TODO

- Keep it both compressed and up-to-date via some gha
- might need to delete it and recreate once in a while to kill accumulated
  cruft.
- bunch of json files per repo to use with `gh workflow run`
- doesn't work properly for torvalds/linux

### Resources/Notes

- https://stackoverflow.com/q/6150188
- https://stackoverflow.com/q/2199897
- https://stackoverflow.com/q/64981184
- https://christoph.ruegg.name/blog/git-howto-mirror-a-github-repository-without-pull-refs
- git clone --mirror doesn't work
  - git clone --bare and editing git config to include
    `refs/heads/*:refs/heads/*` and `refs/tags/*:refs/tags/*` along with any
    other refs (e.g. git-bug, git-appraise, git-review etc.) except
    `refs/pull/*` (`refs/pulls` ?)
  - github rejects these `refs/pull/*`
  - best not to use git clone --mirror but --bare
    - diff b/w mirror and bare https://stackoverflow.com/q/3959924
  - https://stackoverflow.com/a/78540430
- git push --mirror doesn't work, need to push refs in batches, see
  [.github/workflows/scripts/git-push-chunked.sh](.github/workflows/scripts/git-push-chunked.sh)
  from https://stackoverflow.com/a/51468389
