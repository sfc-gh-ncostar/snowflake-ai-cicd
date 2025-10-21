USE ROLE TECHUP25_RL;
SET ENV = '<%env%>';

CREATE OR REPLACE PROCEDURE TECHUP25.AGENTIC_AI.CREATE_HOUSEKEEPING_MCP(
    ENV VARCHAR
)
RETURNS VARCHAR
LANGUAGE SQL
AS
DECLARE
    DOLLAR_QUOTE VARCHAR;
BEGIN
  DOLLAR_QUOTE := '$$';
  EXECUTE IMMEDIATE 'CREATE OR REPLACE MCP SERVER TECHUP25.'|| ENV || 'AGENTIC_AI.HOUSEKEEPING_MCP_SERVER FROM SPECIFICATION ' || DOLLAR_QUOTE || 
          REPLACE($$
          tools:
            - name: "Snowflake Housekeeping Cortex Search Service"
              identifier: "TECHUP25.$$ || ENV || $$AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE"
              type: "CORTEX_SEARCH_SERVICE_QUERY"
              description: "A tool that performs keyword and vector search over Snowflake query history."
              title: "Snowflake Housekeeping Cortex Search Service"

            - name: "Snowflake Housekeeping Cortex Documentation"
              identifier: "SNOWFLAKE_DOCUMENTATION.SHARED.CKE_SNOWFLAKE_DOCS_SERVICE"
              type: "CORTEX_SEARCH_SERVICE_QUERY"
              description: "A tool that performs keyword and vector search over Snowflake documentation."
              title: "Snowflake Housekeeping Cortex Documentation"$$, 'ENV', ENV) || 
          DOLLAR_QUOTE || ';';
END;

call TECHUP25.AGENTIC_AI.CREATE_HOUSEKEEPING_MCP($ENV);
