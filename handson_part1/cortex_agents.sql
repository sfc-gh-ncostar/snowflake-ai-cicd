USE ROLE TECHUP25_RL;
USE SCHEMA TECHUP25.AGENTIC_AI;
CREATE OR REPLACE AGENT TECHUP25.AGENTIC_AI.SNOWFLAKE_HOUSEKEEPING_AGENT
WITH PROFILE='{ "display_name": "Snowflake Housekeeping Agent" }'
    COMMENT=$$ Snowflake Housekeeping Agent helps analysts and managers monitor query cost and performance across the account. It detects expensive queries, bottlenecks, and trends, and recommends best‑practice optimizations to reduce spend and improve efficiency. Using Cortex Search and Cortex Analyst over sanctioned usage data, it provides clear, dependable insights. The agent will not access or expose private or restricted data and will decline requests requiring unauthorized access. Built for Snowflake administrators, it supports proactive governance and reliable, actionable decisions. $$
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
        "description": "This Cortex Search provides query history snippets and execution metadata for Snowflake administrators and users. Use this tool for investigating expensive or slow queries, ownership attribution, and execution patterns, and when users ask about cost drivers, performance outliers, or who ran a query on a date. It contains indexed QUERY_TEXT with runtime, warehouse, user, and timing details."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_search",
        "name": "cortex_snowflake_documentation",
        "description": "This Cortex Search provides Snowflake official documentation content for product guidance. Use this tool for feature explanations, SQL syntax, limits, and configuration references, and when users ask how-to questions, error meanings, or best-practice configurations. It contains curated documentation chunks indexed for fast retrieval."
      }
    },
    {
      "tool_spec": {
        "type": "cortex_analyst_text_to_sql",
        "name": "cortex_analyst_snowflake_query_history ",
        "description": "This Cortex Analyst provides structured analytics over account usage and query history for Snowflake administrators and analysts. Use this tool for natural-language questions that require SQL against the semantic model (e.g., costs by warehouse, top expensive users, performance trends) and when users need governed metrics and drill-downs. It contains yaml/semantic_model.yaml mapped to ACCOUNT_USAGE with governed dimensions and measures."
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
