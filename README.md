# carvel-release-scripts

## Overview

carvel-release-scripts contains scripting assets related to distributing carvel's binaries to the various distribution channels. i.e. Homebrew, carvel.dev install.sh script etc.

- .github/ contains github action workflow files
- ./scripts/ contains scripts used by the github action in this repo
- releases.yaml contains all the tools shasums for the latest version (used on the generation of the install.sh)

## How can a tool start using this release process:
1. The following step need to be added to the current release-published.yml of the tools repository
   
for e.g.
```
- run: |
  curl -X POST https://api.github.com/repos/vmware-tanzu/carvel-release-scripts/dispatches \
  -H 'Accept: application/vnd.github.everest-preview+json' \
  -u ${{ secrets.ACCESS_TOKEN }} \
  --data '{"event_type": "<YourToolName>_released", "client_payload": { "tagName": "${{ github.event.release.tag_name }}", "repo": "${{ github.repository }}", "toolName": "<YourToolName>" }}'
```
Need to change in the above:
  - `ACCESS_TOKEN` this secret needs to be one the format username@accessToken and the user needs to have access to execute workflows in this repository
  - `<YourToolName>` should be replace with the tool name

## How can a new carvel tool start using this release process:
1. Enable in the tool the published workflow and add the [step in this question](#how-can-a-tool-start-using-this-release-process)
2. Edit `releases.yaml` and add the following entry to it:

```yaml
- product: YourProductName
```
3. Release the new tool on the tools Github Repository and the automation will start running

**Note:** This automated release process will make the tool installable via installation script from the website

## Start using the trivy scanning for CLI tools

### Pre-requirements
- The repository has a `./hack/build.sh` script that will build the binaries

### Steps
1. Create a secret named `SLACK_WEBHOOK_URL` that points to a slack webhook or slack workflow.
2. Create a new workflow that looks like this:
```yaml
name: Trivy CVE Dependency Scanner

on:
  schedule:
    - cron: '0 0 * * *'

jobs:
  trivy-scan:
    uses: vmware-tanzu/carvel-release-scripts/.github/workflows/trivy-scan.yml@main
    with:
      repo: vmware-tanzu/carvel-imgpkg
      tool: imgpkg
      goVersion: 1.17.0
    secrets:
      githubToken: ${{ secrets.GITHUB_TOKEN }}
      slackWebhookURL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## Contributing

The carvel-release-scripts project team welcomes contributions from the community. 
If you wish to contribute code and you have not signed our [contributor license agreement](https://cla.vmware.com/cla/1/preview), our bot will update the issue when you open a Pull Request. 
For any questions about the CLA process, please refer to our [FAQ](https://cla.vmware.com/faq).
