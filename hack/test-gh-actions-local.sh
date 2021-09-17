#!/bin/bash

set -xeu

# TODO: Add Install instructions act via https://github.com/nektos/act

# SECRETS:
# CARVEL_RELEASE_SCRIPTS_PAT / Push access to vmware-tanzu/carvel-release-scripts

docker run --rm -P --name=local-artifact-server -d --entrypoint=sh mkenney/npm -c "
git clone https://github.com/DennisDenuto/artifact-server
cd artifact-server
npm install
export AUTH_KEY=foo
npm run start
"

function stop-local-artifact-server() {
    docker kill local-artifact-server
}

trap stop-local-artifact-server EXIT

local_artifact_server_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' local-artifact-server)

# https://docs.github.com/en/developers/webhooks-and-events/webhooks/webhook-events-and-payloads
act push -e <(cat <<EOF
{
  "push": {
      "ref": "refs/tags/v0.0.0"
  }
}
EOF
) --job imgpkg --env ACTIONS_RUNTIME_TOKEN=foo --env ACTIONS_RUNTIME_URL=http://${local_artifact_server_ip}:8080/