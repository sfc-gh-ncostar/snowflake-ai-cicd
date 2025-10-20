USE ROLE TECHUP25_RL;
SET env = '<%env%>';
set name = CONCAT('TECHUP25.', $env ,'_AGENTIC_AI.','_HOUSEKEEPING_MCP_SERVER');
CREATE OR REPLACE MCP SERVER identifier($name) from specification
$$
  tools:
    - name: "Snowflake Housekeeping Cortex Search Service"
      identifier: "TECHUP25.AGENTIC_AI.SNOWFLAKE_HOUSEKEEPING_AGENT"
      type: "CORTEX_SEARCH_SERVICE_QUERY"
      description: "A tool that performs keyword and vector search over Snowflake query history."
      title: "Snowflake Housekeeping Cortex Search Service"

    - name: "Snowflake Housekeeping Cortex Documentation"
      identifier: "SNOWFLAKE_DOCUMENTATION.SHARED"
      type: "CKE_SNOWFLAKE_DOCS_SERVICE"
      description: "A tool that performs keyword and vector search over Snowflake documentation."
      title: "Snowflake Housekeeping Cortex Documentation"

    -- - name: "Snowflake Housekeeping Cortex Analyst"
    --   identifier: "TECHUP25.AGENTIC_AI.MODELS/semantic_model.yaml"
    --   type: "CORTEX_ANALYST_MESSAGE"
    --   description: "A tool that performs structured data analysis over Snowflake query history."
    --   title: "Snowflake Housekeeping Cortex Analyst"
    --   config:
    --       warehouse: "TECHUP25_wh"
$$;

GRANT USAGE ON MCP SERVER SNOWFLAKE_HOUSEKEEPING_MCP_SERVER TO ROLE TECHUP25_RL;