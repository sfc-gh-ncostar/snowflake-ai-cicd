# AI Deployment Patterns on Snowflake

[![Deploy Service to Environments](https://github.com/sfc-gh-mtakada/agentic_ai/actions/workflows/deploy-service.yml/badge.svg)](https://github.com/sfc-gh-mtakada/agentic_ai/actions/workflows/deploy-service.yml)

## Overview

This project creates an example environment for deploying AI models on Snowflake. I intend to evolve this over time to encompass more of the Snowflake platform. Today it covers:
- Deployment patterns (via GitHub Actions) for the following components:
  - Cortex Search Service
  - Cortex Agent
  - MCP Server
  - Cortex Analyst

![Deployment Pattern](./assets/pipeline.png)

## How to run the project.

### Prerequisites

- A Snowflake account with ability to assume `ACCOUNTADMIN` during setup
- Snowsight or `snowsql` to run SQL
- A Programmatic Access Token (PAT) tied to role `AI_CICD_RL` for MCP access
- [Optional] A GitHub account and another Snowflake PAT token to deploy the service to the different environments (DEV, TEST, PROD)

## Step-by-step

### 1) Run the setup script

Run `setup.sql` in a Snowflake worksheet or via `snowsql`.

- Enables cross-region inference (for models such as `claude-4-sonnet`):
  - `ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';`
- Creates role and grants:
  - `AI_CICD_RL`, `SNOWFLAKE.CORTEX_USER`, `SNOWFLAKE.GOVERNANCE_VIEWER`
  - Grants usage and object privileges on `AI_CICD` and `AI_CICD.AGENTIC_AI`
- Creates compute:
  - Warehouse: `AI_CICD_wh` (SMALL, auto-resume, 1-hour auto-suspend)
- Creates and populates data:
  - `AI_CICD.AGENTIC_AI.QUERY_HISTORY_MATERIALIZED` from `SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY`
  - Populates the last 14 days with derived search fields and categories
- Creates Cortex Search Service:
  - `AI_CICD.AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE` (warehouse `AI_CICD_wh`, `TARGET_LAG = '1 HOUR'`)
- Creates the semantic view:
  - `AI_CICD.AGENTIC_AI.SNOWFLAKE_HOUSEKEEPING_AGENT` from an inline definition
- Creates the Cortex Agent:
  - `AI_CICD.AGENTIC_AI.SNOWFLAKE_HOUSEKEEPING_AGENT` with tools: Cortex Search and Cortex Analyst (text-to-sql) over the staged semantic model
- Creates the MCP Server and grants usage:
  - `SNOWFLAKE_HOUSEKEEPING_MCP_SERVER` and `GRANT USAGE` to `AI_CICD_RL`
- ‼️ Important, the last command in the script will create a PAT token for use later. Please store this somewhere securely and locally for future use. If you lose it, you will need to create a new one.

Tip: If you want to use existing database/schema/warehouse names, adjust them in `setup.sql` before running (not recommended).

### 2) Deploy to different environments

The repository includes a GitHub Actions workflow that can deploy the service to the different environments (DEV, TEST, PROD). To use it, you need to:

1. Create (or reuse from the setup script) a PAT token for the different environments and store it in the GitHub repository secrets.
1. Clone this repository to your own Github account.
1. Go to your repository settings and create the following secrets:
   - `SNOWFLAKE_ACCOUNT`: Your Snowflake account name (e.g, ORG-ACCOUNT)
   - `SNOWFLAKE_USER`: Your Snowflake user (e.g. `GH_ACTION_USER`)
   - `SNOWFLAKE_PASSWORD`: Your Snowflake user's PAT token created in the setup script
1. Make changes to the service definitions in the `components` folder.
1. Push your changes to the repository.
1. The workflow will deploy the service to the different environments (DEV, TEST, PROD).
