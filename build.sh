version=$(cat `pwd`/package.json | json version)
name=$(cat `pwd`/package.json | json name)
org=$(cat `pwd`/package.json | json organisation)
tag=$1

set -e

active=$(docker-machine active)

isSwarm=$(docker-machine inspect $active | json HostOptions.SwarmOptions.IsSwarm)

if [[ "true" == "$isSwarm" ]]
then
  chalk -t "{red Attempt to build on swarm.} Switch to {bold dev machine} to build."
  exit 1
fi

chalk -t "Building {green $org/$name:{bold $tag}} version {blue.bold $version} using {blue.bold $active} docker machine"

docker build -t $org/$name:$1 \
  --label "version=$version" \
  --label "commit-msg=`git log -1 --pretty=%s`" \
  --label "commit-sha=`git rev-parse --short HEAD`" \
  --label "commit-author=`git log -1 --pretty='%an <%ae>'`" \
  --label "release-date=`date -u '+%Y-%m-%d %H:%M %Z'`" \
  --label "released-by=`git config --get user.name`" \
  `pwd`

