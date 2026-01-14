#!/bin/bash

# OCP Opal Tool Template Setup Script
# Replaces placeholders in template files with values from template-vars.json

set -e

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Install with: brew install jq"
    exit 1
fi

# Check if template-vars.json exists
if [ ! -f "template-vars.json" ]; then
    echo "Error: template-vars.json not found"
    exit 1
fi

# Read variables from JSON
APP_ID=$(jq -r '.APP_ID' template-vars.json)
APP_DISPLAY_NAME=$(jq -r '.APP_DISPLAY_NAME' template-vars.json)
APP_DESCRIPTION=$(jq -r '.APP_DESCRIPTION' template-vars.json)
APP_SUMMARY=$(jq -r '.APP_SUMMARY' template-vars.json)
TOOL_DESCRIPTION=$(jq -r '.TOOL_DESCRIPTION' template-vars.json)
GITHUB_USERNAME=$(jq -r '.GITHUB_USERNAME' template-vars.json)
REPO_NAME=$(jq -r '.REPO_NAME' template-vars.json)
CONTACT_EMAIL=$(jq -r '.CONTACT_EMAIL' template-vars.json)

echo "Setting up OCP Opal Tool with:"
echo "  APP_ID: $APP_ID"
echo "  APP_DISPLAY_NAME: $APP_DISPLAY_NAME"
echo ""

# Files to process
FILES=(
    "package.json"
    "app.yml"
    "assets/directory/overview.md"
)

# Replace placeholders
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Processing $file..."
        sed -i '' "s/{{APP_ID}}/$APP_ID/g" "$file"
        sed -i '' "s/{{APP_DISPLAY_NAME}}/$APP_DISPLAY_NAME/g" "$file"
        sed -i '' "s/{{APP_DESCRIPTION}}/$APP_DESCRIPTION/g" "$file"
        sed -i '' "s/{{APP_SUMMARY}}/$APP_SUMMARY/g" "$file"
        sed -i '' "s/{{TOOL_DESCRIPTION}}/$TOOL_DESCRIPTION/g" "$file"
        sed -i '' "s/{{GITHUB_USERNAME}}/$GITHUB_USERNAME/g" "$file"
        sed -i '' "s/{{REPO_NAME}}/$REPO_NAME/g" "$file"
        sed -i '' "s/{{CONTACT_EMAIL}}/$CONTACT_EMAIL/g" "$file"
    fi
done

echo ""
echo "Setup complete! Next steps:"
echo "  1. yarn install"
echo "  2. Edit src/functions/OpalToolFunction.ts to add your tools"
echo "  3. Edit forms/settings.yml if you need configuration options"
echo "  4. yarn build && yarn validate"
echo "  5. ocp app register && ocp app prepare"
