---
name: defensive-coder
description: Expert in defensive programming, edge case handling, error recovery, and production-hardened code. Ensures code handles ALL failure scenarios gracefully.
keywords: defensive, edge case, error handling, validation, exception, null check, timeout, retry, fallback, robust, production-ready, failure, crash, abnormal
version: 1.0.0
---

# 🛡️ Defensive Coder - Production-Hardened Code Expert

## Core Philosophy

**"Code for the worst case, hope for the best case."**

Every line of code MUST assume:
- Input will be invalid
- Network will fail
- Resources will be unavailable
- Users will behave unexpectedly

## Activation Triggers

This skill activates when AI detects:
- Keywords: `defensive`, `edge case`, `error handling`, `validation`, `robust`
- Patterns: Writing functions that accept external input
- Context: Production code, API integration, user-facing features
- Review mode: Auditing existing code for vulnerabilities

---

## 🎯 Defensive Programming Checklist

### Phase 1: Input Validation (ALWAYS FIRST)

**Rule:** NEVER trust any input from outside your function.

#### Pattern: Guard Clauses at Top

```typescript
// ❌ BAD: Assume input is valid
function processUser(user: User) {
  console.log(user.name.toUpperCase());  // CRASH if user is null
  return user.email.split('@')[1];        // CRASH if email is undefined
}

// ✅ GOOD: Validate everything first
function processUser(user: User | null | undefined): Result<ProcessedUser, Error> {
  // Guard 1: Null/undefined check
  if (!user) {
    logger.warn("processUser called with null/undefined user");
    return Result.err(new Error("User is required"));
  }
  
  // Guard 2: Required fields
  if (!user.name?.trim()) {
    return Result.err(new Error("User name is required"));
  }
  
  if (!user.email?.includes('@')) {
    return Result.err(new Error("Invalid email format"));
  }
  
  // Now SAFE to proceed
  const processed = {
    name: user.name.toUpperCase(),
    domain: user.email.split('@')[1]
  };
  
  return Result.ok(processed);
}
```

#### Pattern: Type Guards for Union Types

```typescript
// ✅ Runtime type checking
function isValidUser(data: unknown): data is User {
  return (
    typeof data === 'object' &&
    data !== null &&
    'name' in data &&
    'email' in data &&
    typeof (data as User).name === 'string' &&
    typeof (data as User).email === 'string'
  );
}

function handleApiResponse(data: unknown) {
  if (!isValidUser(data)) {
    throw new ValidationError("Invalid user data from API");
  }
  
  // TypeScript now knows data is User
  return processUser(data);
}
```

#### Pattern: Array Safety

```typescript
// ❌ BAD: Assume array has items
const firstItem = items[0];  // undefined if empty
const lastItem = items[items.length - 1];

// ✅ GOOD: Always check length
const firstItem = items.length > 0 ? items[0] : null;
const lastItem = items.at(-1) ?? null;  // Modern approach

// ✅ BETTER: Use optional chaining
items.forEach(item => process(item));  // Safe even if items is []
```

---

### Phase 2: Network & External Dependencies

**Rule:** External systems WILL fail. Handle it gracefully.

#### Pattern: Timeout Protection

```typescript
// ❌ BAD: Infinite wait
const data = await fetch(url);

// ✅ GOOD: Always timeout external calls
const fetchWithTimeout = (url: string, timeoutMs = 30000) => {
  return Promise.race([
    fetch(url),
    new Promise((_, reject) => 
      setTimeout(() => reject(new Error('Request timeout')), timeoutMs)
    )
  ]);
};

const data = await fetchWithTimeout(url);
```

#### Pattern: Retry with Exponential Backoff

```typescript
async function fetchWithRetry<T>(
  operation: () => Promise<T>,
  maxRetries = 3,
  baseDelay = 1000
): Promise<T> {
  let lastError: Error;
  
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await operation();
    } catch (error) {
      lastError = error as Error;
      
      // Don't retry on client errors (4xx)
      if (error instanceof HttpError && error.status < 500) {
        throw error;
      }
      
      // Exponential backoff: 1s, 2s, 4s...
      const delay = baseDelay * Math.pow(2, attempt);
      await sleep(delay);
      
      logger.warn(`Retry attempt ${attempt + 1}/${maxRetries}`, { error, delay });
    }
  }
  
  throw new Error(`Failed after ${maxRetries} retries: ${lastError.message}`);
}
```

#### Pattern: Offline Handling

```typescript
// ✅ Check connectivity before expensive operations
async function syncData() {
  if (!navigator.onLine) {
    showToast("You're offline. Data will sync when connection is restored.");
    queueForLaterSync(data);
    return;
  }
  
  try {
    await api.syncData(data);
    showToast("Sync successful!");
  } catch (error) {
    if (error instanceof NetworkError) {
      // Connection lost during operation
      queueForLaterSync(data);
      showToast("Sync failed. Will retry automatically.");
    } else {
      throw error;  // Unexpected error, re-throw
    }
  }
}
```

#### Pattern: Response Validation

```typescript
// ❌ BAD: Trust API response structure
const users = await api.getUsers();
const firstUser = users.data[0].name;  // CRASH if structure differs

// ✅ GOOD: Validate schema
import { z } from 'zod';

const UserSchema = z.object({
  data: z.array(z.object({
    id: z.string(),
    name: z.string(),
    email: z.string().email()
  }))
});

const response = await api.getUsers();
const validated = UserSchema.safeParse(response);

if (!validated.success) {
  logger.error("Invalid API response", { errors: validated.error });
  throw new Error("API returned unexpected data format");
}

const users = validated.data.data;  // Now type-safe
```

---

### Phase 3: Resource Management

**Rule:** Always clean up resources, even when errors occur.

#### Pattern: Try-Finally for Cleanup

```typescript
// ✅ Guaranteed cleanup
async function processFile(path: string) {
  let file: FileHandle | null = null;
  
  try {
    file = await fs.open(path, 'r');
    const content = await file.readFile();
    return processContent(content);
  } catch (error) {
    logger.error("File processing failed", { path, error });
    throw error;
  } finally {
    // ALWAYS runs, even if error thrown
    await file?.close();
  }
}
```

#### Pattern: Resource Pooling with Limits

```typescript
// ✅ Prevent resource exhaustion
class ConnectionPool {
  private connections: Connection[] = [];
  private readonly maxSize = 10;
  
  async acquire(): Promise<Connection> {
    if (this.connections.length >= this.maxSize) {
      throw new Error("Connection pool exhausted");
    }
    
    const conn = await createConnection();
    this.connections.push(conn);
    return conn;
  }
  
  release(conn: Connection) {
    const index = this.connections.indexOf(conn);
    if (index > -1) {
      this.connections.splice(index, 1);
      conn.close();
    }
  }
}
```

#### Pattern: Memory-Safe Large Data Processing

```typescript
// ❌ BAD: Load everything into memory
const allRecords = await db.query("SELECT * FROM huge_table");  // OOM!
processAllRecords(allRecords);

// ✅ GOOD: Stream/paginate
async function* fetchRecordsInBatches(batchSize = 100) {
  let offset = 0;
  
  while (true) {
    const batch = await db.query(
      "SELECT * FROM huge_table LIMIT ? OFFSET ?",
      [batchSize, offset]
    );
    
    if (batch.length === 0) break;
    
    yield batch;
    offset += batchSize;
  }
}

// Process in chunks
for await (const batch of fetchRecordsInBatches()) {
  await processBatch(batch);
  // Each batch is GC'd after processing
}
```

---

### Phase 4: User Behavior (UI/UX)

**Rule:** Users will click everything, multiple times, at the worst possible moment.

#### Pattern: Idempotent Button Actions

```typescript
// ❌ BAD: Multiple clicks = multiple API calls
<button onClick={handleSubmit}>Submit</button>

// ✅ GOOD: Disable during processing
const [isSubmitting, setIsSubmitting] = useState(false);

const handleSubmit = async () => {
  if (isSubmitting) return;  // Guard against rapid clicks
  
  setIsSubmitting(true);
  try {
    await api.submitForm(data);
    showSuccess();
  } catch (error) {
    showError(error.message);
  } finally {
    setIsSubmitting(false);
  }
};

<button onClick={handleSubmit} disabled={isSubmitting}>
  {isSubmitting ? 'Submitting...' : 'Submit'}
</button>
```

#### Pattern: Confirm Before Destructive Actions

```typescript
// ✅ Always confirm deletion
async function deleteAccount() {
  const confirmed = await showConfirmDialog({
    title: "Delete Account?",
    message: "This action cannot be undone. All your data will be permanently deleted.",
    confirmText: "Delete Forever",
    confirmStyle: "destructive"
  });
  
  if (!confirmed) return;
  
  // Add extra confirmation for high-risk operations
  const typedConfirmation = await showInputDialog({
    title: "Type 'DELETE' to confirm",
    placeholder: "DELETE"
  });
  
  if (typedConfirmation !== "DELETE") {
    showToast("Account deletion cancelled.");
    return;
  }
  
  await api.deleteAccount();
}
```

---

## 🚨 Auto-Fail Review Patterns

When reviewing code, IMMEDIATELY flag these patterns:

### Critical Failures (Block Merge)

```typescript
// 🚫 BLOCK: No null check before property access
user.name
config.apiUrl
response.data.items[0]

// 🚫 BLOCK: Async without error handling
await fetchData()
promise.then(data => process(data))

// 🚫 BLOCK: Array access without bounds check
items[0]
users[index]

// 🚫 BLOCK: JSON parsing without try-catch
JSON.parse(str)
JSON.stringify(obj)

// 🚫 BLOCK: External call without timeout
fetch(url)
axios.get(url)

// 🚫 BLOCK: Resource without cleanup
const file = fs.openSync(path)
const connection = await db.connect()
```

### Medium Severity (Require Fix)

```typescript
// ⚠️ WARN: No loading state for async operations
// ⚠️ WARN: No error message display to user
// ⚠️ WARN: Hardcoded retry count/timeout values
// ⚠️ WARN: No logging for error scenarios
// ⚠️ WARN: No fallback UI for empty states
```

---

## 📚 Code Templates

### Template 1: Safe API Call Wrapper

```typescript
type ApiResult<T> = 
  | { success: true; data: T }
  | { success: false; error: string };

async function safeApiCall<T>(
  operation: () => Promise<T>,
  options: {
    timeout?: number;
    retries?: number;
    fallback?: T;
  } = {}
): Promise<ApiResult<T>> {
  const { timeout = 30000, retries = 3, fallback } = options;
  
  try {
    const result = await fetchWithRetry(
      () => withTimeout(operation(), timeout),
      retries
    );
    
    return { success: true, data: result };
  } catch (error) {
    logger.error("API call failed", { error, options });
    
    if (fallback !== undefined) {
      return { success: true, data: fallback };
    }
    
    return { 
      success: false, 
      error: error instanceof Error ? error.message : "Unknown error" 
    };
  }
}

// Usage
const result = await safeApiCall(() => api.getUser(id), {
  timeout: 5000,
  retries: 2,
  fallback: { id, name: "Unknown User" }
});

if (result.success) {
  displayUser(result.data);
} else {
  showError(result.error);
}
```

### Template 2: Safe Form Submission

```typescript
async function handleFormSubmit(formData: FormData) {
  // 1. Validate input
  const validation = validateFormData(formData);
  if (!validation.success) {
    showErrors(validation.errors);
    return;
  }
  
  // 2. Prevent double submission
  if (isSubmitting.current) return;
  isSubmitting.current = true;
  
  // 3. Show loading state
  setLoading(true);
  
  try {
    // 4. Submit with timeout
    const result = await withTimeout(
      api.submitForm(validation.data),
      10000
    );
    
    // 5. Handle success
    showSuccess("Form submitted successfully!");
    resetForm();
    
  } catch (error) {
    // 6. Categorize errors
    if (error instanceof ValidationError) {
      showErrors(error.fields);
    } else if (error instanceof NetworkError) {
      showError("Network error. Please check your connection and try again.");
    } else if (error instanceof TimeoutError) {
      showError("Request timed out. Please try again.");
    } else {
      showError("An unexpected error occurred. Please try again later.");
      logger.error("Form submission error", { error, formData });
    }
  } finally {
    // 7. Always cleanup
    setLoading(false);
    isSubmitting.current = false;
  }
}
```

---

## 🎯 Skill Application Rules

### When AI Uses This Skill:

1. **All production code** - Assume this skill is ALWAYS active
2. **Before writing ANY function** - Think: "What can go wrong?"
3. **During code review** - Scan for missing error handling
4. **When integrating external APIs** - Apply network patterns
5. **When handling user input** - Apply validation patterns

### Skill Output Format:

When generating defensive code, AI MUST:

1. **Add comment explaining the defensive measure:**
   ```typescript
   // Defensive: Check for null to prevent crash on invalid API response
   if (!data?.user) {
     return defaultUser;
   }
   ```

2. **Provide fallback behavior:**
   ```typescript
   // Fallback to cached data if network fails
   const users = await fetchUsers().catch(() => getCachedUsers());
   ```

3. **Log defensive actions:**
   ```typescript
   logger.warn("Invalid input detected", { input, expected: "non-empty string" });
   ```

---

## 🏆 Success Metrics

Code is "Defensively Hardened" when:

- ✅ Zero null-reference crashes
- ✅ All async operations have timeout
- ✅ All external calls have retry logic
- ✅ All user inputs are validated
- ✅ All resources are cleaned up in finally
- ✅ All error scenarios have user-friendly messages
- ✅ App never shows blank/crashed screen to users

**Motto:** "If it can fail, it will fail. Be ready."
