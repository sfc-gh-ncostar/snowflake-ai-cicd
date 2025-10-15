-- 1. Create consumer role
USE ROLE ACCOUNTADMIN;
-- Enable cross region inference (required to use claude-4-sonnet)
ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';

CREATE ROLE IF NOT EXISTS TECHUP25_RL;
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO ROLE TECHUP25_RL;
SET my_user = CURRENT_USER();
GRANT ROLE TECHUP25_RL to user IDENTIFIER($my_user);

-- 2. Create database, schema, and warehouse
CREATE DATABASE IF NOT EXISTS TECHUP25;
CREATE SCHEMA IF NOT EXISTS TECHUP25.AGENTIC_AI;

-- TECHUP25 Database
GRANT USAGE ON DATABASE TECHUP25 TO ROLE TECHUP25_RL;
GRANT USAGE ON SCHEMA TECHUP25.AGENTIC_AI TO ROLE TECHUP25_RL;
GRANT SELECT ON ALL TABLES IN SCHEMA TECHUP25.AGENTIC_AI TO ROLE TECHUP25_RL;
GRANT SELECT ON FUTURE TABLES IN SCHEMA TECHUP25.AGENTIC_AI TO ROLE TECHUP25_RL;
GRANT CREATE TABLE ON SCHEMA TECHUP25.AGENTIC_AI TO ROLE TECHUP25_RL;
-- Snowflake Database
GRANT DATABASE ROLE SNOWFLAKE.GOVERNANCE_VIEWER TO ROLE TECHUP25_RL;
-- Cortex Search Service
GRANT CREATE CORTEX SEARCH SERVICE ON SCHEMA TECHUP25.AGENTIC_AI TO ROLE TECHUP25_RL;
-- Cortex Agent 
GRANT CREATE AGENT ON SCHEMA TECHUP25.AGENTIC_AI TO ROLE TECHUP25_RL;
-- Warehouse
CREATE WAREHOUSE IF NOT EXISTS TECHUP25_wh
WITH 
    WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 3600
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = FALSE
COMMENT = 'TechUp Warehouse with 1-hour auto-suspend policy';
GRANT USAGE, OPERATE ON WAREHOUSE TECHUP25_wh TO ROLE TECHUP25_RL;

-- 3. Create tables for sales data
USE ROLE TECHUP25_RL;
USE SCHEMA TECHUP25.AGENTIC_AI;

-- Create the physical table structure
CREATE OR REPLACE TABLE QUERY_HISTORY_MATERIALIZED (
    -- Core Query Identification
    QUERY_ID VARCHAR(16777216),
    QUERY_TEXT STRING,
    QUERY_TYPE VARCHAR(16777216),
    QUERY_HASH VARCHAR(16777216),
    QUERY_PARAMETERIZED_HASH VARCHAR(16777216),
    QUERY_TAG VARCHAR(16777216),
    
    -- User & Security Context
    USER_NAME VARCHAR(16777216),
    ROLE_NAME VARCHAR(16777216),
    USER_TYPE VARCHAR(16777216),
    
    -- Infrastructure Context  
    DATABASE_NAME VARCHAR(16777216),
    SCHEMA_NAME VARCHAR(16777216),
    WAREHOUSE_NAME VARCHAR(16777216),
    WAREHOUSE_SIZE VARCHAR(16777216),
    WAREHOUSE_TYPE VARCHAR(16777216),
    
    -- Execution Context
    START_TIME TIMESTAMP_LTZ(6),
    END_TIME TIMESTAMP_LTZ(6),
    TOTAL_ELAPSED_TIME NUMBER(38,0),
    EXECUTION_TIME NUMBER(38,0),
    COMPILATION_TIME NUMBER(38,0),
    EXECUTION_STATUS VARCHAR(16777216),
    ERROR_CODE VARCHAR(16777216),
    ERROR_MESSAGE STRING,
    
    -- Performance Metrics
    BYTES_SCANNED NUMBER(38,0),
    BYTES_WRITTEN NUMBER(38,0),
    BYTES_DELETED NUMBER(38,0),
    ROWS_PRODUCED NUMBER(38,0),
    ROWS_INSERTED NUMBER(38,0),
    ROWS_UPDATED NUMBER(38,0),
    ROWS_DELETED NUMBER(38,0),
    ROWS_UNLOADED NUMBER(38,0),
    PERCENTAGE_SCANNED_FROM_CACHE NUMBER(38,3),
    
    -- Cost Metrics
    CREDITS_USED_CLOUD_SERVICES NUMBER(38,9),
    
    -- Data Transfer
    INBOUND_DATA_TRANSFER_BYTES NUMBER(38,0),
    OUTBOUND_DATA_TRANSFER_BYTES NUMBER(38,0),
    INBOUND_DATA_TRANSFER_CLOUD VARCHAR(16777216),
    INBOUND_DATA_TRANSFER_REGION VARCHAR(16777216),
    OUTBOUND_DATA_TRANSFER_CLOUD VARCHAR(16777216),
    OUTBOUND_DATA_TRANSFER_REGION VARCHAR(16777216),
    
    -- Memory & Spill
    BYTES_SPILLED_TO_LOCAL_STORAGE NUMBER(38,0),
    BYTES_SPILLED_TO_REMOTE_STORAGE NUMBER(38,0),
    BYTES_READ_FROM_RESULT NUMBER(38,0),
    BYTES_SENT_OVER_THE_NETWORK NUMBER(38,0),
    BYTES_WRITTEN_TO_RESULT NUMBER(38,0),
    
    -- Advanced Metrics
    PARTITIONS_SCANNED NUMBER(38,0),
    PARTITIONS_TOTAL NUMBER(38,0),
    QUERY_LOAD_PERCENT NUMBER(38,3),
    CLUSTER_NUMBER NUMBER(38,0),
    
    -- Queue & Wait Times
    QUEUED_OVERLOAD_TIME NUMBER(38,0),
    QUEUED_PROVISIONING_TIME NUMBER(38,0),
    QUEUED_REPAIR_TIME NUMBER(38,0),
    CHILD_QUERIES_WAIT_TIME NUMBER(38,0),
    
    -- System Context
    SESSION_ID NUMBER(38,0),
    TRANSACTION_ID NUMBER(38,0),
    TRANSACTION_BLOCKED_TIME NUMBER(38,0),
    RELEASE_VERSION VARCHAR(16777216),
    
    -- External Functions
    EXTERNAL_FUNCTION_TOTAL_INVOCATIONS NUMBER(38,0),
    EXTERNAL_FUNCTION_TOTAL_SENT_ROWS NUMBER(38,0),
    EXTERNAL_FUNCTION_TOTAL_RECEIVED_ROWS NUMBER(38,0),
    EXTERNAL_FUNCTION_TOTAL_SENT_BYTES NUMBER(38,0),
    EXTERNAL_FUNCTION_TOTAL_RECEIVED_BYTES NUMBER(38,0),
    
    -- Additional Context
    IS_CLIENT_GENERATED_STATEMENT BOOLEAN,
    QUERY_RETRY_CAUSE VARCHAR(16777216),
    QUERY_RETRY_TIME NUMBER(38,0),
    FAULT_HANDLING_TIME NUMBER(38,0),
    LIST_EXTERNAL_FILES_TIME NUMBER(38,0),
    
    -- Search-Optimized Fields
    SEARCH_METADATA STRING,
    QUERY_SUMMARY STRING,
    PERFORMANCE_CATEGORY VARCHAR(50),
    COST_CATEGORY VARCHAR(50),
    
    -- Metadata
    MATERIALIZED_AT TIMESTAMP_NTZ
);

-- Populate with 60 days of data
INSERT INTO QUERY_HISTORY_MATERIALIZED
SELECT 
    -- Core Query Identification
    QUERY_ID,
    QUERY_TEXT,
    QUERY_TYPE,
    QUERY_HASH,
    QUERY_PARAMETERIZED_HASH,
    QUERY_TAG,
    
    -- User & Security Context
    USER_NAME,
    ROLE_NAME,
    USER_TYPE,
    
    -- Infrastructure Context  
    DATABASE_NAME,
    SCHEMA_NAME,
    WAREHOUSE_NAME,
    WAREHOUSE_SIZE,
    WAREHOUSE_TYPE,
    
    -- Execution Context
    START_TIME,
    END_TIME,
    TOTAL_ELAPSED_TIME,
    EXECUTION_TIME,
    COMPILATION_TIME,
    EXECUTION_STATUS,
    ERROR_CODE,
    ERROR_MESSAGE,
    
    -- Performance Metrics
    BYTES_SCANNED,
    BYTES_WRITTEN,
    BYTES_DELETED,
    ROWS_PRODUCED,
    ROWS_INSERTED,
    ROWS_UPDATED,
    ROWS_DELETED,
    ROWS_UNLOADED,
    PERCENTAGE_SCANNED_FROM_CACHE,
    
    -- Cost Metrics
    CREDITS_USED_CLOUD_SERVICES,
    
    -- Data Transfer
    INBOUND_DATA_TRANSFER_BYTES,
    OUTBOUND_DATA_TRANSFER_BYTES,
    INBOUND_DATA_TRANSFER_CLOUD,
    INBOUND_DATA_TRANSFER_REGION,
    OUTBOUND_DATA_TRANSFER_CLOUD,
    OUTBOUND_DATA_TRANSFER_REGION,
    
    -- Memory & Spill
    BYTES_SPILLED_TO_LOCAL_STORAGE,
    BYTES_SPILLED_TO_REMOTE_STORAGE,
    BYTES_READ_FROM_RESULT,
    BYTES_SENT_OVER_THE_NETWORK,
    BYTES_WRITTEN_TO_RESULT,
    
    -- Advanced Metrics
    PARTITIONS_SCANNED,
    PARTITIONS_TOTAL,
    QUERY_LOAD_PERCENT,
    CLUSTER_NUMBER,
    
    -- Queue & Wait Times
    QUEUED_OVERLOAD_TIME,
    QUEUED_PROVISIONING_TIME,
    QUEUED_REPAIR_TIME,
    CHILD_QUERIES_WAIT_TIME,
    
    -- System Context
    SESSION_ID,
    TRANSACTION_ID,
    TRANSACTION_BLOCKED_TIME,
    RELEASE_VERSION,
    
    -- External Functions
    EXTERNAL_FUNCTION_TOTAL_INVOCATIONS,
    EXTERNAL_FUNCTION_TOTAL_SENT_ROWS,
    EXTERNAL_FUNCTION_TOTAL_RECEIVED_ROWS,
    EXTERNAL_FUNCTION_TOTAL_SENT_BYTES,
    EXTERNAL_FUNCTION_TOTAL_RECEIVED_BYTES,
    
    -- Additional Context
    IS_CLIENT_GENERATED_STATEMENT,
    QUERY_RETRY_CAUSE,
    QUERY_RETRY_TIME,
    FAULT_HANDLING_TIME,
    LIST_EXTERNAL_FILES_TIME,
    
    -- Derived Searchable Fields
    CONCAT_WS(' | ',
        COALESCE(QUERY_TYPE, 'UNKNOWN'),
        COALESCE(DATABASE_NAME, 'NO_DB'),
        COALESCE(SCHEMA_NAME, 'NO_SCHEMA'),
        COALESCE(USER_NAME, 'NO_USER'),
        COALESCE(ROLE_NAME, 'NO_ROLE'),
        COALESCE(WAREHOUSE_NAME, 'NO_WAREHOUSE'),
        CASE WHEN ERROR_CODE IS NOT NULL THEN 'ERROR' ELSE 'SUCCESS' END,
        CASE 
            WHEN TOTAL_ELAPSED_TIME > 300000 THEN 'LONG_RUNNING'
            WHEN TOTAL_ELAPSED_TIME > 30000 THEN 'MEDIUM_DURATION'
            ELSE 'QUICK'
        END,
        CASE
            WHEN CREDITS_USED_CLOUD_SERVICES > 0.1 THEN 'HIGH_COST'
            WHEN CREDITS_USED_CLOUD_SERVICES > 0.01 THEN 'MEDIUM_COST'
            WHEN CREDITS_USED_CLOUD_SERVICES > 0 THEN 'LOW_COST'
            ELSE 'MINIMAL_COST'
        END
    ) AS SEARCH_METADATA,
    
    -- Human-readable query summary
    CONCAT(
        'Query Type: ', COALESCE(QUERY_TYPE, 'Unknown'), ' | ',
        'User: ', COALESCE(USER_NAME, 'Unknown'), ' | ',
        'Role: ', COALESCE(ROLE_NAME, 'Unknown'), ' | ',
        'Database: ', COALESCE(DATABASE_NAME, 'None'), ' | ',
        'Warehouse: ', COALESCE(WAREHOUSE_NAME, 'None'), ' | ',
        'Duration: ', COALESCE(ROUND(TOTAL_ELAPSED_TIME/1000, 2), 0), ' seconds | ',
        'Status: ', COALESCE(EXECUTION_STATUS, 'Unknown'), ' | ',
        'Data Scanned: ', COALESCE(ROUND(BYTES_SCANNED/POWER(1024,3), 2), 0), ' GB | ',
        'Credits: ', COALESCE(ROUND(CREDITS_USED_CLOUD_SERVICES, 4), 0)
    ) AS QUERY_SUMMARY,
    
    -- Performance categorization
    CASE 
        WHEN TOTAL_ELAPSED_TIME > 300000 THEN 'LONG_RUNNING'
        WHEN TOTAL_ELAPSED_TIME > 30000 THEN 'MEDIUM_DURATION'
        WHEN TOTAL_ELAPSED_TIME > 5000 THEN 'QUICK'
        ELSE 'INSTANT'
    END AS PERFORMANCE_CATEGORY,
    
    -- Cost categorization
    CASE
        WHEN CREDITS_USED_CLOUD_SERVICES > 1.0 THEN 'VERY_EXPENSIVE'
        WHEN CREDITS_USED_CLOUD_SERVICES > 0.1 THEN 'EXPENSIVE'
        WHEN CREDITS_USED_CLOUD_SERVICES > 0.01 THEN 'MODERATE'
        WHEN CREDITS_USED_CLOUD_SERVICES > 0 THEN 'LOW_COST'
        ELSE 'FREE'
    END AS COST_CATEGORY,
    
    -- Materialization timestamp
    CURRENT_TIMESTAMP() AS MATERIALIZED_AT

FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE START_TIME >= CURRENT_DATE - INTERVAL '14 DAYS'
  AND START_TIME < CURRENT_DATE  -- Avoid partial current day
ORDER BY START_TIME DESC
LIMIT 1000
;


-- [Optional] Verify the materialization
SELECT 
    COUNT(*) AS total_queries,
    MIN(START_TIME) AS earliest_query,
    MAX(START_TIME) AS latest_query,
    COUNT(DISTINCT USER_NAME) AS unique_users,
    COUNT(DISTINCT DATABASE_NAME) AS unique_databases,
    COUNT(DISTINCT WAREHOUSE_NAME) AS unique_warehouses,
    ROUND(SUM(CREDITS_USED_CLOUD_SERVICES), 2) AS total_cloud_service_credits,
FROM QUERY_HISTORY_MATERIALIZED;

-- [Optional] Sample the search fields
SELECT 
    QUERY_ID,
    QUERY_TYPE,
    USER_NAME,
    DATABASE_NAME,
    PERFORMANCE_CATEGORY,
    COST_CATEGORY,
    LEFT(SEARCH_METADATA, 100) AS search_metadata_preview,
    LEFT(QUERY_SUMMARY, 150) AS query_summary_preview,
    START_TIME
FROM QUERY_HISTORY_MATERIALIZED 
ORDER BY START_TIME DESC
LIMIT 5;


-- 4. Create the search service
USE ROLE TECHUP25_RL;
USE DATABASE TECHUP25;
USE SCHEMA AGENTIC_AI;

-- Create cortexsearch service
-- Note: It will take 1-2 minutes to create the search service
CREATE OR REPLACE CORTEX SEARCH SERVICE QUERY_HISTORY_SEARCH_SERVICE
ON QUERY_TEXT  -- Primary searchable column (SQL text content)
ATTRIBUTES (
    -- Core identifiers for filtering and context
    QUERY_ID,
    QUERY_TYPE,
    
    -- User and security context
    USER_NAME,
    ROLE_NAME,
    USER_TYPE,
    
    -- Infrastructure context
    DATABASE_NAME,
    SCHEMA_NAME,
    WAREHOUSE_NAME,
    WAREHOUSE_SIZE,
    
    -- Execution context
    START_TIME,
    END_TIME,
    EXECUTION_STATUS,
    ERROR_CODE,
    ERROR_MESSAGE,
    
    -- Performance metrics
    TOTAL_ELAPSED_TIME,
    BYTES_SCANNED,
    PERCENTAGE_SCANNED_FROM_CACHE,
    
    -- Cost information
    CREDITS_USED_CLOUD_SERVICES,
    
    -- Search-optimized fields
    SEARCH_METADATA,
    QUERY_SUMMARY,
    PERFORMANCE_CATEGORY,
    COST_CATEGORY,
    
    -- Spill indicators (for performance analysis)
    BYTES_SPILLED_TO_LOCAL_STORAGE,
    BYTES_SPILLED_TO_REMOTE_STORAGE
)
WAREHOUSE = TECHUP25_WH  -- Change this to your preferred warehouse
TARGET_LAG = '1 HOUR'   -- How often to refresh the search index
AS
SELECT 
    QUERY_TEXT,
    QUERY_ID,
    QUERY_TYPE,
    USER_NAME,
    ROLE_NAME,
    USER_TYPE,
    DATABASE_NAME,
    SCHEMA_NAME,
    WAREHOUSE_NAME,
    WAREHOUSE_SIZE,
    START_TIME,
    END_TIME,
    EXECUTION_STATUS,
    ERROR_CODE,
    ERROR_MESSAGE,
    TOTAL_ELAPSED_TIME,
    BYTES_SCANNED,
    PERCENTAGE_SCANNED_FROM_CACHE,
    CREDITS_USED_CLOUD_SERVICES,
    SEARCH_METADATA,
    QUERY_SUMMARY,
    PERFORMANCE_CATEGORY,
    COST_CATEGORY,
    BYTES_SPILLED_TO_LOCAL_STORAGE,
    BYTES_SPILLED_TO_REMOTE_STORAGE
FROM QUERY_HISTORY_MATERIALIZED;

-- /** [Optional] Start of test. 
-- Note: Wait a few minutes after creation for indexing to complete
-- Test the search service with sample queries
-- Test 1: Find queries by SQL pattern
SELECT 'TEST 1: Find SELECT queries on SALES database' AS test_description;
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'TECHUP25.AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE',
    '{
        "query": "SELECT FROM sales database table",
        "columns": ["QUERY_ID", "USER_NAME", "QUERY_SUMMARY", "QUERY_TEXT"],
        "limit": 3
    }'
);

-- Test 2: Find expensive queries
SELECT 'TEST 2: Find expensive or long-running queries' AS test_description;
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'TECHUP25.AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE',
    '{
        "query": "expensive long running high cost query optimization",
        "columns": ["QUERY_ID", "USER_NAME", "COST_CATEGORY", "PERFORMANCE_CATEGORY", "QUERY_SUMMARY"],
        "limit": 3
    }'
);

-- Test 3: Find queries with errors
SELECT 'TEST 3: Find failed queries with error messages' AS test_description;
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'TECHUP25.AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE',
    '{
        "query": "error failed compilation timeout",
        "columns": ["QUERY_ID", "USER_NAME", "ERROR_CODE", "ERROR_MESSAGE", "QUERY_SUMMARY"],
        "limit": 3
    }'
);

-- Test 4: Find queries by specific user or role patterns
SELECT 'TEST 4: Find queries by data engineering roles' AS test_description;
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'TECHUP25.AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE',
    '{
        "query": "data engineer ETL transformation pipeline",
        "columns": ["USER_NAME", "ROLE_NAME", "DATABASE_NAME", "QUERY_TYPE", "QUERY_SUMMARY"],
        "limit": 3
    }'
);

-- Test 5: Find queries with performance issues
SELECT 'TEST 5: Find queries that spilled to disk' AS test_description;
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'TECHUP25.AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE',
    '{
        "query": "memory spill disk storage performance optimization",
        "columns": ["QUERY_ID", "USER_NAME", "BYTES_SPILLED_TO_LOCAL_STORAGE", "BYTES_SPILLED_TO_REMOTE_STORAGE", "QUERY_SUMMARY"],
        "limit": 3
    }'
);

-- Advanced search examples with filters
SELECT 'ADVANCED: Find recent expensive queries by specific users' AS test_description;
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'TECHUP25.AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE',
    '{
        "query": "expensive query optimization performance tuning",
        "columns": ["QUERY_ID", "USER_NAME", "COST_CATEGORY", "QUERY_SUMMARY", "START_TIME"],
        "limit": 5
    }'
);

-- Utility: Check search service status and statistics
SELECT 'SEARCH SERVICE STATUS' AS info;
SHOW CORTEX SEARCH SERVICES LIKE 'TECHUP25.AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE';

-- Utility: Get search service information
SELECT 
    'SEARCH SERVICE INFO' AS category,
    COUNT(*) AS indexed_records
FROM QUERY_HISTORY_MATERIALIZED;

SELECT 
    'RECENT DATA AVAILABILITY' AS category,
    MIN(START_TIME) AS earliest_query,
    MAX(START_TIME) AS latest_query,
    COUNT(DISTINCT USER_NAME) AS unique_users,
    COUNT(DISTINCT DATABASE_NAME) AS unique_databases,
    COUNT(DISTINCT QUERY_TYPE) AS unique_query_types
FROM QUERY_HISTORY_MATERIALIZED;
-- [Optional] End of test. **/


-- 5. Create Stage for the semantic model.
USE ROLE ACCOUNTADMIN;
USE SCHEMA TECHUP25.AGENTIC_AI;
CREATE OR REPLACE STAGE MODELS DIRECTORY = (ENABLE = TRUE);
GRANT WRITE, READ ON STAGE MODELS TO ROLE TECHUP25_RL;

-- Create API Integration and Git Repository
CREATE OR REPLACE API INTEGRATION TKO25_AGENTIC_AI_GIT_API_INTEGRATION
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/mrecos/')
  ENABLED = TRUE;

CREATE OR REPLACE GIT REPOSITORY TKO25_AGENTIC_AI_GIT_INTEGRATION
  API_INTEGRATION = TKO25_AGENTIC_AI_GIT_API_INTEGRATION
  ORIGIN = 'https://github.com/mrecos/Snowflake.git/';

-- Copy the semantic model.yaml file to the models stage
COPY FILES INTO @TECHUP25.AGENTIC_AI.MODELS
  FROM '@TKO25_AGENTIC_AI_GIT_INTEGRATION/branches/main/Snowflake Housekeeping Agent/semantic_model.yaml'
  PATTERN = '.*\\.yaml$';

--6. Create Cortex Agents
USE ROLE ACCOUNTADMIN;
USE ROLE TECHUP25_RL;
USE SCHEMA TECHUP25.AGENTIC_AI;
CREATE OR REPLACE AGENT TECHUP25.AGENTIC_AI.SNOWFLAKE_HOUSEKEEPING_AGENT
WITH PROFILE='{ "display_name": "Snowflake Housekeeping Agent" }'
    COMMENT=$$ This is an agent that can answer questions about Snowflake platform monitoring, cost optimization, and governance questions. $$
FROM SPECIFICATION $$
{
  "models": {
    "orchestration": ""
  },
  "instructions": {
    "response": "You are a data analyst who has access to Snowflake usage and cost.",
    "orchestration": "Use cortex search for known entities and pass the results to cortex analyst for detailed analysis.",
    "sample_questions": [
      {
        "question": "expensive query optimization performance tuning"
      }
    ]
  },
  "tools": [
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "cortex_search_snowflake_query_history",
        "description": "Allows users to query Snowflake query history."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "cortex_analyst_snowflake_query_history ",
        "description": "This is the Platform Health & Governance Model. It provides a unified business layer over the Snowflake ACCOUNT_USAGE schema, designed for platform owners and administrators. The model is optimized for natural language queries with Cortex Analyst, allowing users to proactively manage the environment by asking questions related to cost efficiency, operational performance, and security governance."
      }
    }
  ],
  "tool_resources": {
    "cortex_search_snowflake_query_history": {
      "id_column": "QUERY_TEXT",
      "max_results": 5,
      "name": "TECHUP25.AGENTIC_AI.QUERY_HISTORY_SEARCH_SERVICE",
    },
    "cortex_analyst_snowflake_query_history": {
      "semantic_model_file": "@TECHUP25.AGENTIC_AI.models/semantic_model.yaml",
      "execution_environment": {
        "type": "warehouse",
        "warehouse": "TECHUP25_wh"
      }
    }
  }
}
$$;

--7. Create MCP Server
USE ROLE ACCOUNTADMIN;
USE SCHEMA TECHUP25.AGENTIC_AI;
CREATE OR REPLACE MCP SERVER SNOWFLAKE_HOUSEKEEPING_MCP_SERVER from specification
$$
tools:
  - name: "Snowflake Housekeeping Cortex Search Service"
    identifier: "TECHUP25.AGENTIC_AI.SNOWFLAKE_HOUSEKEEPING_AGENT"
    type: "CORTEX_SEARCH_SERVICE_QUERY"
    description: "A tool that performs keyword and vector search over Snowflake query history."
    title: "Snowflake Housekeeping Cortex Search Service"

  - name: "Snowflake Housekeeping Cortex Analyst"
    identifier: "TECHUP25.AGENTIC_AI.MODELS/semantic_model.yaml"
    type: "CORTEX_ANALYST_MESSAGE"
    description: "A tool that performs structured data analysis over Snowflake query history."
    title: "Snowflake Housekeeping Cortex Analyst"
    config:
        warehouse: "TECHUP25_wh"
$$;
GRANT USAGE ON MCP SERVER SNOWFLAKE_HOUSEKEEPING_MCP_SERVER TO ROLE TECHUP25_RL;

-- 9. Open Cussor and set the Snowflake_TECHUP25 as the MCP server

-- add the following to your .cursor/mcp.json.
--    "Snowflake_TECHUP25": {
--        "url": "https://{your_org_name}.{your_account_name}.snowflakecomputing.com/api/v2/databases/TECHUP25/schemas/AGENTIC_AI/mcp-servers/SNOWFLAKE_HOUSEKEEPING_MCP_SERVER",
--            "headers": {
--              "Authorization": "Bearer {your_pat_token}"
--            }
--      }
--}