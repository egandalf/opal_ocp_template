# Claude Code Instructions for OCP Opal Tool Development

This is a template for building Opal tools on Optimizely Connect Platform (OCP).

## When Using This Template

### Step 1: Clone and Configure
1. Clone this repo to a new directory named after the integration (e.g., `salesforce-opal-tool`)
2. Update `template-vars.json` with actual values
3. Run the placeholder replacement (or replace manually in package.json, app.yml, assets/directory/overview.md)

### Step 2: Implement Tools
Edit `src/functions/OpalToolFunction.ts`:
- Remove the example `hello_world` and `get_info` tools
- Add tools appropriate for the integration
- Each tool needs the `@tool` decorator with name, description, endpoint, and parameters

### Step 3: Configure Settings (if needed)
Edit `forms/settings.yml` if the integration needs configuration (API keys, endpoints, etc.):
- Use `type: secret` for API keys/tokens
- Use `type: text` for URLs/endpoints
- Use `type: select` for options
- IMPORTANT: Use `help:` not `helpText:`, use `text:` not `label:` in options

### Step 4: Build and Validate
```bash
nvm use 22  # Must use Node 22+
yarn install
yarn build
yarn validate
```

### Step 5: Local Testing (Beta)
Use `ocp dev` for local testing before deploying:
```bash
ocp dev
```
Open http://localhost:3000 to test:
- **Settings forms** - Preview UI exactly as it appears in the App Directory
- **Functions** - Send custom payloads with any HTTP method
- **Jobs** - Execute jobs manually and inspect execution state
- **Lifecycle hooks** - Test install and uninstall flows
- **Real-time logs** - Code changes rebuild automatically

Documentation: https://docs.developers.optimizely.com/optimizely-connect-platform/docs/local-testing

### Step 6: Deploy
```bash
ocp app register  # First time only
ocp app prepare
ocp directory publish APP_ID@VERSION
ocp directory install APP_ID@VERSION TRACKER_ID
```

## Tool Implementation Patterns

### Basic API Call Tool
```typescript
@tool({
  name: 'get_record',
  description: 'Retrieves a record from the external system',
  endpoint: '/tools/get-record',
  parameters: [
    { name: 'record_id', type: ParameterType.String, description: 'The record ID', required: true }
  ]
})
async getRecord(parameters: { record_id: string }): Promise<{ record: object }> {
  const settings = await storage.settings.get('api');
  const response = await fetch(`${settings.api_url}/records/${parameters.record_id}`, {
    headers: { 'Authorization': `Bearer ${settings.api_key}` }
  });
  return { record: await response.json() };
}
```

### Search/Query Tool
```typescript
@tool({
  name: 'search_records',
  description: 'Searches for records matching criteria',
  endpoint: '/tools/search',
  parameters: [
    { name: 'query', type: ParameterType.String, description: 'Search query', required: true },
    { name: 'limit', type: ParameterType.Number, description: 'Max results', required: false }
  ]
})
async searchRecords(parameters: { query: string; limit?: number }): Promise<{ results: object[] }> {
  // Implementation
}
```

### Create/Update Tool
```typescript
@tool({
  name: 'create_record',
  description: 'Creates a new record',
  endpoint: '/tools/create',
  parameters: [
    { name: 'data', type: ParameterType.Object, description: 'Record data', required: true }
  ]
})
async createRecord(parameters: { data: object }): Promise<{ id: string; success: boolean }> {
  // Implementation
}
```

## Settings Form Patterns

### API Configuration
```yaml
sections:
  - key: api
    label: API Configuration
    elements:
      - key: api_url
        label: API URL
        type: text
        help: The base URL for the API (e.g., https://api.example.com)
      - key: api_key
        label: API Key
        type: secret
        help: Your API key for authentication
```

### OAuth Configuration
```yaml
sections:
  - key: oauth
    label: OAuth Configuration
    elements:
      - key: client_id
        label: Client ID
        type: text
        help: OAuth client ID
      - key: client_secret
        label: Client Secret
        type: secret
        help: OAuth client secret
```

## Common Integrations - Suggested Tools

### CRM Integration (Salesforce, HubSpot, etc.)
- `search_contacts` - Search for contacts/leads
- `get_contact` - Get contact details by ID
- `create_contact` - Create a new contact
- `update_contact` - Update contact fields
- `search_opportunities` - Search deals/opportunities
- `get_account` - Get company/account info

### Project Management (Jira, Asana, etc.)
- `search_issues` - Search for issues/tasks
- `get_issue` - Get issue details
- `create_issue` - Create new issue
- `update_issue` - Update issue status/fields
- `add_comment` - Add comment to issue
- `get_project` - Get project info

### Communication (Slack, Teams, etc.)
- `send_message` - Send a message to a channel
- `search_messages` - Search message history
- `get_channel_info` - Get channel details
- `list_channels` - List available channels

### Data/Analytics (Google Analytics, Mixpanel, etc.)
- `query_metrics` - Query analytics data
- `get_report` - Get a specific report
- `list_events` - List tracked events

## File Structure Reference

```
├── src/
│   ├── index.ts                    # DO NOT MODIFY - just exports
│   ├── functions/
│   │   └── OpalToolFunction.ts     # ADD YOUR TOOLS HERE
│   └── lifecycle/
│       └── Lifecycle.ts            # Modify if needed for install/upgrade logic
├── forms/
│   └── settings.yml                # ADD SETTINGS HERE if needed
├── assets/
│   ├── icon.svg                    # Replace with app icon
│   ├── logo.svg                    # Replace with app logo
│   └── directory/
│       └── overview.md             # UPDATE with app documentation
├── app.yml                         # UPDATE placeholders
├── package.json                    # UPDATE placeholders
└── template-vars.json              # FILL IN first, then replace
```

## Critical Requirements (Build Will Fail Without These)

1. **grpc-boom resolution** - Already in package.json, don't remove
2. **lint and test scripts** - Already in package.json, don't remove
3. **Node 22+** - Use `nvm use 22` before yarn install
4. **settings.yml format** - Use `help:` not `helpText:`, `text:` not `label:`
5. **Lifecycle class** - Must extend BaseLifecycle with all abstract methods

## Imports Reference

```typescript
// Tool decorators and types
import { ToolFunction, tool, ParameterType } from '@optimizely-opal/opal-tool-ocp-sdk';

// Storage and logging
import { storage, logger } from '@zaiusinc/app-sdk';

// Lifecycle (in Lifecycle.ts)
import {
  Lifecycle as BaseLifecycle,
  SubmittedFormData,
  LifecycleSettingsResult,
  AuthorizationGrantResult,
  Request,
  LifecycleResult,
  logger,
  storage
} from '@zaiusinc/app-sdk';
```
