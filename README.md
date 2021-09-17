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

## Contributing

The carvel-release-scripts project team welcomes contributions from the community. Before you start working with carvel-release-scripts, please
read our [Developer Certificate of Origin](https://cla.vmware.com/dco). All contributions to this repository must be
signed as described on that page. Your signature certifies that you wrote the patch or have the right to pass it on
as an open-source patch. For more detailed information, refer to [CONTRIBUTING.md](CONTRIBUTING.md).