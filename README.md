# code-review-zsh

zsh code review plugin

### Usage

```
code-review [base_branch] [target_branch]
```

- `base_branch`: (default: $REVIEW_BASE_BRANCH, master)
- `target_branch`: (default: HEAD)

Launches `git difftool` on `git merge-base target_branch base_branch` and
`target_branch`.

### Install

#### Antibody

```
$ antibody bundle xorkevin/code-review-zsh
```

#### Manual

In `.zshrc`:

```
source code-review.plugin.zsh
```
