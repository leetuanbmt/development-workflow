# Code Review Checklist

> **Purpose:** A systematic framework to ensure code quality, security, and maintainability.
> **Usage:** Reference this checklist during every `/review-code` session.

## 1. Pre-Review
- [ ] **Context:** Understand the problem being solved and requirements.
- [ ] **CI/CD:** Check if automated tests pass.
- [ ] **Scope:** Verify the PR description matches the file changes.

## 2. Functionality
- [ ] **Solves Problem:** Code addresses the stated requirements.
- [ ] **Edge Cases:** Null values, empty lists, network errors are handled.
- [ ] **Validation:** User input is validated before processing.
- [ ] **Logic:** No off-by-one errors, infinite loops, or incorrect conditions.

## 3. Security (Critical)
- [ ] **Injection:** No SQL injection (use ORM parameters) or XSS.
- [ ] **Secrets:** No hardcoded API keys or credentials.
- [ ] **Auth:** Authentication checks on sensitive endpoints/actions.
- [ ] **Data:** Sensitive data is not logged or exposed.

## 4. Performance
- [ ] **Rendering:** Minimize unnecessary rendering/re-painting.
- [ ] **Async:** Heavy computations are offloaded to Background Threads/Workers.
- [ ] **Memory:** Event Listeners and Controllers are disposed properly.
- [ ] **Database:** Efficient queries (Indices utilized).

## 5. Code Quality (Clean Architecture)
- [ ] **Readability:** Naming is clear (e.g., `isUserLoggedIn` vs `flag`).
- [ ] **DRY:** No duplicated logic; logic extracted to UseCases/Utils.
- [ ] **Structure:** Domain layer is pure (User/Business Logic); no UI imports in Data layer.
- [ ] **Functions:** Small, focused, Single Responsibility Principle.

## 6. Tests
- [ ] **Coverage:** New logic has corresponding Unit/Widget tests.
- [ ] **Quality:** Tests cover happy paths AND failure scenarios.

## 7. Documentation
- [ ] **Comments:** Explain "Why", not "What".
- [ ] **Docs:** Public APIs have proper documentation/docstrings.
- [ ] **Migration:** Database migrations are documented if schema changed.
