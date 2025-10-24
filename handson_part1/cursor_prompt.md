## Final Delivery and End Results

Upon completion of this workflow, you will have generated the following production-ready files that can be directly used in Cortex Agent setup:
Generated Configuration Files

1.agent_description.md

- Purpose: Core agent identity and scope definition
- Content: Concise executive-focused description with clear role, target users, capabilities, and limitations
- Usage: Direct copy-paste into Cortex Agent description field

2.tool_descriptions.md

- Purpose: Tool capability definitions for agent understanding
- Content: Concise descriptions of when to use each tool (Cortex Analyst, Cortex Search, Custom tools)
- Usage: Reference for agent tool selection logic

3.orchestration_instructions.md

- Purpose: Multi-tool coordination and parallel execution logic
- Content: Step-by-step orchestration patterns, business rules, and decision trees
- Usage: Core agent instructions for tool selection and coordination

4.response_instructions.md

- Purpose: Professional formatting and communication standards
- Content: User-focused response patterns, data formatting rules, and business context integration
- Usage: Agent response quality and formatting guidelines

5.testing_strategy.md(Optional)

- Purpose: Comprehensive validation and quality assurance
- Content: 50+ test questions covering in-scope, out-of-scope, and edge cases
- Usage: Agent testing and validation framework

## 1. Generate Agent Description

Use this Cursor prompt to generate a clear, user-focused agent description:

```cursor
@snowflake_agent_best_practices.md @Snowflake_Cortex_Agent

Generate a concise agent description (50-100 words) following Snowflake best practices and save it to agent_description.md:

CONTEXT:
- Business domain: ["Snowflake Administrators"]
- Primary users: ["Analysts"]
- Secondary users: ["Managers"]
- Company context: ["Snowflake User"]
- Critical user journeys: ["To check snowflake query cost and performance"]
- Data access limitations: ["Private data can't access if it is found"]

REQUIREMENTS:
- Clear role definition with specific purpose and target users
- Focus on core capabilities and business value propositions
- Include scope limitations and what questions to decline
- Professional tone with domain expertise
- Keep it concise and actionable
- PROFILE in Cortex Agents object has only "display_name" key, NOT include other keys.
- A generated description must be set to COMMENTS in Cortex Agents object

OUTPUT: Update COMMENT and PROFILE parameters of cortex agents in cortex_agents.sql with a concise agent description that follows Snowflake best practices. Also, Create/replace the same contents with agent_description.md under handson_part1/output folder.
```

## 2. Generate Tool Descriptions

Use this Cursor prompt to generate clear descriptions for each tool:

```cursor
@snowflake_agent_best_practices.md @Snowflake_Cortex_Agent @Snowflake_Cortex_Analyst @Snowflake_Cortex_Search

Generate concise tool descriptions for Cortex Agent configuration. Update description in tool_spec column of cortex_agents.sql and save it to tool_descriptions.md:

CONTEXT:
- Available tools: Cortex Analyst [yaml/semantic_model.yaml], Cortex Search [Allowing users to query Snowflake query history] and [Snowflake Official Document as Cortex Knowledge Base Service]
- Business domain: ["Snowflake Administrators and Users"]
- User personas: ["Analysts will check query attribution and cost as well as Snowflake offical document"]
- Data types available: [structured data, two knowledge bases]

REQUIREMENTS:
- Focus ONLY on tool descriptions (no tool selection strategies, decision trees, or conflict resolution)
- Each tool description should be 2-3 sentences maximum
- Format: "This [tool type] provides [data type] for [business context]. Use this tool for [specific use cases]. It contains [data details]. Query this [tool type] when users ask about [specific scenarios]."
- Keep descriptions concise and focused on capabilities and use cases
- Update ONLY **description** column in tool_spec

OUTPUT: Update description in tool_spec column of cortex_agents.sql and Create or replace the same and concise tool descriptions with tool_descriptions.md under handson_part1/output folder file for Cortex Agent configuration.
```

## 3. Generate Orchestration Instructions

Use this Cursor prompt to generate sophisticated orchestration logic:

```cursor
@snowflake_agent_best_practices.md @Snowflake_Cortex_Agent @Snowflake_Cortex_Analyst @Snowflake_Cortex_Search

Generate crisp, specific orchestration instructions following Snowflake best practices and update cortex_agents.sql/save it to orchestration_instructions.md:

CONTEXT:
- Available tools:  Cortex Analyst [yaml/semantic_model.yaml], Cortex Search [Allowing users to query Snowflake query history] and [Snowflake Official Document as Cortex Knowledge Base Service]
- Business domain: ["Snowflake Administrators and Users"]
- User personas: ["Analysts will check query attribution and cost as well as Snowflake offical document"]
- Critical user journeys: [This is for typical step-by-step reasoning logic that agent should follow]
- Business processes: [This is for specific business logic and how agent should perform, select tool, coordination, routing, make decision etc]
- Data access: [Private data can't access if it is found]

REQUIREMENTS:
- OVERALL: Parallelize as many tool calls as possible for latency optimization
- Include concrete examples and sample questions for each tool category
- Provide specific step-by-step instructions for multi-tool scenarios
- Handle edge cases with concrete fallback strategies
- Include business context and domain-specific logic
- Generate specific business rules and decision trees
- Include tool-specific usage patterns with examples
- Add parallel execution patterns for complex queries
- Include data access controls and filtering requirements
- Please update ONLY "orchestration" and "sample_questions" column in cortex_agents.sql, not update other columns

ORCHESTRATION FORMAT:
1. Use "For [question type] questions: Use [Tool Name]" format
2. Include 2-3 sample questions for each tool category
3. Provide specific step-by-step instructions
4. Handle edge cases with concrete fallback strategies
5. Include business context and domain-specific rules
6. Add parallel execution patterns
7. Include data access and filtering guidelines

OUTPUT: Update ONLY "orchestration" and "sample_questions" column in cortex_agents.sql and create orchestration_instructions.md under handson_part1/output folder file with crisp, specific orchestration instructions that follow Snowflake best practices
```

## 4. Generate Response Instructions

Use this Cursor prompt to generate comprehensive response guidelines

```cursor
@snowflake_agent_best_practices.md @Snowflake_Cortex_Agent

Generate crisp, specific response instructions following Snowflake best practices and update cortex_agents.sql/save it to response_instructions.md:

CONTEXT:
- Business domain: ["Snowflake Administrators and Users"]
- User personas: ["Analysts will check query attribution and cost as well as Snowflake offical document"]
- Communication style: [professional] 
- Business terminology: [Data specialist]
- Data access: [Private data can't access if it is found]

REQUIREMENTS:
- Include concrete formatting instructions (e.g., "Show in table format", "Format dates as YYYY-MM-DD")
- Provide specific edge case handling (multiple results, no results, ambiguous queries)
- Include business context and domain-specific terminology
- Add specific error handling and fallback strategies
- Generate style guidelines and communication standards
- Include data access warnings and scope limitations
- Add specific formatting rules for different data types
- Include business context integration requirements
- Add performance optimization guidelines
- Update ONLY "response" column in cortex_agents.sql

RESPONSE FORMAT:
1. Start with specific tone and style guidelines
2. Include concrete formatting instructions
3. Provide specific edge case handling
4. Include business context and domain-specific terminology
5. Add specific error handling and fallback strategies
6. Include data access warnings and disclaimers
7. Add performance optimization guidelines

OUTPUT: Update ONLY "response" column in cortex_agents.sql and create response_instructions.md under handson_part1/output folder file with crisp, specific response instructions that follow Snowflake best practices
```

## 5. Generate Testing Strategy (Optional)

Use this Cursor prompt to generate comprehensive testing approach:

```cursor
@snowflake_agent_best_practices.md @Snowflake_Cortex_Agent

Generate testing strategy following Snowflake best practices and save it to testing_strategy.md:

CONTEXT:
- Business domain: ["Snowflake Administrators and Users"]
- User personas: ["Analysts will check query attribution and cost as well as Snowflake offical document"]
- Critical user journeys: [This is for typical step-by-step reasoning logic that agent should follow]
- Business processes: [This is for specific business logic and how agent should perform, select tool, coordination, routing, make decision etc]
- Data access: [Private data can't access if it is found]

REQUIREMENTS:
- Test scenarios including in-scope, out-of-scope, and edge cases
- Business best practices and workflow automation
- Scope limitations and alternative responses
- Data access guidelines and gap handling
- Include 50-100 specific test questions covering all scenarios

TESTING FORMAT:
1. In-scope test questions (30-40 questions)
2. Out-of-scope test questions (10-15 questions)
3. Edge case scenarios (10-15 questions)
4. Business workflow validation questions (10-15 questions)
5. Error handling and fallback scenarios (5-10 questions)

OUTPUT: Create testing_strategy.md file under handson_part1/output folder with comprehensive testing strategy that follows Snowflake best practices.
```
