# Servactory Extensions

Extensions allow adding cross-cutting logic to services without modifying their core code.

## Overview

An extension is a module that:
- Adds DSL methods for configuration in the service class
- Modifies behavior by wrapping the `call!` method

**When to use:**
- Authorization, validation, logging
- Transactions, idempotency, caching
- Event publishing, error handling

## Extension Structure

```
extensions/
└── extension_name/
    └── dsl.rb
```

Each extension contains a `DSL` module with two nested modules:

| Module | Purpose |
|--------|---------|
| `ClassMethods` | DSL configuration methods called in the class body |
| `InstanceMethods` | The `call!(**)` method with execution logic |

## Wrapping call! Patterns

### Before — logic before execution
```ruby
def call!(**)
  # checks before execution
  super
end
```
**Examples:** `authorization`, `status_active`

### After — logic after execution
```ruby
def call!(**)
  super
  # actions after execution
end
```
**Examples:** `post_condition`, `publishable`

### Around — execution wrapper
```ruby
def call!(**)
  wrapper_class.wrap { super }
end
```
**Examples:** `transactional`

### On_failure — error handling
```ruby
def call!(**)
  super
rescue SpecificError => e
  # handle error
  raise # or fail!
end
```
**Examples:** `rollbackable`, `external_api_request`

### Before + After — combined
```ruby
def call!(incoming_arguments: {}, **)
  # logic before
  super
  # logic after
end
```
**Examples:** `idempotent`

## Configuration Storage

### Single value
```ruby
attr_accessor :config_name

def dsl_method!(value)
  self.config_name = value
end
```

### Multiple values
```ruby
def configurations
  @configurations ||= []
end

def add_config!(name, **options)
  configurations << { name:, **options }
end
```

## Recommendations

| Rule | Description |
|------|-------------|
| **Inline logic** | All logic in `call!`, no private helper methods |
| **Local variables** | For storing configuration from the class |
| **Nil checks** | Always check for configuration presence before use |
| **Config access** | Via `self.class.send(:config_name)` |
| **Errors** | Use `fail!(:type, message:)` or `fail_input!(name, message:)` |
| **Blocks** | Execute via `instance_exec(&block)` for context access |

## Registration in Base

Extensions are registered in `ApplicationService::Base`:

```ruby
extensions do
  before :actions, Extensions::Authorization::DSL
  before :actions, Extensions::StatusActive::DSL
  after :actions, Extensions::PostCondition::DSL
end
```

## Available Extensions

| Extension | Pattern | Purpose |
|-----------|---------|---------|
| `status_active` | After | Checks model active status |
| `authorization` | After | Checks access permissions |
| `post_condition` | After | Validates post-conditions on outputs |
| `transactional` | Around | Executes within DB transaction |
| `rollbackable` | On_failure | Rollback on error |
| `publishable` | After | Publishes events |
| `idempotent` | Before+After | Idempotency by key |
| `external_api_request` | On_failure | Handles external API errors |
| `api_action` | ClassMethods | Generates make calls for API |

## Important Notes

### external_api_request

The `error_class` parameter must be a **specific** exception class expected from your API client:

- `Faraday::Error`, `Net::HTTPError`, `RestClient::Exception`, etc.
- **NEVER** use `StandardError`, `Exception`, or `Servactory::Exceptions::Base`
- Using broad exception classes will intercept Servactory's internal exceptions (`fail!`, `success!`, validation errors)

The extension uses `rescue StandardError => e` but filters exceptions via `raise e unless e.is_a?(error_class)`. Only exceptions matching the configured `error_class` are converted to service failures; all others (including Servactory exceptions) are re-raised.

### rollbackable

The rollback method is called on **any** `StandardError`, then the original exception is re-raised. This preserves Servactory's exception flow while allowing cleanup actions.

## Files

- DSL: `examples/application_service/extensions/*/dsl.rb`
- Examples: `examples/usual/extensions/*/example1.rb`
- Tests: `spec/examples/usual/extensions/*/example1_spec.rb`
