# {{PROJECT_NAME}} - Conventions & Standards

> **Last Updated:** {{DATE}}

---

## 1. Git Conventions

### Branch Naming

- **Feature:** `feature/{{FEATURE_NAME}}`
- **Bugfix:** `fix/{{BUG_NAME}}`
- **Hotfix:** `hotfix/{{HOTFIX_NAME}}`
- **Release:** `release/v{{VERSION}}`

### Commit Message Format

**Template:**

```
{{COMMIT_MESSAGE_TEMPLATE}}
```

**Example:**

```
{{COMMIT_MESSAGE_EXAMPLE}}
```

### PR Title Format

```
{{PR_TITLE_FORMAT}}
```

---

## 2. Folder & File Organization

### Feature Folder Structure

```
features/{{feature_name}}/
├── data/
│   ├── data_sources/
│   ├── models/
│   ├── repositories/
│   └── mappers/
├── domain/
│   ├── entities/
│   ├── repositories/     (interfaces)
│   └── use_cases/
└── presentation/
    ├── pages/
    ├── widgets/
    ├── blocs/
    └── routes/
```

### File Organization Rules

- {{FILE_ORG_RULE_1}}
- {{FILE_ORG_RULE_2}}
- {{FILE_ORG_RULE_3}}

---

## 3. API Naming Conventions

### Endpoint Naming

- **Pattern:** {{API_ENDPOINT_PATTERN}}
- **Resource Plural:** {{API_PLURAL_RULE}}
- **Versioning:** {{API_VERSIONING_STRATEGY}}

### Request/Response Fields

- **Naming:** {{REQUEST_FIELD_NAMING}}
- **Timestamps:** {{TIMESTAMP_FORMAT}}
- **IDs:** {{ID_FORMAT}}

---

## 4. Database Column Conventions

- **Table Names:** {{TABLE_NAMING}}
- **Column Names:** {{COLUMN_NAMING}}
- **Primary Keys:** {{PRIMARY_KEY_NAMING}}
- **Foreign Keys:** {{FOREIGN_KEY_NAMING}}
- **Timestamps:** {{TIMESTAMP_COLUMNS}}

---

## 5. Environment Configuration

### Environment Variables

- **Format:** {{ENV_VAR_FORMAT}}
- **Naming:** {{ENV_VAR_NAMING}}
- **Files:** {{ENV_FILE_LOCATIONS}}

### Example

```
{{ENV_EXAMPLE}}
```

---

## 6. Error/Exception Naming

- **Exception Class Format:** {{EXCEPTION_NAMING}}
- **Error Messages:** {{ERROR_MESSAGE_FORMAT}}
- **HTTP Status Codes:** {{HTTP_STATUS_CONVENTION}}

### Example

```
{{EXCEPTION_EXAMPLE}}
```

---

## 7. Logging Conventions

- **Logger Naming:** {{LOGGER_NAMING}}
- **Log Levels:** {{LOG_LEVELS_USAGE}}
- **Message Format:** {{LOG_MESSAGE_FORMAT}}

### Example

```
{{LOG_EXAMPLE}}
```

---

## 8. Date/Time Conventions

- **Format:** {{DATETIME_FORMAT}}
- **Timezone:** {{TIMEZONE_STANDARD}}
- **Serialization:** {{DATETIME_SERIALIZATION}}

---

## 9. String & Resource Management

- **i18n Keys:** {{I18N_KEY_FORMAT}}
- **Config Keys:** {{CONFIG_KEY_FORMAT}}
- **Asset Naming:** {{ASSET_NAMING_CONVENTION}}

---

## 10. Version Numbering

- **Format:** {{VERSION_FORMAT}}
- **Increment Rules:** {{VERSION_INCREMENT_RULES}}
- **Release Cycle:** {{RELEASE_CYCLE}}
