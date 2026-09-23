# Git-tag release for this config repo (no package manifest — plain
# Neovim config, not a PyPI/Docker project). No lint/test targets: there's
# no code here with runnable checks. Two independent tag lineages coexist
# on purpose: semantic vX.Y.Z tags and standalone corvid codenames (e.g.
# "raven") — `version`/`codename` report each separately since a plain
# `git describe` can't tell them apart.
#
# Usage:
#   make release                           # no TAG: just commit if dirty, push
#   make release TAG=v1.2.0                # commit if dirty, tag, push
#   make release TAG=raven                 # same, with a codename tag
#   make release TAG=v1.2.0 MSG="Add X"     # custom commit + tag message
#   make release TAG=v1.2.0                # TAG already exists: deletes it
#                                           # locally + on origin, re-tags HEAD
#   make version                           # print the latest vX.Y.Z tag
#   make codename                          # print the latest codename tag

MSG ?= $(if $(TAG),Release $(TAG),Update)
export TAG
export MSG

.PHONY: help release version codename

help:
	@printf '%s\n' 'Targets: release version codename'

version:
	@git describe --tags --abbrev=0 --match 'v*' 2>/dev/null || echo 'no version tags yet'

codename:
	@git describe --tags --abbrev=0 --exclude 'v*' 2>/dev/null || echo 'no codename tags yet'

# TAG is optional: without it, this just commits (if dirty) and pushes
# HEAD — no tag created. If TAG already exists (locally or on origin), it
# is deleted both places and recreated on the new HEAD — re-running
# release with the same TAG moves it forward rather than failing. TAG/MSG
# are passed through the environment ($$TAG/$$MSG) rather than substituted
# by Make ($(TAG)/$(MSG)) into the recipe text: a raw Make substitution
# lands inside the shell's command line unescaped, so a message containing
# backticks or $(...) would execute as a command. `--` stops git from
# reading a TAG starting with `-` as an option.
release:
	@if [ -n "$$(git status --porcelain)" ]; then \
		git add -A; \
		git commit -m "$$MSG"; \
	fi
	git push origin HEAD
	@if [ -n "$$TAG" ]; then \
		if git rev-parse "refs/tags/$$TAG" >/dev/null 2>&1; then \
			echo "release: tag $$TAG already exists, moving it to current HEAD" >&2; \
			git tag -d -- "$$TAG"; \
			git push origin --delete -- "$$TAG" 2>/dev/null || true; \
		fi; \
		git tag -a -m "$$MSG" -- "$$TAG"; \
		git push origin -- "$$TAG"; \
	fi
