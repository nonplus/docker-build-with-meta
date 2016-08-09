#!/bin/bash

version=$(cat `pwd`/package.json | json version)
name=$(cat `pwd`/package.json | json name)
org=$(cat `pwd`/package.json | json organisation)
alias=""
tag=latest
publish=0

usage() {

cat << EOF
Usage: docker-build-with-meta -t latest -n projectname -p

Build docker image using meta information from git and package.json and
optionally publish to docker hub registry.

All arguments are optional:

  -n PROJECT project name (default to what specified in package.json)
  -t TAG     project tag (default to latest)
  -a ALIAS   alias tag (docker tag :tag :alias)
  -p         whether publish to registry (not published when omitted)
  -h         display usage info

EOF

}

while getopts "a:hpt:n:" opt; do
  case $opt in
    a)
      alias=$OPTARG
      ;;
    n)
      name=$OPTARG
      ;;
    t)
      tag=$OPTARG
      ;;
    p)
      publish=1
      ;;
    h)
      usage >&2
      exit 1
  esac
done

active=$(docker-machine active)
activeResult=$!;

if [[ ! -z $activeResult ]]; then
  isSwarm=$(docker-machine inspect $active | json HostOptions.SwarmOptions.IsSwarm)

  if [[ "true" == "$isSwarm" ]]
  then
    chalk -t "{red Attempt to build on swarm.} Switch to {bold dev machine} to build."
      exit 1
  fi
else
  osType=$(uname -s);
  if [[ ! "$osType" == "Linux" ]]; then
    chalk -t "{red No active host found.} Switch to {bold dev machine} to build."
    exit 1
  fi
fi

set -e

chalk -t "Building {green $org/$name:{bold $tag}} version {blue.bold $version} using {blue.bold $active} docker machine"

docker build -t $org/$name:$tag \
  --label "version=$version" \
  --label "project=$name" \
  --label "commit-msg=`git log -1 --pretty=%s`" \
  --label "commit-sha=`git rev-parse --short HEAD`" \
  --label "commit-author=`git log -1 --pretty='%an <%ae>'`" \
  --label "release-date=`date -u '+%Y-%m-%d %H:%M %Z'`" \
  --label "released-by=`git config --get user.name`" \
  `pwd`

if [[ "$publish" == "1" ]]
then
  echo ""
  chalk -t "{red Publishing {green $org/$name{bold :$tag}} image to registry}"
  docker push $org/$name:$tag
fi

if [[ ! -z $alias ]]
then
  echo ""
  chalk -t "{red Tagging image {green $org/$name{bold :$tag}} as {green.bold :$alias}}"
  docker tag $org/$name:$tag $org/$name:$alias

  if [[ "$publish" == "1" ]]
  then
    docker push $org/$name:$alias
  fi

fi

