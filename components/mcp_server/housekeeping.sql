--!jinja
USE ROLE TECHUP25_RL; 
CREATE OR REPLACE MCP SERVER IDENTIFIER('TECHUP25.{{ENV}}AGENTIC_AI.HOUSEKEEPING_MCP_SERVER') FROM SPECIFICATION
$$
tools:
  - name: "Snowflake Housekeeping Cortex Search Service"
    identifier: "TECHUP25.{{ENV}}AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE"
    type: "CORTEX_SEARCH_SERVICE_QUERY"
    description: "A tool that performs keyword and vector search over Snowflake query history."
    title: "Snowflake Housekeeping Cortex Search Service"

  - name: "Snowflake Housekeeping Cortex Documentation"
    identifier: "SNOWFLAKE_DOCUMENTATION.SHARED.CKE_SNOWFLAKE_DOCS_SERVICE"
    type: "CORTEX_SEARCH_SERVICE_QUERY"
    description: "A tool that performs keyword and vector search over Snowflake documentation."
    title: "Snowflake Housekeeping Cortex Documentation"
$$;
