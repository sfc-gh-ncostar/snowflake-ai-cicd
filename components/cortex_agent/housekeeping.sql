USE ROLE TECHUP25_RL;
SET env = '<%env%>';
set name = CONCAT('TECHUP25.', $env ,'_AGENTIC_AI.','SNOWFLAKE_HOUSEKEEPING_AGENT');
CREATE OR REPLACE AGENT identifier($name)
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
        "type": "cortex_search",
        "name": "cortex_snowflake_documentation",
        "description": "Allows users to get documentations from Snowflake Documentation."
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
    "cortex_snowflake_documentation": {
      "id_column": "CHUNK",
      "max_results": 5,
      "name": "SNOWFLAKE_DOCUMENTATION.SHARED.CKE_SNOWFLAKE_DOCS_SERVICE",
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