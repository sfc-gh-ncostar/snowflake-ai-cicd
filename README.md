# TKO AGENTIC AI and PRODCTUION

## Overview

This quickstart provisions a Snowflake environment named `tko_ai_production` and demonstrates how to:

- Create a Cortex Search Service over sample sales conversations
- Create a semantic model (semantic view) for sales metrics
- Grant a consumer role `tko_ai_production_rl` to use these assets
- Configure a local MCP server endpoint so tools can query both the search service and the semantic model from Cursor

Everything is orchestrated through `setup.sql`, which creates all objects, sample data, grants, and the MCP server.

## Prerequisites

- A Snowflake account with the ability to assume `ACCOUNTADMIN` during setup
- Snowsight or `snowsql` to run SQL
- A Programmatic Access Token (PAT) tied to role `tko_ai_production_rl` for MCP access

## Step-by-step

### 1) Run the setup script

Run `setup.sql` in a Snowflake worksheet or via `snowsql`.

- Creates role: `tko_ai_production_rl`
- Creates database, schemas, and warehouse:
  - Database: `tko_ai_production`
  - Schemas: `tko_ai_production.data`, `tko_ai_production.agents`
  - Warehouse: `tko_ai_production_wh`
- Seeds tables with sample data:
  - `data.sales_conversations`
  - `data.sales_metrics`
- Enables change tracking and cross-region inference (required for certain models)
- Creates Cortex Search Service: `data.sales_conversation_search`
- Creates Stage: `data.models`
- Creates a semantic view from YAML for sales metrics: `data.sales_metrics_sv`
- Creates an MCP server: `data.mcp-servers.tko_ai_production_mcp_server`

Tip: If you want to use existing database/schema/warehouse, adjust object names in `setup.sql` before running.

### 2) Upload the semantic model (optional)

`setup.sql` already calls `SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML` with an embedded YAML block. If you prefer to upload the YAML file directly:

- In Snowsight: Data » Databases » `tko_ai_production` » `DATA` » Stages » `MODELS` » + Files
- Or with `snowsql`:

```sql
PUT file://sales_metrics_model.yaml @tko_ai_production.data.models AUTO_COMPRESS=false;
```

### 3) Create a Programmatic Access Token (PAT)

In Snowsight: Profile (bottom-left) » Settings » Authentication » Programmatic access tokens » Generate new token.

- Select Single Role and choose `tko_ai_production_rl`
- Copy and securely store the token (you cannot view it again)

### 4) Configure Cursor MCP client

Add the following entry to your local `.cursor/mcp.json` so Cursor can call Snowflake MCP endpoints with your PAT.

```json
{
  "Snowflake_tko_ai_production": {
    "url": "https://<org>.<account>.snowflakecomputing.com/api/v2/databases/tko_ai_production/schemas/data/mcp-servers/tko_ai_production_mcp_server",
    "headers": {
      "Authorization": "Bearer <YOUR_PAT_TOKEN>"
    }
  }
}
```

Replace `<org>.<account>` and `<YOUR_PAT_TOKEN>` accordingly.

## Verify your setup

Run these checks in a worksheet after executing `setup.sql`.

### Check sample rows

```sql
USE ROLE tko_ai_production_rl;
USE DATABASE tko_ai_production;
USE SCHEMA data;
SELECT COUNT(*) FROM sales_conversations;
SELECT COUNT(*) FROM sales_metrics;
```

### Test Cortex Search Service

```sql
SELECT *
FROM TABLE(CORTEX_SEARCH(
  'tko_ai_production.data.sales_conversation_search',
  'security architecture deep dive'
))
LIMIT 5;
```

### Explore the semantic view

```sql
SELECT * FROM tko_ai_production.data.sales_metrics_sv LIMIT 10;
```

## Notes

- Cross-region inference is enabled to allow models like `claude-4-sonnet`:
  - `ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';`
- Grants are applied so `tko_ai_production_rl` can use the warehouse, search service, stage, and objects.
- If you change object names, update the MCP server `url` accordingly.

## Repository contents

- `setup.sql`: End-to-end provisioning (roles, DB/SC, WH, tables, data, search service, stage, semantic view, MCP server)
- `sales_metrics_model.yaml`: Standalone YAML model (optional if using the embedded YAML in `setup.sql`)
- `README.md`: This guide
