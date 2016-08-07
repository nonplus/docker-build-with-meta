## Docker build with meta

This package builds `docker build ` command using meta info from git:

- last commit sha
- last commit message
- last commit author
- git user name

## Installation

Add to project's dev dependencies

```
npm i -D dokcer-build-with-meta
```

Use as part of build process (add to "scripts" section in package.json):

```
    ...
    "postbuild": "docker-build-with-meta -t latest -p",
    ...
```

## Usage

Run in directory with package.json and .git

```
docker-build-with-meta -t latest -n projectname -p
```

all arguments are optional:

```
  -t project tag (default to latest)
  -n project name (default to what specified in package.json)
  -p whether publish to registry (not published when omitted)
  -h usage info
```

The package.json file must include name, version and organisation keys on top level.

Example of `psFormat` for `~/.docker/config.json`:

```
    "psFormat": "table {{.Label \"com.docker.compose.service\"}}\t{{.Label \"version\"}}\t{{.Label \"release-date\"}}\t{{.Status}}\t{{.Label \"commit-sha\"}}\t{{.Label \"released-by\"}}",
```

## LICENSE

MIT

