--!jinja
USE ROLE AI_CICD_RL;
CREATE OR REPLACE MCP SERVER IDENTIFIER('AI_CICD.{{ENV}}AGENTIC_AI.HOUSEKEEPING_MCP_SERVER') FROM SPECIFICATION
$$
tools:
  - name: "Snowflake Housekeeping Cortex Search Service"
    identifier: "AI_CICD.{{ENV}}AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE"
    type: "CORTEX_SEARCH_SERVICE_QUERY"
    description: "A tool that performs keyword and vector search over Snowflake query history."
    title: "Snowflake Housekeeping Cortex Search Service"

  - name: "Snowflake Housekeeping Cortex Documentation"
    identifier: "SNOWFLAKE_DOCUMENTATION.SHARED.CKE_SNOWFLAKE_DOCS_SERVICE"
    type: "CORTEX_SEARCH_SERVICE_QUERY"
    description: "A tool that performs keyword and vector search over Snowflake documentation."
    title: "Snowflake Housekeeping Cortex Documentation"

  - name: "snowflake_account_usage"
    type: "CORTEX_ANALYST_MESSAGE"
    identifier: "AI_CICD.{{ENV}}AGENTIC_AI.SNOWFLAKE_HOUSEKEEPING_AGENT"
    description: "This tool allows users to query the Snowflake account usage schema. It provides a unified business layer over the Snowflake ACCOUNT_USAGE schema, designed for platform owners and administrators. The model is optimized for natural language queries with Cortex Analyst, allowing users to proactively manage the environment by asking questions related to cost efficiency, operational performance, and security governance."
    title: "Semantic view for Snowflake Account Usage"
  
  - name: "snowflake_housekeeping_agent"
    type: "CORTEX_AGENT_RUN"
    identifier: "AI_CICD.{{ENV}}AGENTIC_AI.SNOWFLAKE_HOUSEKEEPING_AGENT"
    description: "This tool will trigger an agentic workflow to invoke tools inside Snowflake with the goal of answering the users question"
    title: "Snowflake Account Agent"
$$;
