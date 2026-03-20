# Refactoring Catalog

Patterns to detect and how to fix them. Ordered by impact. Each pattern includes detection criteria, refactoring approach, and a before/after example.

## 1. God Object / God Function

**Detect**: Class with 5+ unrelated responsibilities, or function over 60 lines doing multiple distinct tasks. Look for: many unrelated methods, mixed concerns (I/O + logic + formatting), or a function with multiple "phases" separated by blank lines or comments.

**Refactor**: Extract cohesive groups of methods/logic into separate modules or classes. Each extracted unit should have a single clear responsibility.

**Approach**:
1. List every method/block and label its responsibility.
2. Group methods by responsibility.
3. Extract each group into its own module/class.
4. Replace direct access with imports/delegation.
5. Update callers — grep for all usages before extracting.

```python
# BEFORE: UserManager handles auth, profile, notifications, billing, reporting
class UserManager:
    def login(self, credentials): ...
    def logout(self, session): ...
    def update_profile(self, user_id, data): ...
    def get_avatar(self, user_id): ...
    def send_notification(self, user_id, msg): ...
    def charge_card(self, user_id, amount): ...
    def generate_report(self, start, end): ...

# AFTER: Each responsibility is its own module
class AuthService:
    def login(self, credentials): ...
    def logout(self, session): ...

class ProfileService:
    def update_profile(self, user_id, data): ...
    def get_avatar(self, user_id): ...

class NotificationService:
    def send(self, user_id, msg): ...
```

**Risk**: Callers that accessed the god object now need updated imports. Shared state between methods may need explicit passing.

## 2. Callback Hell / Deeply Nested Async

**Detect**: 3+ levels of nested callbacks. Indentation creep. Promise chains with inline functions over 5 lines. `.then().then().then()` chains mixing logic and error handling.

**Refactor**: Convert to async/await. Extract inline callbacks into named functions when they represent distinct steps.

**Approach**:
1. Identify the sequential flow hidden in the nesting.
2. Convert each callback level to an awaited call.
3. Preserve error handling — map `.catch()` and error-first callbacks to try/catch.
4. Keep error specificity — if different errors were handled differently, maintain that.

```javascript
// BEFORE: Nested callbacks
function processOrder(orderId, callback) {
  db.getOrder(orderId, (err, order) => {
    if (err) return callback(err);
    payment.charge(order.total, (err, receipt) => {
      if (err) return callback(err);
      inventory.update(order.items, (err) => {
        if (err) return callback(err);
        email.sendConfirmation(order.email, receipt, (err) => {
          if (err) return callback(err);
          callback(null, { order, receipt });
        });
      });
    });
  });
}

// AFTER: Async/await with preserved error handling
async function processOrder(orderId) {
  const order = await db.getOrder(orderId);
  const receipt = await payment.charge(order.total);
  await inventory.update(order.items);
  await email.sendConfirmation(order.email, receipt);
  return { order, receipt };
}
```

**Risk**: Error handling semantics may differ between callbacks and async/await. Verify that errors propagate the same way. Watch for callback APIs that don't support promises (may need `util.promisify` or manual wrapping).

## 3. Hardcoded Dependencies

**Detect**: Classes/functions that instantiate their own dependencies internally. `new DatabaseClient()` or `requests.get()` called directly inside business logic. Makes unit testing impossible without monkey-patching.

**Refactor**: Accept dependencies as constructor/function parameters. Provide defaults for production use; tests pass mocks.

**Approach**:
1. Identify the hardcoded dependency.
2. Add it as a parameter with a default value (production instance).
3. Update the constructor or function signature.
4. Update existing callers (they should continue working due to the default).
5. Write new tests using mock/stub dependencies.

```python
# BEFORE: Hardcoded dependency
class OrderProcessor:
    def __init__(self):
        self.db = PostgresClient("prod-connection-string")
        self.mailer = SmtpMailer("smtp.company.com")

    def process(self, order):
        self.db.save(order)
        self.mailer.send(order.customer_email, "Order confirmed")

# AFTER: Dependencies injected with production defaults
class OrderProcessor:
    def __init__(self, db=None, mailer=None):
        self.db = db or PostgresClient("prod-connection-string")
        self.mailer = mailer or SmtpMailer("smtp.company.com")

    def process(self, order):
        self.db.save(order)
        self.mailer.send(order.customer_email, "Order confirmed")

# Tests can now inject mocks:
def test_process_sends_email():
    mock_db = Mock()
    mock_mailer = Mock()
    processor = OrderProcessor(db=mock_db, mailer=mock_mailer)
    processor.process(order)
    mock_mailer.send.assert_called_once()
```

**Risk**: Changing constructor signatures can break subclasses. Check for inheritance hierarchies before modifying.

## 4. Dead Code

**Detect**: Unused functions, unreachable branches, commented-out code, imports with no references. Use the language's tooling when available (`pylint`, `eslint --no-unused-vars`, `cargo +nightly udeps`).

**Refactor**: Delete it. If uncertain whether code is used (e.g., called via reflection or dynamic dispatch), add a deprecation log and remove in a follow-up.

**Verification**: Grep the entire codebase for references before deleting. Check for dynamic invocation patterns (string-based dispatch, `getattr`, reflection).

**Risk**: Low for truly dead code. Medium if the code is invoked dynamically. When in doubt, deprecate with logging rather than deleting outright.

## 5. Code Duplication

**Detect**: Two or more code blocks that do the same thing with minor variations. Near-identical functions in different files. Copy-paste with find-and-replace variable names.

**Refactor**: Extract the common logic into a shared function. Parameterize the differences. Keep the shared function in a location that makes sense architecturally (utility module, base class, or shared library).

**Do NOT extract** if:
- The "duplicated" code is only 2-3 lines — the extraction overhead exceeds the benefit.
- The code paths are likely to diverge in the future (ask: will these always change together?).
- The extraction would create a dependency between unrelated modules.

**Risk**: Over-eager deduplication couples unrelated code. Only extract when the duplicated logic genuinely represents a single concept.

## 6. Over-Abstraction

**Detect**: Interfaces/abstract classes with only one implementation. Factory patterns that construct only one type. Strategy patterns with one strategy. Wrapper classes that add no behavior. Configuration objects for things that never change.

**Refactor**: Inline the abstraction. Replace the interface + implementation with the concrete implementation. Remove the factory; construct directly.

```python
# BEFORE: Over-abstracted
class IUserRepository(ABC):
    @abstractmethod
    def get_user(self, id): ...

class PostgresUserRepository(IUserRepository):
    def get_user(self, id):
        return self.db.query("SELECT * FROM users WHERE id = %s", id)

class UserRepositoryFactory:
    @staticmethod
    def create():
        return PostgresUserRepository()

# AFTER: Just the implementation
class UserRepository:
    def get_user(self, id):
        return self.db.query("SELECT * FROM users WHERE id = %s", id)
```

**When to keep the abstraction**: Multiple implementations exist or are concretely planned. The interface is used for dependency injection in tests (this is a valid use).

**Risk**: If the abstraction is part of a published API, removing it is a breaking change.

## 7. Overly Clever Code

**Detect**: One-liners that take 30+ seconds to understand. Nested ternaries. Regex where simple string operations work. Metaprogramming for straightforward tasks. "Golf" code that prioritizes brevity over clarity.

**Refactor**: Rewrite in plain, readable form. Add a brief comment if the logic is inherently complex.

```python
# BEFORE: Clever
result = {k: v for d in [defaults, overrides, {k: transform(v) for k, v in extras.items() if pred(k)}] for k, v in d.items()}

# AFTER: Clear
result = dict(defaults)
result.update(overrides)
for key, value in extras.items():
    if pred(key):
        result[key] = transform(value)
```

**Risk**: Minimal. Readability improvements rarely change behavior if the rewrite is tested.

## Detection Quick Reference

| Pattern | Key Signal | Severity |
|---------|-----------|----------|
| God Object | 5+ responsibilities, 200+ lines | High |
| Callback Hell | 3+ nesting levels | High |
| Hardcoded Deps | `new X()` inside business logic, untestable | High |
| Dead Code | No references in codebase | Medium |
| Duplication | Near-identical blocks in 2+ locations | Medium |
| Over-Abstraction | Interface with 1 implementation | Medium |
| Overly Clever | Takes 30s+ to understand a single line | Low |
