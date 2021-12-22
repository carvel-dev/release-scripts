# carvel-release-scripts

## Overview

carvel-release-scripts contains scripting assets related to distributing carvel's binaries to the various distribution channels. i.e. Homebrew, carvel.dev install.sh script etc.

- ./hack/ contains scripts/assets for developers maintaining this repo
- .github/ contains github action workflow files
- ./scripts/ contains scripts used by the github action in this repo
- ./releases/ contains release metadata for each of the carvel tools. This metadata is used when generating downstream release files. i.e. used to generate a Homebrew formula file.

## Adding a new product requires adding a github action workflow file:
1. Add a release directory and add a seed release file containing the latest release information
   
for e.g.
```
mkdir releases/tool-name-goes-here
cp releases/imgpkg/0.17.0.yml releases/tool-name-goes-here/v?.?.?.yml
# Modify the release file to contain correct details for the tool being added
```

2. Generate github action workflow file
```bash
./hack/generate-gh-action-workflows.sh tool-name-goes-here
```

for e.g.

```bash
./hack/generate-gh-action-workflows.sh imgpkg
```

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
      goVersion: 1.17.0 # This field is optional and will default to 1.17.0
```

## Contributing

The carvel-release-scripts project team welcomes contributions from the community. 
If you wish to contribute code and you have not signed our [contributor license agreement](https://cla.vmware.com/cla/1/preview), our bot will update the issue when you open a Pull Request. 
For any questions about the CLA process, please refer to our [FAQ](https://cla.vmware.com/faq).
