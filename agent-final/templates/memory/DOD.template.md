# {{PROJECT_NAME}} - Definition of Done (DoD)

> **Last Updated:** {{DATE}}  
> **Purpose:** Checklist to determine when work is truly complete

---

## Engineering Excellence

### Code Quality

- [ ] **Zero Linter Errors:** `{{LINT_COMMAND}}` passes with 0 warnings
- [ ] **Code Formatted:** `{{FORMAT_COMMAND}}` applied
- [ ] **No Hardcoded Values:** All magic values are named constants
- [ ] **No Debug Logs:** Removed `print()`, `console.log()`, etc.
- [ ] **No Dead Code:** Removed unused imports, functions, variables

### Clean Architecture

- [ ] **Layer Separation:** Code respects Domain/Data/Presentation layers (if applicable)
- [ ] **Dependency Rule:** No upward dependencies (Presentation → Domain ← Data)
- [ ] **No Circular Dependencies:** `{{CIRCULAR_DEPENDENCY_CHECK_CMD}}`
- [ ] **Meaningful Names:** Classes, functions, variables have clear purpose

### Testing

- [ ] **Unit Tests Written:** Domain logic & repositories have tests
- [ ] **Test Coverage:** Minimum {{COVERAGE_MIN}}% (target {{COVERAGE_TARGET}}%)
- [ ] **Tests Pass:** `{{TEST_COMMAND}}` passes 100%
- [ ] **Edge Cases Covered:** Tests include success, error, empty cases
- [ ] **No Flaky Tests:** Tests pass consistently (3 consecutive runs)

### Error Handling

- [ ] **Try-Catch Blocks:** Error scenarios are handled
- [ ] **User-Friendly Messages:** Errors show friendly messages, not tech details
- [ ] **Fallback Behavior:** App gracefully handles API failures, network issues
- [ ] **Logging:** Important errors are logged for debugging

---

## Product Requirements

### User-Facing Functionality

- [ ] **Requirements Met:** Feature satisfies all acceptance criteria
- [ ] **UI States Handled:** Loading, Success, Error, Empty states implemented
- [ ] **Accessibility:** Follows {{A11Y_STANDARD}} standards
  - [ ] Keyboard navigation works
  - [ ] Screen reader compatible
  - [ ] Color contrast adequate
- [ ] **Responsive Design:** Works on {{SUPPORTED_SCREEN_SIZES}}

### Data & Localization

- [ ] **i18n Integrated:** All user-facing strings use translation keys
- [ ] **No Hardcoded Strings:** zero hardcoded text strings in code
- [ ] **RTL Support:** {{RTL_SUPPORT_REQUIREMENT}}
- [ ] **Data Serialization:** Proper format (JSON, protobuf, etc.)

### API Integration

- [ ] **API Contract Complete:** Request/response schemas documented
- [ ] **Auth Implemented:** {{AUTH_METHOD}} authentication configured
- [ ] **Error Codes Handled:** All API error codes have user message
- [ ] **Rate Limiting:** Respects {{RATE_LIMIT}} policy
- [ ] **Timeout Handling:** Configured {{TIMEOUT_SECONDS}}s timeout with retry

---

## Performance & Optimization

### Loading & Responsiveness

- [ ] **Page Load:** {{PAGE_LOAD_TARGET}}ms (first meaningful paint)
- [ ] **App Startup:** {{APP_STARTUP_TARGET}}ms
- [ ] **No Jank:** Animations run at {{FRAME_RATE}}fps
- [ ] **No ANR/Freezes:** No Application Not Responding events

### Memory & Resources

- [ ] **Memory Profiling:** {{MEMORY_PROFILE_TOOL}} shows {{MEMORY_TARGET}}MB peak
- [ ] **Leaks Checked:** No memory leaks detected
- [ ] **Efficient Caching:** {{CACHING_STRATEGY}} implemented correctly
- [ ] **Bundle Size:** {{BUNDLE_SIZE_TARGET}}MB (iOS: {{IOS_BUNDLE_TARGET}}MB, Android: {{ANDROID_BUNDLE_TARGET}}MB)

---

## Security & Compliance

### Secrets & Credentials

- [ ] **No Secrets in Code:** No API keys, tokens, passwords hardcoded
- [ ] **Secret Storage:** {{SECRET_STORAGE_METHOD}} used for sensitive data
- [ ] **No Logs of Secrets:** Logging excludes passwords, tokens, PII
- [ ] **SSL Pinning:** {{SSL_PINNING_REQUIREMENT}}

### Data Protection

- [ ] **PII Handling:** Personal data encrypted {{PII_ENCRYPTION_METHOD}}
- [ ] **Secure Storage:** {{SECURE_STORAGE_METHOD}} for local persistence
- [ ] **API Security:** HTTPS/TLS {{TLS_VERSION}} minimum
- [ ] **GDPR Compliant:** {{GDPR_REQUIREMENTS}}

---

## Testing Before Release

### Manual Testing

- [ ] **Happy Path:** Core user flow tested end-to-end
- [ ] **Error Scenarios:** Tested with network offline, API down, bad data
- [ ] **Platform Testing:** Tested on {{SUPPORTED_PLATFORMS}}
- [ ] **Devices Tested:** Minimum {{MIN_DEVICE_COUNT}} devices/OS versions

### Automated Testing

- [ ] **CI Build:** Passes in {{CI_TOOL}}
- [ ] **Unit Tests:** 100% pass
- [ ] **Integration Tests:** 100% pass (if applicable)
- [ ] **E2E Tests:** {{CRITICAL_E2E_FLOWS}} critical flows pass

---

## Documentation & Handoff

### Code Documentation

- [ ] **Complex Logic Documented:** Commented where non-obvious
- [ ] **Function Docs:** Public functions have purpose/params/return docs
- [ ] **README Updated:** Added setup/run instructions if needed
- [ ] **Tech Decision Recorded:** Architecture decisions documented (ADR)

### Product Documentation

- [ ] **Feature Spec Updated:** {{SPEC_LOCATION}} reflects final feature
- [ ] **Screenshots/GIFs:** UI changes documented with visuals
- [ ] **API Docs Updated:** Swagger/PostMan specs reflect changes
- [ ] **Changelog Updated:** {{CHANGELOG_LOCATION}} entry added

---

## Deployment Readiness

### Release Preparation

- [ ] **Version Bumped:** {{VERSION_BUMPING_METHOD}} applied
- [ ] **BREAKING CHANGES:** Documented (if any)
- [ ] **Migration Script:** Data migration ready (if database change)
- [ ] **Rollback Plan:** Plan documented for reverting if needed

### Deployment

- [ ] **Build Artifacts:** APK, IPA, WAR ready to deploy
- [ ] **Staging Tested:** Feature works in {{STAGING_ENV}}
- [ ] **Feature Flag:** {{FEATURE_FLAG_REQUIREMENT}}
- [ ] **Deployment Checklist:** {{DEPLOYMENT_CHECKLIST_URL}}

---

## Post-Release

### Monitoring

- [ ] **Crash Reporting:** {{CRASH_REPORT_TOOL}} configured
- [ ] **Analytics Events:** Tracking configured
- [ ] **Performance Monitoring:** Real-user monitoring enabled
- [ ] **Error Budget:** {{ERROR_BUDGET_PERCENTAGE}}% allocated

### Follow-up

- [ ] **Monitor Metrics:** {{MONITORING_METRICS}} for {{MONITORING_DURATION}}
- [ ] **User Feedback:** Gathered and filed in {{FEEDBACK_LOCATION}}
- [ ] **Known Issues:** Documented in {{KNOWN_ISSUES_LOCATION}}

---

## Sign-Off

**Definition of Done approved by:**

- [ ] **Developer:** Code adheres to DoD
- [ ] **Code Reviewer:** Verified all checkboxes
- [ ] **QA Engineer:** Functional testing passed
- [ ] **Product Manager:** Feature meets requirements

> ✅ **DONE:** All checklist items completed. Ready for release.
