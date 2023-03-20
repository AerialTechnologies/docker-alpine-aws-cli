# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2023-03-20

### Added

- Helm cli tool
- Helm S3 plugin
- CHANGELOG.md

### Changed

- Upgraded AWS-CLI to version 2
- Upgrade alpine base version to 3.17
- Accept alpine version as build argument
- Dockerfile layout to mustistage to raduce final image size

### Removed

- Unused toos (python, jq, npm, less, bash)

## [1.0.0] - 2010-10-23

### Added

- Merge pull request #5 from kritchie/f/update-alpine
- Update alpine and AWS cli to latest versions
- Merge pull request #4 from kritchie/master
- Add installation for groff & less to fix aws cli dependencies
- Merge pull request #3 from kritchie/master
- Update alpine and aws-cli to current latest
- Merge pull request #2 from sportebois/master
- Add curl, npm, yarn and node in the toolkit
- Merge pull request #1 from sportebois/master
- Add README
- Add Dockerfile for AWS CLI v1.15.40
- Fix gitignore fuckery
- Add initial gitignore
