# {{PROJECT_NAME}} - Code Style Guidelines

> **Last Updated:** {{DATE}}  
> **Language:** {{PRIMARY_LANGUAGE}}  
> **Framework:** {{FRAMEWORK}}

---

## 1. Naming Conventions

### Classes & Types

```
{{PRIMARY_LANGUAGE}}: {{CLASS_NAMING_CONVENTION}}

Example:
{{CLASS_NAMING_EXAMPLE}}
```

### Functions & Methods

```
{{FUNCTION_NAMING_CONVENTION}}

Example:
{{FUNCTION_NAMING_EXAMPLE}}
```

### Variables & Constants

```
Variables: {{VARIABLE_NAMING_CONVENTION}}
Constants: {{CONSTANT_NAMING_CONVENTION}}
Enums: {{ENUM_NAMING_CONVENTION}}

Examples:
{{NAMING_EXAMPLES}}
```

### File Names

```
{{FILE_NAMING_CONVENTION}}

Examples:
{{FILE_NAMING_EXAMPLES}}
```

---

## 2. Formatting Rules

### Indentation & Spacing

- **Indentation:** {{INDENT_SIZE}} spaces
- **Line Length:** {{MAX_LINE_LENGTH}} characters
- **Trailing Whitespace:** Not allowed
- **Blank Lines:** {{BLANK_LINES_RULE}}

### Formatting Tool

- **Tool:** {{FORMAT_TOOL}} (Auto-format on save)
- **Command:** `{{FORMAT_COMMAND}}`
- **Config File:** {{FORMAT_CONFIG_FILE}}

---

## 3. Import Organization

### Order

1. {{IMPORT_ORDER_1}}
2. {{IMPORT_ORDER_2}}
3. {{IMPORT_ORDER_3}}

### Example

```
{{IMPORT_EXAMPLE}}
```

### Rules

- Remove unused imports: {{UNUSED_IMPORT_RULE}}
- Avoid wildcard imports: {{WILDCARD_IMPORT_RULE}}
- Group related imports: {{GROUPED_IMPORT_RULE}}

---

## 4. Comments & Documentation

### Inline Comments

- **Style:** {{INLINE_COMMENT_STYLE}}
- **When to use:** {{INLINE_COMMENT_WHEN}}
- **Example:**
  ```
  {{INLINE_COMMENT_EXAMPLE}}
  ```

### Documentation Comments

- **Style:** {{DOC_COMMENT_STYLE}}
- **Coverage:** {{DOC_COMMENT_COVERAGE}}
- **Example:**
  ```
  {{DOC_COMMENT_EXAMPLE}}
  ```

### README in Folders

- **Purpose:** {{README_PURPOSE}}
- **Content:** {{README_CONTENT}}

---

## 5. Return Statements & Error Handling

### Return Statements

- **Style:** {{RETURN_STYLE}}
- **Multiple Returns:** {{MULTIPLE_RETURNS_STYLE}}

### Error Handling

- **Exception Type:** {{ERROR_TYPE}}
- **Handling Strategy:** {{ERROR_HANDLING_STRATEGY}}
- **Logging:** {{ERROR_LOGGING_STYLE}}

### Null Safety

- **Approach:** {{NULL_SAFETY_APPROACH}}
- **Tools:** {{NULL_SAFETY_TOOLS}}

---

## 6. Collections & Data Structures

### Lists/Arrays

- **Mutable by default?** {{MUTABLE_BY_DEFAULT}}
- **Use `final` where:** {{FINAL_USAGE}}
- **Naming:** {{COLLECTION_NAMING}}

### Maps/Dictionaries

- **Key Naming:** {{MAP_KEY_NAMING}}
- **Iteration Style:** {{MAP_ITERATION_STYLE}}

---

## 7. Async & Concurrency

### Async/Promise/Observable

- **Pattern:** {{ASYNC_PATTERN}}
- **Naming Convention:** {{ASYNC_NAMING}}
- **Error Handling:** {{ASYNC_ERROR_HANDLING}}
- **Timeouts:** {{ASYNC_TIMEOUT_STRATEGY}}

### Example

```
{{ASYNC_CODE_EXAMPLE}}
```

---

## 8. Testing Code Style

### Test File Naming

- **Convention:** {{TEST_FILE_NAMING}}
- **Location:** {{TEST_FILE_LOCATION}}

### Test Method Naming

- **Pattern:** `{{TEST_METHOD_PATTERN}}`
- **Example:** `{{TEST_METHOD_EXAMPLE}}`

### Test Structure

```
{{TEST_STRUCTURE_EXAMPLE}}
```

### Assertions

- **Framework:** {{ASSERTION_FRAMEWORK}}
- **Style:** {{ASSERTION_STYLE}}

---

## 9. Linting & Static Analysis

### Tools

- **Primary Linter:** {{LINTER_TOOL}}
- **Configuration File:** {{LINTER_CONFIG}}
- **Run Command:** `{{LINT_COMMAND}}`

### Important Rules

- {{IMPORTANT_LINT_RULE_1}}
- {{IMPORTANT_LINT_RULE_2}}
- {{IMPORTANT_LINT_RULE_3}}

### Warnings as Errors

- **Enabled?** {{WARNINGS_AS_ERRORS}}
- **Exception Rules:** {{LINT_EXCEPTION_RULES}}

---

## 10. Accessibility & Localization

### Translations

- **i18n Framework:** {{I18N_FRAMEWORK}}
- **String Storage:** {{STRING_STORAGE_LOCATION}}
- **Naming Convention:** {{I18N_KEY_NAMING}}

### Accessibility Standards

- **Target Standard:** {{A11Y_STANDARD}}
- **Key Practices:** {{A11Y_PRACTICES}}

---

## 11. Quick Reference

**Run all checks:**

```
{{RUN_ALL_CHECKS_COMMAND}}
```

**Auto-format code:**

```
{{AUTO_FORMAT_COMMAND}}
```

**Run linter:**

```
{{LINT_COMMAND}}
```

**Run tests:**

```
{{TEST_COMMAND}}
```
