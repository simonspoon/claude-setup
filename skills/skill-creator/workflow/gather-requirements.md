# Gather Requirements

Ask user clarifying questions when skill requirements are unclear.

## When to Use This Workflow

Use when:
- User said "create a skill" without details
- Unclear what the skill should do
- Don't know when skill should trigger
- Uncertain about scope or complexity

## ⚠️ CRITICAL: Don't Guess

Do NOT create a skill without clear requirements.
Do NOT assume what the user wants.
DO ask questions to understand needs.

## Questions to Ask

Ask these questions to gather requirements:

### 1. Purpose Question

**Ask:**
"To create this skill, I need to understand its purpose. What specific operations or tasks should it perform?"

**What you're looking for:**
- What the skill does (core functionality)
- What outputs it produces
- What problems it solves

**Example responses:**
- "Generate SQL queries for our database"
- "Format JSON and XML files"
- "Review code for security issues"

### 2. Trigger Question

**Ask:**
"When should this skill be activated? What keywords or scenarios should trigger it?"

**What you're looking for:**
- Keywords users might say
- File types or extensions
- Tools or technologies mentioned
- Activities that need the skill

**Example responses:**
- "When I mention SQL, databases, or queries"
- "When I upload .json or .xml files"
- "When I ask for code review or mention pull requests"

### 3. Scope Question

**Ask:**
"Should this be a simple skill (single file with basic examples) or comprehensive (multiple files with scripts and detailed docs)?"

**What you're looking for:**
- Complexity level
- Need for automation
- Amount of documentation required

**Example responses:**
- "Simple - just need basic formatting"
- "Comprehensive - needs validation scripts and templates"

### 4. Examples Question

**Ask:**
"Can you provide an example of how you'd use this skill? What would the input and output look like?"

**What you're looking for:**
- Concrete use case
- Input format
- Expected output
- Edge cases

**Example responses:**
- "Input: compact JSON. Output: formatted with indentation"
- "Input: SQL table name. Output: query template"

### 5. Dependencies Question (if relevant)

**Ask:**
"Does this skill use any specific tools, libraries, or APIs?"

**What you're looking for:**
- External dependencies
- Programming languages
- Tools or frameworks

**Example responses:**
- "Uses pandas and matplotlib"
- "Company's internal API"
- "PostgreSQL database"

## Example Dialogue

**User:** "Create a skill for data stuff"

**Assistant (gathering requirements):**
"To create this skill, I need to understand its purpose. What specific operations or tasks should it perform with data?"

**User:** "I need to analyze CSV files and create charts"

**Assistant:**
"When should this skill be activated? What keywords should trigger it?"

**User:** "When I mention CSV, data analysis, or charts"

**Assistant:**
"Does this use any specific tools or libraries?"

**User:** "Yes, pandas for data and matplotlib for charts"

**Assistant:**
"Should this be a simple skill with basic examples, or comprehensive with scripts and detailed documentation?"

**User:** "Simple is fine, just common operations"

**Assistant:**
"Great! I'll create a tool wrapper skill for data analysis using pandas and matplotlib. It will trigger on keywords like 'CSV', 'data analysis', 'pandas', and 'charts'."

## Requirements Checklist

Before creating skill, ensure you have:

- [ ] Clear description of what skill does
- [ ] List of trigger keywords/scenarios
- [ ] Complexity level (minimal, tool wrapper, workflow, knowledge base, comprehensive)
- [ ] At least one concrete example of usage
- [ ] Dependencies/tools identified (if any)
- [ ] Any critical requirements or constraints

## Decision Framework

After gathering requirements, choose pattern:

**If simple operations, single file:**
→ Read [../patterns/minimal-skill.md](../patterns/minimal-skill.md)

**If wrapping tool/library:**
→ Read [../patterns/tool-wrapper.md](../patterns/tool-wrapper.md)

**If encoding process/workflow:**
→ Read [../patterns/workflow-process.md](../patterns/workflow-process.md)

**If providing reference docs:**
→ Read [../patterns/knowledge-base.md](../patterns/knowledge-base.md)

**If complex with scripts:**
→ Read [../patterns/comprehensive-skill.md](../patterns/comprehensive-skill.md)

## Common Scenarios

### Scenario 1: User Provides Vague Request

**User:** "Make a skill for Python stuff"

**Your response:**
"Python covers many areas. To create the right skill, I need to know:
1. What specific Python operations do you need? (e.g., file handling, web scraping, data analysis)
2. When should it trigger? (e.g., when you mention specific libraries or tasks)
3. Do you have an example of how you'd use it?"

### Scenario 2: User Mentions Tool Without Context

**User:** "Create a skill for our API"

**Your response:**
"To create an API skill, I need to understand:
1. What API operations are most common? (authentication, data queries, webhooks)
2. What keywords should trigger it? (API name, endpoint types, etc.)
3. Do you have API documentation I should reference?
4. Should this include example requests/responses?"

### Scenario 3: User Has Clear Requirements

**User:** "Create a skill to format JSON files. It should trigger when I mention JSON, formatting, or prettify. Just needs basic functionality."

**Your response:**
"Perfect! I have everything I need:
- Purpose: Format JSON files
- Triggers: JSON, formatting, prettify
- Scope: Simple/minimal
I'll create a minimal skill with JSON formatting examples."

## When Requirements Are Still Unclear

If after asking questions, requirements are still unclear:

**Ask:**
"I want to make sure I create the right skill for you. Could you describe a specific situation where you'd use this skill? What would you ask me to do, and what result would you expect?"

This often reveals:
- Real use case
- Actual workflow
- True requirements

## Red Flags

Stop and ask more questions if:

- User's description is <10 words
- No trigger keywords mentioned
- Can't tell if it's simple or complex
- Multiple different purposes mentioned
- Unclear which tools/technologies involved

Don't proceed until you have clarity.

## After Gathering Requirements

Once you have clear requirements:

1. **Summarize** what you understood
2. **Confirm** with user you got it right
3. **Choose pattern** from patterns/INDEX.md
4. **Create skill** following chosen pattern
5. **Validate** using validation/CHECKLIST.md

## Related Workflows

- [create-from-requirements.md](create-from-requirements.md) - When requirements are clear
- [../patterns/INDEX.md](../patterns/INDEX.md) - Choose skill pattern
