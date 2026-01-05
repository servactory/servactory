# Servactory Generators

## Installation

```bash
rails generate servactory:install [options]
```

**Options:**
- `--namespace` — Base namespace (default: `ApplicationService`)
- `--path` — Path to install service files (default: `app/services`)
- `--locales` — Locales to install (e.g., `--locales=en,ru`)
- `--minimal` — Generate minimal setup without configuration examples

## Service

```bash
rails generate servactory:service NAME [inputs] [options]
```

**Arguments:**
- `NAME` — Service name (e.g., `Users::Create`, `ProcessOrder`)
- `inputs` — Input attributes with optional types (e.g., `email:String count:Integer`)

**Options:**
- `--base-class` — Base class for service (default: `ApplicationService::Base`)
- `--path` — Path to generate service files (default: `app/services`)
- `--skip-output` — Skip default output declaration

## RSpec

```bash
rails generate servactory:rspec NAME [options]
```

Generates RSpec spec for an existing service using `.info` API.

**Arguments:**
- `NAME` — Existing service name (e.g., `Users::Create`)

**Options:**
- `--call-method` — Primary call method: `call` or `call!` (default: `call!`)
- `--path` — Path to generate spec files (default: `spec/services`)
- `--skip-validations` — Skip validation examples
- `--skip-pending` — Skip pending placeholder
