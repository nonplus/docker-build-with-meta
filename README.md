## Docker build with meta

This package builds `docker build ` command using meta info from git:

- last commit sha
- last commit message
- last commit author
- git user name

## Usage

Run in directory with package.json and .git

```
docker-build-with-meta latest
```

The package.json file must include name, version and organisation keys on top level.

Example of `psFormat` for `~/.docker/config.json`:

```
    "psFormat": "table {{.Label \"com.docker.compose.service\"}}\t{{.Label \"version\"}}\t{{.Label \"release-date\"}}\t{{.Status}}\t{{.Label \"commit-sha\"}}\t{{.Label \"released-by\"}}",
```

## LICENSE

MIT

