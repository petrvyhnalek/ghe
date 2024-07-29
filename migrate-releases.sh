#!/bin/bash

# Set variables
GITHUB_COM_TOKEN=${GHCOM_TOKEN_PVS1}
GITHUB_ENTERPRISE_TOKEN=${GHE_TOKEN_DEV_PVS1}
SOURCE_REPO="sentinel-one/agent-communicator"
#TARGET_REPO="owner/target-repo"
TARGET_REPO=$SOURCE_REPO
GITHUB_COM_API="https://api.github.com"
GITHUB_ENTERPRISE_API="https://ghe-dev-001.eng.sentinelone.tech/api/v3"

echo $GITHUB_COM_TOKEN
echo $GITHUB_ENTERPRISE_TOKEN

# Fetch releases from GitHub.com
releases=$(curl -s -H "Authorization: token $GITHUB_COM_TOKEN" "$GITHUB_COM_API/repos/$SOURCE_REPO/releases")

echo $releases
exit 0

# Loop through each release and create it on GitHub Enterprise
echo "$releases" | jq -c '.[]' | while read -r release; do
  tag_name=$(echo "$release" | jq -r '.tag_name')
  name=$(echo "$release" | jq -r '.name')
  body=$(echo "$release" | jq -r '.body')
  draft=$(echo "$release" | jq -r '.draft')
  prerelease=$(echo "$release" | jq -r '.prerelease')

  # Create release on GitHub Enterprise
#  curl -s -H "Authorization: token $GITHUB_ENTERPRISE_TOKEN" \
#       -H "Content-Type: application/json" \
#       -d "$(jq -n --arg tag_name "$tag_name" --arg name "$name" --arg body "$body" --argjson draft "$draft" --argjson prerelease "$prerelease" \
#       '{tag_name: $tag_name, name: $name, body: $body, draft: $draft, prerelease: $prerelease}')" \
#       "$GITHUB_ENTERPRISE_API/repos/$TARGET_REPO/releases"
  data_pv="$(jq -n --arg tag_name "$tag_name" --arg name "$name" --arg body "$body" --argjson draft "$draft" --argjson prerelease "$prerelease" \
                 '{tag_name: $tag_name, name: $name, body: $body, draft: $draft, prerelease: $prerelease}')"
  echo $data_pv
  echo "\n"
done